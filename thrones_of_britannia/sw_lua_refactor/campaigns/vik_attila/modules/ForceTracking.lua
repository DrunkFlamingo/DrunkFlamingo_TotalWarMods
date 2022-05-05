local force_tracker = {} --# assume force_tracker: FORCE_TRACKER


--v function() --> FORCE_TRACKER
function force_tracker.new()
    local self = {}
    setmetatable(self, {
        __index = force_tracker
    }) --# assume self: FORCE_TRACKER

    self.forces_cache = {} --:map<string, map<string, number>>
    self.force_casualties = {} --:map<string, map<string, number>>
    self.force_replenishment = {} --:map<string, map<string, number>>
    self.last_battle_significance = {} --:map<string, number>
    self.last_battle_size = 0--:number
    self.last_battle_balance = 1 --:number
    self.last_battle_faction_leaders = {} --:map<string, string>

    self.save = {
        name = "FORCE_CACHE",
        for_save = {
             "forces_cache", "force_casualties", "force_replenishment", "last_battle_size", "last_battle_significance", "last_battle_balance", "last_battle_faction_leaders"
        }, 
    }
    dev.Save.attach_to_object(self)
    return self
end

local instance = force_tracker.new()

dev.pre_first_tick(function(context)
    if dev.is_new_game() then
        local humans = cm:get_human_factions() 
        for i = 1, #humans do
            local char_list = dev.get_faction(humans[i]):character_list()
            for j = 0, char_list:num_items() - 1 do
                local char = char_list:item_at(j)
                if dev.is_char_normal_general(char) then
                    instance.forces_cache[tostring(char:command_queue_index())] = dev.generate_force_cache_entry(char)
                end
            end
        end
    end
    dev.eh:add_listener(
        "ForceCacheCharacterTurnEnd",
        "CharacterTurnEnd",
        function(context)
            return context:character():faction():is_human() and dev.is_char_normal_general(context:character())
        end,
        function(context)
            local char = context:character()
            instance.forces_cache[tostring(char:command_queue_index())] = dev.generate_force_cache_entry(char)
        end,
        true)
    dev.eh:add_listener(
        "ForceCachePendingBattle",
        "PendingBattle",
        function(context)
            return context:pending_battle():attacker():faction():is_human() or context:pending_battle():defender():faction():is_human()
        end,
        function(context)     
            instance.last_battle_significance = {}
            instance.last_battle_faction_leaders = {}
            local attacker_sig = 0 --:number
            local attacker_total_forces = 0 --:number
            local defender_sig = 0--:number
            local defender_total_forces = 0--:number
            local size = 0 --:number
            local pb = context:pending_battle() --:CA_PENDING_BATTLE

            local attacker = pb:attacker()
            if attacker:is_faction_leader() then
                instance.last_battle_faction_leaders[tostring(attacker:command_queue_index())] = attacker:faction():name()
            end
            for i = 0, attacker:military_force():unit_list():num_items() - 1 do
                local unit = attacker:military_force():unit_list():item_at(i)
                attacker_sig = attacker_sig + unit:percentage_proportion_of_full_strength()
                size = size + unit:percentage_proportion_of_full_strength()
            end
            local secondary_attacker_list = pb:secondary_attackers();
            for i = 0, secondary_attacker_list:num_items() - 1 do
                local char = secondary_attacker_list:item_at(i)
                if char:faction():name() == pb:attacker():faction():name() then
                    local mf = char:military_force()
                    if not mf:is_armed_citizenry() then
                        for j = 0, mf:unit_list():num_items() - 1 do
                            local unit = mf:unit_list():item_at(j)
                            attacker_sig = attacker_sig + unit:percentage_proportion_of_full_strength()
                            size = size + unit:percentage_proportion_of_full_strength()
                        end 
                    end
                end
                if char:is_faction_leader() then
                    instance.last_battle_faction_leaders[tostring(char:command_queue_index())] = char:faction():name()
                end
            end;
            
            local mf_list = pb:attacker():faction():military_force_list()
            for i = 0, mf_list:num_items() - 1 do
                local mf = mf_list:item_at(i)
                if not mf:is_armed_citizenry() then
                    for j = 0, mf:unit_list():num_items() - 1 do
                        local unit = mf:unit_list():item_at(j)
                        attacker_total_forces = attacker_total_forces + unit:percentage_proportion_of_full_strength()
                    end
                end
            end

            local defender = pb:defender()
            if defender:is_faction_leader() then
                instance.last_battle_faction_leaders[tostring(defender:command_queue_index())] = defender:faction():name()
            end
            for i = 0, defender:military_force():unit_list():num_items() - 1 do
                local unit = defender:military_force():unit_list():item_at(i)
                defender_sig = defender_sig + unit:percentage_proportion_of_full_strength()
                size = size + unit:percentage_proportion_of_full_strength()
            end
            local secondary_defender_list = pb:secondary_defenders();
            for i = 0, secondary_defender_list:num_items() - 1 do
                local char = secondary_defender_list:item_at(i)
                if char:faction():name() == pb:defender():faction():name() then
                    local mf = char:military_force()
                    if not mf:is_armed_citizenry() then
                        for j = 0, mf:unit_list():num_items() - 1 do
                            local unit = mf:unit_list():item_at(j)
                            defender_sig = defender_sig + unit:percentage_proportion_of_full_strength()
                            size = size + unit:percentage_proportion_of_full_strength()
                        end 
                    end
                end
                if char:is_faction_leader() then
                    instance.last_battle_faction_leaders[tostring(char:command_queue_index())] = char:faction():name()
                end
            end;

            local mf_list = pb:defender():faction():military_force_list()
            for i = 0, mf_list:num_items() - 1 do
                local mf = mf_list:item_at(i)
                if not mf:is_armed_citizenry() then
                    for j = 0, mf:unit_list():num_items() - 1 do
                        local unit = mf:unit_list():item_at(j)
                        defender_total_forces = defender_total_forces + unit:percentage_proportion_of_full_strength()
                    end
                end
            end

            instance.last_battle_significance[attacker:faction():name()] = dev.mround((attacker_sig / attacker_total_forces)*100, 1)
            dev.log("Attacker significance for this battle is: "..tostring(instance.last_battle_significance[attacker:faction():name()]))
            instance.last_battle_significance[defender:faction():name()] = dev.mround((defender_sig / defender_total_forces)*100, 1)
            dev.log("Defender significance for this battle is: "..tostring(instance.last_battle_significance[defender:faction():name()]))
            instance.last_battle_size = size
            dev.log("Size of this battle is: "..tostring(size))
            instance.last_battle_balance = dev.mround((attacker_sig / defender_sig)*100, 1)
            dev.log("Balance of this battle is: "..tostring(instance.last_battle_balance))
        end,
        true
    )
    dev.eh:add_listener(
        "ForceCacheCharacterCompletedBattle",
        "ShieldwallCharacterCompletedBattle",
        function(context)
            return context:character():faction():is_human() and (not context:character():military_force():is_null_interface()) and dev.is_char_normal_general(context:character()) 
        end,
        function(context)
            local char = context:character()
            local cache_temp = dev.generate_force_cache_entry(char)
            local old_cache = instance.forces_cache[tostring(char:command_queue_index())]
            local casualties_cache = {} --:map<string, number>
            local significance = 0

            for unit_key, old_val in pairs(old_cache) do
                local new_val = cache_temp[unit_key] or 0
                casualties_cache[unit_key] = new_val - old_val
            end
            -- values in this cache will be negative numbers.
            instance.force_casualties[tostring(char:command_queue_index())] = casualties_cache
            -- update the internal cache so we can accurately track replenishment
            instance.forces_cache[tostring(char:command_queue_index())] = cache_temp
            --fire event
            dev.eh:trigger_event("CharacterCasualtiesCached", context:character(), casualties_cache) --accessed through context:table_data()
        end,
        true)
    dev.eh:add_listener(
        "ForceCacheCharacterTurnStart",
        "CharacterTurnStart",
        function(context)
            return context:character():faction():is_human() and dev.is_char_normal_general(context:character())
        end,
        function(context)
            local char = context:character()
            local cache_temp = dev.generate_force_cache_entry(char)
            local old_cache = instance.forces_cache[tostring(char:command_queue_index())]
            local replen_cache = {} --:map<string, number>
            for unit_key, old_val in pairs(old_cache) do
                local new_val = cache_temp[unit_key] or 0
                replen_cache[unit_key] = new_val - old_val
            end
            -- values in this cache will be positive numbers
            instance.force_replenishment[tostring(char:command_queue_index())] = replen_cache
            -- update the internal cache so we can accurately track battle casualties.
            instance.forces_cache[tostring(char:command_queue_index())] = cache_temp
            --fire event
            dev.eh:trigger_event("CharacterReplenishmentCached", context:character(), replen_cache)
        end,
        true
    )
end)

--v function(character: CA_CHAR) --> map<string, number>
local function get_last_casualties_for_character(character)
    return instance.force_casualties[tostring(character:command_queue_index())]
end

--v function(character: CA_CHAR) --> map<string, number>
local function get_last_replenishment_for_character(character)
    return instance.force_replenishment[tostring(character:command_queue_index())]
end

--v function(character: CA_CHAR) --> map<string, number>
local function get_force_for_character(character)
    return instance.forces_cache[tostring(character:command_queue_index())]
end

--v function(faction: CA_FACTION) --> number
local function get_last_battle_significance_for_faction(faction)
    return instance.last_battle_significance[faction:name()] or 0
end

--v function(cqi: CA_CQI) --> boolean
local function was_character_a_faction_leader_in_last_battle(cqi)
    return not not instance.last_battle_faction_leaders[tostring(cqi)]
end

return {
    get_character_force_strength = get_force_for_character,
    get_character_casualties = get_last_casualties_for_character,
    get_character_replenishment = get_last_replenishment_for_character,
    get_last_battle_significance_for_faction = get_last_battle_significance_for_faction,
    was_char_cqi_a_faction_leader_in_last_battle = was_character_a_faction_leader_in_last_battle
}