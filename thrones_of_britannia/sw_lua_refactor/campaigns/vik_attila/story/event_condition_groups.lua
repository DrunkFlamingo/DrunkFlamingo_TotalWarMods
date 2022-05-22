--how many events can be triggered from this group?
--chance formula
local condition_group = {} --# assume condition_group: EVENT_CONDITION_GROUP

--v function(name: string, manager: GAME_EVENT_MANAGER, num_allowed_in_queue: int?, use_mission_cooldown_mode: boolean?) --> EVENT_CONDITION_GROUP
function condition_group.new(name, manager, num_allowed_in_queue, use_mission_cooldown_mode)
    local self = {}
    setmetatable(self, {
        __index = condition_group
    }) --# assume self: EVENT_CONDITION_GROUP

    self.name = name
    self.manager = manager
    self.members = {} --:map<string, GAME_EVENT>

    self.last_turn_occured = -10000
    self.last_turn_completed = -1
    self.use_mission_cooldown_mode = not not use_mission_cooldown_mode

    --flags how many currently in queue, and how many allowed in queue.
    self.num_allowed_queued = num_allowed_in_queue or 0
    self.currently_in_queue = 0
    self.ignore_queue_room_during_own_turn = false --:boolean
    self.last_queued_event = "" --:string 

    --allows for controlling a shared cooldown for a group of events.
    self.cooldown = 0
    self.is_unique = false
    
    --swapouts
    --allows for setting an event which cannot queue due to violation of num_allowed_queued for this group to roll for a chance to displace the currently queued event.
    self.permits_swapping = false --:boolean
    self.swap_custom_chances = {} --:map<string, int>

    --queue time conditons
    --allows events in the same group to share conditions for queue time.
    self.queue_time_condition = function(context) return true end --:function(context: WHATEVER) --> boolean
    self.queued_callback = function(context) end --:function(context: WHATEVER)
    self.unqueued_callback = function(context) end --:function(context: WHATEVER)

    self.callback = function(context) end --:function(context: WHATEVER)

    self.save = {
        name = "event_condition_group_"..name, 
        for_save = {"last_turn_occured", "last_queued_event", "currently_in_queue", "last_turn_completed"}
    }--:SAVE_SCHEMA
    dev.Save.attach_to_object(self)
    return self
end

--queries
--v function(self: EVENT_CONDITION_GROUP) --> boolean
function condition_group.is_off_cooldown(self)
    if self.is_unique then
        return self.last_turn_occured < 0
    end
    if self.use_mission_cooldown_mode then
        return self.cooldown == 0 or dev.turn() > self.last_turn_completed + self.cooldown
    end
    return self.cooldown == 0 or dev.turn() > self.last_turn_occured + self.cooldown
end

--v function(self: EVENT_CONDITION_GROUP) --> boolean
function condition_group.has_room_in_queue(self)
    if self.ignore_queue_room_during_own_turn and self.manager.whose_turn ~= "" then
        if cm:model():world():whose_turn_is_it():name() == self.manager.whose_turn then
            self.manager:log("Group "..self.name.." has is ignoring queue room because this schedule is during the faction's turn!")
            return true
        end
    end
    return self.num_allowed_queued == 0 or self.currently_in_queue < self.num_allowed_queued
end

--v function(self: EVENT_CONDITION_GROUP, event_key: string) --> int
function condition_group.get_swap_chance(self, event_key)
    return self.swap_custom_chances[event_key] or 50
end

--mods
--v [NO_CHECK] function(self: EVENT_CONDITION_GROUP, event: GAME_EVENT)
function condition_group.add_event(self, event)
    self.members[event.key] = event
end

--v function(self: EVENT_CONDITION_GROUP)
function condition_group.enable_swapping(self)
    self.permits_swapping = true
end

--v function(self: EVENT_CONDITION_GROUP, cooldown: int)
function condition_group.set_cooldown(self, cooldown)
    self.cooldown = cooldown
end

--v function(self: EVENT_CONDITION_GROUP, is_unique: boolean)
function condition_group.set_unique(self, is_unique)
    self.is_unique = is_unique
    if self.num_allowed_queued == 0 then
        self.num_allowed_queued = 1
    end
end

--v function(self: EVENT_CONDITION_GROUP, num_allowed: int)
function condition_group.set_number_allowed_in_queue(self, num_allowed)
    self.num_allowed_queued = num_allowed
end

--v function(self: EVENT_CONDITION_GROUP, callback: function(context: WHATEVER))
function condition_group.add_callback(self, callback)
    self.callback  = callback
end

--v function(self: EVENT_CONDITION_GROUP, callback: function(context: WHATEVER))
function condition_group.add_callback_on_queue(self, callback)
    self.queued_callback  = callback
end

--v function(self: EVENT_CONDITION_GROUP, callback: function(context: WHATEVER))
function condition_group.add_callback_on_unqueue(self, callback)
    self.unqueued_callback  = callback
end


--v function(self: EVENT_CONDITION_GROUP, condition: (function(context: WHATEVER) --> boolean))
function condition_group.add_queue_time_condition(self, condition)
    self.queue_time_condition = condition
end

--system
--v function(self: EVENT_CONDITION_GROUP, event: string,turn: int)
function condition_group.OnMemberEventQueued(self, event, turn)

    self.currently_in_queue = self.currently_in_queue + 1
    self.manager:log("Group "..self.name.." has "..self.currently_in_queue.." events in Queue!")
    self.last_queued_event = event
end

--v function(self: EVENT_CONDITION_GROUP, event: string, turn: int)
function condition_group.OnMemberEventRemovedFromQueue(self, event, turn)
    self.currently_in_queue = self.currently_in_queue - 1
    if self.last_queued_event == event then
        self.last_queued_event = ""
    end
end

--v function(self: EVENT_CONDITION_GROUP, event: string, turn: int)
function condition_group.OnMemberEventOccured(self, event, turn)
    self.currently_in_queue = self.currently_in_queue - 1
    if self.last_queued_event == event then
        self.last_queued_event = ""
    end
    self.last_turn_occured = turn
end

--v function(self: EVENT_CONDITION_GROUP, event: string, turn: int)
function condition_group.OnMemberMissionCompleted(self, event, turn)
    self.last_turn_completed = turn
end

return {
    new = condition_group.new
}