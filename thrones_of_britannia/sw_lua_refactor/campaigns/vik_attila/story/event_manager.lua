local game_event_manager = {} --# assume game_event_manager: GAME_EVENT_MANAGER

--v function(self: GAME_EVENT_MANAGER, t: any)
function game_event_manager.log(self, t)
    dev.log(tostring(t), "EVENTS")
end

local queue_times = {
    "FactionTurnStart", "CharacterTurnStart", "RegionTurnStart", "ShieldwallCharacterCompletedBattle", "CharacterRetreatedFromBattle",
    "CharacterEntersGarrison", "MissionTargetGeneratorFactionAtWarWith"
} --:vector<GAME_EVENT_QUEUE_TIMES>

local default_groups = {"dilemma", "incident", "mission"}

--v function() --> GAME_EVENT_MANAGER
function game_event_manager.new()

    local self = {}
    setmetatable(self, {
        __index = game_event_manager
    }) --# assume self: GAME_EVENT_MANAGER

    --maps event keys to their event object
    self.events = {} --:map<string, GAME_EVENT>
    self.condition_groups = {} --:map<string, EVENT_CONDITION_GROUP>
    --maps event keys to their most recent position in the queue.
    self.queue_map = {} --:map<string, int>
    --holds the actual queue
    self.event_queue = {} --:vector<QUEUED_GAME_EVENT>
    --maps the event keys of missions to a queued event entry which contains information stored for us in completion context
    self.mission_info = {} --:map<string, QUEUED_GAME_EVENT>

    --holds which settlements the human factions have already visited with which characters to prevent doubling up events.
    self.garrison_visits_cache = {} --:map<string, map<CA_CQI, boolean>>

    self.whose_turn = "" --:string
    self.block_visit_events = {} --:map<string, CA_CQI>

    self.schedule = {} --:map<GAME_EVENT_QUEUE_TIMES, vector<EVENT_CONDITION_GROUP>>
    for i = 1, #queue_times do
        self.schedule[queue_times[i]] = {}
    end
    self.save = {
        name = "GAME_EVENT_MANAGER", 
        for_save = {"event_queue", "queue_map", "block_visit_events", "mission_info"}
    }--:SAVE_SCHEMA
    dev.Save.attach_to_object(self)
    return self
end

--context
--v [NO_CHECK] function(self: GAME_EVENT_MANAGER, ...:any) --> WHATEVER
function game_event_manager.build_context_for_event(self, ...)
    -- build an event context
    local context = custom_context:new();
    for i = 1, arg.n do
        local current_obj = arg[i];
        if is_string(current_obj) and self.events[current_obj] then
            current_obj = self.events[current_obj]
        end
        context:add_data(current_obj);
    end
    return context
end

--v function(self: GAME_EVENT_MANAGER, queued_event: QUEUED_GAME_EVENT) --> WHATEVER
function game_event_manager.build_context_from_queued_event(self, queued_event)
    self:log("Building event context for: "..queued_event.event_key)
    local event = self.events[queued_event.event_key]
    local faction_to_recieve = dev.get_faction(queued_event.faction_key)
    local region_to_recieve = dev.get_region(queued_event.region_key) or true
    local character_to_recieve = dev.get_character(queued_event.char_cqi) or true
    local second_faction_to_recieve = dev.get_faction(queued_event.other_faction) or true
    local second_character_to_recieve = dev.get_character(queued_event.target_cqi) or true
    return self:build_context_for_event(event, faction_to_recieve, region_to_recieve, character_to_recieve, second_faction_to_recieve, second_character_to_recieve)
end

--mission information
--v function(self: GAME_EVENT_MANAGER, event_key: string)
function game_event_manager.remove_mission_info(self, event_key)
    self.mission_info[event_key] = nil
end

--v function(self: GAME_EVENT_MANAGER, event_key: string) --> QUEUED_GAME_EVENT
function game_event_manager.get_mission_info(self, event_key)
    if not self.mission_info[event_key] then
        self:log("Could not get mission info for "..event_key..". Its entry was nil")
    end
    return self.mission_info[event_key]
end

--v function(self: GAME_EVENT_MANAGER, event_key: string, queue_entry: QUEUED_GAME_EVENT)
function game_event_manager.add_mission_info(self, event_key, queue_entry)
    self.mission_info[event_key] = queue_entry
end

--condition groups
local condition_group = require("story/event_condition_groups")


--v function(self: GAME_EVENT_MANAGER, condition_group: EVENT_CONDITION_GROUP, schedule: GAME_EVENT_QUEUE_TIMES)
function game_event_manager.schedule_condition_group(self, condition_group, schedule)
    table.insert(self.schedule[schedule], condition_group)
end

--v function(self: GAME_EVENT_MANAGER, new_condition_group: EVENT_CONDITION_GROUP, schedule: GAME_EVENT_QUEUE_TIMES?)
function game_event_manager.register_condition_group(self, new_condition_group, schedule)
    self.condition_groups[new_condition_group.name] = new_condition_group
    local t = "Registered " .. new_condition_group.name .. " as an event condition group"
    if schedule then
        --# assume schedule: GAME_EVENT_QUEUE_TIMES
        t = t .. "; scheduled group for " ..schedule
        self:schedule_condition_group(new_condition_group, schedule)
    end
    self:log(t)
end

--v function(self: GAME_EVENT_MANAGER, name: string, condition: (function(context: WHATEVER) --> boolean)?) --> EVENT_CONDITION_GROUP
function game_event_manager.create_new_condition_group(self, name, condition)
    local new_group = condition_group.new(name, self)
    if condition then
        new_group.queue_time_condition = condition
    end
    return new_group
end

--game events
local game_event = require("story/event")

--v function(self: GAME_EVENT_MANAGER, name: string, event_type: GAME_EVENT_TYPE, event_trigger_kind: GAME_EVENT_TRIGGER_KIND) --> GAME_EVENT
function game_event_manager.create_event(self, name, event_type, event_trigger_kind)
    local type_group = self.condition_groups[event_type]
    if not type_group then
        self:log("Attempting to create event: "..name..". The provided event type "..event_type.." is not registered!")
    end
    local new_event = game_event.new(self, name, type_group, event_trigger_kind)
    self.events[name] = new_event
    return new_event
end

--v function(self: GAME_EVENT_MANAGER, name: string) --> GAME_EVENT
function game_event_manager.get_event(self, name)
    if not self.events[name] then
        self:log("Asked to get an event which doesn't exist: "..name)
    end
    return self.events[name]
end



--internals



--v function(self: GAME_EVENT_MANAGER, event_key: string) --> QUEUED_GAME_EVENT
function game_event_manager.get_event_from_queue(self, event_key)
    local pos = self.queue_map[event_key]
    local event = self.event_queue[pos]
    return event
end

--v function(self: GAME_EVENT_MANAGER, event_key: string, should_notify: boolean) --> boolean
function game_event_manager.remove_event_from_queue(self, event_key, should_notify)
    if (not event_key) or (not self.events[event_key]) then
        return false
    end
    local position_in_queue = self.queue_map[event_key]
    local queue_entry = self.event_queue[position_in_queue]
    if self.events[event_key].trigger_kind == "trait_flag" then
        local char_cqi = queue_entry.char_cqi
        dev.remove_trait(char_cqi, event_key .. "_flag")
    end

    if queue_entry.event_key == event_key then
        table.remove(self.event_queue, position_in_queue)
        self.queue_map[event_key] = nil
        for i = 1, #self.event_queue do
            self.queue_map[self.event_queue[i].event_key] = i
        end
        if should_notify then
            local context = self:build_context_from_queued_event(queue_entry)
            local turn = dev.turn()
            for i = 1, #self.events[event_key].groups do
                local group = self.events[event_key].groups[i]
                group:OnMemberEventRemovedFromQueue(event_key, turn)
                local ok, err = pcall(function()
                    group.unqueued_callback(context)
                end) if not ok then 
                    self:log("Event "..event_key .. " has errored on unqueue callback given by group: "..group.name)
                end
            end
        end
        return true
    end
    return false
end

--v function(self: GAME_EVENT_MANAGER, event_object: GAME_EVENT, context: WHATEVER) --> QUEUED_GAME_EVENT
function game_event_manager.generate_queue_entry(self, event_object, context)
    local queue_entry = {event_key = event_object.key, faction_key = context:faction():name()} --:QUEUED_GAME_EVENT
    if context:character() then
        queue_entry.char_cqi = context:character():command_queue_index()
    end
    if context:region() then
        queue_entry.region_key = context:region():name()
    end
    if context:other_faction() then
        queue_entry.other_faction = context:other_faction():name()
    end
    if context:target_character() then
        queue_entry.target_cqi = context:target_character()
    end
    return queue_entry
end


--v function(self: GAME_EVENT_MANAGER, event_object: GAME_EVENT, context: WHATEVER)
function game_event_manager.queue_event(self, event_object, context)
    self:log("Queueing Event: "..event_object.key)
    local queue_entry = self:generate_queue_entry(event_object, context)
    local pos = #self.event_queue+1
    self.queue_map[event_object.key] = pos
    self.event_queue[pos] = queue_entry
    local groups = event_object.groups
    local current_turn = dev.turn()
    for i = 1, #groups do
        local group = groups[i]
        group:OnMemberEventQueued(event_object.key, current_turn)
        local ok, err = pcall(function()
            group.queued_callback(context)
        end) if not ok then 
            self:log("Event "..event_object.key .. " has errored on queue callback given by group: "..group.name)
        end
    end
    if event_object.trigger_kind == "trait_flag" and queue_entry.char_cqi then
        dev.add_trait(context:character(), event_object.key .. "_flag", false, true)
    end
end

--v function(self: GAME_EVENT_MANAGER, main_group: EVENT_CONDITION_GROUP, event_object: GAME_EVENT, event_context: WHATEVER) --> (boolean, string?)
function game_event_manager.can_queue_event(self, main_group, event_object, event_context)
    --self:log("Checking if "..event_object.key.." is queueable")
    if not event_context.game_event_data then
        event_context:add_data(event_object)
    end

    if event_object.trigger_kind == "trait_flag" then
        if not event_context:character() then
            self:log("Event "..event_object.key .. " is a trait_flag event and has no character context provided!")
            return false
        end
        if event_context:character():is_faction_leader() then
            self:log("Event "..event_object.key .. " is a trait_flag event and targets the faction leader. Those don't work!")
            return false
        end
    elseif event_object.trigger_kind == "concatenate_region" then
        if not event_context:region() then
            self:log("Event "..event_object.key .. " is a concatenate_region event and has no region context provided!")
            return false
        end
    elseif event_object.trigger_kind == "concatenate_faction" then
        if not event_context:other_faction() then
            self:log("Event "..event_object.key .. " is a concatenate_faction event and has no region context provided!")
            return false
        end
    end

    local is_own_turn = self.whose_turn == event_context:faction():name()
    local groups_to_check = event_object.groups
    for i = 1, #groups_to_check do
        local group = groups_to_check[i]
        if group ~= main_group then
            if group:is_off_cooldown() then
               if group:has_room_in_queue() then
                    local condition_result = false
                    local ok, err = pcall(function()
                        condition_result = group.queue_time_condition(event_context)
                    end)
                    if not ok then
                        condition_result = false
                        self:log("Event "..event_object.key .. " has errored on conditions given by group: "..group.name)
                        self:log(err)
                    elseif condition_result then
                        self:log("Event "..event_object.key .. " has passed conditions given by group: "..group.name)
                    else
                        self:log("Event "..event_object.key .. " has failed conditions given by group: "..group.name)
                        return false
                    end
                else
                    self:log("Event "..event_object.key .. " cannot fit in queue due to group: "..group.name)
                    return false
                end
            else
                self:log("Event "..event_object.key .. " is on a cooldown given by group: "..group.name)
                return false
            end
        end
    end
    if not main_group:is_off_cooldown() then 
        self:log("Event "..event_object.key .. " is on a cooldown given by its main group")
        return false
    end
    local main_group_result = false --:boolean
    local ok, err = pcall(function()
        main_group_result = main_group.queue_time_condition(event_context)
    end)
    if not ok then
        self:log("Event "..event_object.key .. " has errored on conditions given by group: "..main_group.name)
        self:log(err)
    end
    if main_group_result then
        self:log("Event "..event_object.key .. " has passed the condition given by its main group")
        if main_group:has_room_in_queue() then
            return main_group_result
        elseif main_group.permits_swapping then
            local chance_to_swap_in = main_group:get_swap_chance(event_object.key)
            if dev.chance(chance_to_swap_in) then
                local swap_out = main_group.last_queued_event
                return main_group_result, swap_out 
            else
                self:log("Event "..event_object.key .. " had no room in its main group and failed the swap chance test")
            end
        else
            self:log("Event "..event_object.key .. " had no room in its main group and is not swappable")
        end
    end
    self:log("Event "..event_object.key .. " has failed the condition given by its main group")
    return false
end

--v function(self: GAME_EVENT_MANAGER, event_key_or_object: string|GAME_EVENT, event_context: WHATEVER)
function game_event_manager.force_check_and_queue_event(self, event_key_or_object, event_context)
    local event_object --:GAME_EVENT
    if is_string(event_key_or_object) then
        --# assume event_key_or_object: string
        event_object = self.events[event_key_or_object]
    else
        --# assume event_key_or_object: GAME_EVENT
        event_object = event_key_or_object
    end
    if not event_object then
        self:log("Tried to force check and queue for an event: "..event_object.key.." but this event does not have any registry in the events manager")
    end
    self:log("Script checked event "..event_object.key.." for validity!")
    if self:can_queue_event(event_object.own_group, event_object, event_context) then

        self:queue_event(event_object, event_context)
    end

end

--v function(self: GAME_EVENT_MANAGER, event_key_or_object: string|GAME_EVENT, event_context: WHATEVER) --> boolean
function game_event_manager.force_check_and_trigger_event_immediately(self, event_key_or_object, event_context)
    local event_object --:GAME_EVENT
    if is_string(event_key_or_object) then
        --# assume event_key_or_object: string
        event_object = self.events[event_key_or_object]
    else
        --# assume event_key_or_object: GAME_EVENT
        event_object = event_key_or_object
    end
    if not event_object then
        self:log("Tried to force check and trigger for an event: "..tostring(event_key_or_object).." but this event does not have any registry in the events manager")
        return false
    end
    if event_object:is_dilemma() then
        self:log("WARNING: asked to trigger a dilemma immediately! This is not supported, dilemmas must use the Queue!")
        return false
    end
    if event_object.trigger_kind == "trait_flag" then
        self:log("Error: tried to force check and trigger an event with the trigger kind trait_flag. These events cannot be force triggered.")
        return false
    end
    if self:can_queue_event(event_object.own_group, event_object, event_context) then
        if event_object:is_mission() then
            local queue_entry = self:generate_queue_entry(event_object, event_context)
            self:add_mission_info(event_object.key, queue_entry)
        end
        event_object:trigger(event_context)
        return true
    else
        return false
    end
end

--v function(self: GAME_EVENT_MANAGER, player_faction: CA_FACTION)
function game_event_manager.fire_queued_events(self, player_faction)
    local other_player_events = {} --:vector<QUEUED_GAME_EVENT>
    for i = 1, #self.event_queue do
        local queue_record = self.event_queue[i]
        local event_object = self.events[queue_record.event_key]
        if queue_record.faction_key == player_faction:name() then
            if event_object.trigger_kind ~= "trait_flag" then
                local context = self:build_context_from_queued_event(queue_record)
                self:log("Firing Queued Event: "..event_object.key.." of kind "..event_object.type_group.name)
                if event_object:is_mission() then
                    self:add_mission_info(event_object.key, queue_record)
                end
                event_object:trigger(context)
            else
                if dev.get_character(queue_record.char_cqi) and not dev.get_character(queue_record.char_cqi):is_faction_leader() then
                    self:log("Queued Dilemma: "..event_object.key.." is flagged on character")
                    table.insert(other_player_events, queue_record)
                else
                    self:log("Queued Dilemma: "..event_object.key.." is flagged on a character who is either dead or who has become faction leader, erasing it from queue")
                end
            end
        else
            self:log("Queued Event "..event_object.key.." is for the other human!")
            table.insert(other_player_events, queue_record)
        end
    end
    self.event_queue = {}
    self.queue_map = {}
    for i = 1, #other_player_events do
        local queue_entry = other_player_events[i]
        local pos = #self.event_queue+1
        self.queue_map[queue_entry.event_key] = pos
        self.event_queue[pos] = queue_entry
    end
end

--v function(self: GAME_EVENT_MANAGER, player_faction: CA_FACTION)
function game_event_manager.start_player_turn(self, player_faction)
    --do faction turn start trigger time
    local qt = "FactionTurnStart" --:GAME_EVENT_QUEUE_TIMES
    local scheduled_groups = self.schedule[qt]

    self:log("Checking schedule: "..qt)
    for i = 1, #scheduled_groups do
        local this_group = scheduled_groups[i]
        self:log("Checking group: "..this_group.name)
        for event_key, event_object in pairs(this_group.members) do
            self:log("Checking event: "..event_key)
            local context = self:build_context_for_event(player_faction, event_object)
            local can_queue, displaces_event = self:can_queue_event(this_group, event_object, context)
            if can_queue and displaces_event then
                if self:remove_event_from_queue(displaces_event, true) then
                    self:queue_event(event_object, context)
                end
            elseif can_queue then
                self:queue_event(event_object, context)
            end
        end
    end
    local qt = "MissionTargetGeneratorFactionAtWarWith" --:GAME_EVENT_QUEUE_TIMES
    local scheduled_groups = self.schedule[qt]
    local other_faction_list = player_faction:factions_at_war_with()
    self:log("Checking schedule: "..qt)
    for i = 1, #scheduled_groups do
        local this_group = scheduled_groups[i]
        self:log("Checking group: "..this_group.name)
        for event_key, event_object in pairs(this_group.members) do
            self:log("Checking event: "..event_key)
            for j = 0, other_faction_list:num_items() - 1 do
                local factions_context = self:build_context_for_event(event_object, player_faction, other_faction_list:item_at(j))
                local can_queue, displaces_event = self:can_queue_event(this_group, event_object, factions_context)
                if can_queue and displaces_event then
                    --# assume displaces_event: string
                    if self:remove_event_from_queue(displaces_event, true) then
                        self:log("Displaced Event "..displaces_event)
                        self:queue_event(event_object, factions_context)
                    end
                elseif can_queue then
                    self:queue_event(event_object, factions_context)
                end
            end
        end
    end
    --do region turn start trigger time
    local qt = "RegionTurnStart" --:GAME_EVENT_QUEUE_TIMES
    local scheduled_groups = self.schedule[qt]
    local region_list = player_faction:region_list()
    self:log("Checking schedule: "..qt)
    for i = 1, #scheduled_groups do
        local this_group = scheduled_groups[i]
        self:log("Checking group: "..this_group.name)
        for event_key, event_object in pairs(this_group.members) do
            self:log("Checking event: "..event_key)
            for j = 0, region_list:num_items() - 1 do
                local region_context = self:build_context_for_event(event_object, player_faction, region_list:item_at(j))
                local can_queue, displaces_event = self:can_queue_event(this_group, event_object, region_context)
                if can_queue and displaces_event then
                    --# assume displaces_event: string
                    if self:remove_event_from_queue(displaces_event, true) then
                        self:log("Displaced Event "..displaces_event)
                        self:queue_event(event_object, region_context)
                    end
                elseif can_queue then
                    self:queue_event(event_object, region_context)
                end
            end
        end
    end
    --do character turn start trigger time
    local qt = "CharacterTurnStart" --:GAME_EVENT_QUEUE_TIMES
    local scheduled_groups = self.schedule[qt]
    local character_list = player_faction:character_list()
    self:log("Checking schedule: "..qt)
    for i = 1, #scheduled_groups do
        local this_group = scheduled_groups[i]
        self:log("Checking group: "..this_group.name)
        for event_key, event_object in pairs(this_group.members) do
            self:log("Checking event: "..event_key)
            for j = 0, character_list:num_items() - 1 do
                local character = character_list:item_at(j)
                if dev.is_char_normal(character) then
                    self:log("checking event on char: "..tostring(character:command_queue_index()))
                    local character_context = self:build_context_for_event(event_object, player_faction, character)
                    local can_queue, displaces_event = self:can_queue_event(this_group, event_object, character_context)
                    if can_queue and displaces_event then
                        if self:remove_event_from_queue(displaces_event, true) then
                            self:queue_event(event_object, character_context)
                        end
                    elseif can_queue then
                        self:queue_event(event_object, character_context)
                    end
                end
            end
        end
    end
    self:log("Firing Queue")
    --fire the events waiting in the Queue
    self:fire_queued_events(player_faction)

    --reset the garrison visits cache for the new turn
    self.garrison_visits_cache = {}
    --set whose turn to our faction key so that during-turn dilemmas like settlement visits can run while trait-flagged dilemmas are in queue.
    self.whose_turn = player_faction:name()
end

--v function(self: GAME_EVENT_MANAGER, context: CA_CONTEXT)
function game_event_manager.completed_battle(self, context)
    local players_in_battle = {} --:map<CA_CQI, CA_FACTION>
    local characters_died_in_battle = {} --:map<CA_CQI, {CA_CQI, CA_CQI, string, CA_CQI, string}>
	local attacker_result = cm:model():pending_battle():attacker_battle_result();
    local defender_result = cm:model():pending_battle():defender_battle_result();
    local was_retreat = false --:boolean
    local has_humans = false --:boolean
    if attacker_result == "close_defeat" and defender_result == "close_defeat" then
        was_retreat = true
    end
    for i = 1, cm:pending_battle_cache_num_attackers() do
        local char_cqi, force_cqi, faction_key = cm:pending_battle_cache_get_attacker(i)
        local faction = dev.get_faction(faction_key)
        if dev.get_character(char_cqi) then 
            if faction:is_human() then
                self:log("Found a human with char_cqi "..tostring(char_cqi))    
                players_in_battle[char_cqi] = faction
                has_humans = true
            end
        else
            self:log("Character "..char_cqi.." was returned by the pending battle cache, but no longer exists. They died in battle.")
            local other_char, other_force, other_faction = cm:pending_battle_cache_get_defender(1)
            characters_died_in_battle[char_cqi] = {char_cqi, force_cqi, faction_key, other_char, other_faction}
        end 
    end

    for i = 1, cm:pending_battle_cache_num_defenders() do
        local char_cqi, force_cqi, faction_key = cm:pending_battle_cache_get_defender(i)
        local faction = dev.get_faction(faction_key)
        if dev.get_character(char_cqi) then 
            if faction:is_human() then
                self:log("Found a human with char_cqi "..tostring(char_cqi))
                players_in_battle[char_cqi] = faction
                has_humans = true
            end
        else
            self:log("Character "..char_cqi.." was returned by the pending battle cache, but no longer exists. They died in battle.")
            local other_char, other_force, other_faction = cm:pending_battle_cache_get_attacker(1)
            characters_died_in_battle[char_cqi] = {char_cqi, force_cqi, faction_key, other_char, other_faction}
        end
    end

    if not has_humans then
        return
    end
    local qt = "ShieldwallCharacterCompletedBattle" --:GAME_EVENT_QUEUE_TIMES
    if was_retreat then
        qt = "CharacterRetreatedFromBattle"
    end
    local scheduled_groups = self.schedule[qt]
    self:log("Checking schedule: "..qt)
    for i = 1, #scheduled_groups do
        local this_group = scheduled_groups[i]
        self:log("Checking group: "..this_group.name)
        for event_key, event_object in pairs(this_group.members) do
            for character_cqi, player_faction in pairs(players_in_battle) do
                local character = dev.get_character(character_cqi)
                if (not was_retreat) or dev.did_character_retreat_from_last_battle(character) then
                    local character_context = self:build_context_for_event(event_object, player_faction, character)
                    if dev.is_char_normal_general(character) then
                        local can_queue, displaces_event = self:can_queue_event(this_group, event_object, character_context)
                        if can_queue and displaces_event then
                            if self:remove_event_from_queue(displaces_event, true) then
                                self:queue_event(event_object, character_context)
                            end
                        elseif can_queue then
                            self:queue_event(event_object, character_context)
                        end
                    end   
                end
            end
        end
    end
    for _, pb_cache in pairs(characters_died_in_battle) do
        local char_cqi, force_cqi, faction_key = pb_cache[1], pb_cache[2], pb_cache[3]
        local force = cm:model():military_force_for_command_queue_index(force_cqi)
        local faction = dev.get_faction(faction_key)
        dev.eh:trigger_event("MilitaryForceCommanderDiesInBattle", force, faction, char_cqi)
    end
    self:log("Firing Queue")
    for character_cqi, player_faction in pairs(players_in_battle) do
        --fire the events waiting in the Queue
        self:fire_queued_events(player_faction)
    end
end

--v function(self: GAME_EVENT_MANAGER, character: CA_CHAR, region: CA_REGION)
function game_event_manager.player_character_entered_garrison(self, character, region)
    --prevent doubling up events
    if self.garrison_visits_cache[region:name()] then
        if self.garrison_visits_cache[region:name()][character:command_queue_index()] then
            return
        else
            self.garrison_visits_cache[region:name()][character:command_queue_index()] = true
        end
    else
        self.garrison_visits_cache[region:name()] = {}
        self.garrison_visits_cache[region:name()][character:command_queue_index()] = true
    end

    local qt = "CharacterEntersGarrison" --:GAME_EVENT_QUEUE_TIMES
    local scheduled_groups = self.schedule[qt]
    local player_faction = character:faction()
    self:log("Checking schedule: "..qt)
    for i = 1, #scheduled_groups do
        local this_group = scheduled_groups[i]
        self:log("Checking group: "..this_group.name)
        for event_key, event_object in pairs(this_group.members) do
            local character_context = self:build_context_for_event(event_object, player_faction, character, region)
            if dev.is_char_normal_general(character) then
                local can_queue, displaces_event = self:can_queue_event(this_group, event_object, character_context)
                if can_queue and displaces_event then
                    if self:remove_event_from_queue(displaces_event, true) then
                        self:queue_event(event_object, character_context)
                    end
                elseif can_queue then
                    self:queue_event(event_object, character_context)
                end
            end   
        end
    end
    self:log("Firing Queue")
    self:fire_queued_events(player_faction)
end

--v function(self: GAME_EVENT_MANAGER) --> boolean
function game_event_manager.can_queue_dilemma(self)
    local dilemma = self.condition_groups["dilemma"]
    if not dilemma then
        self:log("asked if a dilemma could be queued, but dilemma isn't set up?!")
        return false
    end
    return dilemma:has_room_in_queue() and dilemma:is_off_cooldown()
end

--v function(self: GAME_EVENT_MANAGER) --> boolean
function game_event_manager.can_queue_mission(self)
    local mission = self.condition_groups["mission"]
    if not mission then
        self:log("asked if a mission could be queued, but mission isn't set up?!")
        return false
    end
    return mission:has_room_in_queue() and mission:is_off_cooldown()
end

local active_manager = nil --:GAME_EVENT_MANAGER
--v function() --> GAME_EVENT_MANAGER
local function initialize_game_events()
    --init objects
    game_event.init(condition_group.new)
    active_manager = game_event_manager.new()
    --create basic groups
    local dilemma = condition_group.new("dilemma", active_manager)
    dilemma:set_number_allowed_in_queue(1)
    --dilemma.cooldown = 1
    dilemma.ignore_queue_room_during_own_turn = true
    active_manager:register_condition_group(dilemma)

    local mission = condition_group.new("mission", active_manager)
    mission.queue_time_condition = function(context)
        local game_event = context:game_event() --:GAME_EVENT
        local mission_info = game_event:mission()
        return (not mission_info.is_active) 
    end

    mission:set_number_allowed_in_queue(1)
    --mission.cooldown = 1
    active_manager:register_condition_group(mission)

    local incident = condition_group.new("incident", active_manager)
    active_manager:register_condition_group(incident)
    dev.first_tick(function(context)
        dev.eh:add_listener(
            "EventsCore",
            "FactionBeginTurnPhaseNormal",
            function(context)
                return context:faction():is_human()
            end,
            function(context)
                active_manager:log(tostring(dilemma.currently_in_queue).." currently in the queue.")
                active_manager:start_player_turn(context:faction())
            end,
            true
        )
        active_manager.whose_turn = cm:model():world():whose_turn_is_it():name()
        dev.eh:add_listener(
            "EventsCore",
            "FactionTurnEnd",
            function(context)
                return context:faction():is_human()
            end,
            function(context)
                active_manager.whose_turn = ""
            end,
            true
        )
        dev.eh:add_listener(
            "EventsCore",
            "PendingBattle",
            function(context)
                return context:pending_battle():has_contested_garrison()
            end,
            function(context)       
                local garrison = context:pending_battle():contested_garrison() --:CA_GARRISON_RESIDENCE
                local attacker = context:pending_battle():attacker() --:CA_CHAR
                active_manager:log("Pending battle has contested garrison: locking visit evens for "..garrison:region():name())
                active_manager.block_visit_events[garrison:region():name()] = attacker:command_queue_index()
            end,
            true
        )
        dev.eh:add_listener(
            "EventsCore",
            "BattleCompleted",
            true,
            function(context)
                active_manager:completed_battle(context)
            end,
            true
        )
        dev.eh:add_listener(
            "EventsCore",
            "ShieldwallCharacterCompletedBattle",
            function(context)
                local character = context:character() --:CA_CHAR
                return not character:won_battle()
            end,
            function(context)
                local character = context:character() --:CA_CHAR
                for region, cqi in pairs(active_manager.block_visit_events) do
                    if cqi == character:command_queue_index() then
                        active_manager.block_visit_events[region] = nil
                    end
                end
            end,
            true
        )
        dev.eh:add_listener(
            "EventsCore",
            "CharacterEntersGarrison",
            function(context)
                return context:character():faction():is_human()
            end,
            function(context)
                local character = context:character() --:CA_CHAR
                local region = context:garrison_residence():region() --:CA_REGION
                if not active_manager.block_visit_events[region:name()] then
                    active_manager:player_character_entered_garrison(character, region)
                end
            end,
            true
        )
        dev.eh:add_listener(
            "EventsCore",
            "CharacterLeavesGarrison",
            function(context)
                local region = context:garrison_residence():region() --:CA_REGION
                return not not active_manager.block_visit_events[region:name()]
            end,
            function(context)
                local region = context:garrison_residence():region() --:CA_REGION
                active_manager:log("re-enabled visit events for "..region:name())
                active_manager.block_visit_events[region:name()] = nil    
            end,
            true
        )
        dev.eh:add_listener(
            "EventsCore",
            "DilemmaChoiceMadeEvent",
            true,
            function(context)
                local key = context:dilemma() --:string
                if active_manager.events[key] and active_manager.events[key].trigger_kind == "trait_flag" then
                    local queued_event = active_manager:get_event_from_queue(key)
                    if queued_event then
                        local event_context = active_manager:build_context_from_queued_event(queued_event)
                        event_context.choice_data = context:choice()
                        if event_context then
                            active_manager.events[key].last_choice_made = context:choice()
                            active_manager.events[key]:trigger(event_context)
                            local ok = active_manager:remove_event_from_queue(key, false)
                            if not ok then
                                active_manager:log("Failed to remove flagged dilemma "..key.." from the Queue after it fired!")
                            end
                        end
                    end
                end
            end,
            true)
        dev.eh:add_listener(
            "EventsCore",
            "TraitsClearedFromFactionLeader",
            function(context)
                return context:character():is_human()
            end,
            function(context)
                local new_faction_leader = context:character() --:CA_CHAR
                for i = 1, #active_manager.event_queue do
                    local queue_record = active_manager.event_queue[i]
                    local event_object = active_manager.events[queue_record.event_key]
                    if event_object.trigger_kind == "trait_flag" then
                        local character = dev.get_character(queue_record.char_cqi)
                        if character and character:command_queue_index() == new_faction_leader:command_queue_index() then
                            active_manager:remove_event_from_queue(queue_record.event_key, true)
                        end
                    end
                end
            end,
            true
        )
    end)
    return active_manager
end


return initialize_game_events()
