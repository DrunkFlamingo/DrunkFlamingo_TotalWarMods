require("common")
--[[
armory_part_sets.txt
commander_set_to_commanders.tsv
commander_sets.tsv
commanders.tsv
effect_bundle_lists.lua
effect_bundle_lists_to_effect_bundles.lua
encounters.tsv
faction_sets.tsv
faction_sets_to_factions.tsv
force_fragment_to_main_units.tsv
force_fragments.tsv
force_set_to_forces.tsv
force_sets.tsv
force_to_force_fragments.tsv
forces.tsv
player_characters.tsv
progress_gates.tsv
reward_dilemma_choice_details.tsv
reward_sets.tsv
reward_sets_to_dilemmas.tsv
upe_sets.lua
upe_sets_to_upe.lua
    ]]
local rogue_daniel_file_inputs = {
    "armory_part_sets",
    "armory_part_sets_to_armory_parts",
    "commander_set_to_commanders",
    "commander_sets",
    "commanders",
    "effect_bundle_lists",
    "effect_bundle_lists_to_effect_bundles",
    "encounters",
    "faction_sets",
    "faction_sets_to_factions",
    "force_fragment_to_main_units",
    "force_fragments",
    "force_set_to_forces",
    "force_sets",
    "force_fragment_sets",
    "force_fragment_sets_to_force_fragments",
    "forces",
    "player_characters",
    "progress_gates",
    "progress_payloads",
    "progress_payloads_to_progress_gates",
    "reward_dilemma_choice_details",
    "reward_sets",
    "reward_sets_to_dilemmas",
    "upe_sets",
    "upe_sets_to_upe"
}

--for each file, parse the TSV format and create a string representing a valid .lua table.
--print the string to a file in the output folder.
for i = 1, #rogue_daniel_file_inputs do
    local file = io.open("lua/input/rogue_daniel_db/"..rogue_daniel_file_inputs[i]..".tsv", "r+")
    if not file then
        error("Could not read file: "..rogue_daniel_file_inputs[i])
    end
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
    local output_file = io.open("lua/output/rogue_daniel_db/"..rogue_daniel_file_inputs[i]..".lua", "w+")
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

    --[[
        Files must be loaded in the following hierarchy

            upe_sets > upe_sets_to_upe
            faction_sets > faction_sets_to_factions
            effect_bundle_lists > effect_bundle_lists_to_effect_bundles

            commander_sets > commanders > commander_set_to_commanders
            force_fragments  > force_fragment_to_main_units
            force_fragment_sets > force_fragment_sets_to_force_fragments
            forces 
            force_sets > force_set_to_forces
            armory_part_sets > armory_part_sets_to_armory_parts
            progress_gates 
            progress_payloads > progress_payloads_to_progress_gates
            reward_dilemma_choice_details
            reward_sets > reward_set_to_dilemmas
            encounters
            player_characters
    ]]
    local skipped_encounters = {}
    local n_skipped_encounters = 0
    local function skip_encounter(encounter_name, message)
        skipped_encounters[encounter_name] = message
        n_skipped_encounters = n_skipped_encounters + 1
    end

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
    local commander_sets_data = req_data("commander_sets")
    MOD_DATABASE.commander_sets = {}
    for row_index = 1, #commander_sets_data do
        local this_row = commander_sets_data[row_index]
        --[[COMMANDER_SET_KEY: string]]
        MOD_DATABASE.commander_sets[this_row.COMMANDER_SET_KEY] = {}
    end
    --commander_sets > commanders > commander_set_to_commanders
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
        --[[DIFFICULTY_DELTA: string->number]]
        --[[LOCALISED_NAME: string]]
        if this_row.FORCE_FRAGMENT_KEY == "" then
            --skip this row, its blank.
        else
            MOD_DATABASE.force_fragments[this_row.FORCE_FRAGMENT_KEY] = {
                force_fragment_key = this_row.FORCE_FRAGMENT_KEY,
                localised_name = this_row.LOCALISED_NAME or "",
                difficulty_delta = tonumber(this_row.DIFFICULTY_DELTA) or 0,
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

    --force_fragment_sets > force_fragment_sets_to_force_fragments
    local force_fragment_sets_data = req_data("force_fragment_sets")
    MOD_DATABASE.force_fragment_sets = {}
    for row_index = 1, #force_fragment_sets_data do
        local this_row = force_fragment_sets_data[row_index]
        --[[FORCE_FRAGMENT_SET: string]]
        if this_row.FORCE_FRAGMENT_SET == "" then
            --skip this row, its blank.
        else
            MOD_DATABASE.force_fragment_sets[this_row.FORCE_FRAGMENT_SET] = {
                key = this_row.FORCE_FRAGMENT_SET,
                mandatory_fragments = {},
                generated_fragment_slots = {}
            }
        end
    end
    local force_fragment_set_to_force_fragments_data = req_data("force_fragment_sets_to_force_fragments")
    for row_index = 1, #force_fragment_set_to_force_fragments_data do
        local this_row = force_fragment_set_to_force_fragments_data[row_index]
        --[[FORCE_FRAGMENT_SET: force_fragment_sets]]
        --[[FORCE_FRAGMENT_KEY: force_fragments]]
        --[[HIDE_FRAGMENT: string->boolean]]
        --[[SELECTION_SET: selection_set_enum]]
        if this_row.FORCE_FRAGMENT_SET == "" or this_row.FORCE_FRAGMENT_KEY == "" then
            --skip this row, its blank.
        elseif not select_set_validation[this_row.SELECTION_SET] then
            error("invalid selection set enum: "..this_row.SELECTION_SET.. " on row "..row_index.." of force_fragment_set_to_force_fragments")
        elseif not MOD_DATABASE.force_fragment_sets[this_row.FORCE_FRAGMENT_SET] then
            error("invalid force fragment set key: "..this_row.FORCE_FRAGMENT_SET.. " on row "..row_index.." of force_fragment_set_to_force_fragments")
        elseif not MOD_DATABASE.force_fragments[this_row.FORCE_FRAGMENT_KEY] then
            error("invalid force fragment key: "..this_row.FORCE_FRAGMENT_KEY.. " on row "..row_index.." of force_fragment_set_to_force_fragments")
        elseif this_row.SELECTION_SET == "MANDATORY" then
            table.insert(MOD_DATABASE.force_fragment_sets[this_row.FORCE_FRAGMENT_SET].mandatory_fragments, {
                force_fragment_key = this_row.FORCE_FRAGMENT_KEY,
                hidden_fragment = this_row.HIDE_FRAGMENT == "true"
            })
        else
            local list_index = tonumber(this_row.SELECTION_SET)
            if not list_index then
               --the only value which can trigger this is MANDATORY, which is handled above.
            else
                MOD_DATABASE.force_fragment_sets[this_row.FORCE_FRAGMENT_SET].generated_fragment_slots[list_index] = 
                MOD_DATABASE.force_fragment_sets[this_row.FORCE_FRAGMENT_SET].generated_fragment_slots[list_index] or {}
                table.insert(MOD_DATABASE.force_fragment_sets[this_row.FORCE_FRAGMENT_SET].generated_fragment_slots[list_index], {
                    force_fragment_key = this_row.FORCE_FRAGMENT_KEY,
                    hidden_fragment = this_row.HIDE_FRAGMENT == "true"
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
        --[[FORCE_FRAGMENT_SET: force_fragment_sets]]
        
        if this_row.FORCE_KEY == "" then
            --skip this row, its blank.
        elseif MOD_DATABASE.commander_sets[this_row.COMMANDER_SET] == nil then
            error("Invalid Commander Set key ["..this_row.COMMANDER_SET.."] on row "..row_index.." of forces")
        elseif MOD_DATABASE.faction_sets[this_row.FACTION_SET] == nil then
            error("Invalid Faction Set key ["..this_row.FACTION_SET.."] on row "..row_index.." of forces")
        elseif not MOD_DATABASE.force_fragment_sets[this_row.FORCE_FRAGMENT_SET] then
            error("Invalid Force Fragment Set key ["..this_row.FORCE_FRAGMENT_SET.."] on row "..row_index.." of forces")
        else
            MOD_DATABASE.forces[this_row.FORCE_KEY] = {
                force_key = this_row.FORCE_KEY,
                commander_set = MOD_DATABASE.commander_sets[this_row.COMMANDER_SET],
                base_difficulty = tonumber(this_row.BASE_DIFFICULTY) or 0,
                faction_set = MOD_DATABASE.faction_sets[this_row.FACTION_SET],
                force_fragment_set = MOD_DATABASE.force_fragment_sets[this_row.FORCE_FRAGMENT_SET]
            }
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

    
    --armory_part_sets > armory_part_set_to_armory_parts
    local armory_part_sets_data = req_data("armory_part_sets")
    MOD_DATABASE.armory_part_sets = {}
    for i = 1, #armory_part_sets_data do
        local this_row = armory_part_sets_data[i]
        --[[ARMORY_PART_SET_KEY: string]]
        --[[UPGRADE_WHEN_EXHAUSTED: string]]
        MOD_DATABASE.armory_part_sets[this_row.ARMORY_PART_SET_KEY] = {
            key = this_row.ARMORY_PART_SET_KEY,
            upgrade_when_exhausted = this_row.UPGRADE_WHEN_EXHAUSTED,
            mandatory_parts = {},
            generated_part_slots = {}
        }
    end
    local armory_part_sets_to_armory_parts = req_data("armory_part_sets_to_armory_parts")
    for i = 1, #armory_part_sets_to_armory_parts do
        local this_row = armory_part_sets_to_armory_parts[i]
        --[[ARMORY_PART_SET: armory_part_sets]]
        --[[ARMORY_PART: armory_parts]]
        --[[SELECTION_SET: selection_sets]]
        if this_row.ARMORY_PART_SET == "" or this_row.ARMORY_PART == "" then
            --skip this row, its blank.
        elseif not MOD_DATABASE.armory_part_sets[this_row.ARMORY_PART_SET] then
            error("invalid armory part set key: "..this_row.ARMORY_PART_SET.. " on row "..i.." of armory_part_set_to_armory_parts")
        elseif this_row.SELECTION_SET == "MANDATORY" then
            table.insert(MOD_DATABASE.armory_part_sets[this_row.ARMORY_PART_SET].mandatory_parts, this_row.ARMORY_PART)
        else
            local list_index = tonumber(this_row.SELECTION_SET)
            if not list_index then
                --the value which can trigger this is MANDATORY, which is handled above.
            else
                MOD_DATABASE.armory_part_sets[this_row.ARMORY_PART_SET].generated_part_slots[list_index] = 
                MOD_DATABASE.armory_part_sets[this_row.ARMORY_PART_SET].generated_part_slots[list_index] or {}
                table.insert(MOD_DATABASE.armory_part_sets[this_row.ARMORY_PART_SET].generated_part_slots[list_index], this_row.ARMORY_PART)
            end
        end
    end

    --progress gates
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

    --progress_payloads > progress_payloads_to_progress_gates
    local progress_payloads_data = req_data("progress_payloads")
    MOD_DATABASE.progress_payloads = {}
    for i = 1, #progress_payloads_data do
        local this_row = progress_payloads_data[i]
        --[[PROGRESS_PAYLOAD_KEY: string]]
        MOD_DATABASE.progress_payloads[this_row.PROGRESS_PAYLOAD_KEY] = {
            key = this_row.PROGRESS_PAYLOAD_KEY,
            mandatory_gate_increments = {},
            generated_gate_increments = {}
        }
    end
    local progress_payloads_to_progress_gates = req_data("progress_payloads_to_progress_gates")
    for i = 1, #progress_payloads_to_progress_gates do
        local this_row = progress_payloads_to_progress_gates[i]
        --[[PROGRESS_PAYLOAD: progress_payloads]]
        --[[PROGRESS_GATE: progress_gates]]
        --[[INCREMENT: string->number]]
        --[[SELECTION_SET: selection_sets]]
        if this_row.PROGRESS_PAYLOAD == "" or this_row.PROGRESS_GATE == "" then
            --skip this row, its blank.
        elseif not MOD_DATABASE.progress_payloads[this_row.PROGRESS_PAYLOAD] then
            error("invalid progress payload key: "..this_row.PROGRESS_PAYLOAD.. " on row "..i.." of progress_payloads_to_progress_gates")
        elseif not MOD_DATABASE.progress_gates[this_row.PROGRESS_GATE] then
            error("invalid progress gate key: "..this_row.PROGRESS_GATE.. " on row "..i.." of progress_payloads_to_progress_gates")
        elseif this_row.SELECTION_SET == "MANDATORY" then
            MOD_DATABASE.progress_payloads[this_row.PROGRESS_PAYLOAD].mandatory_gate_increments[this_row.PROGRESS_GATE] = tonumber(this_row.INCREMENT) or 0
        else
            local list_index = tonumber(this_row.SELECTION_SET)
            if not list_index then
                --the value which can trigger this is MANDATORY, which is handled above.
            else
                MOD_DATABASE.progress_payloads[this_row.PROGRESS_PAYLOAD].generated_gate_increments[list_index] = 
                MOD_DATABASE.progress_payloads[this_row.PROGRESS_PAYLOAD].generated_gate_increments[list_index] or {}
                MOD_DATABASE.progress_payloads[this_row.PROGRESS_PAYLOAD].generated_gate_increments[list_index][this_row.PROGRESS_GATE] = tonumber(this_row.INCREMENT) or 0
            end
        end
    end

    --reward_dilemma_choice_details
    local reward_dilemma_choice_details_data = req_data("reward_dilemma_choice_details")
    MOD_DATABASE.reward_dilemma_choice_details = {}
    for i = 1, #reward_dilemma_choice_details_data do
        local this_row = reward_dilemma_choice_details_data[i]
        --[[REWARD_DILEMMA: string]]
        --[[DILEMMA_CHOICE_KEY: string]]
        --[[SELECTION_SET: selection_sets]]
        --[[COSTS_RESOURCE: string]]
        --[[COSTS: string->number]]
        --[[FORCE_FRAGMENT_SET: force_fragment_sets]]
        --[[ARMORY_PART_SET: armory_part_sets]]
        if this_row.REWARD_DILEMMA == "" or this_row.DILEMMA_CHOICE_KEY == "" then
            --skip this row, its blank.
        elseif this_row.FORCE_FRAGMENT_SET ~= "" and not MOD_DATABASE.force_fragment_sets[this_row.FORCE_FRAGMENT_SET] then
            error("invalid force fragment set key: "..this_row.FORCE_FRAGMENT_SET.. " on row "..i.." of reward_dilemma_choice_details")
        elseif this_row.ARMORY_PART_SET ~= "" and not MOD_DATABASE.armory_part_sets[this_row.ARMORY_PART_SET] then
            error("invalid armory part set key: "..this_row.ARMORY_PART_SET.. " on row "..i.." of reward_dilemma_choice_details")
        else
            MOD_DATABASE.reward_dilemma_choice_details[this_row.REWARD_DILEMMA] = 
            MOD_DATABASE.reward_dilemma_choice_details[this_row.REWARD_DILEMMA] or {}
            MOD_DATABASE.reward_dilemma_choice_details[this_row.REWARD_DILEMMA][this_row.DILEMMA_CHOICE_KEY] =
            MOD_DATABASE.reward_dilemma_choice_details[this_row.REWARD_DILEMMA][this_row.DILEMMA_CHOICE_KEY] or {
                mandatory_reward_components = {},
                generated_reward_components = {}
            }
            if this_row.SELECTION_SET == "MANDATORY" then
                table.insert(MOD_DATABASE.reward_dilemma_choice_details[this_row.REWARD_DILEMMA][this_row.DILEMMA_CHOICE_KEY].mandatory_reward_components, {
                    costs_resource = this_row.COSTS_RESOURCE,
                    costs = this_row.COSTS,
                    force_fragment_set = this_row.FORCE_FRAGMENT_SET,
                    armory_part_set = MOD_DATABASE.armory_part_sets[this_row.ARMORY_PART_SET]
                })
            else
                local list_index = tonumber(this_row.SELECTION_SET)
                if not list_index then
                    
                else
                    table.insert(MOD_DATABASE.reward_dilemma_choice_details[this_row.REWARD_DILEMMA][this_row.DILEMMA_CHOICE_KEY].generated_reward_components[this_row.SELECTION_SET], {
                        costs_resource = this_row.COSTS_RESOURCE,
                        costs = this_row.COSTS,
                        force_fragment_set = this_row.FORCE_FRAGMENT_SET,
                        armory_part_set = MOD_DATABASE.armory_part_sets[this_row.ARMORY_PART_SET]
                    })
                end
            end
        end
    end

    --reward_sets > reward_set_to_dilemmas
    local reward_sets_data = req_data("reward_sets")
    MOD_DATABASE.reward_sets = {}
    for i = 1, #reward_sets_data do
        local this_row = reward_sets_data[i]
        --[[REWARD_SET_KEY: string]]
        MOD_DATABASE.reward_sets[this_row.REWARD_SET_KEY] = {}
    end
    local reward_sets_to_dilemmas = req_data("reward_sets_to_dilemmas")
    for i = 1, #reward_sets_to_dilemmas do
        local this_row = reward_sets_to_dilemmas[i]
        --[[REWARD_SET: reward_sets]]
        --[[DILEMMA: string]]
        --[[REQUIRES_RESOURCE: string]]
        --[[RESOURCE_THRESHOLD: string->number]]
        if this_row.REWARD_SET == "" or this_row.DILEMMA == "" then
            --skip this row, its blank.
        elseif not MOD_DATABASE.reward_sets[this_row.REWARD_SET] then
            error("invalid reward set key: "..this_row.REWARD_SET.. " on row "..i.." of reward_set_to_dilemmas")
        else
            table.insert(MOD_DATABASE.reward_sets[this_row.REWARD_SET], {
                dilemma = this_row.DILEMMA,
                requires_resource = this_row.REQUIRES_RESOURCE,
                resource_threshold = tonumber(this_row.RESOURCE_THRESHOLD) or 0
            })
        end
    end


    --encounters
    local encounters_data = req_data("encounters")
    MOD_DATABASE.encounters = {}
    for i = 1, #encounters_data do
        local this_row = encounters_data[i]
        --[[ENCOUNTER_KEY: string]]
        --[[REGION: string]]
        --[[LOCALISED_NAME: string]]
        --[[LOCALISED_DESCRIPTION: string]]
        --[[FORCE_SET: force_sets]]
        --[[BATTLE_TYPE: string]]
        --[[GENERATED_AT_PROGRESS_GATE: progress_gates]]
        --[[FORCED_AT_PROGRESS_GATE: progress_gates]]
        --[[DISPLACED_AT_PROGRESS_GATE: progress_gates]]
        --[[PROGRESS_GATE_SELECTION_SET: selection_set_enum]]
        --[[PROGRESS_PAYLOAD: progress_payloads]]
        --[[DURATION: string->number]]
        --[[REWARD_SET: reward_sets]]
        --[[BOSS_OVERLAY: string->boolean]]
        --[[POST_BATTLE_DILEMMA_OVERRIDE: string]]
        --[[INCITING_INCIDENT_KEY: string]]
        if this_row.ENCOUNTER_KEY == "" then
            --skip with no message, key is empty
        elseif this_row.REGION == "" or this_row.BATTLE_TYPE == "" or this_row.FORCE_SET == "" 
        or this_row.PROGRESS_PAYLOAD == "" or this_row.REWARD_SET == "" then
            skip_encounter(this_row.ENCOUNTER_KEY, "encounter on row "..i.." Missing necessary data")
        elseif #MOD_DATABASE.force_sets[this_row.FORCE_SET] == 0 then
            skip_encounter(this_row.ENCOUNTER_KEY, "force set "..this_row.FORCE_SET.." has no forces, but is used on row "..i.." of encounters")
        elseif #MOD_DATABASE.reward_sets[this_row.REWARD_SET] == 0 then
            skip_encounter(this_row.ENCOUNTER_KEY, "reward set "..this_row.REWARD_SET.." has no members, but is used on row "..i.." of encounters")
        elseif not MOD_DATABASE.progress_payloads[this_row.PROGRESS_PAYLOAD] then
            skip_encounter(this_row.ENCOUNTER_KEY, "progress payload "..this_row.PROGRESS_PAYLOAD.." does not exist, but is used on row "..i.." of encounters")
        else
            local encounter = {
                key = this_row.ENCOUNTER_KEY,
                region = "settlement:"..this_row.REGION,
                force_set = MOD_DATABASE.force_sets[this_row.FORCE_SET],
                battle_type = this_row.BATTLE_TYPE,
                progress_payload = this_row.PROGRESS_PAYLOAD,
                duration = tonumber(this_row.DURATION) or 0,
                reward_set = this_row.REWARD_SET,
                boss_overlay = this_row.BOSS_OVERLAY == "TRUE",
                post_battle_dilemma_override = this_row.POST_BATTLE_DILEMMA_OVERRIDE,
                inciting_incident_key = this_row.INCITING_INCIDENT_KEY
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
    --player_characters
    local player_characters_data = req_data("player_characters")
    MOD_DATABASE.player_characters = {}
    for i = 1, #player_characters_data do
        local this_row = player_characters_data[i]
        --[[PLAYABLE_FACTION: string]]
        --[[START_GATE: progress_gates]]
        --[[START_REWARD_SET: reward_sets]]
        if this_row.PLAYABLE_FACTION == "" or this_row.START_GATE == "" or this_row.START_REWARD_SET == "" then
            --skip this row, its blank.
        elseif not MOD_DATABASE.progress_gates[this_row.START_GATE] then
            error("start gate "..this_row.START_GATE.." does not exist, but is used on row "..i.." of player_characters")
        elseif not MOD_DATABASE.reward_sets[this_row.START_REWARD_SET] then
            error("start reward set "..this_row.START_REWARD_SET.." does not exist, but is used on row "..i.." of player_characters")
        elseif #MOD_DATABASE.reward_sets[this_row.START_REWARD_SET] == 0 then
            error("start reward set "..this_row.START_REWARD_SET.." has no members, but is used on row "..i.." of player_characters")
        else
            MOD_DATABASE.player_characters[this_row.PLAYABLE_FACTION] = {
                start_gate = this_row.START_GATE,
                start_reward_set = this_row.START_REWARD_SET
            }
        end
    end



    return MOD_DATABASE, n_skipped_encounters, skipped_encounters
end

local mod_db, skips, skipped_encounters = rogue_daniel_loader.load_all_data()
local output_file = io.open("lua/output/rogue_daniel_db/".."test_case.lua", "w+")
output_file:write("return ".. table_to_string(mod_db, 1))
output_file:flush()
output_file:close()
--lua\output\rogue_daniel_db\forces.lua
if skips > 0 then
    local err_string = "Skipped "..skips.." encounters: "
    for key, reason in pairs(skipped_encounters) do
        err_string = err_string .. key .. ": " .. reason .. "\n"
    end
    error(err_string)
end
