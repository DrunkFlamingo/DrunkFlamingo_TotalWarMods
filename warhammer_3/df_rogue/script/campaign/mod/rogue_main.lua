local out = function(t)
    ModLog("DRUNKFLAMINGO: "..tostring(t).." (rogue_main.lua)")
end

--- load a lua file with the correct environment
--- ie. load_module("test", "script/my_folder/") to load script/my_folder/test.lua
---@param file_name string
---@param file_path string
---@return any
local function load_module(file_name, file_path)
    local full_path = file_path.. file_name.. ".lua"
    local file, load_error = loadfile(full_path)
  
    if not file then
        out("Attempted to load module with name ["..file_name.."], but loadfile had an error: ".. load_error .."")
    else
        out("Loading module with name [" .. file_name.. ".lua]")
  
        local global_env = core:get_env()
        setfenv(file, global_env)
        local lua_module = file(file_name)
  
        if lua_module ~= false then
            out("[" .. file_name.. ".lua] loaded successfully!")
        end
  
        return lua_module
    end
  
    -- run "require" to see what the specific error is
    local ok, msg = pcall(function() require(file_path .. file_name) end)
  
    if not ok then
        out("Tried to load module with name [" .. file_name .. ".lua], failed on runtime. Error below:")
        out(msg)
        return false
    end
end

---load all of the lua files from a specific folder
--- ie. load_modules("script/my_folder/") to load everything in ?.pack/script/my_folder/
--- code shamelessly stolen from Vandy <3
---@param path string
local function load_modules(path)
    local search_override = "*.lua" -- search for all files that end in .lua within this path
    local file_str = common.filesystem_lookup(path, search_override)

    for filename in string.gmatch(file_str, '([^,]+)') do
        local filename_for_out = filename

        local pointer = 1
        while true do
            local next_sep = string.find(filename, "\\", pointer) or string.find(filename, "/", pointer)

            if next_sep then
                pointer = next_sep + 1
            else
                if pointer > 1 then
                    filename = string.sub(filename, pointer)
                end
                break
            end
        end

        local suffix = string.sub(filename, string.len(filename) - 3)

        if string.lower(suffix) == ".lua" then
            filename = string.sub(filename, 1, string.len(filename) -4)
        end


        load_module(filename, string.gsub(filename_for_out, filename..".lua", ""))
    end
end

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

---comment
---@param call fun()
---@param time number
---@param name string
local function game_callback(call, time, name)
    cm:callback(function()
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

---comment
---@param list string[]
---@return string
local function list_to_string(list)
    if #list == 0 then
        return ""
    end
    local str = list[1]
    for i = 2, #list do
        local list_str = list[i]
        if type(list_str) == "string" then
            str = str..","..list_str
        else
            out("non-string value in the list passed to list_to_string")
            if type(list_str) == "table" then
                out("table value: "..table_to_string(list_str))
            else
                out("value: "..tostring(list_str))
            end
        end
    end
    return str
end

---Save a table to the save file.
---@param table_name string
---@param table any
local function persist_table(table_name, table)
    cm:add_saving_game_callback(function(context) cm:save_named_value("rogue_"..table_name, table, context) end)
    cm:add_loading_game_callback(function(context) table = cm:load_named_value("rogue_"..table_name, {}, context) end)
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

local mod_database = rogue_daniel_loader.load_all_data()

if not Forced_Battle_Manager then
    load_module("wh2_campaign_forced_battle_manager", "script/campaign/")
end

---SECTION: Persistent Data

local progress_gates = {} ---@type table<string, integer>
persist_table("progress_gates", progress_gates)

local function was_progress_gate_reached(gate)
    if not progress_gates[gate] then
        return false
    end
    return progress_gates[gate] >= mod_database.progress_gates[gate].activation_threshold
end


local active_encounters = {} ---@type table<string, GENERATED_ENCOUNTER>
persist_table("active_encounter_details", active_encounters)
local function send_encounters_to_ui()
    common.set_context_value("rogue_active_encounters", active_encounters)
end

--dev, for now, just set a dummy value

local pending_forced_encounters = {} ---@type GENERATED_ENCOUNTER[]
persist_table("pending_forced_encounters", pending_forced_encounters)

local pending_rewards = {}
persist_table("pending_rewards", pending_rewards)
local function send_rewards_to_ui()
    common.set_context_value("rogue_pending_rewards", pending_rewards)
end


---SECTION: GENERATION FUNCTIONS
---These functions are used to generate randomized forces, commanders, rewards, and encounters


local function queue_forced_encounter(encounter)
    out("Queued forced encounter: "..encounter.key)
    table.insert(pending_forced_encounters, encounter)
end

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

---commentmod_database
---@param force_key string
---@return GENERATED_FORCE
local function generate_force(force_key)
    ---@class GENERATED_FORCE
    local force = {} 
    local force_data = mod_database.forces[force_key]

    force.key = force_key

    local faction_options = force_data.faction_set
    force.faction = faction_options[cm:random_number(#faction_options)]

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
    force.unit_string = force.units[1].unit_key
    for i = 2, #force.units do
        local unit = force.units[i]
        force.unit_string = force.unit_string..","..unit.unit_key
    end

    local commander_options = force_data.commander_set
    force.commander = commander_options[cm:random_number(#commander_options)] ---@type ROGUE_DATA_COMMANDER_ENTRY
    force.difficulty = force.difficulty + force.commander.difficulty_delta


    return force
end

---comment
---@param encounter_key string
---@param is_forced_encounter boolean
---@return GENERATED_ENCOUNTER
local function generate_encounter(encounter_key, is_forced_encounter)
    local encounter_data = mod_database.encounters[encounter_key]

    if active_encounters[encounter_data.region] then
        out("There is already an encounter "..tostring(active_encounters[encounter_data.region].key).. "  in this region: "..encounter_data.region)
        out("Displacing this encounter!") 
        --TODO - handle this case
    end

    ---@class GENERATED_ENCOUNTER
    local encounter = {}

    encounter.key = encounter_key ---@type string
    --create a force for the encounter
    local force_set = encounter_data.force_set
    local selected_force_key = force_set[cm:random_number(#force_set)]
    local force = generate_force(selected_force_key)
    encounter.force = force ---@type GENERATED_FORCE

    --TODO - generate rewards

    active_encounters[encounter_data.region] = encounter

    return encounter
end

local function progress_gate_activated(progress_gate)
    out("Progress gate "..progress_gate.." activated!")
    local gate_data = mod_database.progress_gates[progress_gate]

    --loop through the encounters displaced by this gate and, if they are active, remove them.
    local displaces_encounters = gate_data.displaces_encounters
    for i = 1, #displaces_encounters do
        local displaced_encounter = displaces_encounters[i]
        if active_encounters[displaced_encounter.region] then
            out("Removing displaced encounter "..displaced_encounter)
            active_encounters[displaced_encounter.region] = nil
        end
    end
    --generate the encounters for this gate
    local generates_encounters = gate_data.generates_encounters
    for i = 1, #generates_encounters do
        local encounter_key = generates_encounters[i].key
        generate_encounter(encounter_key)
    end
    --Randomly select an encounter to force
    local forces_encounters = gate_data.forces_encounters
    if #forces_encounters > 0 then
        local encounter_key = forces_encounters[cm:random_number(#forces_encounters)].key
        queue_forced_encounter(generate_encounter(encounter_key, true))
    end

    send_encounters_to_ui()
end 

local function increment_progress_gate_progress(progress_gate, increment)
    if was_progress_gate_reached(progress_gate) then
        return
    end
    progress_gates[progress_gate] = (progress_gates[progress_gate] or 0) + increment
    out("Progress gate "..progress_gate.." is now at "..progress_gates[progress_gate])
    if was_progress_gate_reached(progress_gate) then
        progress_gate_activated(progress_gate)
    end
end

---SECTION: EVENT HANDLERS

local function on_encounter_completed(encounter_key)
    local encounter_data = mod_database.encounters[encounter_key]

    --increment the progress gate for this encounter
    local progress_gate = encounter_data.increments_progress_gate
    local progress_increment = encounter_data.gate_increment_weight
    if progress_gate then
        increment_progress_gate_progress(progress_gate, progress_increment)
    end

    --TODO pend rewards

    --remove the encounter from the active encounters list
    local region = encounter_data.region
    if active_encounters[region] then
        active_encounters[region] = nil
    end
end

local function commence_encounter(settlement_key)
    local encounter = active_encounters[settlement_key]

    if not encounter then
        out("No encounter to commence in region "..settlement_key)
        return
    end
    out("Commencing encounter "..encounter.key.." in region "..settlement_key)
    local fbm = Forced_Battle_Manager:setup_new_battle(encounter.key)
    local faction_name = encounter.force.faction
    local unit_list_string = encounter.force.unit_string
    local agent_subtype = encounter.force.commander.agent_subtype
    local force_key = encounter.force.key
    local region_key = string.gsub(settlement_key, "settlement:", "")
    local x, y = cm:find_valid_spawn_location_for_character_from_settlement(faction_name, region_key, false, true, 30)
    local player_cqi = cm:get_local_faction():faction_leader():command_queue_index()
    local is_ambush = false
    fbm:add_new_force(force_key, unit_list_string, faction_name, true, nil, agent_subtype)
    --TODO fill out this conditional for defensive/offensive/ambush
    if true then
        out("Forcing an encounter battle!")
        fbm:trigger_battle(force_key, player_cqi, x, y, false)
    end
end


local function create_event_handlers()
    
end

---SECTION: UI 

--3dUI elements for the encounters are generated with the context expression: 
--[[
    SettlementList.Filter(ScriptObjectContext("rogue_active_encounters").TableValue.HasValueForKey(SettlementKey, false))
--]]



---comment
---@param settlement_key string
---@return UIC|nil
local function get_3dui_child_for_settlement(settlement_key)
    local worldspace_parent = find_uicomponent(core:get_ui_root(), "rogue3dui")
    if not worldspace_parent then
        out("get_3dui_child_for_settlement Could not find 3dUI parent")
        return nil
    end
    local settlement_key = "CcoCampaignSettlement"..settlement_key
    local settlement_parent = find_uicomponent(worldspace_parent, settlement_key)
    if not settlement_parent then
        out("get_3dui_child_for_settlement Could not find 3dUI parent for settlement "..settlement_key)
        return nil
    else
        return settlement_parent
    end
end

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
    send_encounters_to_ui()
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

    game_callback(function ()
        out("Game Starting Callback")
        create_event_handlers()
        if cm:is_new_game() then
            increment_progress_gate_progress("NEW_GAME", 1)
        end
    end, 0.1, "GAMESTARTCALLBACK")
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
    generate_and_print_force_with_key = generate_and_print_force_with_key,
    generate_encounter = generate_encounter,
    commence_encounter = commence_encounter
}
--[[
    local ok, err = pcall(function()
        rogue_console.commence_encounter("settlement:wh3_main_chaos_region_doomkeep")
    end)
    if not ok then
        ModLog(tostring(err))
        ModLog(debug.traceback())
    end
--]]
