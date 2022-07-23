local out = function(t)
    ModLog("DRUNKFLAMINGO: "..tostring(t).." (Teclis)")
end

local mod = {}

mod.feature_button_name = "teclis_teleport"
mod.teclis_faction_key = "wh2_main_hef_order_of_loremasters"
mod.get_teclis_faction = function()
    return cm:get_faction(mod.teclis_faction_key)
end

---applying this effect bundle to a region causes a TP button to appear there.
mod.teleport_node_bundle = "df_teclis_teleport_node"

mod.is_teleport_panel_open = false
mod.panels_hidden = {}

mod.high_elf_colony_factions = {"wh2_main_hef_fortress_of_dawn", "wh2_main_hef_citadel_of_dusk", "wh2_main_hef_tor_elasor"}

--wh3_main_combi_region_great_turtle_isle
--wh3_main_combi_region_the_star_tower
--wh3_main_combi_region_arnheim
mod.high_elf_colony_regions = {"wh3_main_combi_region_great_turtle_isle", 
"wh3_main_combi_region_the_star_tower", "wh3_main_combi_region_arnheim",
"wh3_main_combi_region_fortress_of_dawn", "wh3_main_combi_region_citadel_of_dusk", "wh3_main_combi_region_tower_of_the_sun"
}

---grabs the visible 3DUI elements currently displayed on the screen and populates them with contextual infromation.
-----Consider doing this with CCO instead of Lua.
local function teleport_feature_callback()
    local teleport_feature = find_uicomponent("teclis_teleport_feature")
end

local function open_teleport_feature()
    mod.is_teleport_panel_open = true
    out("Opening teleport feature")
    local uim = cm:get_campaign_ui_manager()
    uim:enable_character_selection_whitelist()
    local currently_selected_char = cm:get_character_by_cqi(uim:get_char_selected_cqi() or 0)
    if currently_selected_char and not currently_selected_char:faction():name() == mod.teclis_faction_key then
        CampaignUI.ClearSelection()
    end
    uim:add_all_characters_for_faction_selection_whitelist(mod.teclis_faction_key)
    uim:enable_settlement_selection_whitelist()
    cm:override_ui("disable_settlement_labels", true);
    cm:repeat_real_callback(teleport_feature_callback, 200, "teclis_teleport_feature_callback")
    local teleport_feature_address = core:get_ui_root():CreateComponent("teclis_teleport_feature", "ui/campaign ui/teclis_teleport_panel")
    local teleport_feature_panel = UIComponent(teleport_feature_address)
    teleport_feature_panel:SetContextObject(cco("CcoCampaignRoot", ""))

    
end

local function close_teleport_feature()
    out("Closing teleport feature")
    mod.is_teleport_panel_open = false
    local uim = cm:get_campaign_ui_manager()
    uim:disable_character_selection_whitelist()
    uim:disable_settlement_selection_whitelist()
    cm:override_ui("disable_settlement_labels", false);
    cm:remove_real_callback("teclis_teleport_feature_callback")
    local teleport_feature = find_uicomponent("teclis_teleport_feature")
    if teleport_feature then
        teleport_feature:DestroyChildren()
        teleport_feature:Destroy()
    end

end

---comment
---@return UIC|nil
local function get_button_group_management()
    return find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management")
end

---comment
---@return UIC|nil
local function get_or_create_feature_button()
    local button_parent = get_button_group_management()
    if not button_parent then
        out("get_or_create_feature_button Could not find button group management component")
        return nil
    end
    local existing_button = find_child_uicomponent(button_parent, mod.feature_button_name)
    if existing_button then
        return existing_button
    else
        local new_button = button_parent:CreateComponent(mod.feature_button_name, "ui/campaign ui/teclis_teleport_feature_button")
    end
end

local function update_feature_button_mission_counter(feature_button)
    if not feature_button then
        out("update_feature_button_mission_counter Could not find feature button")
        return
    end
    local mission_counter = find_child_uicomponent(feature_button, "label_teclis_missions_count")
    --TODO update_feature_button_mission_counter

end

---comment
---@param regions string[]
---@param faction_key string
local function transfer_multiple_regions(regions, faction_key)
    for i = 1, #regions do
        cm:callback(function ()
            cm:transfer_region_to_faction(regions[i], faction_key)
        end, i/10)
    end
end

local function start_ui_listeners()
    if cm:get_local_faction_name(true) ~= mod.teclis_faction_key then
        return
    end
    --nothing with gameplay effects after this point. UI code only.
    local whose_turn = cm:model():world():whose_turn_is_it()
    for i = 0, whose_turn:num_items() - 1 do
        local who = whose_turn:item_at(i)
        if who:is_human() and who:name() == mod.teclis_faction_key then
            core:progress_on_loading_screen_dismissed(function()
                cm:callback(function() update_feature_button_mission_counter(get_or_create_feature_button()) end, 0.1)
            end)
        end
    end
    core:add_listener(
        "TeclisUI_FactionTurnStart",
        "FactionTurnStart",
        function (context)
            return context:faction():name() == mod.teclis_faction_key
        end,
        function(context)
            update_feature_button_mission_counter(get_or_create_feature_button())
        end,
        true)
    core:add_listener(
        "TeclisUI_ComponentLClickUp",
        "ComponentLClickUp",
        function (context)
            return context.string == mod.feature_button_name
        end,
        function (context)
            out("TeclisUI_ComponentLClickUp")
            if mod.is_teleport_panel_open then
                close_teleport_feature()
            else
                open_teleport_feature()
            end
        end,
        true)
    core:add_listener(
        "TeclisUI_PanelOpenedCampaign",
        "PanelOpenedCampaign",
        function (context)
            return true
        end,
        function (context)
            out("Panel opened: "..tostring(context.string))
        end,
        true)
    
end

local function new_game_setup()
    out("new game setup")
    local starting_mission = "df_teclis_start_mission"
    --grant regions to the Fortress of Dawn faction so they have a chance to survive until the player can reach them.
    transfer_multiple_regions({"wh3_main_combi_region_tor_surpindar", "wh3_main_combi_region_dawns_light"}, "wh2_main_hef_fortress_of_dawn")
    --give Teclis a defensive alliance with the Elven Colonies
    for i = 1, #mod.high_elf_colony_factions do
        cm:force_alliance(mod.high_elf_colony_factions[i], mod.teclis_faction_key, false)
    end
    --have teclis declare war on kairos and on the fortress of dusk's starting enemy.
    cm:force_declare_war(mod.teclis_faction_key, "wh3_main_tze_oracles_of_tzeentch", false, false)
    cm:force_declare_war(mod.teclis_faction_key, "wh3_main_kho_brazen_throne", false, false)
    --TODO grant Kairos additional units based on the difficulty level.

    if mod.get_teclis_faction():is_human() then

        --apply effect bundles to the elven colonies to enable teleportation to them
        for i = 1, #mod.high_elf_colony_regions do
            cm:apply_effect_bundle_to_region(mod.teleport_node_bundle, mod.high_elf_colony_regions[i], 0)
        end

        --issue the mission to rescue the fortress of dawn.
        cm:trigger_mission(mod.teclis_faction_key, starting_mission, true)
        --grant diplomatic visibility of the Empire and Tyrion
        cm:make_diplomacy_available(mod.teclis_faction_key, "wh_main_emp_empire")
        cm:make_region_visible_in_shroud(mod.teclis_faction_key, "wh3_main_combi_region_altdorf")
        cm:make_diplomacy_available(mod.teclis_faction_key, "wh2_main_hef_lothern")
        cm:make_region_visible_in_shroud(mod.teclis_faction_key, "wh3_main_combi_region_lothern")
    end
end


---called on first tick after world created by the mod loader.
df_teclis = function ()
    out("Mod is active")
    if cm:is_new_game() then
        new_game_setup()
    end
    start_ui_listeners()
    core:add_listener(
        "Teclis_FactionTurnStart",
        "FactionTurnStart",
        function (context)
            return context:faction():name() ~= mod.teclis_faction_key and context:faction():has_home_region()
        end,
        function(context)
            local faction = context:faction() ---@type FACTION_SCRIPT_INTERFACE
            local home_region = faction:home_region() 
            local is_allied = faction:is_ally_vassal_or_client_state_of(mod.get_teclis_faction())
            if is_allied and not home_region:has_effect_bundle(mod.teleport_node_bundle) then
                out("Teclis_FactionTurnStart updating home region effect bundle for ally "..faction:name())
                cm:apply_effect_bundle_to_region(mod.teleport_node_bundle, home_region:name(), 0)
            elseif home_region:has_effect_bundle(mod.teleport_node_bundle) and not is_allied then
                out("Teclis_FactionTurnStart removing home region effect bundle for non-ally "..faction:name())
                cm:remove_effect_bundle_from_region(mod.teleport_node_bundle, home_region:name())
            end
        end, true)
end


--[[notes
 precache condition for ui
  PlayersFaction.FactionRecordContext.Key == &quot;wh2_main_hef_order_of_loremasters&quot;  

  TODO
    - replace faction and culture effects.

  ideas for AI events:
  Teleport Teclis to the player to help them when they play as an Order faction.

--]]