local game_mission = {} --# assume game_mission: GAME_MISSION


--v function(manager: GAME_EVENT_MANAGER, key: string, trigger_type: GAME_EVENT_TRIGGER_KIND) --> GAME_MISSION
function game_mission.new(manager, key, trigger_type)
    local self = {}
    setmetatable(self, {
        __index = game_mission
    })--# assume self: GAME_MISSION

    self.key = key
    self.manager = manager
    self.trigger_type = trigger_type
    self.is_active = false --:boolean
    self.is_complete = false --:boolean
    self.did_succeed = false --:boolean
    self.turn_activated = 0
    self.turn_completed = 0
    self.completion_events = {} --:vector<string>
    self.completion_conditions = {} --:map<string, function(context: WHATEVER) --> (boolean, boolean)>

    self.completion_callback = function(context) end --:function(context: WHATEVER)
    self.mission_success_callback = function(context) end --:function(context: WHATEVER)
    self.mission_failure_callback = function(context) end --:function(context: WHATEVER)

    self.stored_context = nil --:WHATEVER

    self.save = {
        name = "GameMission"..key, 
        for_save = {"is_active", "is_complete", "turn_activated", "turn_completed", "did_succeed"}
    }--:SAVE_SCHEMA
    dev.Save.attach_to_object(self)
    if self.is_active then
        self.manager:log("Mission ["..self.key.."] is active after loading game!")
    end
    return self

end

--v function(self: GAME_MISSION) --> boolean
function game_mission.was_successful(self)
    if self.is_active == true then
        self.manager:log("Asked if mission ["..self.key.."] was successful, but that mission is currently active!")
        return false
    end
    if self.is_complete == false then
        self.manager:log("Asked if mission ["..self.key.."] was successful, but that mission isn't complete!")
    end
    return self.did_succeed 
end

--v function(self: GAME_MISSION) --> WHATEVER
function game_mission.context(self)
    if self.is_active == false then
        self.manager:log("Asked for mission context for "..self.key.." which is not an active mission right now!")
        return nil
    end
    if self.stored_context == nil then
        local mission_info = self.manager:get_mission_info(self.key)
        self.stored_context = self.manager:build_context_from_queued_event(mission_info)
    end
    return self.stored_context 
end



--v function(self: GAME_MISSION, context: WHATEVER, is_success: boolean)
function game_mission.complete_mission(self, context, is_success)
    self.manager:log("Mission "..self.key.." was completed by "..context:faction():name())
    self.is_complete = true
    self.turn_completed = dev.turn()
    self.is_active = false
    self.did_succeed = is_success
    local in_game_key = self.key
    if self.trigger_type == "concatenate_region" then
        in_game_key = in_game_key .. context:region():name()
        self.manager:log("Mission was concatenate_region type, key is "..in_game_key)
    elseif self.trigger_type == "concatenate_faction" then
        in_game_key = in_game_key .. context:other_faction():name()
        self.manager:log("Mission was concatenate_faction type, key is "..in_game_key)
    else
        self.manager:log("Mission was "..self.trigger_type.." type, key is "..in_game_key)
    end

    cm:override_mission_succeeded_status(context:faction():name(), in_game_key, is_success)
    self.completion_callback(context)
    if is_success then
        self.mission_success_callback(context)
    else
        self.mission_failure_callback(context)
    end
    for i = 1, #self.completion_events do
        local event = self.completion_events[i]
        dev.eh:remove_listener(event..self.key.."MissionListener")
    end
    self.manager:remove_mission_info(self.key)
    local event_object = context:game_event()
    --# assume event_object: {key: string, groups: vector<EVENT_CONDITION_GROUP>}
    for i = 1, #event_object.groups do
        local this_group = event_object.groups[i]
        if this_group.use_mission_cooldown_mode then
            this_group:OnMemberMissionCompleted(event_object.key, self.turn_completed)
        end
    end
end

--v function(self: GAME_MISSION)
function game_mission.add_completion_listeners(self)
    for i = 1, #self.completion_events do
        local event = self.completion_events[i]
        dev.eh:add_listener(
            event..self.key.."MissionListener",
            event,
            function(context)
                return self.is_active
            end,
            function(context)
                self.manager:log("Evaluating mission completion condition for "..self.key.." on event "..event)
                local completion_condition = self.completion_conditions[event]
                local is_complete, is_success = completion_condition(context)
                self.manager:log("Mission is complete: "..tostring(is_complete)..". Mission is success: "..tostring(is_success))
                if is_complete then
                    self:complete_mission(self:context(), is_success)
                end
            end,
            true)
    end
end

--v function(self: GAME_MISSION, condition_event: string, condition: function(context: WHATEVER) --> (boolean, boolean))
function game_mission.add_completion_condition(self, condition_event, condition)
    if not self.completion_conditions[condition_event] then
        self.completion_events[#self.completion_events+1] = condition_event 
        self.completion_conditions[condition_event] = condition
        if self.is_active then
            self.manager:log("completion condition for "..self.key.." on event "..condition_event.." is being listened immediately because the event is active")
            dev.eh:add_listener(
                condition_event..self.key.."MissionListener",
                condition_event,
                function(context)
                    return self.is_active
                end,
                function(context)
                    self.manager:log("Evaluating mission completion condition for "..self.key.." on event "..condition_event)
                    local is_complete, is_success = condition(context)
                    self.manager:log("Mission is complete: "..tostring(is_complete)..". Mission is success: "..tostring(is_success))
                    if is_complete then
                        self:complete_mission(self:context(), is_success)
                    end
                end,
                true)
        end
    else
        self.manager:log("Could not add a mission completion event to ["..self.key.."] because a condition already exists for the event ["..condition_event.."]")
    end
end

--v function(self: GAME_MISSION, callback: function(context: WHATEVER))
function game_mission.add_mission_complete_callback(self, callback)
    self.completion_callback = callback
end

--v function(self: GAME_MISSION, callback: function(context: WHATEVER))
function game_mission.add_mission_success_callback(self, callback)
    self.mission_success_callback = callback
end

--v function(self: GAME_MISSION, callback: function(context: WHATEVER))
function game_mission.add_mission_failure_callback(self, callback)
    self.mission_failure_callback = callback
end




--v function(self: GAME_MISSION, context: WHATEVER)
function game_mission.activate(self, context)
    self.is_active = true
    self.turn_activated = dev.turn()
    self:add_completion_listeners()
end

return {
    new = game_mission.new
}