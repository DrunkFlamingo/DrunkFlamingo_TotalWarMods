local game_event = {} --# assume game_event: GAME_EVENT

local game_mission = require("story/mission")

local callback_by_type = {
    incident = function()
        return dev.respond_to_incident
    end,
    dilemma = function()
        return dev.respond_to_dilemma
    end,
    mission = function()
        return dev.respond_to_mission_issued
    end
} --:map<string, function() --> (function(event_key: string, callback: function(context: WHATEVER)))>


local game_interface_by_type = {
    incident = function(faction_key, --:string
        event_key) --:string
        cm:trigger_incident(faction_key, event_key, true)
    end,
    dilemma = function(faction_key, --:string
        event_key) --:string 
        cm:trigger_dilemma(faction_key, event_key, true)
    end,
    mission = function(faction_key, --:string
        event_key) --:string 
        cm:trigger_mission(faction_key, event_key, true)
    end
} --:map<string, function(faction_key: string, event_key: string)>

local condition_contructor = nil --:function(string, GAME_EVENT_MANAGER, int?, bool?) --> EVENT_CONDITION_GROUP


--v function(manager: GAME_EVENT_MANAGER, key: string, type_group: EVENT_CONDITION_GROUP, trigger_kind: GAME_EVENT_TRIGGER_KIND) --> GAME_EVENT
function game_event.new(manager, key, type_group, trigger_kind)
    local self = {}
    setmetatable(self, {
        __index = game_event
    }) --# assume self: GAME_EVENT
    self.manager = manager
    self.key = key
    self.event_type = type_group.name
    self.type_group = type_group
    self.trigger_kind = trigger_kind
    self.context_data = "shieldwall_game_event"
    if not condition_contructor then
        self.manager:log("NO CONDITION CONSTRUCTOR FOUND")
    end
    local limit --:int
    if self.trigger_kind == "standard" then
        limit = 1
    end
    self.own_group = condition_contructor(key, manager, limit, self.event_type == "mission")
    self.own_group:add_event(self)
    self.manager:register_condition_group(self.own_group)
    self.mission_detail = nil --:GAME_MISSION
    if self.event_type == "mission" then
        self.mission_detail = game_mission.new(self.manager, self.key, trigger_kind)
    end
    self.last_choice_made = 0
    self.groups = {
        type_group,
        self.own_group
    } --:vector<EVENT_CONDITION_GROUP>
    if self.event_type == "dilemma" then
        self.save = {
            name = "Dilemma"..key, 
            for_save = {"last_choice_made"}
        }--:SAVE_SCHEMA
        dev.Save.attach_to_object(self)
    end
    return self
end

--queries
--v function(self: GAME_EVENT) --> boolean
function game_event.is_off_cooldown(self)
    if self.own_group.is_unique then
        return self.own_group.last_turn_occured < 0
    end
    return self.own_group.cooldown == 0 or dev.turn() > self.own_group.last_turn_occured + self.own_group.cooldown
end

--v function(self: GAME_EVENT) --> boolean
function game_event.has_occured(self)
    return self.own_group.last_turn_occured > 0
end

--v function(self: GAME_EVENT) --> int
function game_event.last_turn_occured(self)
    return self.own_group.last_turn_occured
end

--v function(self: GAME_EVENT) --> boolean
function game_event.is_incident(self)
    return self.event_type == "incident"
end

--v function(self: GAME_EVENT) --> boolean
function game_event.is_dilemma(self)
    return self.event_type == "dilemma"
end

--v function(self: GAME_EVENT) --> int
function game_event.choice(self)
    return self.last_choice_made
end

--v function(self: GAME_EVENT) --> boolean
function game_event.is_mission(self)
    return self.event_type == "mission"
end

--v function(self: GAME_EVENT) --> GAME_MISSION
function game_event.mission(self)
    if not self:is_mission() then
        self.manager:log("Asked for mission details for "..self.key.." but this event is not a mission!")
    end
    return self.mission_detail
end

--v function(self: GAME_EVENT) --> boolean
function game_event.is_active(self)
    if not self:is_mission() then
        self.manager:log("Asked for mission details for "..self.key.." but this event is not a mission!")
    end
    return self.mission_detail.is_active
end
--mods



--v function(self: GAME_EVENT, group_name: string)
function game_event.join_group(self, group_name)
    local group = self.manager.condition_groups[group_name]
    if not group then
        self.manager:log("Attempted to add "..self.key.." to event group: ".. group_name .." which does not exist!")
        return
    end
    dev.insert(self.groups, #self.groups+1, group)
    self.manager:log("Added "..self.key.. " to group "..group_name)
    group:add_event(self)
end

--v function(self: GAME_EVENT, ...: string)
function game_event.join_groups(self, ...)
    for i = 1, arg.n do
        self:join_group(arg[i])
    end
end

--v function(self: GAME_EVENT, schedule: GAME_EVENT_QUEUE_TIMES)
function game_event.schedule(self, schedule)
    self.manager:schedule_condition_group(self.own_group, schedule)
end

--v function(self: GAME_EVENT, condition: (function(context: WHATEVER) --> boolean))
function game_event.add_queue_time_condition(self, condition)
    self.own_group.queue_time_condition = condition
end

--v function(self: GAME_EVENT, callback: function(context: WHATEVER))
function game_event.add_callback(self, callback)
    self.own_group.callback  = callback
end

--v function(self: GAME_EVENT, callback: function(context: WHATEVER))
function game_event.add_callback_on_queue(self, callback)
    self.own_group.queued_callback  = callback
end

--v function(self: GAME_EVENT, callback: function(context: WHATEVER))
function game_event.add_callback_on_unqueue(self, callback)
    self.own_group.unqueued_callback  = callback
end


--v function(self: GAME_EVENT, cooldown: int)
function game_event.set_cooldown(self, cooldown)
    self.own_group.cooldown = cooldown
end

--v function(self: GAME_EVENT, is_unique: boolean)
function game_event.set_unique(self, is_unique)
    self.own_group:set_unique(is_unique)
end


--v function(self: GAME_EVENT, num_allowed: int)
function game_event.set_number_allowed_in_queue(self, num_allowed)
    self.own_group.num_allowed_queued = num_allowed
end

--v function(self: GAME_EVENT, condition_event: string, condition: function(context: WHATEVER) --> (boolean, boolean))
function game_event.add_completion_condition(self, condition_event, condition)
    if not self:is_mission() then
        self.manager:log("Tried to add completion conditions for "..self.key.." but this event is not a mission!")
        return
    end
    self:mission():add_completion_condition(condition_event, condition)
end

--v function(self: GAME_EVENT, callback: function(context: WHATEVER))
function game_event.add_mission_complete_callback(self, callback)
    self.mission_detail.completion_callback = callback
end

--v function(self: GAME_EVENT, callback: function(context: WHATEVER))
function game_event.add_mission_success_callback(self, callback)
    self.mission_detail.mission_success_callback = callback
end

--v function(self: GAME_EVENT, callback: function(context: WHATEVER))
function game_event.add_mission_failure_callback(self, callback)
    self.mission_detail.mission_failure_callback = callback
end



--system

local trigger_by_kind = {
    standard = function(event_object, --:GAME_EVENT
        custom_event_context) --:WHATEVER

        local turn = dev.turn()
        callback_by_type[event_object.event_type]()(event_object.key, function(context) 
            if event_object.event_type == "dilemma" then
                custom_event_context.choice_data = context:choice()
                event_object.last_choice_made = context:choice()
            end
            for i = 1, #event_object.groups do
                event_object.groups[i]:OnMemberEventOccured(event_object.key, turn)
            end
            for i = 1, #event_object.groups do
                event_object.groups[i].callback(custom_event_context) 
            end 
        end)
        game_interface_by_type[event_object.event_type](custom_event_context:faction():name(), event_object.key)
    end,
    concatenate_region = function(event_object, --:GAME_EVENT
        custom_event_context) --:WHATEVER
        local actual_event_key = event_object.key .. custom_event_context:region():name()
        event_object.manager:log("Concatenated region to build key: "..actual_event_key)
        local turn = dev.turn()
        --[[dev.log("DEBUG:")
        for k, v in pairs(custom_event_context) do
            dev.log("context has data on "..k)
        end--]]
        callback_by_type[event_object.event_type]()(actual_event_key, function(context)
            if event_object.event_type == "dilemma" then
                custom_event_context.choice_data = context:choice()
                event_object.last_choice_made = context:choice()
            end
            for i = 1, #event_object.groups do
                event_object.groups[i]:OnMemberEventOccured(event_object.key, turn)
            end
            for i = 1, #event_object.groups do
                event_object.groups[i].callback(custom_event_context) 
            end 
        end)
        game_interface_by_type[event_object.event_type](custom_event_context:faction():name(), actual_event_key)
    end,
    concatenate_faction = function(event_object, --:GAME_EVENT
        custom_event_context) --:WHATEVER
        local actual_event_key
        actual_event_key = event_object.key .. custom_event_context:other_faction():name()
        event_object.manager:log("Concatenated faction to build key: "..actual_event_key)
        local turn = dev.turn()
        callback_by_type[event_object.event_type]()(actual_event_key, function(context)
            if event_object.event_type == "dilemma" then
                custom_event_context.choice_data = context:choice()
                event_object.last_choice_made = context:choice()
            end
            for i = 1, #event_object.groups do
                event_object.groups[i]:OnMemberEventOccured(event_object.key, turn)
            end
            for i = 1, #event_object.groups do
                event_object.groups[i].callback(custom_event_context) 
            end 
        end)
        game_interface_by_type[event_object.event_type](custom_event_context:faction():name(), actual_event_key)
    end,
    trait_flag = function(event_object, --:GAME_EVENT
        custom_event_context) --:WHATEVER
        local turn = dev.turn()
        for i = 1, #event_object.groups do
            event_object.groups[i]:OnMemberEventOccured(event_object.key, turn)
        end
        for i = 1, #event_object.groups do
            event_object.groups[i].callback(custom_event_context) 
        end 
    end
} --:map<GAME_EVENT_TRIGGER_KIND, function(event_object: GAME_EVENT, custom_event_context: WHATEVER)>

--v function(self: GAME_EVENT, custom_event_context: WHATEVER)
function game_event.trigger(self, custom_event_context)
    if trigger_by_kind[self.trigger_kind] then
        self.manager:log("Triggering event: "..self.key)
        trigger_by_kind[self.trigger_kind](self, custom_event_context)
        if self:is_mission() then
            self:mission():activate(custom_event_context)
        end
    else
        self.manager:log("WARNING: no trigger kind for event "..self.key)
    end
end

--v function(event_condition_group_prototype: function(string, GAME_EVENT_MANAGER, int?, bool?) --> EVENT_CONDITION_GROUP)
local function init(event_condition_group_prototype)
    condition_contructor = event_condition_group_prototype
end

return {
    init = init,
    new = game_event.new
}