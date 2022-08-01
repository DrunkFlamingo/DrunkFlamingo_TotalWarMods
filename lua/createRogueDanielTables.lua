require("common")
--[[
    Rogue Daniel Database - commander_set_to_commanders.tsv
    Rogue Daniel Database - commander_sets.tsv
    Rogue Daniel Database - commanders.tsv
    Rogue Daniel Database - effect_bundle_lists.tsv
    Rogue Daniel Database - effect_bundle_lists_to_effect_bundles.tsv
    Rogue Daniel Database - faction_sets.tsv
    Rogue Daniel Database - faction_sets_to_factions.tsv
    Rogue Daniel Database - force_fragment_to_main_units.tsv
    Rogue Daniel Database - force_fragments.tsv
    Rogue Daniel Database - force_to_force_fragments.tsv
    Rogue Daniel Database - forces.tsv
    Rogue Daniel Database - upe_sets.tsv
    Rogue Daniel Database - upe_sets_to_upe.tsv
    Rogue Daniel Database - progress_gates.tsv
    Rogue Daniel Database - encounters.tsv
    Rogue Daniel Database - force_set_to_forces.tsv
    Rogue Daniel Database - force_sets.tsv
    ]]
local rogue_daniel_file_inputs = {
    "Rogue Daniel Database - commander_set_to_commanders.tsv",
    "Rogue Daniel Database - commander_sets.tsv",
    "Rogue Daniel Database - commanders.tsv",
    "Rogue Daniel Database - effect_bundle_lists.tsv",
    "Rogue Daniel Database - effect_bundle_lists_to_effect_bundles.tsv",
    "Rogue Daniel Database - faction_sets.tsv",
    "Rogue Daniel Database - faction_sets_to_factions.tsv",
    "Rogue Daniel Database - force_fragment_to_main_units.tsv",
    "Rogue Daniel Database - force_fragments.tsv",
    "Rogue Daniel Database - force_to_force_fragments.tsv",
    "Rogue Daniel Database - forces.tsv",
    "Rogue Daniel Database - upe_sets.tsv",
    "Rogue Daniel Database - upe_sets_to_upe.tsv",
    "Rogue Daniel Database - progress_gates.tsv",
    "Rogue Daniel Database - encounters.tsv",
    "Rogue Daniel Database - force_set_to_forces.tsv",
    "Rogue Daniel Database - force_sets.tsv"
}

--for each file, parse the TSV format and create a string representing a valid .lua table.
--print the string to a file in the output folder.
for i = 1, #rogue_daniel_file_inputs do
    local file = io.open("lua/input/rogue_daniel_db/"..rogue_daniel_file_inputs[i], "r+")
    local file_text = file:read("*a")
    local file_lines = {}
    for line in string.gmatch(file_text, "[^\n]+") do
        table.insert(file_lines, line)
    end
    local header = file_lines[1]
    local header_fields = split_string(header, "\t")
    local retval = {}
    for i = 2, #file_lines do
        retval[i-1] = {}
        local this_row = retval[i-1]
        for j = 1, #header_fields do
            this_row[header_fields[j]] = {}
        end
        local row_fields = split_string(file_lines[i], "\t")
        for j = 1, #row_fields do
            local field = row_fields[j]
            this_row[header_fields[j]] = field
        end
    end
    local output_file_name = string.gsub(rogue_daniel_file_inputs[i], "Rogue Daniel Database %- ", "")
    local output_file = io.open("lua/output/rogue_daniel_db/"..string.gsub(output_file_name, ".tsv", ".lua"), "w+")
    output_file:write("return "..table_to_string(retval))
    output_file:flush()
    output_file:close()
end

--testable code

local selection_set_enum = {
    "MANDATORY",
    "1",
    "2",
    "3",
    "4",
    "5"
}
local select_set_validation = {}
for i = 1, #selection_set_enum do
    select_set_validation[selection_set_enum[i]] = true
end

local req_data = function (file)
    return require("output/rogue_daniel_db/"..file)
end
local rogue_daniel_loader = {}

function rogue_daniel_loader.load_all_data()
    local MOD_DATABASE = {} --this is the table that will be returned.

    local rogue_daniel_file_inputs = {
        "upe_sets_to_upe",
        "commander_set_to_commanders",
        "commander_sets",
        "commanders",
        "effect_bundle_lists",
        "effect_bundle_lists_to_effect_bundles",
        "faction_sets",
        "faction_sets_to_factions",
        "force_fragment_to_main_units",
        "force_fragments",
        "force_to_force_fragments",
        "forces",
        "upe_sets"
    }
    --[[
        Files must be loaded in the following hierarchy

            upe_sets > upe_sets_to_upe
            faction_sets > faction_sets_to_factions
            effect_bundle_lists > effect_bundle_lists_to_effect_bundles

            commander_sets > commanders > commander_set_to_commanders
            force_fragments  > force_fragment_to_main_units

            forces > force_to_force_fragments
            force_sets > force_set_to_forces
            progress_gates > encounters
    ]]

    --upe_sets > upe_sets_to_upe
    local upe_sets_data = req_data("upe_sets")
    MOD_DATABASE.upe_sets = {}
    --TODO load these once we actually create some

    --faction_sets > faction_sets_to_factions
    local faction_sets_data = req_data("faction_sets")
    MOD_DATABASE.faction_sets = {}
    for row_index = 1, #faction_sets_data do
        local this_row = faction_sets_data[row_index]
        --[[FACTION_SET_KEY: string]]
        if this_row.FACTION_SET_KEY == "" then
            --skip this row, its empty.
        else
            MOD_DATABASE.faction_sets[this_row.FACTION_SET_KEY] = {}
        end 
    end
    local faction_sets_to_factions_data = req_data("faction_sets_to_factions")
    for row_index = 1, #faction_sets_to_factions_data do
        local this_row = faction_sets_to_factions_data[row_index]
        --[[FACTION_SET: faction_sets]]
        --[[FACTION_KEY: string]]
        if this_row.FACTION_KEY == "" or this_row.FACTION_SET == "" then
            --skip this row, its blank.
        elseif not MOD_DATABASE.faction_sets[this_row.FACTION_SET] then
            error("faction_sets_to_factions row "..row_index.." has a FACTION_SET that does not exist in faction_sets: "..this_row.FACTION_SET)
        else
            table.insert(MOD_DATABASE.faction_sets[this_row.FACTION_SET], this_row.FACTION_KEY)
        end
    end

    --effect_bundle_lists > effect_bundle_lists_to_effect_bundles
    local effect_bundle_lists_data = req_data("effect_bundle_lists")
    MOD_DATABASE.effect_bundle_lists = {}
    for row_index = 1, #effect_bundle_lists_data do
        local this_row = effect_bundle_lists_data[row_index]
        --[[EFFECT_BUNDLE_LIST_KEY: string]]
        --TODO load these once we actually create some
        --MOD_DATABASE.effect_bundle_lists[this_row.EFFECT_BUNDLE_LIST_KEY] = {}
    end

    --commander_sets > commanders > commander_set_to_commanders
    local commander_sets_data = req_data("commander_sets")
    MOD_DATABASE.commander_sets = {}
    for row_index = 1, #commander_sets_data do
        local this_row = commander_sets_data[row_index]
        --[[COMMANDER_SET_KEY: string]]
        MOD_DATABASE.commander_sets[this_row.COMMANDER_SET_KEY] = {}
    end
    local commanders_data = req_data("commanders")
    MOD_DATABASE.commanders = {}
    for row_index = 1, #commanders_data do
        local this_row = commanders_data[row_index]
        --[[COMMANDER_KEY: string]]
        --[[AGENT_SUBTYPE: string]]
        --[[DIFFICULTY_DELTA: string->number]]
        --TODO effect bundle lists for commanders
        if this_row.COMMANDER_KEY == "" then
            --skip this row, its blank.
        else
            MOD_DATABASE.commanders[this_row.COMMANDER_KEY] = {
                commander_key = this_row.COMMANDER_KEY,
                agent_subtype = this_row.AGENT_SUBTYPE,
                difficulty_delta = tonumber(this_row.DIFFICULTY_DELTA) or 0
            }
        end
    end
    local commander_set_to_commanders_data = req_data("commander_set_to_commanders")
    for row_index = 1, #commander_set_to_commanders_data do
        local this_row = commander_set_to_commanders_data[row_index]
        --[[COMMANDER_SET: commander_sets]]
        --[[COMMANDER_KEY: commanders]]
        if this_row.COMMANDER_KEY == "" or this_row.COMMANDER_SET == "" then
            --skip this row, its blank.
        elseif MOD_DATABASE.commanders[this_row.COMMANDER_KEY] == nil then
            error("Invalid Commander key ["..this_row.COMMANDER_KEY.."] on row "..row_index.." of commander_set_to_commanders")
        elseif MOD_DATABASE.commander_sets[this_row.COMMANDER_SET] == nil then
            error("Invalid Commander Set key ["..this_row.COMMANDER_SET.."] on row "..row_index.." of commander_set_to_commanders")
        else
            table.insert(MOD_DATABASE.commander_sets[this_row.COMMANDER_SET], MOD_DATABASE.commanders[this_row.COMMANDER_KEY])
        end
    end

    --force_fragments  > force_fragment_to_main_units
    local force_fragments_data = req_data("force_fragments")
    MOD_DATABASE.force_fragments = {}
    for row_index = 1, #force_fragments_data do
        local this_row = force_fragments_data[row_index]
        --[[FORCE_FRAGMENT_KEY: string]]
        --[[LOCALISED_NAME: string]]
        --[[DIFFICULTY_DELTA: string->number]]
        --[[ALLOWED_AS_REWARD: string->boolean]]
        --[[INTERNAL_DESCRIPTION: string]]
        if this_row.FORCE_FRAGMENT_KEY == "" then
            --skip this row, its blank.
        else
            MOD_DATABASE.force_fragments[this_row.FORCE_FRAGMENT_KEY] = {
                force_fragment_key = this_row.FORCE_FRAGMENT_KEY,
                localised_name = this_row.LOCALISED_NAME or "",
                difficulty_delta = tonumber(this_row.DIFFICULTY_DELTA) or 0,
                allowed_as_reward = this_row.ALLOWED_AS_REWARD == "TRUE",
                internal_description = this_row.INTERNAL_DESCRIPTION or "",
                mandatory_units = {},
                generated_unit_slots = {}
            }
        end
    end
    local force_fragment_to_main_units_data = req_data("force_fragment_to_main_units")
    for row_index = 1, #force_fragment_to_main_units_data do
        local this_row = force_fragment_to_main_units_data[row_index]
        --[[FORCE_FRAGMENT_KEY: force_fragments]]
        --[[MAIN_UNIT_KEY: string]]
        --[[LIST_INDEX: selection_set_enum]]
        --TODO add UPE for units
        if this_row.FORCE_FRAGMENT == "" or this_row.MAIN_UNIT_KEY == "" then
            --skip this row, its blank.
        elseif not select_set_validation[this_row.LIST_INDEX] then
            error("invalid selection set enum: "..this_row.LIST_INDEX.. " on row "..row_index.." of force_fragment_to_main_units")
        elseif not MOD_DATABASE.force_fragments[this_row.FORCE_FRAGMENT_KEY] then
            error("invalid force fragment key: "..this_row.FORCE_FRAGMENT_KEY.. " on row "..row_index.." of force_fragment_to_main_units")
        elseif this_row.LIST_INDEX == "MANDATORY" then
            table.insert(MOD_DATABASE.force_fragments[this_row.FORCE_FRAGMENT_KEY].mandatory_units, {
                unit_key = this_row.MAIN_UNIT_KEY
            })
        else
            local list_index = tonumber(this_row.LIST_INDEX)
            if not list_index then
               --the only value which can trigger this is MANDATORY, which is handled above.
            else
                MOD_DATABASE.force_fragments[this_row.FORCE_FRAGMENT_KEY].generated_unit_slots[list_index] = 
                MOD_DATABASE.force_fragments[this_row.FORCE_FRAGMENT_KEY].generated_unit_slots[list_index] or {}
                table.insert(MOD_DATABASE.force_fragments[this_row.FORCE_FRAGMENT_KEY].generated_unit_slots[list_index], {
                    unit_key = this_row.MAIN_UNIT_KEY
                })
            end
        end
    end

    --forces > force_to_force_fragments
    local forces_data = req_data("forces") 
    MOD_DATABASE.forces = {}
    for row_index = 1, #forces_data do
        local this_row = forces_data[row_index]
        --[[FORCE_KEY: string]]
        --[[COMMANDER_SET: commander_sets]]
        --[[BASE_DIFFICULTY: string->number]]
        --[[FACTION_SET: faction_sets]]
        
        if this_row.FORCE_KEY == "" then
            --skip this row, its blank.
        elseif MOD_DATABASE.commander_sets[this_row.COMMANDER_SET] == nil then
            error("Invalid Commander Set key ["..this_row.COMMANDER_SET.."] on row "..row_index.." of forces")
        elseif MOD_DATABASE.faction_sets[this_row.FACTION_SET] == nil then
            error("Invalid Faction Set key ["..this_row.FACTION_SET.."] on row "..row_index.." of forces")
        else
            MOD_DATABASE.forces[this_row.FORCE_KEY] = {
                force_key = this_row.FORCE_KEY,
                commander_set = MOD_DATABASE.commander_sets[this_row.COMMANDER_SET],
                base_difficulty = tonumber(this_row.BASE_DIFFICULTY) or 0,
                faction_set = MOD_DATABASE.faction_sets[this_row.FACTION_SET],
                force_fragments = {}
            }
        end
    end
    local force_to_force_fragments_data = req_data("force_to_force_fragments")
    for row_index = 1, #force_to_force_fragments_data do
        local this_row = force_to_force_fragments_data[row_index]
        --[[FORCE_KEY: forces]]
        --[[FORCE_FRAGMENT_KEY: force_fragments]]
        --[[SELECTION_SET: selection_set_enum]]

        if this_row.FORCE_KEY == "" or this_row.FORCE_FRAGMENT_KEY == "" then
            --skip this row, its blank.
        elseif not select_set_validation[this_row.SELECTION_SET] then
            error("invalid selection set enum: "..this_row.SELECTION_SET.. " on row "..row_index.." of force_to_force_fragments")
        elseif not MOD_DATABASE.forces[this_row.FORCE_KEY] then
            error("invalid force key: "..this_row.FORCE_KEY.. " on row "..row_index.." of force_to_force_fragments")
        elseif not MOD_DATABASE.force_fragments[this_row.FORCE_FRAGMENT_KEY] then
            error("invalid force fragment key: "..this_row.FORCE_FRAGMENT_KEY.. " on row "..row_index.." of force_to_force_fragments")
        elseif this_row.SELECTION_SET == "MANDATORY" then
            MOD_DATABASE.forces[this_row.FORCE_KEY].force_fragments[this_row.SELECTION_SET] = 
            MOD_DATABASE.forces[this_row.FORCE_KEY].force_fragments[this_row.SELECTION_SET] or {}
            table.insert(MOD_DATABASE.forces[this_row.FORCE_KEY].force_fragments[this_row.SELECTION_SET], MOD_DATABASE.force_fragments[this_row.FORCE_FRAGMENT_KEY])
        else
            local list_index = tonumber(this_row.SELECTION_SET)
            if not list_index then
                --the value which can trigger this is MANDATORY, which is handled above.
            else
                MOD_DATABASE.forces[this_row.FORCE_KEY].force_fragments[list_index] = 
                MOD_DATABASE.forces[this_row.FORCE_KEY].force_fragments[list_index] or {}
                table.insert(MOD_DATABASE.forces[this_row.FORCE_KEY].force_fragments[list_index], MOD_DATABASE.force_fragments[this_row.FORCE_FRAGMENT_KEY])
            end
        end
    end

    --force_sets > force_set_to_forces
    local force_sets_data = req_data("force_sets")
    MOD_DATABASE.force_sets = {}
    for i = 1, #force_sets_data do
        local this_row = force_sets_data[i]
        --[[FORCE_SET_KEY: string]]
        MOD_DATABASE.force_sets[this_row.FORCE_SET_KEY] = {}
    end
    local force_set_to_forces_data = req_data("force_set_to_forces")
    for i = 1, #force_set_to_forces_data do
        local this_row = force_set_to_forces_data[i]
        --[[FORCE_SET_KEY: force_sets]]
        --[[FORCE_KEY: forces]]
        if this_row.FORCE_SET_KEY == "" or this_row.FORCE_KEY == "" then
            --skip this row, its blank.
        elseif not MOD_DATABASE.force_sets[this_row.FORCE_SET_KEY] then
            error("invalid force set key: "..this_row.FORCE_SET_KEY.. " on row "..i.." of force_set_to_forces")
        elseif not MOD_DATABASE.forces[this_row.FORCE_KEY] then
            error("invalid force key: "..this_row.FORCE_KEY.. " on row "..i.." of force_set_to_forces")
        else
            table.insert(MOD_DATABASE.force_sets[this_row.FORCE_SET_KEY], this_row.FORCE_KEY)
        end
    end

    --progress gates > encounters
    local progress_gates_data = req_data("progress_gates")
    MOD_DATABASE.progress_gates = {}
    for i = 1, #progress_gates_data do
        local this_row = progress_gates_data[i]
        --[[PROGRESS_GATE_KEY: string]]
        --[[ACTIVATION_THRESHOLD: string->number]]
        MOD_DATABASE.progress_gates[this_row.PROGRESS_GATE_KEY] = {
            activation_threshold = tonumber(this_row.ACTIVATION_THRESHOLD) or 0,
            generates_encounters = {}, 
            forces_encounters = {},
            displaces_encounters = {}
        }
    end
    local encounters_data = req_data("encounters")
    MOD_DATABASE.encounters = {}
    for i = 1, #encounters_data do
        local this_row = encounters_data[i]
        --[[ENCOUNTER_KEY: string]]
        --[[REGION: string]]
        --[[FORCE_SET: force_sets]]
        --[[BATTLE_TYPE: string]]
        --[[GENERATED_AT_PROGRESS_GATE: progress_gates]]
        --[[FORCED_AT_PROGRESS_GATE: progress_gates]]
        --[[DISPLACED_AT_PROGRESS_GATE: progress_gates]]
        --[[PROGRESS_GATE_SELECTION_SET: selection_set_enum]]
        --[[INCREMENTS_PROGRESS_GATE: progress_gates]]
        --[[GATE_INCREMENT_WEIGHT: string->number]]
        --TODO add the remaining fields to the encounter table.
        if this_row.ENCOUNTER_KEY == "" or this_row.REGION == "" or this_row.BATTLE_TYPE == "" or this_row.FORCE_SET == "" 
        or this_row.PROGRESS_GATE_SELECTION_SET == "" or this_row.GATE_INCREMENT_WEIGHT == "" then
            --skip this row, its blank.
        elseif #MOD_DATABASE.force_sets[this_row.FORCE_SET] == 0 then
            error("force set "..this_row.FORCE_SET.." has no forces, but is used on row "..i.." of encounters")
        else
            local encounter = {
                key = this_row.ENCOUNTER_KEY,
                region = "settlement:"..this_row.REGION,
                force_set = MOD_DATABASE.force_sets[this_row.FORCE_SET],
                battle_type = this_row.BATTLE_TYPE,
                increments_progress_gate = this_row.INCREMENTS_PROGRESS_GATE,
                gate_increment_weight = tonumber(this_row.GATE_INCREMENT_WEIGHT) or 0,
                progress_gate_selection_set = this_row.PROGRESS_GATE_SELECTION_SET
            }
            MOD_DATABASE.encounters[this_row.ENCOUNTER_KEY] = encounter
            if this_row.GENERATED_AT_PROGRESS_GATE ~= "NEVER" then
                table.insert(MOD_DATABASE.progress_gates[this_row.GENERATED_AT_PROGRESS_GATE].generates_encounters, encounter)
            end
            if this_row.FORCED_AT_PROGRESS_GATE ~= "NEVER" then
                table.insert(MOD_DATABASE.progress_gates[this_row.FORCED_AT_PROGRESS_GATE].forces_encounters, encounter)
            end
            if this_row.DISPLACED_AT_PROGRESS_GATE ~= "NEVER" then
                table.insert(MOD_DATABASE.progress_gates[this_row.DISPLACED_AT_PROGRESS_GATE].displaces_encounters, encounter)
            end
        end
    end

    return MOD_DATABASE
end

local output_file = io.open("lua/output/rogue_daniel_db/".."test_case.lua", "w+")
output_file:write("return ".. table_to_string(rogue_daniel_loader.load_all_data(), 1))
--lua\output\rogue_daniel_db\forces.lua
