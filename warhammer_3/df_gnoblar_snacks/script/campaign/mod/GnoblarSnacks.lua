local out = function(t)
    ModLog("DRUNKFLAMINGO: "..tostring(t).." (Gnoblar Snacks)")
end

local mod = {}

mod.ogre_pooled_resource_costs = {
	["wh3_main_ogr_cav_crushers_0"] = { ["unit"] = "wh3_main_ogr_cav_crushers_0", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_cav_crushers_1"] = { ["unit"] = "wh3_main_ogr_cav_crushers_1", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_cav_mournfang_cavalry_0"] = { ["unit"] = "wh3_main_ogr_cav_mournfang_cavalry_0", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_cav_mournfang_cavalry_1"] = { ["unit"] = "wh3_main_ogr_cav_mournfang_cavalry_1", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_cav_mournfang_cavalry_2"] = { ["unit"] = "wh3_main_ogr_cav_mournfang_cavalry_2", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_cha_butcher_beasts_0"] = { ["unit"] = "wh3_main_ogr_cha_butcher_beasts_0", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_cha_butcher_great_maw_0"] = { ["unit"] = "wh3_main_ogr_cha_butcher_great_maw_0", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_cha_firebelly_0"] = { ["unit"] = "wh3_main_ogr_cha_firebelly_0", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_cha_greasus_goldtooth_0"] = { ["unit"] = "wh3_main_ogr_cha_greasus_goldtooth_0", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_cha_hunter_0"] = { ["unit"] = "wh3_main_ogr_cha_hunter_0", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_cha_hunter_1"] = { ["unit"] = "wh3_main_ogr_cha_hunter_1", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_cha_skrag_the_slaughterer_0"] = { ["unit"] = "wh3_main_ogr_cha_skrag_the_slaughterer_0", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_cha_slaughtermaster_beasts_0"] = { ["unit"] = "wh3_main_ogr_cha_slaughtermaster_beasts_0", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_cha_slaughtermaster_great_maw_0"] = { ["unit"] = "wh3_main_ogr_cha_slaughtermaster_great_maw_0", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_cha_tyrant_0"] = { ["unit"] = "wh3_main_ogr_cha_tyrant_0", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_inf_ironguts_0"] = { ["unit"] = "wh3_main_ogr_inf_ironguts_0", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_inf_leadbelchers_0"] = { ["unit"] = "wh3_main_ogr_inf_leadbelchers_0", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_inf_maneaters_0"] = { ["unit"] = "wh3_main_ogr_inf_maneaters_0", ["upkeep_resource_cost"] = 2 },
	["wh3_main_ogr_inf_maneaters_1"] = { ["unit"] = "wh3_main_ogr_inf_maneaters_1", ["upkeep_resource_cost"] = 2 },
	["wh3_main_ogr_inf_maneaters_2"] = { ["unit"] = "wh3_main_ogr_inf_maneaters_2", ["upkeep_resource_cost"] = 2 },
	["wh3_main_ogr_inf_maneaters_3"] = { ["unit"] = "wh3_main_ogr_inf_maneaters_3", ["upkeep_resource_cost"] = 2 },
	["wh3_main_ogr_inf_maneaters_summoned_0"] = { ["unit"] = "wh3_main_ogr_inf_maneaters_summoned_0", ["upkeep_resource_cost"] = 2 },
	["wh3_main_ogr_inf_ogres_0"] = { ["unit"] = "wh3_main_ogr_inf_ogres_0", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_inf_ogres_1"] = { ["unit"] = "wh3_main_ogr_inf_ogres_1", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_inf_ogres_2"] = { ["unit"] = "wh3_main_ogr_inf_ogres_2", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_mon_giant_0"] = { ["unit"] = "wh3_main_ogr_mon_giant_0", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_mon_gorgers_0"] = { ["unit"] = "wh3_main_ogr_mon_gorgers_0", ["upkeep_resource_cost"] = 2 },
	["wh3_main_ogr_mon_gorgers_summoned_0"] = { ["unit"] = "wh3_main_ogr_mon_gorgers_summoned_0", ["upkeep_resource_cost"] = 2 },
	["wh3_main_ogr_mon_sabretusk_pack_0"] = { ["unit"] = "wh3_main_ogr_mon_sabretusk_pack_0", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_mon_stonehorn_0"] = { ["unit"] = "wh3_main_ogr_mon_stonehorn_0", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_mon_stonehorn_1"] = { ["unit"] = "wh3_main_ogr_mon_stonehorn_1", ["upkeep_resource_cost"] = 1 },
	["wh3_main_ogr_veh_ironblaster_0"] = { ["unit"] = "wh3_main_ogr_veh_ironblaster_0", ["upkeep_resource_cost"] = 1 },
    ["wh3_twa06_ogr_inf_maneaters_ror_0"] = { ["unit"] = "wh3_main_ogr_veh_ironblaster_0", ["upkeep_resource_cost"] = 2 },
    ["wh3_twa07_ogr_cav_crushers_ror_0"] = { ["unit"] = "wh3_main_ogr_veh_ironblaster_0", ["upkeep_resource_cost"] = 1 },
}

local ui_table = {}
local ui_2_table = {}
for k, v in pairs(mod.ogre_pooled_resource_costs) do
    ui_table[k] = v.upkeep_resource_cost
    if v.upkeep_resource_cost > 1 then
        ui_2_table[k] = v.upkeep_resource_cost
    end
end
common.set_context_value("gnoblar_snacks_meat_costs", ui_table)
common.set_context_value("gnoblar_snacks_high_meat_costs", ui_2_table)

mod.gnoblar_units = {
    wh3_main_ogr_inf_gnoblars_0 = true,
    wh3_main_ogr_inf_gnoblars_1 = true
}


mod.flavour_events = {
    ["df_gnoblar_snacks_horse_meat"] = {
        ["wh2_main_def_cav_cold_one_chariot"] = true,
        ["wh2_main_def_cav_cold_one_knights_0"] = true,
        ["wh2_main_def_cav_cold_one_knights_1"] = true,
        ["wh2_main_def_cav_dark_riders_0"] = true,
        ["wh2_main_def_cav_dark_riders_1"] = true,
        ["wh2_main_def_cav_dark_riders_2"] = true,
        ["wh2_main_hef_cav_dragon_princes"] = true,
        ["wh2_main_hef_cav_ellyrian_reavers_0"] = true,
        ["wh2_main_hef_cav_ellyrian_reavers_1"] = true,
        ["wh2_main_hef_cav_ithilmar_chariot"] = true,
        ["wh2_main_hef_cav_silver_helms_0"] = true,
        ["wh2_main_hef_cav_silver_helms_1"] = true,
        ["wh2_main_hef_cav_tiranoc_chariot"] = true,
        
        ["wh3_main_cth_cav_jade_lancers_0"] = true,
        ["wh3_main_cth_cav_jade_longma_riders_0"] = true,
        ["wh3_main_cth_cav_peasant_horsemen_0"] = true,
        ["wh3_main_ksl_cav_gryphon_legion_0"] = true,
        ["wh3_main_ksl_cav_horse_archers_0"] = true,
        ["wh3_main_ksl_cav_horse_raiders_0"] = true,
        ["wh3_main_ksl_cav_war_bear_riders_1"] = true,
        ["wh3_main_ksl_cav_winged_lancers_0"] = true,
        ["wh_dlc07_brt_cav_knights_errant_0"] = true,
        ["wh_dlc07_brt_cav_questing_knights_0"] = true,
        ["wh_main_brt_cav_grail_knights"] = true,
        ["wh_main_brt_cav_pegasus_knights"] = true,
        ["wh_main_chs_cav_chaos_knights_1"] = true,
        ["wh_main_chs_cav_marauder_horsemen_1"] = true,
        ["wh_main_emp_cav_demigryph_knights_0"] = true,
        ["wh_main_emp_cav_demigryph_knights_1"] = true,
        ["wh_main_emp_cav_empire_knights"] = true,
        ["wh_main_emp_cav_outriders_0"] = true,
        ["wh_main_emp_cav_outriders_1"] = true,
        ["wh_main_emp_cav_pistoliers_1"] = true,
        ["wh_main_emp_cav_reiksguard"] = true,
        ["wh_main_nor_cav_marauder_horsemen_0"] = true 
    },
    ["df_gnoblar_snacks_disgusting_food"] = {
        ["wh_dlc07_brt_peasant_mob_0"] = true
    },
    ["df_gnoblar_snacks_stomache_ache_skaven"] = {

    },
    ["df_gnoblar_snacks_stomache_ache_undead"] = {
        
    },
    ["df_gnoblar_snacks_stomache_ache_nurgle"] = {
        
    },
    ["df_gnoblar_snacks_alcohol_content"] = {
        
    }
}

mod.dilemma_key = "df_gnoblar_snacks_dilemma_"
mod.dilemma_number = 1
mod.dilemma_max_number = 2

---Handles alternating between two dilemma to solve a UI bug that occurs when firing the same one multiple times.
---@return string
mod.get_dilemma_key = function()
    mod.dilemma_number = mod.dilemma_number + 1
    if mod.dilemma_number > mod.dilemma_max_number then
        mod.dilemma_number = 1
    end
    return mod.dilemma_key..tostring(mod.dilemma_number)
end

mod.grudge_event =  "df_gnoblar_snacks_in_the_book"
mod.fearful_gnoblar_event = "df_gnoblar_snacks_fearful_gnoblars"
mod.fearful_gnoblar_chance = 20

mod.button_name = "button_gnoblar_snack"
mod.per_unit_food_gain = 10
mod.character_bonus_food_factor = 2
mod.ui_trigger_prefix = "gnoblar_snacks_button_pressed_context:"

mod.unit_selection = {}

---Can the character passed use the snack feature
---@param character CHARACTER_SCRIPT_INTERFACE
---@return boolean
mod.has_snacks = function(character)
    return character:has_military_force() and character:faction():name() == cm:get_local_faction_name(true) 
    and character:faction():subculture() == "wh3_main_sc_ogr_ogre_kingdoms" and character:military_force():force_type():key() ~= "OGRE_CAMP"
end

---@return boolean
mod.is_units_panel_open = function()
    return cm:get_campaign_ui_manager():is_panel_open("units_panel")
end

---@return boolean
mod.is_character_details_open = function()
    return cm:get_campaign_ui_manager():is_panel_open("character_details_panel")
end

---@param callback fun(context)
---@param ... string
mod.panels_open_callback = function(callback, ...)
    local panels = {}
    local log = ""
    for i = 1, #arg do
        panels[arg[i]] = true
        log = log .. arg[i]
    end
    out("Added panel open callback for "..log)
    core:add_listener(
        "GnoblarSnacksTemp",
        "PanelOpenedCampaign",
        function(context)
        return not not panels[context.string]
        end,
        callback,
        false)
end

---turn a table into a string for transit in MP games.
---@param tab string[]
---@return string
local function serialize_simple_string_list(tab)
    local str = "return {"
    for i = 1, #tab do 
        str = str .. "\"".. tab[i] .. "\""
        if tab[i+1] then
            str = str .. ","
        end
    end
    str = str ..  "}"
    return str
end

---load a table from a string for MP games
---@param serialized_list string
---@return string[]
local function restore_serialized_string_list(serialized_list)
    local load = loadstring(serialized_list)
    if load then
        local t = load()
        return t
    else
        return {}
    end
end

mod.get_or_create_snack_button = function()
    --[[ copied from context viewer
        :root:hud_campaign:hud_center_docker:hud_center:small_bar:button_subpanel_parent:button_subpanel:button_group_army:button_detachments
    ]]
    out("Getting or creating the snack button!")
    --get
    local snack_button = find_uicomponent(
		core:get_ui_root(),
		"hud_campaign",
		"hud_center_docker",
        "hud_center",
        "small_bar",
        "button_subpanel_parent",
        "button_subpanel",
        "button_group_army",
		mod.button_name
	)
    if not snack_button then
        out("No snack button found, creating one.")
    --create
        local detachment_button = find_uicomponent(
            core:get_ui_root(),
            "hud_campaign",
            "hud_center_docker",
            "hud_center",
            "small_bar",
            "button_subpanel_parent",
            "button_subpanel",
            "button_group_army",
            "button_detachments"
        )
        if detachment_button then
            snack_button = UIComponent(
                detachment_button:CopyComponent(mod.button_name)
            )
            snack_button:SetState("active")
        else
            out("Couldn't get the detatchments button")
        end
    end

    snack_button:SetImagePath("ui/custom/gnoblar_snacks/icon_great_feast.png")
    return snack_button
end


mod.is_gnoblar = function(unit_key)

    return not not mod.gnoblar_units[unit_key]
end




mod.update_unit_selection = function()
    mod.unit_selection = {}
    local armyList = find_uicomponent_from_table(core:get_ui_root(), {"units_panel", "main_units_panel", "units"})
    if not not armyList then
        for i = 0, armyList:ChildCount() - 1 do	
            local unitCard = UIComponent(armyList:Find(i))
            unitCard:AddScriptEventReporter()
            if unitCard:CurrentState() == "queued" then
                --do nothing
            elseif unitCard:CurrentState() == "selected" or unitCard:CurrentState() == "selected_hover" then
                local unitContextId = unitCard:GetContextObjectId("CcoCampaignUnit")
                
                table.insert(mod.unit_selection, {tostring(i), unitContextId})
                --causes the unit card to fire ComponentMouseOn
            end
        end
    end
end

mod.check_validity_and_gather_payload_info = function(unitContexts)
    local is_valid = true
    local unit_value = 0
    local allied_factions = {}
    local immortal_character = false
    local entire_army = false
    if #unitContexts == 0 then
        return false, 0, {}
    end 
    for i = 1, #unitContexts do
        local unitContextId = unitContexts[i][2]
        local campaignUnitContext = cco("CcoCampaignUnit", unitContextId)
        local main_unit_key = campaignUnitContext:Call("UnitRecordContext.Key")
        local is_character = campaignUnitContext:Call("IsCharacter")
        local strength = campaignUnitContext:Call("HealthPercent")
        local ally = false
        local ok, err = pcall(function()
            ally = campaignUnitContext:Call("AlliedOriginFactionContext.FactionRecordContext.Key")
        end)
        if mod.ogre_pooled_resource_costs[main_unit_key] then
            --units that have food upkeep can't be eaten.
            is_valid = false
            break
        elseif mod.is_gnoblar(main_unit_key) then
            if is_character then
                --we can only eat mortal characters
                local char_cqi = campaignUnitContext:Call("CharacterContext.CQI")
                local character = cm:get_character_by_cqi(char_cqi)
                if character and not character:is_null_interface() and character:character_details():is_immortal() == false then
                    if character:military_force():unit_list():num_items() == #unitContexts then
                        entire_army = true
                        is_valid = false
                        break
                    else
                        unit_value  = unit_value + math.ceil(mod.per_unit_food_gain*strength*mod.character_bonus_food_factor)
                    end
                else
                    immortal_character = true
                    is_valid = false
                    break
                end
            else
                unit_value  = unit_value + math.ceil(mod.per_unit_food_gain*strength)
            end
        elseif ally then
            table.insert(allied_factions, ally)
            unit_value = unit_value + math.ceil(mod.per_unit_food_gain*strength)
        else
            is_valid = false
            break
        end
    end
    return is_valid, unit_value, allied_factions, immortal_character, entire_army 
end

mod.create_mp_trigger_table = function()
    local payload_list = {}
    for i = 1, #mod.unit_selection do
        local entry = mod.unit_selection[i]
        local entry_string = entry[1]..":"..entry[2]
        table.insert(payload_list, entry_string)
    end
    return payload_list
end

mod.revert_mp_trigger_table = function(trigger_table)
    local reverted_table = {}
    for i = 1, #trigger_table do
        local entry = trigger_table[i]
        local index = string.sub(entry, 1, entry:find(":")-1)
        local contextId = string.sub(entry, entry:find(":")+1)
        table.insert(reverted_table, {index, contextId})
    end
    return reverted_table
end

mod.check_units_and_populate_snack_button = function()
    local SnackButton = mod.get_or_create_snack_button()
    mod.update_unit_selection()
    local title_string = common.get_localised_string("mod_snack_button_label")
    if #mod.unit_selection == 0 then
        SnackButton:SetState("inactive")
        local loc_str = title_string..common.get_localised_string("mod_snack_button_non_selected")
        SnackButton:SetTooltipText(loc_str, true)
    elseif #mod.unit_selection > 4 then
        SnackButton:SetState("inactive")
        local loc_str = title_string..common.get_localised_string("mod_snack_button_unit_limit")
        SnackButton:SetTooltipText(loc_str, true)
    else
        local is_valid, food_gain, allied_factions, has_immortal_character, entire_army = mod.check_validity_and_gather_payload_info(mod.unit_selection)
        if is_valid and #allied_factions > 0 then
            SnackButton:SetState("active")
            local loc_str = title_string..common.get_localised_string("mod_snack_button_food_gain") .. tostring(food_gain)
            loc_str = loc_str .. common.get_localised_string("mod_snack_button_diplomacy")
            SnackButton:SetTooltipText(loc_str, true)
        elseif is_valid then
            SnackButton:SetState("active")
            local loc_str = title_string..common.get_localised_string("mod_snack_button_food_gain") .. tostring(food_gain)
            SnackButton:SetTooltipText(loc_str, true)
        elseif has_immortal_character then
            SnackButton:SetState("inactive")
            local loc_str = title_string..common.get_localised_string("mod_snack_button_immortal_character_selected")
            SnackButton:SetTooltipText(loc_str, true)
        elseif entire_army then
            SnackButton:SetState("inactive")
            local loc_str = title_string..common.get_localised_string("mod_snack_button_entire_army")
            SnackButton:SetTooltipText(loc_str, true)
        else
            SnackButton:SetState("inactive")
            local loc_str = title_string..common.get_localised_string("mod_snack_button_only_gnoblars")
            SnackButton:SetTooltipText(loc_str, true)
        end
    end
    SnackButton:SetVisible(true)
end

--Play_Campaign_Individual_Vocalisation_Elf_Female_Glade_Captain_Pain
mod.eat_gnoblars = function(faction, char_cqi, trigger_table)

    local unitContexts = mod.revert_mp_trigger_table(trigger_table)
    local is_valid, food_gain, allied_factions = mod.check_validity_and_gather_payload_info(unitContexts)
    if not is_valid then
        out("WTF? Asked the script to eat an invalid group of units")
    end
    local character = cm:get_character_by_cqi(char_cqi)
    if not character or character:is_null_interface() then
        out("WTF? Asked the script to eat units on character cqi "..char_cqi.. " but couldn't get that character")
    elseif character:military_force():is_null_interface() then
        out("WTF? Asked the script to eat units on character cqi "..char_cqi.. " but they have no army")
    end
    --build payload for rewards and penalties.
    out("Building Payload!")
    local dilemma_key = mod.get_dilemma_key()
    local dilemma_builder = cm:create_dilemma_builder(dilemma_key)
    --if we trigger multiple times this ends up getting stuck on the first payload we made unless you do this.
    dilemma_builder:remove_choice_payload("FIRST")
    dilemma_builder:remove_choice_payload("SECOND")
    local payload_builder = cm:create_payload();
    payload_builder:clear()

    dilemma_builder:add_target("default", character:military_force())
    local event_to_show 
    for i = 1, #unitContexts do
        local index = tonumber(unitContexts[i][1]) 
        ---@cast index integer
        local unitContextId = unitContexts[i][2]
        local campaignUnitContext = cco("CcoCampaignUnit", unitContextId)
        if campaignUnitContext and not event_to_show then
            local main_unit_key = campaignUnitContext:Call("UnitRecordContext.Key")
            for event_key, valid_units in pairs(mod.flavour_events) do
                if valid_units[main_unit_key] then
                    event_to_show = event_key
                end
            end
        end
        if campaignUnitContext:Call("IsCharacter") then
            local char_cqi = campaignUnitContext:Call("CharacterContext.CQI")
            local char = cm:get_character_by_cqi(char_cqi)
            if char and not char:is_null_interface() then
                --table.insert(characters_to_kill, char_cqi)
                payload_builder:character_to_kill(char)
                --dilemma_builder:add_target(char:family_member())
            else
                out("WTF? Asked the script to eat a character on character cqi "..char_cqi.. " but couldn't get that character")
            end
        end
        local unit_interface = character:military_force():unit_list():item_at(index)
        if unit_interface and not unit_interface:is_null_interface() then
            payload_builder:destroy_unit(unit_interface)
        else
            out("WTF? Asked the script to eat a unit at index "..index.. " but couldn't get that unit")
        end
    end

    out("Adding a pooled resource gain of "..tostring(food_gain).." to the payload!")
    payload_builder:military_force_pooled_resource_transaction(character:military_force(), "wh3_main_ogr_meat", "mod_eat_units", food_gain, false)
    local allies_dealt_with = {}
    for i = 1, #allied_factions do
        if not allies_dealt_with[allied_factions[i]] then
            local ally_faction = cm:get_faction(allied_factions[i])
            out("Adding a diplomatic penalty for "..allied_factions[i].." to the payload builder")
            if ally_faction:subculture() == "wh_main_sc_dwf_dwarfs" then
                local grudge_val = cm:get_saved_value("df_gnoblar_snacks_grudge_"..character:faction():name())
                if grudge_val == 0 then
                    cm:set_saved_value("df_gnoblar_snacks_grudge_"..character:faction():name(), 1)
                end
            end
            allies_dealt_with[allied_factions[i]] = true
            payload_builder:diplomatic_attitude_adjustment(ally_faction, -6)
        end
    end


    core:add_listener(
        "GnoblarDilemmaTrigger",
        "DilemmaChoiceMadeEvent",
        function (context)
            return context:dilemma() == dilemma_key
        end,
        function (context)
            if context:choice() == 0 then
                --disband all units
                out("Disbanding Gnoblar!")
                if not event_to_show then
                    if cm:random_number(mod.fearful_gnoblar_chance) then
                        event_to_show = mod.fearful_gnoblar_event
                    end
                end
                if event_to_show then
                    out("Showing event: "..event_to_show)
                    --cm:trigger_incident_with_targets(faction:command_queue_index(), event_to_show, 0, 0, 0, character:military_force():command_queue_index(), 0, 0)
                    --events currently disabled: I need to finish them and program this part better
                    --TODO for IME
                end
                --notify script.
                core:trigger_event("ModScriptEventGnoblarsEatenByFaction", faction, character)
            end
            --clean up the UI
            if faction:name() == cm:get_local_faction_name(true) then
                mod.unit_selection = {}
                mod.check_units_and_populate_snack_button()
                common.call_context_command("CcoCampaignCharacter", char_cqi, "Select(false)")
            end
        end)
    
    dilemma_builder:add_choice_payload("FIRST", payload_builder)
    local payload_builder_2 = cm:create_payload()
    payload_builder_2:clear()
    payload_builder_2:text_display("dummy_do_nothing")
    dilemma_builder:add_choice_payload("SECOND", payload_builder_2)


    cm:launch_custom_dilemma_from_builder(dilemma_builder, faction)

end


mod.mp_safe_trigger = function()
    if #mod.unit_selection == 0 then
        out("Error: MP safe trigger asked for, but no unit card selection was set")
        return
    end
    local character_cqi = cm:get_campaign_ui_manager():get_char_selected_cqi()
    local payload_list = mod.create_mp_trigger_table()
    local triggerString = mod.ui_trigger_prefix..serialize_simple_string_list(payload_list).."+"..character_cqi

    out("Firing MP Safe Gnoblar Munching Event")
    CampaignUI.TriggerCampaignScriptEvent(cm:get_faction(cm:get_local_faction_name(true)):command_queue_index(),
    triggerString)
end


mod.hide_or_show_snack_button = function(character)
    local snack_button = mod.get_or_create_snack_button()
    if mod.has_snacks(character) then
        snack_button:SetVisible(true)
        mod.check_units_and_populate_snack_button()
    else
        snack_button:SetVisible(false)
    end
end



--unused
mod.get_unit_key_from_unit_card = function(unitCard)
    local unit_key
    local campaignUnitContextId = unitCard:GetContextObjectId("CcoCampaignUnit")
    out("Context ID for "..unitCard:Id().." was "..tostring(campaignUnitContextId))
    if campaignUnitContextId then
      local campaignUnitContext = cco("CcoCampaignUnit", campaignUnitContextId)
        unit_key = campaignUnitContext:Call("UnitRecordContext.Key")
        out(unitCard:Id().." was a unit "..unit_key)
    else
      local experience_icon = find_uicomponent(unitCard, "experience")
      local unitDetailsContextID = experience_icon:GetContextObjectId("CcoUnitDetails")
      out(unitCard:Id().. "is a queued unit "..tostring(unitDetailsContextID))
      local key_with_trailing_data = string.gsub(unitDetailsContextID, "UnitRecord_", "")
        unit_key = string.gsub(key_with_trailing_data, "_%d+_%d+%.%d+$", "")
    end
    if unit_key then
        return unit_key
    else
        out("Could not find unit key for card "..tostring(unitCard:Id()))
    end
end





mod.add_listeners = function()
    --Prevent duplicating listeners when I'm testing with QA console.
    core:remove_listener("GnoblarSnacks")

    --listen for character selected
    if cm:get_local_faction(true):subculture() == "wh3_main_sc_ogr_ogre_kingdoms" then
        core:add_listener(
            "GnoblarSnacks",
            "CharacterSelected",
            function(context)
                return not mod.is_character_details_open()
            end,
            function(context)
                local character = context:character()
                out("Selected a character: "..tostring(character:command_queue_index()))
                if mod.is_units_panel_open() then
                    --This callback is necessary to prevent a crash.
                    cm:callback(function ()
                        if not mod.is_character_details_open() then
                            mod.hide_or_show_snack_button(character)
                        end
                    end, 0.1)
                else
                    --do it a bit later
                    mod.panels_open_callback(function ()
                        mod.hide_or_show_snack_button(character)
                    end, "units_panel")
                end
            end,
            true)

        --when the character details panel closes, check whether the units panel is open, and if it is, call the show or hide function.
        --necessary because the character might get an immortal skill while this panel is open.
        core:add_listener(
            "GnoblarSnacks",
            "PanelClosedCampaign",
            function(context)
                return context.string == "character_details_panel"
            end,
            function(context)
                if mod.is_units_panel_open() then
                    mod.hide_or_show_snack_button(cm:get_character_by_cqi(cm:get_campaign_ui_manager():get_char_selected_cqi()))
                end
            end,
            true)

        --listen for the panel opening, create the snack button 
        core:add_listener(
            "GnoblarSnacks",
            "PanelOpenedCampaign",
            function(context) 
                local panel = (context.string == "units_panel")
                return panel and not mod.is_character_details_open()
            end,
            function(context)
                out("units panel opened")
                mod.hide_or_show_snack_button(cm:get_character_by_cqi(cm:get_campaign_ui_manager():get_char_selected_cqi()))
            end,
            true)

        --update our picture of what is selected when a land unit card is clicked.
        core:add_listener(
            "GnoblarSnacks",
            "ComponentLClickUp",
            function(context)
                return string.find(context.string, "LandUnit")
            end,
            function(context)
                out("Mouseclick triggered on a land unit")
                mod.check_units_and_populate_snack_button()
            end,
            true)
        --listen for the click 
        core:add_listener(
            "GnoblarSnacks",
            "ComponentLClickUp",
            function(context)
                return context.string == mod.button_name
            end,
            function(context)
                out("Player clicked the Snack Button!")
                mod.mp_safe_trigger()
            end,
            true)
    end
    --listen for the MP safe event
    --This listener is outside the local faction check because the MP safe trigger needs to be applied even if you aren't ogres.
    core:add_listener(
        "GnoblarSnacks",
        "UITrigger",
        function(context)
            return string.find(context:trigger(), mod.ui_trigger_prefix)
        end,
        function(context)
            local faction = cm:model():faction_for_command_queue_index(context:faction_cqi());
            local tstr = string.gsub(context:trigger(), mod.ui_trigger_prefix, "")
            local unit_context_str = string.sub(tstr, 0, tstr:find("+") - 1)
            local cqi_as_str = string.sub(tstr, tstr:find("+")+1, tstr:len())
            out("MP Trigger Recieved:\nTSTR:"..tstr.."\n\t"..unit_context_str.."\n\t"..cqi_as_str)
            local unit_context_list = restore_serialized_string_list(unit_context_str)
            mod.eat_gnoblars(faction, tonumber(cqi_as_str), unit_context_list)
        end,
        true)
    core:add_listener(
        "GnoblarSnacks",
        "FactionTurnStart",
        function (context)
            local val = cm:get_saved_value("df_gnoblar_snacks_grudge_"..context:faction():name())
            return val == 1 
        end,
        function (context)
            cm:trigger_incident(context:faction():name(), mod.grudge_event, true)
            cm:set_saved_value("df_gnoblar_snacks_grudge_"..context:faction():name(), 2)
        end
    )
end

local mct = core:get_static_object("mod_configuration_tool")

mct_gnoblarsnacks = function ()
    local function apply_mct()
        out("Applying MCT settings")
        local settings = mct:get_mod_by_key("df_gnoblar_snacks")
        local enabled = settings:get_option_by_key("a_enable")
        if enabled:get_finalized_setting() == true then
            out("Mod Enabled")
            mod.add_listeners()
            local meat_setting = settings:get_option_by_key("b_meat_value")
            local meat_value = meat_setting:get_finalized_setting()
            if is_integer(meat_value) and meat_value ~= mod.per_unit_food_gain then
                out("Meat value changed from "..mod.per_unit_food_gain.." to "..meat_value)
                mod.per_unit_food_gain = meat_value
            end
            local uim = cm:get_campaign_ui_manager()
            local char_selected_cqi = uim:get_char_selected_cqi()
            if cm:get_character_by_cqi(char_selected_cqi) then
                local characterContext = cco("CcoCampaignCharacter", char_selected_cqi)
                characterContext:Call("Select(false)")
            end
        else
            out("Mod disabled")
            core:remove_listener("GnoblarSnacks")
            local button = find_uicomponent(mod.button_name)
            if button then
                button:SetVisible(false)
            end
        end
    end
    core:add_listener(
        "GnoblarSnacks_MctFinalized",
        "MctFinalized",
        true,
        function (context)
            apply_mct()
        end,
        true)
    apply_mct()
end

gnoblarsnacks = function()
    
    --if mct is active, use the mct version of this script to apply settings
    if mct then
        mct_gnoblarsnacks()
        return mod
    end
    --otherwise, add listeners as normal.
    mod.add_listeners()

    return mod
end


local public_functions = {
    add_unit_meat_upkeep_display = function(unit_key, food_upkeep_cost)
        mod.ogre_pooled_resource_costs[unit_key] = {unit = unit_key, upkeep_resource_cost = food_upkeep_cost}
    end,
    set_unit_is_gnoblar = function (unit_key)
        mod.gnoblar_units[unit_key] = true
    end
}
--allow other scripts to access the public functions
core:add_static_object("df_gnoblar_snacks", public_functions)
