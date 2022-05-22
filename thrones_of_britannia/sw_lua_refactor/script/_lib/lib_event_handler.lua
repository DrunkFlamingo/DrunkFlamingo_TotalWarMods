should_log_eh = false

-------------------------------------------------------
-------------------------------------------------------
--	EVENT HANDLER
-------------------------------------------------------
-------------------------------------------------------

__event_handler = nil;



event_handler = {
	add_func = nil,
	attached_events = {},
	listeners = {}
};

function event_handler:new(new_add_func)
	if is_eventhandler(__event_handler) then
		return __event_handler;
	end;
	
	if not is_function(new_add_func) then
		script_error("ERROR: event_handler:new() called but supplied parameter is not a function!");
		return false;
	end;
	
	local eh = {
		add_func = new_add_func,
		attached_events = {},
		listeners = {}
	}
	
	setmetatable(eh, self);
	self.__index = self;
	self.__tostring = function() return TYPE_EVENT_HANDLER end;
	
	-- cleanup events after we shut down
	if __game_mode == __lib_type_campaign then
		-- campaign
		-- add_campaign_cleanup_action(function() ClearEventCallbacks() end);
	elseif __game_mode == __lib_type_battle then
		-- battle
		get_bm():register_phase_change_callback("Complete", function() ClearEventCallbacks() end);
	end;
	
	__event_handler = eh;
	
	return eh;
end;


function get_eh()
	if is_eventhandler(__event_handler) then
		return __event_handler;
	end;
end;



function event_handler:add_listener(new_name, new_event, new_condition, new_callback, new_persistent)
	if not is_string(new_name) then
		script_error("ERROR: event_handler:add_listener() called but name given [" .. tostring(new_name) .. "] is not a string");
		return false;
	end;
	
	if not is_string(new_event) then
		script_error("ERROR: event_handler:add_listener() called but event given [" .. tostring(new_event) .. "] is not a string");
		return false;
	end;
	
	if not is_function(new_condition) and not (is_boolean(new_condition) and new_condition == true) then
		script_error("ERROR: event_handler:add_listener() called but condition given [" .. tostring(new_condition) .. "] is not a function or true");
		return false;
	end;
	
	if not is_function(new_callback) then
		script_error("ERROR: event_handler:add_listener() called but callback given [" .. tostring(new_callback) .. "] is not a function");
		return false;
	end;
	
	local new_persistent = new_persistent or false;
	
	-- attach to the event if we're not already
	self:attach_to_event(new_event);
	
	local new_listener = {
		name = new_name,
		event = new_event,
		condition = new_condition,
		callback = new_callback,
		persistent = new_persistent,
		to_remove = false
	};
		
	table.insert(self.listeners, new_listener);	
end;


function event_handler:attach_to_event(eventname)

	for i = 1, #self.attached_events do
		if self.attached_events[i].name == eventname then
			-- we're already attached
			return;
		end;
	end;
		
	-- we're not attached
	local event_to_attach = {
		name = eventname,
		callback = function(context) self:event_callback(eventname, context) end
	};
	
	self:register_event(eventname);
	
	self.add_func(eventname, function(context) event_to_attach.callback(context) end);
	
	table.insert(self.attached_events, event_to_attach);
end;



function event_handler:event_callback(eventname, context)	
	-- self:list_events();
	
	-- make a list of callbacks to fire and listeners to remove. We can't call the callbacks whilst
	-- processing the list because the callbacks may alter the list length, and we can't rescan because
	-- this will continually hit persistent callbacks
	local callbacks_to_call = {};
	local listeners_to_remove = {};
	
	for i = 1, #self.listeners do
		local current_listener = self.listeners[i];
		
		if current_listener.event == eventname and (is_boolean(current_listener.condition) or current_listener.condition(context)) then
			table.insert(callbacks_to_call, current_listener.callback);
			
			if not current_listener.persistent then
				-- store this listener to be removed post-list
				current_listener.to_remove = true;
			end;
		end;
	end;
	
	-- clean out all the listeners that have been marked for removal
	self:clean_listeners();
	
	for i = 1, #callbacks_to_call do
		callbacks_to_call[i](context);
	end;
end;


-- go through all the listeners and remove those with the to_remove flag set
function event_handler:clean_listeners()
	for i = 1, #self.listeners do
		if self.listeners[i].to_remove then
			table.remove(self.listeners, i);
			-- restart
			self:clean_listeners();
			return;
		end;
	end;
end;


function event_handler:remove_listener(name_to_remove, start_point)
	local start_point = start_point or 1;
	
	-- print("eh:remove_listener(" .. tostring(name_to_remove) .. ", " .. tostring(start_point) .. ") called. #self.listeners is " .. tostring(#self.listeners));

	for i = start_point, #self.listeners do
		-- print("\tchecking listener " .. i);
		-- print("\t\tlistener name is " .. self.listeners[i].name);
		if self.listeners[i].name == name_to_remove then
			table.remove(self.listeners, i);
			--rescan
			self:remove_listener(name_to_remove, i);
			return;
		end;
	end;
end;



function event_handler:list_events()
	print("**************************************");
	print("**************************************");
	print("**************************************");
	print("Event Handler attached events");
	print("**************************************");
	
	local attached_events = self.attached_events;
	for i = 1, #attached_events do
		print(i .. "\tname:\t\t" .. attached_events[i].name .. "\tcallback:" .. tostring(attached_events[i].callback));
	end;
	print("**************************************");
	print("Event Handler listeners");
	print("**************************************");
	
	local listeners = self.listeners;
	for i = 1, #listeners do
		local l = listeners[i];
		print(i .. ":\tname:" .. tostring(l.name) .. "\tevent:" .. tostring(l.event) .. "\tcondition:" .. tostring(l.condition) .. "\tcallback:" .. tostring(l.callback) .. "\tpersistent:" .. tostring(l.persistent));
	end;
	print("**************************************");
end;



function event_handler:register_event(event)
	if not events[event] then
		events[event] = {};
	end;
end;




function event_handler:trigger_event(event, ...)
	
	-- build an event context
	local context = custom_context:new();
	
	for i = 1, arg.n do
		local current_obj = arg[i];
	
		-- if this is a proper context object, pass it through directly
		if is_eventcontext(current_obj) then
		
			if arg.n > 1 then
				script_error("WARNING: trigger_event() was called with multiple objects to pass through on the event context, yet one of them was a proper event context - the rest will be discarded");
			end;
			
			context = current_obj;
			break;
		end;
	
		context:add_data(current_obj);
	end;
	
	-- trigger the event with the context
	local event_table = events[event];
	
	if event_table then
		for i = 1, #event_table do
			event_table[i](context);
		end;
	end;
end;








--v function(text: string, force: boolean?)
local function EHLOG(text, force)
	if (not should_log_eh) and (not force) then
		return
	end
    local pre = "EH-CORE"
    local logText = tostring(text)
    local logTimeStamp = os.date("%d, %m %Y %X")
    local popLog = io.open("sheildwall_logs.txt","a")
    --# assume logTimeStamp: string
    popLog :write(pre..":  [".. logTimeStamp .. "]:  "..logText .. "  \n")
    popLog :flush()
    popLog :close()
end




----------------------------------------------------------------------------
-- custom context script
----------------------------------------------------------------------------

custom_context = {};

local additional_context_types = {
	["shieldwall_game_event"] = "game_event_data"
}

function custom_context:new()
	local cc = {};
	setmetatable(cc, self);
	self.__index = self;	
	
	return cc;
end;

--- @function add_data
--- @desc adds data to the custom context object. Supported data types:
--- @desc <ul><li>string: will be accessible to the receiving script as <code>context.string</code>.</li>
--- @desc <ul><li>number: will be accessible to the receiving script as <code>context.number</code>.</li>
--- @desc <li>table: will be accessible to the receiving script using @custom_context:table_data.</li>
--- @desc <li>region: will be accessible to the receiving script using @custom_context:region.</li>
--- @desc <li>character: will be accessible to the receiving script using @custom_context:character. A second character, if added, is accessible to the receiving script using @custom_context:target_character.</li>
--- @desc <li>faction: will be accessible to the receiving script using @custom_context:faction.</li>
--- @desc <li>component: will be accessible to the receiving script using @custom_context:component.</li>
--- @desc <li>military_force: will be accessible to the receiving script using @custom_context:military_force.</li>
--- @desc <li>pending_battle: will be accessible to the receiving script using @custom_context:pending_battle.</li>
--- @desc <li>garrison_residence: will be accessible to the receiving script using @custom_context:garrison_residence.</li>
--- @desc <li>building: will be accessible to the receiving script using @custom_context:building.</li>
--- @desc <li>vector: will be accessible to the receiving script using @custom_context:vector.</li></ul>
--- @desc A limitation of the implementation is that only one object of each type may be placed on the custom context (except for characters, currently).
--- @p object context data, Data object to add
function custom_context:add_data(obj)
	EHLOG("Custom Context Add Data was called with obj "..tostring(obj))
	local ok, err = pcall(function()
		if is_boolean(obj) then
			EHLOG("Result: boolean, ignored")
			--no error, ignore this one
			return
		elseif is_string(obj) then
			EHLOG("Result: string, added to self.string")
			self.string = obj;
		elseif is_number(obj) then
			EHLOG("Result: number, added to self.number")
			self.number = obj;
		elseif is_region(obj) then
			EHLOG("Result: region, added to self.region_data")
			self.region_data = obj;
			if obj:is_province_capital() and obj:has_governor() then
				EHLOG("Result: had governor, added to self.governor_data")
				self.governor_data = obj:governor()
			end
		elseif is_character(obj) then
			EHLOG("Result: string, added to self.string")
			-- not such a nice construct - the first character will be accessible at "character", the second at "target_character"
			if self.character_data then
				self.target_character_data = obj;
			else
				self.character_data = obj;
			end;
		elseif is_faction(obj) then
			EHLOG("Result: had faction, added to self.faction_data")
			--copying CA's "not such a nice construct" here for diplomacy events
			if self.faction_data then
				EHLOG("Result: had additional faction, added to self.other_faction_data")
				self.other_faction_data = obj
			else
				EHLOG("Result: had faction, added to self.faction_data")
				self.faction_data = obj;
			end	
		elseif is_component(obj) then
			self.component_data = obj;
		elseif is_militaryforce(obj) then
			self.military_force_data = obj;
		elseif is_pendingbattle(obj) then
			EHLOG("Result: had pending battle, added to self.pending_battle_data")
			self.pending_battle_data = obj;
		elseif is_garrisonresidence(obj) then
			self.garrison_residence_data = obj;
		elseif is_building(obj) then
			self.building_data = obj;
		elseif is_vector(obj) then
			self.vector_data = obj;
		elseif is_table(obj) then			-- keep this check last, as script objects are tables and will erroneously return true here
			if obj.context_data then
				EHLOG("Result: additional context type "..obj.context_data)
				if additional_context_types[obj.context_data] then
					local field_name = additional_context_types[obj.context_data]
					EHLOG("Result: additional context type "..obj.context_data .. " added to field name "..field_name)
					self[field_name] = obj
				else
					EHLOG("ERROR: adding additional context type to custom context but couldn't recognise data [" .. tostring(obj) .. "] of type [" .. type(obj.context_data) .. "]", true);
					script_error("ERROR: adding additional context type to custom context but couldn't recognise data [" .. tostring(obj) .. "] of type [" .. type(obj.context_data) .. "]");
				end
			else
				EHLOG("Result: table, added to stored table")
				self.stored_table = obj;
			end
		else
			script_error("ERROR: adding data to custom context but couldn't recognise data [" .. tostring(obj) .. "] of type [" .. type(obj) .. "]");
		end;	
	end)
	if not ok then EHLOG(tostring(err), true) end
end;

function custom_context:choice()
	return self.choice_data
end
function custom_context:game_event()
	return self["game_event_data"]
end

function custom_context:dilemma()
	if not self["game_event_data"] then
		return nil
	end
	return self["game_event_data"].key
end

function custom_context:governor()
	return self.governor_data
end

function custom_context:has_governor()
	return not not self.governor_data
end

--- @function table_data
--- @desc Called by the receiving script to retrieve the table placed on the custom context, were one specified by the script that created it.
--- @return table of user defined values
function custom_context:table_data()
	return self.stored_table;
end;


--- @function region
--- @desc Called by the receiving script to retrieve the region object placed on the custom context, were one specified by the script that created it.
--- @return region region object
function custom_context:region()
	return self.region_data;
end;


--- @function character
--- @desc Called by the receiving script to retrieve the character object placed on the custom context, were one specified by the script that created it.
--- @return character character object
function custom_context:character()
	return self.character_data;
end;


--- @function target_character
--- @desc Called by the receiving script to retrieve the target character object placed on the custom context, were one specified by the script that created it. The target character is the second character added to the context.
--- @return character target character object
function custom_context:target_character()
	return self.target_character_data;
end;


--- @function faction
--- @desc Called by the receiving script to retrieve the faction object placed on the custom context, were one specified by the script that created it.
--- @return faction faction object
function custom_context:faction()
	return self.faction_data;
end;

--- @function faction
--- @desc Called by the receiving script to retrieve the faction object placed on the custom context, were one specified by the script that created it.
--- @return faction faction object
function custom_context:other_faction()
	return self.other_faction_data;
end;


--- @function component
--- @desc Called by the receiving script to retrieve the component object placed on the custom context, were one specified by the script that created it.
--- @return component component object
function custom_context:component()
	return self.component_data;
end;


--- @function military_force
--- @desc Called by the receiving script to retrieve the military force object placed on the custom context, were one specified by the script that created it.
--- @return military_force military force object
function custom_context:military_force()
	return self.military_force_data;
end;


--- @function pending_battle
--- @desc Called by the receiving script to retrieve the pending battle object placed on the custom context, were one specified by the script that created it.
--- @return pending_battle pending battle object
function custom_context:pending_battle()
	return self.pending_battle_data;
end;


--- @function garrison_residence
--- @desc Called by the receiving script to retrieve the garrison residence object placed on the custom context, were one specified by the script that created it.
--- @return garrison_residence garrison residence object
function custom_context:garrison_residence()
	return self.garrison_residence_data;
end;


--- @function building
--- @desc Called by the receiving script to retrieve the building object placed on the custom context, were one specified by the script that created it.
--- @return building building object
function custom_context:building()
	return self.building_data;
end;


--- @function vector
--- @desc Called by the receiving script to retrieve the vector object placed on the custom context, were one specified by the script that created it.
--- @return vector vector object
function custom_context:vector()
	return self.vector_data;
end;