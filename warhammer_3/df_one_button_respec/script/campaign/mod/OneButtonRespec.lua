local out = function(t)
    ModLog("DRUNKFLAMINGO: "..tostring(t).." (One Button Respec)")
end

local respec_button_name = "one_button_respec"
local ui_trigger_string = "one_button_respec:"

---@return boolean
local is_character_details_open = function()
    return cm:get_campaign_ui_manager():is_panel_open("character_details_panel")
end

local mod_dilemma_key = "df_one_button_respec_dilemma_"
local mod_dilemma_number = 1
local mod_dilemma_max_number = 2
local script_state_string = "one_button_respec_has_used_respec"
local respec_cost = -1000

local get_dilemma_key = function()
    mod_dilemma_number = mod_dilemma_number+ 1
    if mod_dilemma_number > mod_dilemma_max_number then
        mod_dilemma_number = 1
    end
    return mod_dilemma_key..tostring(mod_dilemma_number)
end

---@param callback fun(context)
---@param ... string
local panels_open_callback = function(callback, ...)
    local panels = {}
    local log = ""
    for i = 1, #arg do
        panels[arg[i]] = true
        log = log .. arg[i]
    end
    out("Added panel open callback for "..log)
    core:add_listener(
        "OBRTemp",
        "PanelOpenedCampaign",
        function(context)
        return not not panels[context.string]
        end,
        callback,
        false)
end

local get_selected_character = function()
    local character
    --:root:character_details_panel:character_context_parent
    local context_parent = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent")
    if context_parent then
        local character_cqi = context_parent:GetContextObjectId("CcoCampaignCharacter")
        character = cm:get_character_by_cqi(character_cqi)
        out("Got character from context parent")
    else
        out("Error checking the character: couldn't get a handle on the context parent")
    end
    return character
end


local get_or_create_respec_button = function()
    local ui_button_parent = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent", "skill_pts_holder", "skill_pts")
    if not is_uicomponent(ui_button_parent) then
        out("Could not find the button parent for the respec button")
        return
    end
    local existing_button = find_uicomponent(ui_button_parent, respec_button_name)
    if existing_button then
        return existing_button
    else
        local respec_button = UIComponent(ui_button_parent:CreateComponent(respec_button_name, "ui/templates/round_small_button"))
        respec_button:SetImagePath("ui/skins/default/icon_swap.png")
        return respec_button
    end
end

local function get_respec_cost(character)
    local cost = respec_cost
    local cost_mod = get_characters_bonus_value(character, "obr_respec_cost_mod")
    local real_cost = cost + ((cost/100)*cost_mod)
    if real_cost > 0 then
        --respecing can't give you money
        real_cost = 0
    end
    return real_cost
end



local function respec_cost_condition(character, cost)
    return character:faction():treasury() > (-1*cost)
end


local function get_respec_state_and_tooltip(character)
    if character:is_null_interface() then
        out("Something went wrong, character passed for respec state is null")
        return "inactive", "[[col:red]]Something went wrong generating the character context object for this button, please close and reopen the panel[[/col]]"
    end
    local tt = common.get_localised_string("mod_respec_button_tt_title")
    local state = "active"
    local cost = get_respec_cost(character)
    local ssm = cm:model():shared_states_manager()
    local is_unlimited = get_characters_bonus_value(character, "obr_unlimited_respec") > 0
    local was_used = ssm:get_state_as_bool_value(character, script_state_string)
    if cost ~= 0 then
        local cost_tt = string.gsub(common.get_localised_string("mod_respec_button_tt_cost"), "9999", tostring((-1*cost)))
        tt = tt .. cost_tt
    end
    if (not is_unlimited) then
        if was_used then
            state = "inactive"
            local used_tt = common.get_localised_string("mod_respec_button_tt_already_used")
            tt = tt.. used_tt
        else
            local limit_tt = common.get_localised_string("mod_respec_button_once_per_character")
            tt = tt..limit_tt
        end
    end
    if state == "active" then
        if not respec_cost_condition(character, cost) then
            local cant_afford_tt = common.get_localised_string("mod_respec_button_tt_cant_afford")
            state = "inactive"
            tt = tt .. cant_afford_tt            
        end
    end
    return state, tt
end

local populate_respec_button = function (respec_button)
    if not is_uicomponent(respec_button) then
        out("The respec button passed to the populate function is not a valid UIComponent.")
    end

    local character = get_selected_character()
    local state, tooltip = get_respec_state_and_tooltip(character)
    respec_button:SetState(state)
    respec_button:SetTooltipText(tooltip, true)

end



local mp_safe_trigger = function()
    local character = get_selected_character()
    CampaignUI.TriggerCampaignScriptEvent(character:faction():command_queue_index(), ui_trigger_string..tostring(character:command_queue_index()))
end

local trigger_respec_dilemma = function(faction, character)
    out("Offering the respec dilemma for faction "..faction:name().." on character "..tostring(character:command_queue_index()).."  ")
    local dilemma_key = get_dilemma_key()
    local dilemma_builder = cm:create_dilemma_builder(dilemma_key)
    dilemma_builder:remove_choice_payload("FIRST")
    dilemma_builder:remove_choice_payload("SECOND")
    local payload_builder = cm:create_payload();
    payload_builder:clear()

    --couldn't get these to work.
    --payload_builder:text_display("dummy_respec_character")
    --payload_builder:text_display("dummy_respec_only_once")
    local cost = get_respec_cost(character)
    if cost < 0 then
        payload_builder:treasury_adjustment(cost)
    end

    dilemma_builder:add_choice_payload("FIRST", payload_builder)
    local payload_builder_2 = cm:create_payload()
    payload_builder_2:clear()
    payload_builder_2:text_display("dummy_do_nothing")
    dilemma_builder:add_choice_payload("SECOND", payload_builder_2)

    dilemma_builder:add_target(character)

    core:add_listener(
        "OneButtonRespecDilemmaTrigger",
        "DilemmaChoiceMadeEvent",
        function (context)
            return context:dilemma() == dilemma_key
        end,
        function (context)
            if context:choice() == 0 then
                cm:force_reset_skills(cm:char_lookup_str(character))
                cm:set_script_state(character, script_state_string, true)
            end
        end)
    cm:launch_custom_dilemma_from_builder(dilemma_builder, faction)
    if cm:get_local_faction_name(true) == faction:name() then
        CampaignUI.ClosePanel("character_details_panel")
    end
end


--:root:character_details_panel:character_context_parent:skill_pts_holder:skill_pts:round_small_button
onebuttonrespec = function()
    local ssm = cm:model():shared_states_manager()
    core:add_listener(
        "OneButtonRespec",
        "PanelOpenedCampaign",
        function(context)
            return context.string == "character_details_panel"
        end,
        function (context)
            out("Char details panel opened, trying to find or create the respec button")
            populate_respec_button(get_or_create_respec_button())
        end,
        true)
    --listen for char selected changing and update the button
    core:add_listener(
        "OneButtonRespec",
        "CharacterSelected",
        function(context)
            return is_character_details_open()
        end,
        function(context)
            out("New character selected with the details panel already open, updating button")
            --if done immediately, we get the wrong context - wait for the panel to fully update
            cm:callback(function ()
                populate_respec_button(get_or_create_respec_button())
            end, 0.1)
        end,
        true)
    --listen for the click 
    core:add_listener(
        "OneButtonRespec",
        "ComponentLClickUp",
        function(context)
            return context.string == respec_button_name
        end,
        function(context)
            out("Player clicked the Respec Button!")
            mp_safe_trigger()
        end,
        true)

    --listen for the MP safe event
    core:add_listener(
        "OneButtonRespec",
        "UITrigger",
        function(context)
            return string.find(context:trigger(), ui_trigger_string)
        end,
        function(context)
            local this_trigger_str = context:trigger()
            out("OBR UI trigger recieved: "..this_trigger_str)
            local faction = cm:model():faction_for_command_queue_index(context:faction_cqi());
            local cqi_as_str = string.gsub(this_trigger_str, ui_trigger_string, "")
            local character = cm:get_character_by_cqi(tonumber(cqi_as_str))
            trigger_respec_dilemma(faction, character)
        end,
        true)
end