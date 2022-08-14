local log_tab = ""
local function tab_log(n)
    log_tab = log_tab.."\t"
end
local function untab_log(n)
    log_tab = string.gsub(log_tab, "\t", "", 1)
end
local function reset_log_tab()
    log_tab = ""
end
local out = function(t)
    ModLog("DRUNKFLAMINGO:"..log_tab.." "..tostring(t).." (rogue_main.lua)")
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
---@param table any[]
---@param div string 
---@return string
local function tolerant_table_concat(table, div)
    local result = ""
    for i, v in ipairs(table) do
        result = result .. tostring(v) .. div
    end
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

---@param ContextType string
---@param call fun(context: any)
---@param optional_parent_id string|nil
local function context_list_click_callback(ContextType, call, optional_parent_id)
    core:add_listener(
        ContextType.."ListComponentLClickUp",
        "ComponentLClickUp",
        function(context) 
            if optional_parent_id then
                return string.find(context.string, ContextType) and uicomponent_descended_from(UIComponent(context.component), optional_parent_id)
            end
            return string.find(context.string, ContextType) 
        end,
        function(context) 
            out("Click callback for "..context.string)
            local ok, err = pcall(call, context)
            if not ok then 
                out("Error in callback for "..context.string)
                out(err)
                out(debug.traceback())
            end
        end, true)
end
---comment
---@param button_name string
---@param call fun(context: any)
local function ui_click_callback(button_name, call)
    core:add_listener(
        button_name.."ComponentLClickUp",
        "ComponentLClickUp",
        function(context) return context.string == button_name end,
        function(context) 
            out("Click callback for "..button_name)
            local ok, err = pcall(call, context)
            if not ok then 
                out("Error in callback for "..button_name)
                out(err)
                out(debug.traceback())
            end
        end, true)
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

---comment
---@param event_names string|string[]
---@param call fun(context:any)
---@param name string
local function game_event_callback(event_names, call, name, time)
    if type(event_names) == "string" then
        event_names = {event_names}
    end
    for i = 1, #event_names do
        local event = event_names[i]
        local listener_name = (name or "unnamed") .. event
        core:add_listener(
            listener_name,
            event,
            function(context) return true end,
            function(context) 
                out("Event callback for "..event)
                game_callback(function()
                    call(context)
                end, time or 0, listener_name)
            end, true)
        out("Added game event callback "..listener_name)
    end
end

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
---@param t table
---@param load_func fun(t: table)
local function persist_table(table_name, t, load_func)
    if not load_func then
        error("No load_func passed to persist_table")
    elseif not t then
        error("No table passed to persist_table")
    elseif not table_name then
        error("No table_name passed to persist_table")
    elseif type(table_name) ~= "string" then
        error("table_name passed to persist_table is not a string")
    end
    cm:add_saving_game_callback(function(context) cm:save_named_value("rogue_"..table_name, t, context) end)
    cm:add_loading_game_callback(function(context) 
        local loaded_table = cm:load_named_value("rogue_"..table_name, t, context) 
        out("Loaded Rogue table "..table_name)
        out(table_to_string(loaded_table))
        load_func(loaded_table)
    end)
end

---SECTION: type Checker Definitions:
---These are used by the Lua type checker when coding in VSCode.
---They reflect the lowest level structures in the game data table.

---@class ROGUE_DATA_UNIT_ENTRY
local template_unit_entry = {
    unit_key = "" ---@type string
}
---@alias ROGUE_DATA_UNIT_ENTRY_LIST ROGUE_DATA_UNIT_ENTRY[]
---@alias ROGUE_SELECTION_SET "MANDATORY"|integer
---@alias ROGUE_BATTLE_TYPE "LAND_ATTACK"|"LAND_DEFEND"|"SIEGE_ATTACK"|"SIEGE_DEFEND"|"AMBUSH_ATTACK"|"AMBUSH_DEFEND"|"REINFORCE_ALLY"|"NONE"
---@alias DILEMMA_CHOICE_KEY "FIRST"|"SECOND"|"THIRD"| "FOURTH"
local DILEMMA_CHOICE_KEYS = {
    "FIRST",
    "SECOND",
    "THIRD",
    "FOURTH"
} ---@type DILEMMA_CHOICE_KEY[]

---@class ROGUE_DATA_COMMANDER_ENTRY
local template_commander_entry = {
    commander_key = "", ---@type string
    agent_subtype = "", ---@type string
    difficulty_delta = 0, ---@type integer
}

---@class ROGUE_DATA_FRAGMENT_ENTRY
local template_fragment_entry = {
    difficulty_delta = 0, ---@type integer
    localised_name = "", ---@type string
    generated_unit_slots = {}, ---@type ROGUE_DATA_UNIT_ENTRY_LIST[]
    force_fragment_key = "", ---@type string
    mandatory_units = {}, ---@type ROGUE_DATA_UNIT_ENTRY[]
}

---@class ROGUE_DATA_FRAGMENT_SET_MEMBER_ENTRY 
local template_fragment_set_member_entry = {
    force_fragment_key = "", ---@type string
    hidden_fragment = false ---@type boolean
}

---@class ROGUE_DATA_FRAGMENT_SET_ENTRY
local template_fragment_set_entry = {
    key = "", ---@type string
    mandatory_fragments = {}, ---@type ROGUE_DATA_FRAGMENT_SET_MEMBER_ENTRY[]
    generated_fragment_slots = {}, ---@type ROGUE_DATA_FRAGMENT_SET_MEMBER_ENTRY[][]
}

---@class ROGUE_DATA_FORCE_TEMPLATE
local template_force_entry = {
    base_difficulty = 0, ---@type integer
    force_fragment_set = {}, ---@type ROGUE_DATA_FRAGMENT_SET_ENTRY
    force_key = "", ---@type string
    commander_set = {}, ---@type ROGUE_DATA_COMMANDER_ENTRY[]
    faction_set = {} ---@type string[]
}

---@class ROGUE_DATA_PROGRESS_PAYLOAD_ENTRY
local template_progress_payload = {
    key = "", ---@type string
    mandatory_gate_increments = {}, ---@type table<string, integer>
    generated_gate_increments = {}---@type table<string, integer>
}


---@class ROGUE_DATA_ENCOUNTER_ENTRY
local template_encounter_entry = {
    region = "", ---@type string
    duration = 0, ---@type integer
    progress_payload = "", ---@type string
    boss_overlay = false, ---@type boolean
    reward_set = "", ---@type string
    key = "starting_battle", ---@type string
    inciting_incident_key = "", ---@type string
    post_battle_dilemma_override = "", ---@type string
    battle_type = "LAND_ATTACK", ---@type ROGUE_BATTLE_TYPE
    force_set = {} ---@type string[]
}


---@class ROGUE_DATA_ARMORY_PART_SET_ENTRY
local template_armory_part_set_entry = {
    key = "", ---@type string
    upgrade_when_exhausted = "", ---@type string
    mandatory_parts = {}, ---@type string[]
    generated_part_slots = {} ---@type string[][]
}

---@class ROGUE_DATA_CHOICE_PAYLOAD_ENTRY
local template_choice_payload = {
        costs_resource = "", ---@type string
        costs = 0, ---@type integer
        force_fragment_set = "", ---@type string
        armory_part_set = {} ---@type ROGUE_DATA_ARMORY_PART_SET_ENTRY[]
}


---@class ROGUE_DATA_CHOICE_DETAIL_ENTRY
local template_choice_detail_ENTRY = {
    mandatory_reward_components = {}, ---@type ROGUE_DATA_CHOICE_PAYLOAD_ENTRY[]
    generated_reward_components = {} ---@type ROGUE_DATA_CHOICE_PAYLOAD_ENTRY[][]
}

 ---@class ROGUE_DATA_PLAYER_CHARACTER_ENTRY
 local template_player_character = {
    start_gate = "", ---@type string
    start_reward_set = "" ---@type string
 }

 ---@class ROGUE_DATA_PROGRESS_GATE_ENTRY
 local template_progress_gate = {
    activation_threshold = 9999,
    generates_encounters = {}, ---@type ROGUE_DATA_ENCOUNTER_ENTRY[]
    displaces_encounters = {}, ---@type ROGUE_DATA_ENCOUNTER_ENTRY[]
    forces_encounters = {} ---@type ROGUE_DATA_ENCOUNTER_ENTRY[]
 }

 ---@class ROGUE_DATA_REWARD_ENTRY
local template_reward_entry = {
    dilemma = "", ---@type string
    resource_threshold = 0, ---@type integer
    requires_resource = "" ---@type string
}

---@class ROGUE_MOD_DATABASE
local template_mod_database = {
    forces = {}, ---@type table<string, ROGUE_DATA_FORCE_TEMPLATE>
    force_sets = {}, ---@type string[]
    encounters = {}, ---@type table<string, ROGUE_DATA_ENCOUNTER_ENTRY>
    choice_detail = {}, ---@type ROGUE_DATA_CHOICE_DETAIL_ENTRY[]
    reward_sets = {}, ---@type table<string, ROGUE_DATA_REWARD_ENTRY[]>
    player_characters = {}, ---@type table<string, ROGUE_DATA_PLAYER_CHARACTER_ENTRY>
    reward_dilemma_choice_details = {}, ---@type table<string, table<DILEMMA_CHOICE_KEY, ROGUE_DATA_CHOICE_DETAIL_ENTRY>>
    progress_gates = {}, ---@type table<string, ROGUE_DATA_PROGRESS_GATE_ENTRY>
    progress_payloads = {}, ---@type table<string, ROGUE_DATA_PROGRESS_PAYLOAD_ENTRY>
    force_fragment_sets = {}, ---@type table<string, ROGUE_DATA_FRAGMENT_SET_ENTRY>
    force_fragments = {} ---@type table<string, ROGUE_DATA_FRAGMENT_ENTRY>
}


local mod_database, skips, skipped_encounters = rogue_daniel_loader.load_all_data() ---@type ROGUE_MOD_DATABASE
if skips > 0 then
    local err_string = "Loaded data but skipped "..skips.." encounters: "
    for key, reason in pairs(skipped_encounters) do
        err_string = err_string .. key .. ": " .. reason .. "\n"
    end
    out(err_string)
else
    out("Loaded all encounter data successfully")
end
local player = {}

if not Forced_Battle_Manager then
    load_module("wh2_campaign_forced_battle_manager", "script/campaign/")
end

---SECTION: Persistent Data

local progress_gates = {} ---@type table<string, integer>
persist_table("progress_gates", progress_gates, function(t) progress_gates = t end)

local function was_progress_gate_reached(gate)
    if not progress_gates[gate] then
        return false
    end
    return progress_gates[gate] >= mod_database.progress_gates[gate].activation_threshold
end

local obselete_encounters = {} ---@type table<string, boolean>
persist_table("obselete_encounters", obselete_encounters, function(t) obselete_encounters = t end)
local function is_encounter_obselete(encounter)
    if not obselete_encounters[encounter] then
        return false
    end
    return obselete_encounters[encounter]
end


local active_encounters = {} ---@type table<string, GENERATED_ENCOUNTER>
persist_table("active_encounter", active_encounters, function(t) active_encounters = t end)
local function send_encounters_to_ui()
    common.set_context_value("rogue_active_encounters", active_encounters)
end

local encounter_being_played_savestring = "rogue_encounter_in_progress"

--dev, for now, just set a dummy value

local pending_forced_encounters = {} ---@type GENERATED_ENCOUNTER[]
persist_table("pending_forced_encounters", pending_forced_encounters,  function(t) pending_forced_encounters = t end)

local pending_rewards = {
    dilemma = nil, ---@type CAMPAIGN_DILEMMA_BUILDER_SCRIPT_INTERFACE|nil
    armory_parts = {} ---@type string[]
}
persist_table("pending_rewards", pending_rewards,  function(t) pending_rewards = t end)
local function send_rewards_to_ui()
    common.set_context_value("rogue_pending_rewards", pending_rewards.armory_parts)
end




---comment
---@param fragment ROGUE_DATA_FRAGMENT_ENTRY
---@return ROGUE_DATA_UNIT_ENTRY_LIST
local function generate_units_from_force_fragment(fragment)
    local unit_list = {}
    add_list_into_list(unit_list, fragment.mandatory_units)
    out("Fragment had "..#fragment.mandatory_units.." mandatory units")
    local gen_slots = fragment.generated_unit_slots
    out("Fragment had "..#gen_slots.." generated unit slots")
    for i = 1, #gen_slots do
        local slot_options = gen_slots[i]
        table.insert(unit_list, slot_options[cm:random_number(#slot_options)])
    end
    return unit_list 
end

local function generate_unit_list_from_force_fragment_set(fragment_set)
    out("Generating unit list for fragment set: "..fragment_set.key)
    local unit_list = {}
    local mandatory_fragments = fragment_set.mandatory_fragments
    out("Adding "..#mandatory_fragments.." mandatory fragments")
    for i = 1, #mandatory_fragments do
        local fragment_set_member = mandatory_fragments[i]
        tab_log(1)
        out("Adding fragment: "..fragment_set_member.force_fragment_key)
        local fragment = mod_database.force_fragments[fragment_set_member.force_fragment_key]
        add_list_into_list(unit_list, generate_units_from_force_fragment(fragment))
        untab_log(1)
    end
    local generated_fragments = fragment_set.generated_fragment_slots
    out(" Adding "..#generated_fragments.." generated fragment slots")
    for i = 1, #generated_fragments do
        local fragment_options = generated_fragments[i]
        local fragment_set_member = fragment_options[cm:random_number(#fragment_options)]
        tab_log(1)
        out("Adding fragment: "..fragment_set_member.force_fragment_key)
        local fragment = mod_database.force_fragments[fragment_set_member.force_fragment_key]
        add_list_into_list(unit_list, generate_units_from_force_fragment(fragment))
        untab_log(1)
    end
    return unit_list 
end




---SECTION: GENERATION FUNCTIONS FOR REWARDS

---comment
---@param payload CAMPAIGN_PAYLOAD_BUILDER_SCRIPT_INTERFACE
---@param reward_component ROGUE_DATA_CHOICE_PAYLOAD_ENTRY
local function add_reward_component_to_payload(payload, reward_component)
    --add units to the payload
    local fragment_set_key = reward_component.force_fragment_set
    local fragment_set = mod_database.force_fragment_sets[fragment_set_key]
    local units_to_add = {}
    if fragment_set then
        local unit_list = generate_unit_list_from_force_fragment_set(fragment_set)
        for i = 1, #unit_list do
            local unit = unit_list[i]
            units_to_add[unit.unit_key] = (units_to_add[unit.unit_key] or 0) + 1
        end
    else
        out("No fragment set for this payload")
    end
    for unit_to_add, quantity in pairs(units_to_add) do
        payload:add_unit(player.force, unit_to_add, quantity, 0)
    end
    --TODO, the rest of the reward shit.
end

---comment
---TODO make a template for the details table
---@param choice_key string
---@param payload CAMPAIGN_PAYLOAD_BUILDER_SCRIPT_INTERFACE
---@param details ROGUE_DATA_CHOICE_DETAIL_ENTRY
---@return CAMPAIGN_PAYLOAD_BUILDER_SCRIPT_INTERFACE
local function generate_dilemma_payload_from_details(choice_key, payload, details)
    out("Generating reward payload for choice: " .. choice_key)
    --add mandatory rewards
    out("Generating "..#details.mandatory_reward_components.." mandatory components")
    for i = 1, #details.mandatory_reward_components do
        local mandatory_reward_component = details.mandatory_reward_components[i]
        tab_log(1)
        add_reward_component_to_payload(payload, mandatory_reward_component)
        untab_log(1)
    end
    --add generated rewards
    out("Generating "..#details.generated_reward_components.." generated components")
    for i = 1, #details.generated_reward_components do
        local generated_component_options = details.generated_reward_components[i]
        local selected_reward_component = generated_component_options[cm:random_number(#generated_component_options)]
        tab_log(1)
        add_reward_component_to_payload(payload, selected_reward_component)
        untab_log(1)
    end

    return payload
end



---comment
---@param dilemma string
---@return CAMPAIGN_DILEMMA_BUILDER_SCRIPT_INTERFACE
local function generate_reward_dilemma(dilemma)
    out("generating reward dilemma: " .. dilemma)
    local dilemma_details = mod_database.reward_dilemma_choice_details[dilemma]
    local dilemma_builder = cm:create_dilemma_builder(dilemma)
    tab_log(1)
    for i = 1, #DILEMMA_CHOICE_KEYS do
        local choice_key = DILEMMA_CHOICE_KEYS[i]
        local choice_details = dilemma_details[choice_key]
        if choice_details then
            local payload_builder = generate_dilemma_payload_from_details(choice_key, cm:create_payload(), choice_details)
            if payload_builder:valid(player.faction) then
                dilemma_builder:add_choice_payload(choice_key, payload_builder)
            else
                out("Payload for choice "..choice_key.." is invalid")
            end
        end
    end
    untab_log(1)
    --TODO add player details to the dilemma
    dilemma_builder:add_target("default", player.force)
    
    return dilemma_builder
end

---comment


---TODO make a template for the reward_set table
---why does this function exist?
---comment

---@param encounter_key string
---@return CAMPAIGN_DILEMMA_BUILDER_SCRIPT_INTERFACE|nil
local function generate_reward_dilemma_for_encounter(encounter_key)
    local encounter = mod_database.encounters[encounter_key]
    local reward_sets = mod_database.reward_sets[encounter.reward_set]
    if not reward_sets then
        return nil
    end
    out("generating reward for encounter "..encounter.key.." with reward set "..encounter.reward_set)
    tab_log(1)
    local dilemma_options = {}
    out("filtering the reward set")
    tab_log(1)
    for i = 1, #reward_sets do
        local reward = reward_sets[i]
            --TODO add resource and resource thresholds filters
        table.insert(dilemma_options, reward.dilemma)
        out("dilemma "..reward.dilemma.." is valid")
    end
    untab_log(1)
    local selected_dilemma = reward_sets[cm:random_number(#reward_sets)].dilemma
    out("selected dilemma "..selected_dilemma)
    local reward_dilemma = generate_reward_dilemma(selected_dilemma) 
    untab_log(1)
    return reward_dilemma
end

---@return string[]
local function generate_reward_armory_item_choice_for_encounter(encounter)
    return {"wh3_main_dae_cha_daemon_prince_arm_r_armoured_2", "wh3_main_dae_cha_daemon_prince_legs_beast_7"}
end


---SECTION: GENERATION FUNCTIONS FOR ENEMIES
---These functions are used to generate randomized forces, commanders, rewards, and encounters


local function queue_forced_encounter(encounter)
    out("Queued forced encounter: "..encounter.key)
    table.insert(pending_forced_encounters, encounter)
end



---commentmod_database
---@param force_key string
---@return GENERATED_FORCE
local function generate_force(force_key)
    ---@class GENERATED_FORCE
    local force = {} 
    local force_data = mod_database.forces[force_key]
    out("Generating force: "..force_key)
    force.key = force_key

    local faction_options = force_data.faction_set
    force.faction = faction_options[cm:random_number(#faction_options)]
    tab_log(1)
    out("Selected faction: "..force.faction)
    force.difficulty = force_data.base_difficulty ---@type integer
    force.units = {} ---@type ROGUE_DATA_UNIT_ENTRY_LIST

    local fragment_set = force_data.force_fragment_set
    add_list_into_list(force.units, generate_unit_list_from_force_fragment_set(fragment_set))

    force.unit_string = force.units[1].unit_key
    for i = 2, #force.units do
        local unit = force.units[i]
        force.unit_string = force.unit_string..","..unit.unit_key
        --TODO add difficulty 
    end

    local commander_options = force_data.commander_set
    force.commander = commander_options[cm:random_number(#commander_options)] ---@type ROGUE_DATA_COMMANDER_ENTRY
    out("Selected commander: "..force.commander.commander_key.." of subtype "..force.commander.agent_subtype)
    force.difficulty = force.difficulty + force.commander.difficulty_delta
    tab_log(1)
    out("Difficulty increased to "..force.difficulty)
    untab_log(1)


    untab_log(1)
    return force
end

---comment
---@param encounter_key string
---@param is_forced_encounter boolean
---@return GENERATED_ENCOUNTER
local function generate_encounter(encounter_key, is_forced_encounter)
    local encounter_data = mod_database.encounters[encounter_key] ---@type ROGUE_DATA_ENCOUNTER_ENTRY

    if active_encounters[encounter_data.region] then
        out("There is already an encounter "..tostring(active_encounters[encounter_data.region].key).. "  in this region: "..encounter_data.region)
        out("Displacing this encounter!") 
        --TODO - handle this case
    end
    out("generating encounter: "..encounter_key.. " in region: "..encounter_data.region.." is forced: "..tostring(is_forced_encounter or false))
    tab_log(1)
    ---@class GENERATED_ENCOUNTER
    local encounter = {}

    encounter.key = encounter_key ---@type string

    --TODO localize this
    encounter.localised_name = encounter_key

    --create a force for the encounter
    local force_set = encounter_data.force_set
    out("Selecting a force from "..#force_set.." options")
    local selected_force_key = force_set[cm:random_number(#force_set)]
    local force = generate_force(selected_force_key)
    encounter.force = force ---@type GENERATED_FORCE

    --TODO battle type
    out("DEV/ BATTLE TYPE NOT IMPLEMENTED YET, DEFAULTS TO LAND_ATTACK")
    encounter.battle_type = "LAND_ATTACK" ---@type string

    --TODO - generate rewards
    out("DEV/ REWARDS NOT IMPLEMENTED YET, DEFAULTS TO NONE")

    active_encounters[encounter_data.region] = encounter

    untab_log(1)
    return encounter
end

local function progress_gate_activated(progress_gate)
    out("Progress gate "..progress_gate.." activated!")
    local gate_data = mod_database.progress_gates[progress_gate]
    tab_log(1)
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
    untab_log(1)
    send_encounters_to_ui()
end 

local function increment_progress_gate_progress(progress_gate, increment)
    if was_progress_gate_reached(progress_gate) then
        return
    end
    progress_gates[progress_gate] = (progress_gates[progress_gate] or 0) + increment
    out("Progress gate "..progress_gate.." is now at "..progress_gates[progress_gate])
    if was_progress_gate_reached(progress_gate) then
        local ok, err = pcall(function()
            progress_gate_activated(progress_gate)
        end)
        if not ok then
            out("Error while activating progress gate "..progress_gate..": "..tostring(err))
            out(tostring(debug.traceback()))
        end
    end
end

---SECTION: EVENT HANDLERS

local function on_encounter_completed(encounter_key)
    local encounter_data = mod_database.encounters[encounter_key]

    local encounter_reward_dilemma = generate_reward_dilemma_for_encounter(encounter_key)
    if encounter_reward_dilemma then
        out("Generated a reward dilemma for encounter "..encounter_key)
    else
        out("No reward dilemma generated for encounter "..encounter_key)
        out("The rewards for this encounter will not function")
    end
    local armory_item_options = generate_reward_armory_item_choice_for_encounter(encounter_key)
    if #armory_item_options > 0 then
        out("Generated "..#armory_item_options.." reward armory items for encounter "..encounter_key)
    end
    pending_rewards = {
        dilemma = encounter_reward_dilemma,
        armory_parts = armory_item_options
    }
    send_rewards_to_ui()

    --remove the encounter from the active encounters list
    local region = encounter_data.region
    if active_encounters[region] then
        active_encounters[region] = nil
    end
    --remove the encounter from the currently being played register
    cm:set_saved_value(encounter_being_played_savestring, false)

    --increment the progress gates in the progress payload for this encounter
    local progress_payload_key = encounter_data.progress_payload
    local progress_payload = mod_database.progress_payloads[progress_payload_key]
    local mandatory_gates = progress_payload.mandatory_gate_increments
    for gate_key, increment in pairs(mandatory_gates) do
        increment_progress_gate_progress(gate_key, increment)
    end
    local optional_gates = progress_payload.generated_gate_increments
    local random_payload = optional_gates[cm:random_number(#optional_gates)]
    for gate_key, increment in pairs(random_payload) do
        increment_progress_gate_progress(gate_key, increment)
    end

    return encounter_reward_dilemma
end

local function commence_encounter(settlement_key)
    local encounter = active_encounters[settlement_key]

    if not encounter then
        out("No encounter to commence in region "..settlement_key)
        return
    end
    cm:set_saved_value(encounter_being_played_savestring, encounter.key)
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

local function grant_starting_reward()
    local player_character = mod_database.player_characters[player.name]
    local start_reward_set = mod_database.reward_sets[player_character.start_reward_set]
    if not start_reward_set then
        out("No starting reward set for this character!")
        out("Skipping this")
    else
        local random_reward_dilemma = start_reward_set[cm:random_number(#start_reward_set)]
        local reward_dilemma = generate_reward_dilemma(random_reward_dilemma.dilemma)
        out("Firing the new game reward dilemma: "..random_reward_dilemma.dilemma)
        cm:launch_custom_dilemma_from_builder(reward_dilemma, player.faction)  
    end           
end


local function create_event_handlers()
    game_event_callback({"CharacterPostBattleCaptureOption", "CharacterPostBattleEnslave", 
    "CharacterPerformsSettlementOccupationDecision", "CharacterPostBattleRelease", "CharacterPostBattleSlaughter"},
    function (context)
        local encounter_key = cm:get_saved_value(encounter_being_played_savestring)
        if encounter_key then
            local dilemma_builder = on_encounter_completed(encounter_key)
            if dilemma_builder then
                out("Launching reward dilemma: "..type(dilemma_builder))
                cm:launch_custom_dilemma_from_builder(dilemma_builder, player.faction)
            end
        end
    end, "PlayerCompletedEncounterBattle", 0.5)
    game_event_callback("DilemmaChoiceMadeEvent", function (context)
        if #pending_rewards.armory_parts > 0 then
            core:trigger_event("DisplayArmoryRewardDialogue")
        end
    end, "PlayerCompletedDilemma", 0.5)
end


local function grant_armory_item(armory_item_key)
    ---@diagnostic disable-next-line
    cm:add_armory_item_to_character(player.character, armory_item_key, false, false)
end

---SECTION: UI 

--3dUI elements for the encounters are generated with the context expression: 
--[[
    SettlementList.Filter(ScriptObjectContext("rogue_active_encounters").TableValue.HasValueForKey(SettlementKey, false))
--]]

---send a command from UI code to gameplay code
---@param command_key string
---@param ... any
local function ui_command(command_key, ...)
    --TODO rewrite this function to use UITrigger for multiplayer safety.
    --not sure this mod will ever be multiplayer compatible, but maybe one day.
    local commands = {
        ["commence_encounter"] = commence_encounter,
        ["grant_starting_reward"] = grant_starting_reward,
        ["grant_armory_item"] = grant_armory_item
    }
    local command = commands[command_key]
    if not command then
        error("No UI command found for key "..command_key)
    else
        command(...)
    end
end




---@return UIC
local function get_or_create_army_panel(destroy_old)
    local panel_name = "rogue_player_army"
    local existing_panel = find_uicomponent(core:get_ui_root(), panel_name)
    if destroy_old and existing_panel then
        existing_panel:DestroyChildren()
        existing_panel:Destroy()
    elseif existing_panel then
        return existing_panel
    end
    local new_panel = UIComponent(core:get_ui_root():CreateComponent(panel_name, "ui/rogue/rogue_units_panel"))
    new_panel:SetContextObject(cco("CcoCampaignRoot", ""))
    return new_panel
    
end

---@return UIC
local function get_or_create_tr_hud(destroy_old)
    local panel_name = "rogue_tr_hud"
    local existing_panel = find_uicomponent(core:get_ui_root(), panel_name)
    if destroy_old and existing_panel then
        existing_panel:DestroyChildren()
        existing_panel:Destroy()
    elseif existing_panel then
        return existing_panel
    end
    local new_panel = UIComponent(core:get_ui_root():CreateComponent(panel_name, "ui/rogue/rogue_tr_hud"))
    new_panel:SetContextObject(cco("CcoCampaignRoot", ""))
    return new_panel
end


---@return UIC
local function get_or_create_encounter_preview(destroy_old)
    local panel_name = "rogue_encounter_preview"
    local existing_panel = find_uicomponent(core:get_ui_root(), panel_name)
    if destroy_old and existing_panel then
        existing_panel:DestroyChildren()
        existing_panel:Destroy()
    elseif existing_panel then
        return existing_panel
    end
    local new_panel = UIComponent(core:get_ui_root():CreateComponent(panel_name, "ui/rogue/rogue_encounter_preview"))
    new_panel:SetContextObject(cco("CcoCampaignRoot", ""))
    return new_panel
end

local function destroy_encounter_preview()
    local panel_name = "rogue_encounter_preview"
    local existing_panel = find_uicomponent(core:get_ui_root(), panel_name)
    if existing_panel then
        existing_panel:DestroyChildren()
        existing_panel:Destroy()
    end
end


local function send_selected_encounter_to_ui(settlement_key)
    out("Selected encounter in region "..tostring(settlement_key))
    common.set_context_value("rogue_selected_encounter", settlement_key)
    if settlement_key ~= "" then
        get_or_create_encounter_preview()
    end
end

local function clear_encounter_selection()
    destroy_encounter_preview()
    common.set_context_value("rogue_selected_encounter", "")
end

local function get_or_create_armory_reward_dialogue(destroy_old)
    local panel_name = "rogue_reward_dialogue"
    local existing_panel = find_uicomponent(core:get_ui_root(), panel_name)
    if destroy_old and existing_panel then
        existing_panel:DestroyChildren()
        existing_panel:Destroy()
    elseif existing_panel then
        return existing_panel
    end
    local new_panel = UIComponent(core:get_ui_root():CreateComponent(panel_name, "ui/rogue/rogue_reward_dialogue"))
    new_panel:SetContextObject(cco("CcoCampaignRoot", ""))
    common.set_context_value("rogue_reward_dialogue_selection", "")
    send_rewards_to_ui() 
end

local function destroy_armory_reward_dialogue()
    local panel_name = "rogue_reward_dialogue"
    local existing_panel = find_uicomponent(core:get_ui_root(), panel_name)
    if existing_panel then
        existing_panel:DestroyChildren()
        existing_panel:Destroy()
    end
end

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

function dev_ui()
    local out = function (t)
        ModLog("ROGUEDEV: "..tostring(t))
    end

    core:add_listener(
        "ComponentLClickUp",
        "ComponentLClickUp",
        true,
        function(context) 
            out("Clicked: "..tostring(context.string))
        end, true)
end

local hud_children_to_hide = {
    radar_things = true,
    mission_list = true,
    BL_parent = true,
    bar_small_top = true,
    ping_parent = true,
    settings_panel = true,
    faction_buttons_docker = true,
    resources_bar_holder = true,
    offscreen_icon_creator = true,
}


---@param uim campaign_ui_manager
local function hide_or_remove_default_ui(uim)
    --turn off settlement labels 
    cm:override_ui("disable_settlement_labels", true)

    local hud = find_uicomponent("hud_campaign")
    for i = 0, hud:ChildCount() - 1 do
        local child = UIComponent(hud:Find(i))
        if hud_children_to_hide[child:Id()] then
            child:SetVisible(false)
        end
    end
end



function start_ui()
    local uim = cm:get_campaign_ui_manager()
    common.call_context_command("CcoCampaignCharacter", tostring(player.cqi), "Select(false)")
    dev_ui()

    out("Creating the Rogue Daniel UI!")
    --3D UI Parent creation and propogation of the root context object
    local worldspace_parent = UIComponent(core:get_ui_root():CreateComponent("rogue3dui", "ui/rogue/rogue3dui"))
    if worldspace_parent then
        worldspace_parent:SetContextObject(cco("CcoCampaignRoot", ""))

    else
        out("The Worldspace Parent Failed to Create! Check the rogue3dui.twui.xml file!")
    end
    get_or_create_tr_hud()

    --open the units panels
    ui_click_callback("button_unit_panel", function(context)
        get_or_create_army_panel()
    end)

    --open the character details panel
    ui_click_callback("button_character_details", function(context)
        --did this via CCO
    end)

    

    --select encounter
    ui_click_callback("encounter_slot", function (context)
        local slot = UIComponent(context.component)
        local context_id = slot:GetContextObjectId("CcoCampaignSettlement")
        -- note to self: this is a weird case, usually you shouldn't need to modify the context_id for get_context_value. CcoCampaignSettlement requires it.
        local settlement_key = common.get_context_value("CcoCampaignSettlement", "settlement:"..context_id, "SettlementKey")
        send_selected_encounter_to_ui(settlement_key)
        CampaignUI.ClearSelection()
        uim:remove_character_selection_whitelist(player.cqi)
    end)

    --commence encounter
    ui_click_callback("button_commence_encounter", function (context)
        uim:add_character_selection_whitelist(player.cqi)
        local selected_encounter = common.get_context_value("ScriptObjectContext(\"rogue_selected_encounter\").StringValue")
        out("Commence encounter button clicked with UI context "..tostring(selected_encounter))
        if active_encounters[selected_encounter] then
            ui_command("commence_encounter", selected_encounter)
        else
            error("ERROR - no encounter selected to commence!")
        end
        destroy_encounter_preview()
    end)

    --cancel encounter
    ui_click_callback("button_decline_encounter", function (context)
        clear_encounter_selection()
        uim:add_character_selection_whitelist(player.cqi)
    end)

    --reward panel functionality
    game_event_callback("DisplayArmoryRewardDialogue", function (context)
        get_or_create_armory_reward_dialogue()
    end, "UICallback")

    context_list_click_callback("CcoArmoryItemRecord", function (context)
        local clicked_list_component = UIComponent(context.component)
        local clicked_list_context_id = clicked_list_component:GetContextObjectId("CcoArmoryItemRecord")
        common.set_context_value("rogue_reward_dialogue_selection" , clicked_list_context_id)
    end, "reward_armory_item_selection")

    ui_click_callback("button_finalize_armory_reward", function (context)
        ui_command("grant_armory_item", common.get_context_value("CcoScriptObject", "rogue_reward_dialogue_selection", "StringValue"))
        common.set_context_value("rogue_reward_dialogue_selection", "")
        destroy_armory_reward_dialogue()
    end)

    --scripted context objects.
    send_encounters_to_ui()
    send_selected_encounter_to_ui("")
end

---SECTION: MAIN

---called by the system on FirstTick
function rogue_main()
    out("Rogue Main") 
    local uim = cm:get_campaign_ui_manager()
    if cm:is_multiplayer() then
        out("EXITING- MOD DOES NOT SUPPORT MP GAMES")
        CampaignUI.QuitToWindows()
    elseif not mod_database.player_characters[cm:get_local_faction_name()] then
       out("EXITING- THIS FACTION IS NOT PLAYABLE")
       CampaignUI.QuitToWindows()
    end
    local player_character = mod_database.player_characters[cm:get_local_faction_name()]
    player.faction = cm:get_local_faction()
    player.name = player.faction:name()
    player.character = player.faction:faction_leader()
    player.cqi = player.character:command_queue_index()
    player.force =  player.character:military_force()
    is_new_game = cm:is_new_game()
    --skip all ai faction turns
    ---@diagnostic disable-next-line
    cm:skip_all_ai_factions()
    --destroy all AI armies on new game
    if is_new_game then
        local faction_list = cm:model():world():faction_list()
        for i = 0, faction_list:num_items() - 1 do
            local faction = faction_list:item_at(i)
            if faction:is_human() == false then
                cm:kill_all_armies_for_faction(faction)
            end
        end
        --remove all the units from the player characters' army.
        local pc = cm:get_local_faction():faction_leader()
        local unit_list = pc:military_force():unit_list()
        for i = 0, unit_list:num_items() - 1 do
            local unit = unit_list:item_at(i)
            cm:remove_unit_from_character(cm:char_lookup_str(pc), unit:unit_key())
        end
    end

    --disable the event feed
    cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
    cm:disable_event_feed_events(true, "wh_event_category_character", "", "")

    --wait for the loading screen to finish, then set up the UI.
    core:progress_on_loading_screen_dismissed(function ()
        out("Loading Screen Dismissed")
        ui_callback(function ()
            out("UI PreCreation Callback")
            local movies = find_uicomponent("movie_overlay_intro_movie")
            if movies then
                movies:Destroy()
            end

            uim:enable_character_selection_whitelist()
            uim:add_character_selection_whitelist(player.cqi)
            uim:enable_settlement_selection_whitelist()
            hide_or_remove_default_ui(uim)
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
                if is_new_game then
                    ui_callback(function ()
                        ui_command("grant_starting_reward")
                    end, 700, "starting_reward_dilemma")
                end
            end, 250, "UISTART")
        end, 100)
    end)

    game_callback(function ()
        out("Game Starting Callback")
        create_event_handlers()
        if is_new_game then
            local start_gate = player_character.start_gate
            increment_progress_gate_progress(start_gate, 1)
        end
    end, 0.1, "GAMESTARTCALLBACK")
end

---SECTION: Console Commands
---testing functions, exposed to the console

local function generate_and_print_force_with_key(key, optional_logger)
    local log = optional_logger or out
    local force = generate_force(key)
    log("Force Generated: "..key)
    log("Difficulty: "..force.difficulty)
    log("Commander: "..force.commander.commander_key)
    for i = 1, #force.units do
        local unit = force.units[i]
        log("\t"..unit.unit_key)
    end
    log("")
end

---comment
---@param encounter_key string
---@param tries integer
local function test_encounter_force_generation(encounter_key, tries)
    local log_file = io.open("encounter_force_generation_test.txt", "w+")
    if not log_file then
        out("ERROR - unable to open encounter_force_generation_test.txt for writing!")
        return
    end
    local logTimeStamp = os.date("%d, %m %Y %X")
    log_file:write("Encounter test - "..encounter_key.." - "..logTimeStamp.."\n")
    local function testing_log(t)
        out(t)
        log_file:write(t.."\n")
    end
    if not tries then
        tries = 3
    end
    testing_log("Attempting generation of force for "..encounter_key.." "..tries.." times")
    local encounter_data = mod_database.encounters[encounter_key] ---@type ROGUE_DATA_ENCOUNTER_ENTRY
    out("Testing encounter force generation for "..encounter_key)
    tab_log(1)
    local force_set = encounter_data.force_set
    out("Force set size: "..#force_set)
    tab_log(1)
    for i = 1, #force_set do 
        local force_key = force_set[i]
        out("Force key: "..force_key)
        for _ = 1, tries do
            generate_and_print_force_with_key(force_key, testing_log)
        end
    end
    untab_log(1)
    untab_log(1)
    log_file:flush()
    log_file:close()
end


rogue_console = {
    get_or_create_army_panel = get_or_create_army_panel,
    get_or_create_armory_reward_dialogue = get_or_create_armory_reward_dialogue,
    generate_and_print_force_with_key = generate_and_print_force_with_key,
    test_encounter_force_generation = test_encounter_force_generation,
    generate_encounter = generate_encounter,
    commence_encounter = commence_encounter,
    on_encounter_completed = on_encounter_completed
}

---section: disabled commands
---disabling this commands here is easier than running around disabling them in the scripts that use them.

--for these two, allow anything that matches the rogue string through
local trigger_dilemma = cm.trigger_dilemma
local old_cm_dilemma = function(faction_key, dilemma_string, fire_immediately)
    trigger_dilemma(cm, faction_key, dilemma_string, fire_immediately)
end
cm.trigger_dilemma = function(self, faction_key, dilemma_string, fire_immediately)
    if string.find(dilemma_string, "rogue_") then
        old_cm_dilemma(faction_key, dilemma_string, fire_immediately)
    end
    out("Trigger dilemma command "..dilemma_string.." was ignored")
end
local trigger_incident = cm.trigger_incident
local old_trigger_incident = function (faction_key, incident_key, fire_immediately)
    trigger_incident(cm, faction_key, incident_key, fire_immediately)
end
cm.trigger_incident = function (self, faction_key, incident_key, fire_immediately)
    if string.find(incident_key, "rogue_") then
        old_trigger_incident(faction_key, incident_key, fire_immediately)
    end
    out("Trigger incident command "..incident_key.." was ignored")
end

--for the rest, ignore them entirely
cm.trigger_incident_with_targets = function (self, ...)
    local arg_string = tolerant_table_concat({...}, ", ")
    out("Trigger incident with targets command "..arg_string.." was ignored")
end

cm.trigger_dilemma_with_targets = function (self, ...)
    local arg_string = tolerant_table_concat({...}, ", ")
    out("Trigger dilemma with targets command "..arg_string.." was ignored")
end

cm.trigger_mission = function (self, ...)
    local arg_string = tolerant_table_concat({...}, ", ")
    out("Trigger mission command "..arg_string.." was ignored")
end

cm.trigger_mission_with_targets = function (self, ...)
    local arg_string = tolerant_table_concat({...}, ", ")
    out("Trigger mission with targets command "..arg_string.." was ignored")
end

cm.trigger_custom_mission_from_string = function (self, ...)
    local arg_string = tolerant_table_concat({...}, ", ")
    out("Trigger custom mission from string command "..arg_string.." was ignored")
end


--[[UI Notebook:

    -- steal this and the other glory elements to get deamonic favour icons
    --:root:hud_campaign:resources_bar_holder:resources_bar:daemonic_glory_holder:dy_tzeentch_points:icon

    use the units panel as the base for the charactersheet. 

    --character panel
    --:root:character_details_panel
    ----delete black_background_4k
    ----delete panel_frame_wh3
    ----delete character_name
    ----delete tabgroup
    ----delete holder_br
    ----delete tl_holder
    ----delete button_bottom_holder
    ----delete frame_4k
    ----delete_char_select_list
    ----skill_pts_holder
    ----Extract seperately: :root:character_details_panel:character_context_parent:tab_panels:character_details_subpanel:daemon_gifts_holder:body_parts_listview:list_clip:list_box
    -------rework ContextList callback to list equipped items
    -------replace images to hard appearence.
    ----Extract seperately :root:character_details_panel:character_context_parent:tab_panels:stats_effects_holder:unit_information_listview:list_clip:list_box
    ------for previewing daniel's stats
    ------delete row_details
    ------delete details_traits_effects_holder
    ----Extract seperately :root:character_details_panel:general_selection_panel
    ------might be useful for a reward panel


    -- this makes a great resource icon
    :root:daemonic_progression:symbols_holder:list_box:CcoCampaignPooledResourcewh3_main_dae_slaanesh_points_0000000069d7e920:upgrade_row_entry:race_symbol_holder

    --!! for encounter title
    --:root:3d_ui_parent:label_5:list_parent:dy_name 

    --can maybe use this to create a progress bar before you are forced to fight the boss.
    --:root:3d_ui_parent:label_5:list_parent:status_docker:status_bar:realm_pts_khorne_holder

    --A faction icon with a number next to it - maybe good for telegraphing the rewards?
    :root:3d_ui_parent:label_5:list_parent:status_docker:status_bar:icon_loan


    local ok, err = pcall(function()
        rogue_console.commence_encounter("settlement:wh3_main_chaos_region_doomkeep")
    end)
    if not ok then
        ModLog(tostring(err))
        ModLog(debug.traceback())
    end

    --Join(ScriptObjectContext("rogue_active_encounters").TableValue.ValueForKey(StoredContext("CcoCampaignSettlement").SettlementKey)).FirstContext
    --Join(ScriptObjectContext("rogue_active_encounters").TableValue.ValueForKey(StoredContext("CcoCampaignSettlement").SettlementKey)).Any(HasValueForKey("localised_name", false))
    Join(ScriptObjectContext("rogue_active_encounters").TableValue.ValueForKey(StoredContext("CcoCampaignSettlement").SettlementKey)).Filter(HasValueForKey("localised_name", false)).FirstContext

Join(ScriptObjectContext("rogue_active_encounters").TableValue.Value).Filter(Key =="settlement:wh3_main_chaos_region_doomkeep").FirstContext
Join(ScriptObjectContext(&quot;rogue_active_encounters&quot;).TableValue.Value).Filter(Key == this.SettlementKey).FirstContext
--]]

--[[Gameplay Notebook:

    --should players have an inventory of Parts? Or should they be given the opportunity to swap them out as a reward which they have to leave or take?

    --start game with a dilemma to select a starting army.

    --make encounter generation use select sets

    --create the god favour resources
--]]