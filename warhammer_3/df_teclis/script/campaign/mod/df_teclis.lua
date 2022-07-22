local out = function(t)
    ModLog("DRUNKFLAMINGO: "..tostring(t).." (Teclis)")
end

local mod = {}

mod.feature_button_name = "teclis_teleport"
mod.teclis_faction_key = "wh2_main_hef_order_of_loremasters"
mod.get_teclis_faction = function()
    return cm:get_faction(mod.teclis_faction_key)
end

mod.high_elf_colony_factions = {"wh2_main_hef_fortress_of_dawn", "wh2_main_hef_citadel_of_dusk", "wh2_main_hef_tor_elasor"}

local function get_button_group_management()
    return find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management")
end

local function get_or_create_feature_button()
    local button_parent = get_button_group_management()
    local existing_button = find_child_uicomponent(button_parent, mod.feature_button_name)
    if existing_button then
        return existing_button
    else
        local new_button = button_parent:CreateComponent(mod.feature_button_name, "ui/campaign ui/teclis_teleport_feature_button")
    end
end

local function update_feature_button_mission_counter(feature_button)
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
    local whose_turn = cm:model():world():whose_turn_is_it()
    for i = 0, whose_turn:num_items() - 1 do
        local who = whose_turn:item_at(i)
        if who:is_human() and who:name() == mod.teclis_faction_key then
            update_feature_button_mission_counter(get_or_create_feature_button())
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
        true
    )

end

local function new_game_setup()
    local starting_mission = "df_teclis_start_mission"
    --grant regions to the Fortress of Dawn faction so they have a chance to survive until the player can reach them.
    transfer_multiple_regions({"wh3_main_combi_region_tor_surpindar", "wh3_main_combi_region_dawns_light"}, "wh2_main_hef_fortress_of_dawn")
    --give Teclis a defensive alliance with the Elven Colonies
    for i = 1, #mod.high_elf_colony_factions do
        cm:force_alliance(mod.high_elf_colony_factions[i], mod.teclis_faction_key, false)
    end
    --have teclis declare war on kairos
    cm:force_declare_war(mod.teclis_faction_key, "wh3_main_tze_oracles_of_tzeentch", false, false)
    --TODO grant Kairos additional units based on the difficulty level.

    if mod.get_teclis_faction():is_human() then
            --issue the mission to rescue the fortress of dawn.
        cm:trigger_mission(mod.teclis_faction_key, starting_mission, true)
        --grant diplomatic visibility of the Empire and Tyrion
        cm:make_diplomacy_available(mod.teclis_faction_key, "wh_main_emp_empire")
        cm:make_diplomacy_available(mod.teclis_faction_key, "wh2_main_hef_lothern")
    end
end


---called on first tick after world created by the mod loader.
df_teclis = function ()
    out("Mod is active")
    if cm:is_new_game() then
        new_game_setup()
    end
    start_ui_listeners()
end


--[[notes
 precache condition for ui
  PlayersFaction.FactionRecordContext.Key == &quot;wh2_main_hef_order_of_loremasters&quot;  
--]]