local error = function (message)
    local error_message = "ERROR LOADING ROGUE DANIEL DATA: " .. message
    ModLog(error_message)
end

--[[
    upe_sets_to_upe.lua
    commander_set_to_commanders.lua
    commander_sets.lua
    commanders.lua
    effect_bundle_lists.lua
    effect_bundle_lists_to_effect_bundles.lua
    faction_sets.lua
    faction_sets_to_factions.lua
    force_fragment_to_main_units.lua
    force_fragments.lua
    force_to_force_fragments.lua
    forces.lua
    upe_sets.lua
]]

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

local function req_data(table_name) 
    return require("script/rogue_data/"..table_name)
end

rogue_daniel_loader = {}

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
               --this should never happen because of the select_set_validation check above
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
        this_row = force_to_force_fragments_data[row_index]
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
        else
            local list_index = tonumber(this_row.SELECTION_SET)
            if not list_index then
                --this should never happen because of the select_set_validation check above
            else
                MOD_DATABASE.forces[this_row.FORCE_KEY].force_fragments[list_index] = 
                MOD_DATABASE.forces[this_row.FORCE_KEY].force_fragments[list_index] or {}
                table.insert(MOD_DATABASE.forces[this_row.FORCE_KEY].force_fragments[list_index], MOD_DATABASE.force_fragments[this_row.FORCE_FRAGMENT_KEY])
            end
        end
    end

    return MOD_DATABASE
end

function rogue_daniel_loader.verify_all_data(MOD_DATABASE)
    -- verify that the factions listed in each faction set exist
    local faction_sets = MOD_DATABASE.faction_sets
    for faction_set, faction_key_list in pairs(faction_sets) do
        for faction_key_index = 1, #faction_key_list do
            local faction_key = faction_key_list[faction_key_index]
            if not cm:get_faction(faction_key) then
                --TODO convert this into a CCO based check so it can run outside of campaign?
                error("faction key "..faction_key.." does not exist in faction set "..faction_set)
            end
        end
    end
    --TODO verify that all the effect bundles in each effect bundle list exist

    --TODO verify that all the UPEs in each UPE set exist

    --TODO verify that the subtype of each commander in each commander set exists
end