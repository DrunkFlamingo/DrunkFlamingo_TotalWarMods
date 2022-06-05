local out = function(t)
    ModLog("DRUNKFLAMINGO: "..tostring(t).." (rogue_main.lua)")
end


local playable_factions = {
    ["wh3_main_dae_daemon_prince"] = true
}

---data loading

---@class rogue_game_data
local data = {}


data.force_templates = {} ---@type table<string, ROGUE_FORCE_DATA>
data.force_fragments = {} ---@type table<string, ROGUE_FORCE_FRAGMENT_DATA>
data.reward_templates = {} ---@type table<string, ROGUE_REWARD_DATA>
data.name_sets = require("script/rogue_data/encounter_named_commander_set_data")


local function load_data()
    local force_fragment_data = require("script/rogue_data/encounter_force_fragments")
    local force_data = require("script/rogue_data/encounter_force_data")
    local reward_data = require("script/rogue_data/encounter_reward_data")


    local reused_keys = {}

    for i = 1, #force_data do
        local current_data = force_data[i]
        if reused_keys[current_data.id] then
            out("Duplicate force template id: "..current_data.id)
        else
            reused_keys[current_data.id] = true
            data.force_templates[current_data.id] = current_data
        end
    end

    local reused_keys = {}
    for i = 1, #force_fragment_data do
        local current_data = force_fragment_data[i]
        if reused_keys[current_data.id] then
            out("Duplicate force fragment template id: "..current_data.id)
        else
            reused_keys[current_data.id] = true
            data.force_fragments[current_data.id] = current_data
        end
    end

    local reused_keys = {}
    for i = 1, #reward_data do
        local current_data = reward_data[i]
        if reused_keys[current_data.id] then
            out("Duplicate reward template id: "..current_data.id)
        else
            reused_keys[current_data.id] = true
            data.reward_templates[current_data.id] = current_data
        end
    end
end


---loads encounters from the data file
---Verifies that the forces, force fragments, and reward data referenced by the encounter exist.
function verify_encounter_data()

    local reused_keys = {}
    local errors = {}
    local function log(t)
        table.insert(errors, t)
    end
    
    local encounter_data = require("script/rogue_data/worldmap_encounter_data")
    for _, encounter in pairs(encounter_data) do
        if reused_keys[encounter.id] then
            log("Duplicate encounter id: "..encounter.id)
        else
            reused_keys[encounter.id] = true

            for _, force in pairs(encounter.force_keys) do
                if not data.force_templates[force] then
                    log("Force template "..force.." does not exist in encounter "..encounter.id)
                else
                    local force_template = data.force_templates[force] ---@type ROGUE_FORCE_DATA
                    for _, force_fragment_set in pairs(force_template.generated_fragments) do
                        for i = 1, #force_fragment_set do
                            local force_fragment = force_fragment_set[i]
                            if not data.force_fragments[force_fragment] then
                                log("Force fragment template "..force_fragment.." does not exist in force template "..force.." in encounter "..encounter.id)
                            end
                        end
                    end
                end
            end

            for _, reward in pairs(encounter.reward_set_keys) do
                if not data.reward_templates[reward] then
                    log("Reward template "..reward.." does not exist in encounter "..encounter.id)
                end
            end
        end
    end
    if #errors == 0 then
        out("No missing data objects")
    else
        out("Missing data objects:")
        for i = 1, #errors do
            out("\t"..errors[i])
        end
    end
end


----Generators
----The functions in this section take the definitions of an encounter from the encounter data and generate the actual encounter

encounters = {} ---@class rogue_game_encounter
 

---comment
---@param encounter_data ROGUE_ENCOUNTER_DATA
local function generate_field_battle_encounter_from_data(encounter_data)
    local self = {} ---@class rogue_game_encounter
    setmetatable(self, {__index = encounters})

    self.encounter_key = encounter_data.id
    self.kind = encounter_data.encounter_kind
    self.offensive_battle = encounter_data.offensive_battle
    self.ambush_battle = encounter_data.ambush_battle

    self.unit_list = {} ---@type string[]
    self.upgrades_to_grant = {} ---@type string[][]
    
    self.location = encounter_data.encounter_settlement_location

    --pick a random force key.
    self.force_key = encounter_data.force_keys[cm:random_number(#encounter_data.force_keys)]
    --use it to build the force
    local force_template = data.force_templates[self.force_key] ---@type ROGUE_FORCE_DATA
    self.faction_key = force_template.faction_key
    for i = 1, #force_template.generated_fragments do
        local force_fragment_set = force_template.generated_fragments[i]
        local force_fragment_key = force_fragment_set[cm:random_number(#force_fragment_set)]
        local force_fragment_template = data.force_fragments[force_fragment_key] ---@type ROGUE_FORCE_FRAGMENT_DATA
        for j = 1, #force_fragment_template.mandatory_units do
            local unit_data = force_fragment_template.mandatory_units[j] ---@type ROGUE_MANDATORY_UNIT_DATA
            for k = 1, #unit_data.quantity do
                table.insert(self.unit_list, unit_data.unit_key)
            end
            for k = 1, #unit_data.unit_upgradable_effect_keys do
                table.insert(self.upgrades_to_grant, {unit_data.unit_upgradable_effect_keys[k], unit_data.unit_key, unit_data.quantity})
            end
        end
        for j = 1, #force_fragment_template.fragment_members do
            local member = force_fragment_template.fragment_members[j]
            local unit_key = member[cm:random_number(#member)]
            table.insert(self.unit_list, unit_key)
        end
    end
    self.character_details = {}
    local character_template = force_template.commanding_characters[cm:random_number(#force_template.commanding_characters)] ---@type ROGUE_COMMANDER_DATA
    self.character_details.subtype = character_template.agent_subtype_key
    self.character_details.effect_bundle = character_template.effect_bundle
    
    
end


----UI Section: Encounter Selection and Campaign HUD
----includes the code which manages creating the encounter selection screen and custom campaign HUD.

---create a WorldSpaceComponent UI Element and attach the relevant settlement CCO to position it.
local function get_or_create_worldspace_encounter_icon_at_settlement(encounter, settlement)
    --get or create worldspace holder dummy element

    --create the worldspace component as its child with the settlement name as the id

    --get the CcoCampaignSettlement

    --attach it to the worldspace component
end

local function setup_encounter_selection_ui()
	local cam_pos = {x = 119.2, y = 242.0, d = 11.4, b = 0, h = 9.7};
    cm:set_camera_position(cam_pos.x, cam_pos.y, cam_pos.d, cam_pos.b, cam_pos.h);
    --[[cm:scroll_camera_with_cutscene_to_character(3, function ()
        cm:override_ui("disable_settlement_labels", true);
    end, cm:get_local_faction():faction_leader():command_queue_index())--]]
    cm:override_ui("disable_settlement_labels", true);

    --loop through all encounters, and determine whether they are currently available to access.
    --if so, build their details from data and create a worldspace icon for them.
end

----event Callbacks
----this section contains event callbacks which handle transitioning between UI Screens 

local function on_ui_ready_event()
    ---check if we are loading after a battle, and if so, show the rewards screen.
    if cm:get_saved_value("rogue_encounter_underway") then
        
        return
    end
    ---otherwise, load the encounter selection screen.
    setup_encounter_selection_ui()
end

---after the player selects an encounter in the UI, show the encounter preview screen.
local function on_encounter_selected_event(context)
    
end

---after the player confirms the encounter in the UI, use the force battle system to trigger the encounter.
local function on_encounter_confirmed_event(context)
    out("on_encounter_confirmed_event")
    local encounter = context:encounter() ---@type rogue_game_encounter
    local character = encounter.character_details
    
    local forced_battle = Forced_Battle_Manager:setup_new_battle(encounter.encounter_key)

    local unit_string = encounter.unit_list[1]
    for i = 2, #encounter.unit_list do
        unit_string = unit_string..","..encounter.unit_list[i]
    end
    out("Unit string for encounter force: "..unit_string)
    forced_battle:add_new_force(encounter.force_key, unit_string, encounter.faction_key, true, character.effect_bundle, character.subtype)
    local player_cqi = cm:get_local_faction():faction_leader():command_queue_index()
    if encounter.offensive_battle then
        out("Forcing player attack")
        local x, y = cm:find_valid_spawn_location_for_character_from_settlement(encounter.faction_key, encounter.location, false, true, 30)
        forced_battle:trigger_battle(player_cqi, encounter.force_key, x, y, encounter.ambush_battle)
    else
        out("Forcing player defense")
        forced_battle:trigger_battle(encounter.force_key, player_cqi, nil, nil, encounter.ambush_battle)
    end
    
end

---startup

--blank these CA functions
show_intro_story_panel = function() end
setup_realms = function () end
start_game_all_factions = function () end
start_new_game_all_factions = function () end

---called by the system on FirstTick
function rogue_main()
    out("Rogue Main") 
    local uim = cm:get_campaign_ui_manager()
    if cm:is_multiplayer() then
        out("EXITING- MOD DOES NOT SUPPORT MP GAMES")
        CampaignUI.QuitToWindows()
    elseif not playable_factions[cm:get_local_faction_name()] then
       out("EXITING- THIS FACTION IS NOT PLAYABLE")
       CampaignUI.QuitToWindows()
    end


    --skip all ai faction turns
    ---@diagnostic disable-next-line
    cm:skip_all_ai_factions()
    --destroy all AI armies
    local faction_list = cm:model():world():faction_list()
    for i = 0, faction_list:num_items() - 1 do
        local faction = faction_list:item_at(i)
        if faction:is_human() == false then
            cm:callback(function ()
                cm:kill_all_armies_for_faction(faction)
            end, i/10)
        end
    end



    --wait for the loading screen to finish, then set up the UI.
    core:progress_on_loading_screen_dismissed(function ()
        out("Loading Screen Dismissed")
        cm:real_callback(function ()
            local movies = find_uicomponent("movie_overlay_intro_movie")
            if movies then
                movies:Destroy()
            end
            uim:display_first_turn_ui(false)
            uim:enable_character_selection_whitelist()
            uim:enable_settlement_selection_whitelist()
            local hud = find_uicomponent("hud_campaign")
            cm:override_ui("disable_settlement_labels", true);
            hud:SetVisible(false)
            local menu_bar = find_uicomponent("menu_bar")
            for i = 0, menu_bar:ChildCount() - 1 do
                local child = UIComponent(menu_bar:Find(i))
                if child:Id() ~= "button_menu" then
                    child:SetVisible(false)
                end
            end
            core:trigger_event("RogueUIReadyToStart")
        end, 100)
    end)

    --add listeners for the main UI events.
    add_event_callback("RogueUIReadyToStart", on_ui_ready_event)
    add_event_callback("RogueEncounterSelected", on_encounter_selected_event)
    add_event_callback("RogueEncounterConfirmed", on_encounter_confirmed_event)
end

load_data()
verify_encounter_data()