
local event_to_event_processors = {
    ["TurnStart"] = {"RegionTurnStart", function(context, --:WHATEVER
        chain_key) --:string
        return context:region():building_superchain_exists(chain_key), context:region()
    end},
    ["EntersRegion"] = {"CharacterEntersGarrison", function(context, --:WHATEVER
        chain_key) --:string
        return context:character():region():building_superchain_exists(chain_key), context:character():region()
    end}
}--:map<string, {string, function(context: WHATEVER, building_key: string)-->(boolean, CA_REGION)}>

local building_effects = {} --:map<string,vector<string>>
local check = dev.Check
local event_manager = dev.GameEvents

--v function(t: any)
local function log(t)
    dev.log(tostring(t), "BUILD")
end


--v function(chain_key: string, event: string, callback: function(region: CA_REGION))
local function add_building_effect(chain_key, event, callback)
    if event_to_event_processors[event] == nil then
        log("Unrecognized building event")
        return
    end
    dev.eh:add_listener(chain_key..event,
    event_to_event_processors[event][1],
        function(context)
            return true
        end,
        function(context)
            local ok, region = event_to_event_processors[event][2](context, chain_key)
            if ok then
                callback(region)
            end
        end, true)
        if not building_effects[chain_key] then building_effects[chain_key] = {} end
        table.insert(building_effects[chain_key], "")
end

--v function(chain_key: string)
local function clear_building_effects_for_chain(chain_key)
    if building_effects[chain_key] then
        for i = 1, #building_effects[chain_key] do
            dev.eh:remove_listener(building_effects[chain_key][i])
        end
    end
    building_effects[chain_key] = {}
end

local kings_court_check = function(region) --:CA_REGION
    local owner = region:owning_faction()
    local faction_list = dev.faction_list()
    local vassal_count = 0 --:number
    for i = 0, faction_list:num_items() - 1 do
        local vassal = faction_list:item_at(i)
        if vassal:is_vassal_of(owner) then
            vassal_count = vassal_count + 1
        end
    end
    vassal_count = dev.clamp(vassal_count, 0, 5)
    local bundle = cm:get_saved_value("kings_court_bundle") or 0
    if bundle ~= vassal_count then
        if bundle > 0 then
            cm:remove_effect_bundle_from_region("vik_konungsgurtha_"..bundle, region:name())
        end
        if vassal_count > 0 then
            cm:apply_effect_bundle_to_region("vik_konungsgurtha_"..vassal_count, region:name(), 0)
        end
        cm:set_saved_value("kings_court_bundle", vassal_count)
    end
end

local characters_resupplied = {}--:map<CA_CQI, {last_bundle: string, off_cooldown_on_turn: int}>
dev.Save.attach_to_table(characters_resupplied, "characters_resupplied")

local resupply_events = {
    sw_resupply_governor_ = {1, false, true, false},
    sw_resupply_warehouse_ = {1, false, false, true},
    sw_resupply_general_ = {1, true, false, false},
    sw_resupply_general_governor_ = {2, true, true, false},
    sw_resupply_general_warehouse_ = {2, true, false, true},
    sw_resupply_governor_warehouse_ = {2, false, true, true},
    sw_resupply_general_governor_warehouse_ = {3, true, true, true}
}--:map<string, {int, boolean, boolean, boolean}>
local resupply_key = "sw_warehouse_resupply_"
local resupply_skill_higher_level_effect = 3
local resupply_building_levels = {
    vik_warehouse_2 = 2,
    vik_warehouse_3 = 4
} --:map<string, int>

local resupply_level_base_durations = {1, 4, 10} --:vector<int>

--v function(context: WHATEVER) --> (boolean, boolean, boolean)
local function check_resupply_event(context)
    local region = context:region() --:CA_REGION
    local character = context:character()
    if region:owning_faction():name() ~= character:faction():name() then
        log("Resupply station not owned by the same faction, this is a region being captured.")
        return false, false, false
    end
    local gen_check = check.does_char_have_quartermaster(character)
    local gov_check = region:has_governor() and check.does_char_have_quartermaster(region:governor())
    local building_check = region:building_superchain_exists("vik_warehouse")

    return gen_check, gov_check, building_check
end

--v function(character:CA_CHAR, region: CA_REGION, level: int)
local function apply_resupply_effect(character, region, level)
    local turn = dev.turn()
    local gen_pol = PettyKingdoms.CharacterPolitics.get(character:command_queue_index())
    local gov_check = region:has_governor()
    local duration = resupply_level_base_durations[level]
    local gen_pass, skill_key = check.does_char_have_quartermaster(character)
    if gen_pass then
        local skill_level = gen_pol.skills[skill_key]
        if skill_level > 1 then
            duration = duration + resupply_skill_higher_level_effect
        end
    end
    if gov_check then
        local gov_pass, skill_key = check.does_char_have_quartermaster(region:governor())
        local gov_pol = PettyKingdoms.CharacterPolitics.get(region:governor():command_queue_index())
        if gov_pass then
            local skill_level = gov_pol.skills[skill_key]
            if skill_level > 1 then
                duration = duration + resupply_skill_higher_level_effect
            end
        end
    end
    for building_key, effect in pairs(resupply_building_levels) do
        if region:building_exists(building_key) then
            duration = duration + effect
        end
    end
    local bundle_key = resupply_key..level
    local cd_turn = turn  + duration
    --if we aren't off cooldown, don't reset the cooldown.
    if characters_resupplied[character:command_queue_index()] and characters_resupplied[character:command_queue_index()].off_cooldown_on_turn > turn then
        cd_turn = characters_resupplied[character:command_queue_index()].off_cooldown_on_turn
    end
    
    characters_resupplied[character:command_queue_index()] = {last_bundle = bundle_key, off_cooldown_on_turn = cd_turn}
    cm:apply_effect_bundle_to_characters_force(bundle_key, character:command_queue_index(), duration, true)
end

--v function(context: WHATEVER) 
local function apply_resupply_effects_using_context(context)
    local region = context:region() --:CA_REGION
    local character = context:character() --:CA_CHAR
    local event = context:game_event() --:GAME_EVENT

    local level = resupply_events[event.key][1]
    apply_resupply_effect(character, region, level)
end

dev.first_tick(function(context)


    local building_events = {
        sw_foreign_warriors_trial_fair_ = {
            building_superchains = {"vik_moot_hil", "vik_court"},
            cooldown = 24
        },
        sw_religion_convert_church_ = {
            building_superchains = {"vik_church"},
            building_levels = {"vik_monastery_2", "vik_monastery_3", "vik_monastery_4", "vik_monastery_5"},
            cooldown = 24,
            condition = function(context) --:WHATEVER
                local region = context:region() --:CA_REGION
                if region:has_governor() then
                    return region:governor():has_trait("shield_heathen_pagan") and dev.chance(33)
                end
                return false
            end,
            callback = function(context) --:WHATEVER
                local region = context:region() --:CA_REGION
                if region:has_governor() and context:choice() == 0 then
                    dev.remove_trait(region:governor(), "shield_heathen_pagan")
                end

            end,
            is_dilemma = true
        }
    }--:map<string, {building_superchains: vector<string>?, building_levels:vector<string>?, cooldown:int, condition:(function(context: WHATEVER)--> boolean)?, is_dilemma: boolean?, callback: (function(context:WHATEVER))?}>

    local standard_building_event_group = event_manager:create_new_condition_group("BuildingEvents")
    standard_building_event_group:set_cooldown(8)
    standard_building_event_group:set_number_allowed_in_queue(1)
    event_manager:register_condition_group(standard_building_event_group, "RegionTurnStart")
    for event_key, event_info in pairs(building_events) do
        local type_group = "incident" --:GAME_EVENT_TYPE
        if event_info.is_dilemma then
            type_group = "dilemma"
        end
        local event = event_manager:create_event(event_key, type_group, "concatenate_region")
        event:add_queue_time_condition(function(context)
            local region = context:region() --:CA_REGION
            local has_building = false
            if dev.turn() < 4 then
                return false
            end
            for i = 1, #(event_info.building_superchains or {}) do
                --# assume event_info.building_superchains: vector<string>
                local chain = event_info.building_superchains[i]
                if region:building_superchain_exists(chain) then
                    has_building = true
                end
            end
            if not has_building then
                for i = 1, #(event_info.building_levels or {}) do
                    --# assume event_info.building_levels: vector<string>
                    local chain = event_info.building_levels[i]
                    if region:building_exists(chain) then
                        has_building = true
                    end
                end
            end
            --# assume event_info.condition: function(context: WHATEVER)--> boolean
            local cond = (not event_info.condition) or event_info.condition(context)
            return has_building and cond
        end)
        if event_info.callback then
            --# assume event_info.callback: function(context:WHATEVER)
            event:add_callback(event_info.callback)
        end
        event:set_cooldown(event_info.cooldown)
        event:join_groups("BuildingEvents")
    end

    add_building_effect("vik_konungsgurtha", "TurnStart", kings_court_check)

    local resupply_group = event_manager:create_new_condition_group("ResupplyGroup", function(context)
        local character = context:character() --:CA_CHAR
        if not characters_resupplied[character:command_queue_index()] then
            return true
        else
            if dev.turn() >= characters_resupplied[character:command_queue_index()].off_cooldown_on_turn then   
                return true
            end
        end   
        return false
    end)

    resupply_group:add_callback(function(context)
        apply_resupply_effects_using_context(context)
    end)
    event_manager:register_condition_group(resupply_group, "CharacterEntersGarrison")

    for key, info in pairs(resupply_events) do
        local event = event_manager:create_event(key, "incident", "concatenate_region")
        event:add_queue_time_condition(function(context)
 
            local needs_general, needs_governor, needs_warehouse = info[2], info[3], info[4]
            local has_general, has_governor, has_warehouse = check_resupply_event(context)
            return (needs_general == has_general) and (needs_governor == has_governor) and (needs_warehouse == has_warehouse)
        end)
        event:join_groups("ProvinceCapitals", "ResupplyGroup")
    end


end)

return {
    add_building_effect = add_building_effect,
    clear_building_effects_for_chain = clear_building_effects_for_chain
}