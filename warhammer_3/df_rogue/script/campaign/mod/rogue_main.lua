local out = function(t)
    ModLog("DRUNKFLAMINGO: "..tostring(t).." (rogue_main.lua)")
end


local playable_factions = {
    ["wh3_main_dae_daemon_prince"] = true
}

---data loading

---@class rogue_game_data
local data = {}

data.encounters = {}

---loads encounters from the data file
---Verifies that the forces, force fragments, and reward data referenced by the encounter exist.
local function load_encounter_data()
    --TODO load encounter data from file
    local quest_data = require("script/rogue_data/worldmap_encounter_data")
    for _, encounter in pairs(quest_data) do
        data.encounters[encounter.id] = encounter
    end
end


----Generators
----The functions in this section take the definitions of an encounter from the encounter data and generate the actual encounter

local function generate_encounter_from_data(encounter_key)


end


----UI Section: Encounter Selection and Campaign HUD
----includes the code which manages creating the encounter selection screen and custom campaign HUD.

---create a WorldSpaceComponent UI Element and attach the relevant settlement CCO to position it.
local function get_or_create_worldspace_encounter_icon_at_settlement(encounter, settlement)


end

local function setup_encounter_selection_ui()
    --loop through all encounters, and determine whether they are currently available to access.
    --if so, build their details from data and create a worldspace icon for them.
end

----event Callbacks
----this section contains event callbacks which handle transitioning between UI Screens 

local function on_ui_ready_event()
    ---check if we are loading after a battle, and if so, show the rewards screen.
    if cm:get_saved_value("rogue_encounter_underway") then
        
    end
    ---otherwise, load the encounter selection screen.
    setup_encounter_selection_ui()
end

---after the player selects an encounter in the UI, show the encounter preview screen.
local function on_encounter_selected_event(context)
    
end

---after the player confirms the encounter in the UI, use the force battle system to trigger the encounter.
local function on_encounter_confirmed_event()

end

---startup

--blank these CA functions
show_intro_story_panel = function() end
setup_realms = function () end

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