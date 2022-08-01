local out = function(t)
    ModLog("DRUNKFLAMINGO: "..tostring(t).." (rogue_main.lua)")
end

---comment
---@param call fun()
---@param time integer
---@param name string
local function ui_callback(call, time, name)
    cm:real_callback(function()
        local ok, err = pcall(call)
        if not ok then
            out("Error in callback "..((name or "with unspecified name")))
            out(err)
            out(debug.traceback())
        end
    end, time, name)
end

local playable_factions = {
    ["wh3_main_dae_daemon_prince"] = true
}

local function add_list_into_list(list, list_to_add)
    for i = 1, #list_to_add do
        list[#list + 1] = list_to_add[i]
    end
end



---SECTION: type Checker Definitions:
---These are used by the Lua type checker when coding in VSCode.
---They reflect the lowest level structures in the game data table.

---@class ROGUE_DATA_UNIT_ENTRY
local template_unit_entry = {
    unit_key = "" ---@type string
}
---@alias ROGUE_DATA_UNIT_ENTRY_LIST ROGUE_DATA_UNIT_ENTRY[]

---@class ROGUE_DATA_COMMANDER_ENTRY
local template_commander_entry = {
    commander_key = "", ---@type string
    agent_subtype = "", ---@type string
    difficulty_delta = 0, ---@type integer
}

---@class ROGUE_DATA_FRAGMENT_ENTRY
local template_fragment_entry = {
    ["difficulty_delta"] = 0, ---@type integer
    ["localised_name"] = "", ---@type string
    ["generated_unit_slots"] = {}, ---@type ROGUE_DATA_UNIT_ENTRY_LIST[]
    ["force_fragment_key"] = "", ---@type string
    ["mandatory_units"] = {}, ---@type ROGUE_DATA_UNIT_ENTRY[]
    ["internal_description"] = "", ---@type string
    ["allowed_as_reward"] = true ---@type boolean
}

---@module 'rogue_data_loader'

local data = rogue_daniel_loader.load_all_data()


---SECTION: GENERATION FUNCTIONS
---These functions are used to generate randomized forces, commanders, rewards, and encounters

---comment
---@param fragment ROGUE_DATA_FRAGMENT_ENTRY
---@return ROGUE_DATA_UNIT_ENTRY_LIST
local function generate_units_from_force_fragment(fragment)
    local unit_list = {}
    add_list_into_list(unit_list, fragment.mandatory_units)
    local gen_slots = fragment.generated_unit_slots
    for i = 1, #gen_slots do
        local slot_options = gen_slots[i]
        table.insert(unit_list, slot_options[cm:random_number(#slot_options)])
    end
    return unit_list 
end

---comment
---@param force_key string
local function generate_force(force_key)
    local force = {} 
    local force_data = data.forces[force_key]

    force.difficulty = force_data.base_difficulty ---@type integer
    force.units = {} ---@type ROGUE_DATA_UNIT_ENTRY_LIST
    local fragment_list = force_data.force_fragments
    local mandatory_fragments = fragment_list["MANDATORY"] or {}
    for i = 1, #mandatory_fragments do
        local fragment = mandatory_fragments[i]
        add_list_into_list(force.units, generate_units_from_force_fragment(fragment))
        force.difficulty = force.difficulty + fragment.difficulty_delta
    end
    for i = 1, #fragment_list do
        local fragment_options = fragment_list[i]
        local fragment = fragment_options[cm:random_number(#fragment_options)]
        add_list_into_list(force.units, generate_units_from_force_fragment(fragment))
        force.difficulty = force.difficulty + fragment.difficulty_delta
    end

    local commander_options = force_data.commander_set
    force.commander = commander_options[cm:random_number(#commander_options)] ---@type ROGUE_DATA_COMMANDER_ENTRY
    force.difficulty = force.difficulty + force.commander.difficulty_delta


    return force
end




---SECTION: EVENT HANDLERS

local active_encounters = {} ---@type table<string, table>
--3dUI elements for the encounters are generated with the context expression: 
--[[
    SettlementList.Filter(ScriptObjectContext("rogue_active_encounters").TableValue.HasValueForKey(SettlementKey, false))
--]]

--dev, for now, just set a dummy value

active_encounters["settlement:wh3_main_chaos_region_doomkeep"] = {}

function start_ui()
    out("Creating the Rogue Daniel UI!")
    --3D UI Parent creation and propogation of the root context object
    local worldspace_parent = UIComponent(core:get_ui_root():CreateComponent("rogue3dui", "ui/rogue/rogue3dui"))
    if worldspace_parent then
        worldspace_parent:SetContextObject(cco("CcoCampaignRoot", ""))

    else
        out("The Worldspace Parent Failed to Create! Check the rogue3dui.twui.xml file!")
    end

    --scripted context objects.
    common.set_context_value("rogue_active_encounters", active_encounters)
end


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
    --destroy all AI armies on new game
    if cm:is_new_game() then
        local faction_list = cm:model():world():faction_list()
        for i = 0, faction_list:num_items() - 1 do
            local faction = faction_list:item_at(i)
            if faction:is_human() == false then
                cm:callback(function ()
                    cm:kill_all_armies_for_faction(faction)
                end, math.ceil(i+1/10)/10)
            end
        end
    end


    --wait for the loading screen to finish, then set up the UI.
    core:progress_on_loading_screen_dismissed(function ()
        out("Loading Screen Dismissed")
        ui_callback(function ()
            out("UI PreCreation Callback")
            local movies = find_uicomponent("movie_overlay_intro_movie")
            if movies then
                movies:Destroy()
            end
            uim:display_first_turn_ui(false)
            uim:enable_character_selection_whitelist()
            uim:enable_settlement_selection_whitelist()
            local hud = find_uicomponent("hud_campaign")
            cm:override_ui("disable_settlement_labels", true)
            hud:SetVisible(false)
            local menu_bar = find_uicomponent("menu_bar", "buttongroup")
            for i = 0, menu_bar:ChildCount() - 1 do
                local child = UIComponent(menu_bar:Find(i))
                if child:Id() ~= "button_menu" then
                    child:SetVisible(false)
                end
            end
            common.set_context_value("disable_campaign_spacebar_options", 1)
            ui_callback(function ()
                start_ui()
            end, 250, "UISTART")
        end, 100)
    end)
end

---SECTION: Console Commands
---testing functions, exposed to the console

local function generate_and_print_force_with_key(key)
    local force = generate_force(key)
    out("Force Generated: "..key)
    out("Difficulty: "..force.difficulty)
    for i = 1, #force.units do
        local unit = force.units[i]
        out("\t"..unit.unit_key)
    end
    out("Commander: "..force.commander.commander_key)
end


rogue_console = {
    generate_and_print_force_with_key = generate_and_print_force_with_key
}