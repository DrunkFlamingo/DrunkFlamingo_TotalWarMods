---take a lua table and return a string which can be loadstringed to recreate the table.
---@param t table
---@return string
function table_to_string(t, indent)
    if not indent then
        indent = 0
    end
    local prefix = ""
    for i = 1, indent do
        prefix = prefix .. "\t"
    end
    local result = "{" .. "".."\n"
    local first_result = false 
    for k, v in pairs(t) do
        if not first_result then
            first_result = true
        else
            result = result .. ",\n" 
        end
        local layer_indent = "\t"
        if type(k) == "string" then
            k = string.format("%q", k)
        end
        if v == "" then
            v = "\"\"" --empty string
        elseif type(v) == "boolean" or type(v) == "number" then
            v = tostring(v)
        elseif type(v) == "string" then
            v = string.format("%q", v) 
        elseif type(v) == "table" then
            v = table_to_string(v, indent + 1)
        end
        result = result ..layer_indent..prefix.."[" .. k .. "] = " .. v
    end
    result = result .. "\n"..prefix.."}"
    return result
end


local auto_level_skills = require("obr_data/auto_level_skills") 
---skill, rank, level 

local whitelisted_subtypes = require("obr_data/whitelisted_subtypes")
---skill node set, subtype




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

---Gets the character off the UI panel rather than using the current selected character, so that this works with Heroes.
---@return CHARACTER_SCRIPT_INTERFACE|nil
local get_selected_character = function()
    local character
    -- :root:character_details_panel:character_context_parent
    local context_parent = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent")
    if context_parent then
        local char_context_id = context_parent:GetContextObjectId("CcoCampaignCharacter")
        if not char_context_id then
            return nil
        end
        local character_cqi = tonumber(context_parent:GetContextObjectId("CcoCampaignCharacter"))
        ---@cast character_cqi number
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

---Gets the respec cost of the character, factoring the bonus value for submods
---@param character CHARACTER_SCRIPT_INTERFACE
---@return integer
local function get_respec_cost(character)
    local cost = respec_cost
    local cost_mod = cm:get_characters_bonus_value(character, "obr_respec_cost_mod")
    local real_cost = cost + ((cost/100)*cost_mod)
    if real_cost > 0 then
        --respecing can't give you money
        real_cost = 0
    end
    return math.floor(real_cost)
end


---Checks if a character can afford to respec
---@param character CHARACTER_SCRIPT_INTERFACE
---@param cost integer
---@return boolean
local function respec_cost_condition(character, cost)
    return character:faction():treasury() > (-1*cost)
end

---Returns the proper state and tooltip string for a character based on their factions money and their saved shared state
---@param character CHARACTER_SCRIPT_INTERFACE
---@return string
---@return string
local function get_respec_state_and_tooltip(character)
    if not character or character:is_null_interface() then
        out("Something went wrong, character passed for respec state is either nil or the null interface")
        return "inactive", "[[col:red]]Something went wrong generating the character context object for this button, please close and reopen the panel[[/col]]"
    end
    local tt = common.get_localised_string("mod_respec_button_tt_title")
    if character:rank() == 1 then
        return "inactive", tt
    end
    local state = "active"
    local cost = get_respec_cost(character)
    local ssm = cm:model():shared_states_manager()
    local is_unlimited = cm:get_characters_bonus_value(character, "obr_unlimited_respec") > 0
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


---@param respec_button UIC|nil
local populate_respec_button = function (respec_button)
    if not respec_button or  not is_uicomponent(respec_button) then
        out("The respec button passed to the populate function is not a valid UIComponent.")
    end
    ---@cast respec_button UIC

    local character = get_selected_character()
    if not character or character:is_null_interface() then
        return
    end
    local state, tooltip = get_respec_state_and_tooltip(character)
    respec_button:SetState(state)
    respec_button:SetTooltipText(tooltip, true)

end

--[[
---@param character CHARACTER_SCRIPT_INTERFACE
local function reapply_auto_levelled_skills(character)
    cm:disable_event_feed_events(true, "", "wh_event_subcategory_character_ancillaries", "")
    local skills = subtypes_to_auto_skills[character:character_subtype_key()]
    if not skills then
        out("Character " .. character:command_queue_index() .. " of subtype "..character:character_subtype_key().." has no auto-levelled skills")
        return
    end
    out("Checking auto level skills for " .. character:command_queue_index().." of subtype "..character:character_subtype_key().." who is rank "..character:rank())
    for i = 1,character:rank() -1  do
        if not skills[i] then
            out("Character " .. character:command_queue_index() .. " has no auto-levelled skills for rank "..i+1)
        else
            for _,skill in ipairs(skills[i]) do
                out("Applying auto-levelled skill " .. skill .. " to " .. character:command_queue_index().." for rank "..i+1)
                cm:force_add_skill(cm:char_lookup_str(character), skill)
            end
        end
    end
    cm:callback(function ()
        cm:disable_event_feed_events(false, "", "wh_event_subcategory_character_ancillaries", "")
    end, 1)
end--]]

local function respec_character(character)
    local characterContext = cco("CcoCampaignCharacter", character:command_queue_index())
    if not characterContext then
        out("Something went wrong, character passed for respec did not return a valid CCO")
        return
    end
    local num_skills = characterContext:Call("SkillList.Size")
    out("Respecing character: " .. character:command_queue_index() .. " of subtype "..character:character_subtype_key().." who is rank "..character:rank())
    out("They have "..num_skills.." to potentially remove")
    for i = 0, num_skills - 1 do
        local skill_key = characterContext:Call("SkillList.At("..i..").Key")
        local skill_indent = characterContext:Call("SkillList.At("..i..").Indent")
        local skill_level = characterContext:Call("SkillList.At("..i..").Level")
        out("Checking skill: "..skill_key.." with indent "..skill_indent)

        if  (skill_indent > 0 and skill_indent < 7) then
            if skill_level > 0 then    
                out("Removing skill: "..skill_key.. " because it is within indent ranges")
                for _ = 1, skill_level do
                    cm:remove_skill_point(cm:char_lookup_str(character), skill_key)
                end
            else
                out("No points in this skill")
            end
        elseif (not auto_level_skills[skill_key] and whitelisted_subtypes[character:character_subtype_key()]) then
            out("Removing skill: "..skill_key.." because it is from a whitelisted subtype and isn't an auto-skill")
            for _ = 1, skill_level do
                cm:remove_skill_point(cm:char_lookup_str(character), skill_key)
            end
        else
            out("Skill is not a respecable skill")
        end
    end
end



local mp_safe_trigger = function()
    local character = get_selected_character()
    if character then
        CampaignUI.TriggerCampaignScriptEvent(character:faction():command_queue_index(), ui_trigger_string..tostring(character:command_queue_index()))
    else
        script_error("MP Safe trigger was not able to get the character context from the character context parent")
    end
end

---comment
---@param faction FACTION_SCRIPT_INTERFACE
---@param character CHARACTER_SCRIPT_INTERFACE
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

    dilemma_builder:add_target("default", character:family_member())

    core:add_listener(
        "OneButtonRespecDilemmaTrigger",
        "DilemmaChoiceMadeEvent",
        function (context)
            return context:dilemma() == dilemma_key
        end,
        function (context)
            if context:choice() == 0 then
                --[[]
                cm:force_reset_skills(cm:char_lookup_str(character))
                cm:callback(function ()
                    reapply_auto_levelled_skills(character)
                end, 0.1)--]]
                respec_character(character)
                cm:set_script_state(character, script_state_string, true)
            end
        end)
    cm:launch_custom_dilemma_from_builder(dilemma_builder, faction)
    if cm:get_local_faction_name(true) == faction:name() then
        CampaignUI.ClosePanel("character_details_panel")
    end
end

onebuttonrespec_whitelist_subtype = function(subtype_key, new_auto_level_skills) 
    whitelisted_subtypes[subtype_key] = true
    for i = 1, #new_auto_level_skills do
        auto_level_skills[new_auto_level_skills[i]] = true
    end
end

-- :root:character_details_panel:character_context_parent:skill_pts_holder:skill_pts:round_small_button
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
            ---@diagnostic disable-next-line
            local character = cm:get_character_by_cqi(tonumber(cqi_as_str))
            trigger_respec_dilemma(faction, character)
        end,
        true)
end