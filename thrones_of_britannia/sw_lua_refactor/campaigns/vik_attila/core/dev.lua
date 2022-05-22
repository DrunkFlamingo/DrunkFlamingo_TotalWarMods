--v function(text: string, context: string?)
local function MODLOG(text, context)
    if not CONST.__write_output_to_logfile then
        return; 
    end
    local pre = context --:string
    if not context then
        pre = "DEV"
    end
    local logText = tostring(text)
    local logTimeStamp = os.date("%d, %m %Y %X")
    local popLog = io.open("sheildwall_logs.txt","a")
    --# assume logTimeStamp: string
    popLog :write(pre..":  [".. logTimeStamp .. "]:  "..logText .. "  \n")
    popLog :flush()
    popLog :close()
end

local exports = {} --:map<string, boolean>
--v function(name: string, ...: string)
local function RAWPRINT(name, ...)
    logText = arg[1]
    if #arg > 1 then
        for i = 2, #arg do
            logText = logText.."\t"..arg[i]
        end
    end
    local popLog = io.open("sheildwall_output_"..name..".tsv","a")
    --# assume logTimeStamp: string
    popLog :write(logText.."\n")
    popLog :flush()
    popLog :close()
end





local popLog = io.open("sheildwall_logs.txt", "w+")
local logTimeStamp = os.date("%d, %m %Y %X")
--# assume logTimeStamp: string
popLog:write("NEW LOG: ".. logTimeStamp .. "\n")
popLog :flush()
popLog :close()

MODLOG("LOADING SHIELDWALL LIBRARY")
--v function(uic: CA_UIC)
local function log_uicomponent(uic)

    local LOG = MODLOG
    --v function(text: any)
    local function MODLOG(text)
        LOG(tostring(text), "UIC")
    end

    if not is_uicomponent(uic) then
        script_error("ERROR: output_uicomponent() called but supplied object [" .. tostring(uic) .. "] is not a ui component");
        return;
    end;
        
    -- not sure how this can happen, but it does ...
    if not pcall(function() MODLOG("uicomponent " .. tostring(uic:Id()) .. ":") end) then
        MODLOG("output_uicomponent() called but supplied component seems to not be valid, so aborting");
        return;
    end;
    
    MODLOG("path from root:\t\t" .. uicomponent_to_str(uic));
    
    local pos_x, pos_y = uic:Position();
    local size_x, size_y = uic:Bounds();

    MODLOG("\tposition on screen:\t" .. tostring(pos_x) .. ", " .. tostring(pos_y));
    MODLOG("\tsize:\t\t\t" .. tostring(size_x) .. ", " .. tostring(size_y));
    MODLOG("\tstate:\t\t" .. tostring(uic:CurrentState()));
    MODLOG("\tstateText:\t\t" .. tostring(uic:GetStateText()));
    MODLOG("\tTooltipText:\t\t" .. tostring(uic:GetTooltipText()));
    MODLOG("\tvisible:\t\t" .. tostring(uic:Visible()));
    MODLOG("\tpriority:\t\t" .. tostring(uic:Priority()));
    MODLOG("\tchildren:");
    
    
    for i = 0, uic:ChildCount() - 1 do
        local child = UIComponent(uic:Find(i));
        
        MODLOG("\t\t"..tostring(i) .. ": " .. child:Id());
    end;


    MODLOG("");
end;


-- for debug purposes
local function log_uicomponent_on_click()
    if not CONST.__should_output_ui then
        return
    end
    local eh = get_eh();
    
    if not eh then
        script_error("ERROR: output_uicomponent_on_click() called but couldn't get an event handler");
        return false;
    end;
    
    MODLOG("output_uicomponent_on_click() called");
    
    eh:add_listener(
        "output_uicomponent_on_click",
        "ComponentLClickUp",
        true,
        function(context) log_uicomponent(UIComponent(context.component)) end,
        true
    );
end;

--v [NO_CHECK] function(uic: CA_UIC) --> string
local function dev_uicomponent_to_str(uic)
	if not is_uicomponent(uic) then
		return "";
	end;
	
	if uic:Id() == "root" then
		return "root";
	else
		return dev_uicomponent_to_str(UIComponent(uic:Parent())) .. " > " .. uic:Id();
	end;	
end;

--v [NO_CHECK] function(uic: CA_UIC)
local function dev_print_all_uicomponent_children(uic)
	MODLOG(dev_uicomponent_to_str(uic), "UIC");
	for i = 0, uic:ChildCount() - 1 do
		local uic_child = UIComponent(uic:Find(i));
		dev_print_all_uicomponent_children(uic_child);
	end;
end;

--don't call this on root. Just dont. 
--v [NO_CHECK] function(uic: CA_UIC)
local function dev_print_all_uicomponent_details(uic)
    log_uicomponent(uic)
    for i = 0, uic:ChildCount() - 1 do
        local uic_child = UIComponent(uic:Find(i));
        dev_print_all_uicomponent_details(uic_child)
    end;
end;




--v [NO_CHECK] function()
function MOD_ERROR_LOGS()
--Vanish's PCaller
    --All credits to vanishoxyact from WH2
    local eh = get_eh();

    --v function(func: function) --> any
    function safeCall(func)
        local status, result = pcall(func)
        if not status then
            MODLOG(tostring(result), "ERR")
            MODLOG(debug.traceback(), "ERR");
        end
        return result;
    end
    
    
    --v [NO_CHECK] function(...: any)
    function pack2(...) return {n=select('#', ...), ...} end
    --v [NO_CHECK] function(t: vector<WHATEVER>) --> vector<WHATEVER>
    function unpack2(t) return unpack(t, 1, t.n) end
    
    --v [NO_CHECK] function(f: function(), argProcessor: (function())?) --> function()
    function wrapFunction(f, argProcessor)
        return function(...)
            local someArguments = pack2(...);
            if argProcessor then
                safeCall(function() argProcessor(someArguments) end)
            end
            local result = pack2(safeCall(function() return f(unpack2( someArguments )) end));
            return unpack2(result);
            end
    end
    

    eh.trigger_event = wrapFunction(
        eh.trigger_event,
        function(ab)
        end
    );
    
    check_callbacks = wrapFunction(
        check_callbacks,
        function(ab)
        end
    )

    local currentFirstTick = cm.register_first_tick_callback
    --v [NO_CHECK] function (cm: any, callback: function)
    function myFirstTick(cm, callback)
        currentFirstTick(cm, wrapFunction(callback))
    end
    cm.register_first_tick_callback = myFirstTick

    
    local currentAddListener = eh.add_listener;
    --v [NO_CHECK] function(eh: any, listenerName: any, eventName: any, conditionFunc: any, listenerFunc: any, persistent: any)
    function myAddListener(eh, listenerName, eventName, conditionFunc, listenerFunc, persistent)
        local wrappedCondition = nil;
        if is_function(conditionFunc) then
            wrappedCondition =  wrapFunction(conditionFunc);
        else
            wrappedCondition = conditionFunc;
        end
        currentAddListener(
            eh, listenerName, eventName, wrappedCondition, wrapFunction(listenerFunc), persistent
        )
    end
    eh.add_listener = myAddListener;
end
MOD_ERROR_LOGS() 
--# assume logAllObjectCalls: function(object: any)
--# assume safeCall: function(func: function)
--# assume wrapFunction: function(f: function(), argProcessor: (function())?) --> function()

--object logging
cm:register_first_tick_callback(function()
    if not CONST.__log_game_objects then
        return
    end
        
    --v [NO_CHECK] function(f: function(), name: string)
    function logFunctionCall(f, name)
        return function(...)
            MODLOG("function called: " .. name);
            return f(...);
        end
    end
    
    --v [NO_CHECK] function(object: any)
    function logAllObjectCalls(object)
        local metatable = getmetatable(object);
        for name,f in pairs(getmetatable(object)) do
            if is_function(f) then
                MODLOG("\tFound " .. name);
                if name == "Id" or name == "Parent" or name == "Find" or name == "Position" or name == "CurrentState"  or name == "Visible"  or name == "Priority" or "Bounds" then
                    --Skip
                else
                    metatable[name] = logFunctionCall(f, name);
                end
            end
            if name == "__index" and not is_function(f) then
                for indexname,indexf in pairs(f) do
                    MODLOG("\t\tFound in index " .. indexname);
                    if is_function(indexf) then
                        f[indexname] = logFunctionCall(indexf, indexname);
                    end
                end
                MODLOG("\tIndex end");
            end
        end
    end
    
    
    --v function(text: any)
    local function log(text)
        MODLOG(tostring(text), "OBJ")
    end
    log("GAME INTERFACE")
    logAllObjectCalls(cm.scripting.game_interface)
    log("MODEL")
    logAllObjectCalls(cm:model())
    log("WORLD")
    logAllObjectCalls(cm:model():world())
    log("Region manager")
    logAllObjectCalls(cm:model():world():region_manager())
    log("FACTION INTERFACE")
    local faction = cm:model():world():faction_by_key(cm:get_local_faction(true))
    logAllObjectCalls(faction)
    log("REGION INTERFACE")
    logAllObjectCalls(faction:home_region())
    log("SETTLEMENT")
    logAllObjectCalls(faction:home_region():settlement())
    log("SLOT")
    logAllObjectCalls(faction:home_region():settlement():slot_list():item_at(0))
    log("BUILDING")
    logAllObjectCalls(faction:home_region():settlement():slot_list():item_at(0):building())
    log("GARRISON")
    logAllObjectCalls(faction:home_region():garrison_residence())
    log("CHARACTER")
    logAllObjectCalls(faction:faction_leader())
    log("FORCE")
    logAllObjectCalls(faction:faction_leader():military_force())
    log("UIC")
    for key, value in pairs(getmetatable(find_uicomponent(cm:ui_root()))) do
        --# assume key: string
        MODLOG("\tFound "..tostring(key));
    end
    
    
end)



--SELECTION TRACKING

local settlement_selected_log_calls = {} --:vector<(function(CA_REGION) --> string)>
local settlement_selected_log_lists = {} --:vector<(function(CA_REGION) --> (string, vector<string>))>
local char_selected_log_calls = {} --:vector<(function(CA_CHAR) --> string)>
local char_selected_log_lists = {} --:vector<(function(CA_CHAR) --> (string, vector<string>))>

--start UI tracking helpers.
cm:register_ui_created_callback( function()
    log_uicomponent_on_click()
    cm:add_listener(
        "charSelected",
        "CharacterSelected",
        true,
        function(context)
            MODLOG("selected character with CQI ["..tostring(context:character():command_queue_index()).."]", "SEL")
            for i = 1, #char_selected_log_calls do
                MODLOG("\t"..char_selected_log_calls[i](context:character()), "SEL")
            end
            for i = 1, #char_selected_log_lists do
                local title, list = char_selected_log_lists[i](context:character())
                MODLOG("\t"..title, "SEL")
                for j = 1, #list do
                    MODLOG("\t\t"..list[j] , "SEL")
                end
            end
        end,
        true
    )

    cm:add_listener(
        "SettlementSelected",
        "SettlementSelected",
        true,
        function(context)
            MODLOG("Selected settlement ["..  context:garrison_residence():region():name() .. "]", "SEL")
            for i = 1, #settlement_selected_log_calls do
                MODLOG("\t"..settlement_selected_log_calls[i](context:garrison_residence():region()), "SEL")
            end
            for i = 1, #settlement_selected_log_lists do
                local title, list = settlement_selected_log_lists[i](context:garrison_residence():region())
                MODLOG("\t"..title, "SEL")
                for j = 1, #list do
                    MODLOG("\t\t"..list[j] , "SEL")
                end
            end
        end,
        true
    )
    cm:add_listener(
		"PanelClosedCampaign",
		"PanelClosedCampaign",
		true,
		function(context)
            MODLOG("Panel closed: "..context.string, "CAUI")
		end,
		true
    );
    cm:add_listener(
		"PanelOpenedCampaign",
		"PanelOpenedCampaign",
		true,
		function(context)
            MODLOG("Panel opened: "..context.string, "CAUI")
		end,
		true
	);
end)

--v [NO_CHECK] function(item:number, min:number?, max:number?) --> number
local function dev_clamp(item, min, max)
    local ret = item 
    if max and ret > max then
        ret = max
    elseif min and ret < min then
        ret = min
    end
    return ret
end

--v function(num: number, mult: int) --> int
local function dev_mround(num, mult)
    --round num to the nearest multiple of num
    return (math.floor((num/mult)+0.5))*mult
end

--v [NO_CHECK] function(str: string, delim:string) --> vector<string>
local function dev_split_string(str, delim)
    local res = { };
    local pattern = string.format("([^%s]+)%s()", delim, delim);
    while (true) do
        line, pos = str:match(pattern, pos);
        if line == nil then break end;
        table.insert(res, line);
    end
    return res;
end

--v [NO_CHECK] function(...:any) --> WHATEVER
local function dev_pack_args(...)
    return {n=select('#', ...), ...} 
end

--v function(call: function(CA_REGION) --> string)
local function dev_add_settlement_select_log_call(call)
    table.insert(settlement_selected_log_calls, call)
end

--v function(call: function(CA_REGION) --> (string, vector<string>))
local function dev_add_settlement_select_log_list(call)
    table.insert(settlement_selected_log_lists, call)
end

--v function(call: function(CA_CHAR) --> string)
local function dev_add_character_select_log_call(call)
    table.insert(char_selected_log_calls, call)
end

--v function(call: function(CA_CHAR) --> (string, vector<string>))
local function dev_add_character_select_log_list(call)
    table.insert(char_selected_log_lists, call)
end

--settlement logging
if CONST.__log_settlements then
    dev_add_settlement_select_log_list(function(region)
        local retval = {} --:vector<string>
        if region:settlement():is_null_interface() then
            return "Buildings:", retval
        end
        local slot_list = region:settlement():slot_list()
        for i = 0, slot_list:num_items() - 1 do
            local slot = slot_list:item_at(i)
            if slot:has_building() then
                table.insert(retval, slot:building():name())
            end
        end
        return "Buildings:", retval 
    end)
end

if CONST.__log_characters then
    dev_add_character_select_log_list(function(character)
        local retval = {} --:vector<string>
        if character:is_null_interface() then
            return "Info:", retval
        end
        table.insert(retval, "Name: "..character:get_forename())
        table.insert(retval, "X, Y: "..character:logical_position_x()..", "..character:logical_position_y())
        table.insert(retval, "Is faction leader: ".. tostring(character:is_faction_leader()))

        return "Info:", retval
    end)
end









--dev shortcut library

--v function(key: string) --> CA_FACTION
local function dev_get_faction(key)
    local world = cm:model():world();
    
    if world:faction_exists(key) then
        return world:faction_by_key(key);
    end;
    
    return nil;
end

--v function(chance: int) --> boolean
local function dev_chance(chance)
    if CONST.__always_succeed_chance_checks then
        return true
    end
    return cm:random_number(100) <= chance
end

--v function(cqi: CA_CQI) --> CA_FORCE
local function dev_get_force(cqi)
    if cm:model():has_military_force_command_queue_index(cqi) then
        return cm:model():military_force_for_command_queue_index(cqi)
    else
        return nil
    end
end

--v function(region_key: string) --> CA_REGION
local function dev_get_region(region_key)
    return cm:model():world():region_manager():region_by_key(region_key);
end

--v [NO_CHECK] function(cqi: CA_CQI) --> CA_CHAR
local function dev_get_character(cqi)
    local char_cqi = cqi
	if is_string(char_cqi) then
        char_cqi = tonumber(cqi)
    elseif is_number(char_cqi) then
        --do nothing
    else
        dev.log("Called get character with a non-cqi non-string value ["..tostring(cqi).."]")
    end
	local model = cm:model();
	if model:has_character_command_queue_index(char_cqi) then
		return model:character_for_command_queue_index(char_cqi);
	end;

	return nil;
end

--v function(character: CA_CHAR) --> boolean
function dev_is_normal_character(character)
    return character:character_type("general") and character:is_male() and character:family_member():come_of_age()

end


--v function(character: CA_CHAR) --> boolean
local function dev_is_char_normal_general(character)
    return character:character_type("general") and character:has_military_force() and character:military_force():is_army() and (not character:military_force():is_armed_citizenry()) 
end

--v function(ax: number, ay: number, bx: number, by: number) --> number
local function dev_distance_2D(ax, ay, bx, by)
    return (((bx - ax) ^ 2 + (by - ay) ^ 2) ^ 0.5);
end;

--v function() --> int
local function dev_turn()
    return cm:model():turn_number()
end


--v function(character: CA_CHAR, cannot_own: boolean?) --> string
local function dev_closest_settlement_to_char(character, cannot_own)
    local region_list = cm:model():world():region_manager():region_list();
	local target_distance = 0 --:number
	local region_key --:string
	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i);
		local lx = region:settlement():logical_position_x() - character:logical_position_x()
		local ly = region:settlement():logical_position_y() - character:logical_position_y()
		local region_distance = ((lx * lx) + (ly * ly))
		if (not region_key) or region_distance < target_distance then
            if (not cannot_own) or (region:owning_faction():name() ~= character:faction():name()) then
                region_key = region:name();
                target_distance = region_distance;
            end
		end
	end
	return region_key;
end

--v function(settlement: CA_SETTLEMENT) --> (CA_CQI, number)
local function dev_closest_char_to_own_settlement(settlement)
    local character_list = settlement:region():owning_faction():character_list()
	local target_distance = 0 --:number
	local cqi = -1 --# assume cqi: CA_CQI
	for i = 0, character_list:num_items() - 1 do
		local character = character_list:item_at(i);
		local lx = character:logical_position_x() - settlement:logical_position_x()
		local ly = character:logical_position_y() - settlement:logical_position_y()
		local character_distance = ((lx * lx) + (ly * ly))
		if cqi == -1 or character_distance < target_distance then
			cqi = character:command_queue_index()
			target_distance = character_distance;
		end
	end
	return cqi, target_distance
end


--v function(character: CA_CHAR, region: CA_REGION, x: int) --> boolean
local function dev_is_character_near_region(character, region, x)
    local result = false;
    local force_general = character
    local radius = x;
    local distance = dev_distance_2D(force_general:logical_position_x(), force_general:logical_position_y(), region:settlement():logical_position_x(), region:settlement():logical_position_y());
    result = (distance < radius);
    return result;

end

--v function(faction: CA_FACTION?) --> CA_REGION_LIST
local function dev_region_list(faction)
    if faction then
        --# assume faction: CA_FACTION! 
        if not faction:is_null_interface() then
         return faction:region_list()
        end
    end
    return cm:model():world():region_manager():region_list()
end

--v function() --> CA_FACTION_LIST
local function dev_faction_list()
    return cm:model():world():faction_list()
end

--v [NO_CHECK] function(t: table)
local function dev_readonlytable(t)
    local mt = getmetatable(t)
    if not mt then
        MODLOG("Tried to make a table read only, but the table has a private metatable!", "DEV")
        return
    end
    mt.__newindex = function(t, key, value)
                    error("Attempt to modify read-only table")
                end
    setmetatable(t, mt)
end

--v function (callback: function(), timer: number?, name: string?)
local function dev_callback(callback, timer, name)
    add_callback(wrapFunction(callback), timer, name)
end

local pre_first_tick_callbacks = {} --:vector<function(context: WHATEVER)>
local first_tick_callbacks = {} --:vector<function(context: WHATEVER)>
local post_first_tick_callbacks = {} --:vector<function(context: WHATEVER)>
local new_game_callbacks = {} --:vector<function(context: WHATEVER)>

--v function(callback: function(context: WHATEVER))
local function dev_pre_first_tick(callback)
    table.insert(pre_first_tick_callbacks, callback)
end

--v function(callback: function(context: WHATEVER))
local function dev_first_tick(callback)
    table.insert(first_tick_callbacks, callback)
end

--v function(callback: function(context: WHATEVER))
local function dev_post_first_tick(callback)
    table.insert(post_first_tick_callbacks, callback)
end

--v function(callback: function(context: WHATEVER))
local function dev_new_game_callback(callback)
    if cm:get_saved_value("dev_new_game_callback") then
        return
    end
    table.insert(new_game_callbacks, callback)
end


_G.game_created = false


--v function() --> boolean
local function dev_is_new_game()
    return not cm:get_saved_value("dev_new_game_callback")
end

--CharacterCompletedBattle fires before the game is created when you fight battles manually.
--This breaks a lot of stuff.
--We solve this by storing the characters who have completed battles in order to artifically echo the event in script.
local char_completed_battle_cache = {} --:vector<CA_CQI>
cm:add_listener(
    "CharacterCompletedBattleAfterManualResolution",
    "CharacterCompletedBattle",
    function(context)
        return true
    end,
    function(context)
        local char = context:character() --:CA_CHAR
        if not _G.game_created then
            MODLOG("Character completed battle fired on ["..tostring(char:command_queue_index()).."] before first tick, queuing it to echo after first tick", "FTC")
            table.insert(char_completed_battle_cache, char:command_queue_index())
        else
            get_eh():trigger_event("ShieldwallCharacterCompletedBattle", char)
        end
    end,
    true
)

cm:register_first_tick_callback(function(context)
    _G.game_created = true

    _G.shieldwall_version = cm:get_saved_value("shieldwall_script_version")
    if not _G.shieldwall_version then
        _G.shieldwall_version =  CONST.__script_version
        cm:set_saved_value("shieldwall_script_version", CONST.__script_version)
    end
    local faction_list = cm:model():world():faction_list()
    for i = 0, faction_list:num_items() - 1 do
        local faction = faction_list:item_at(i)
        if faction:has_effect_bundle(faction:name().."_startpos") then
            cm:remove_effect_bundle(faction:name().."_startpos", faction:name())
        end
    end
    cm:add_listener(
        "DeselectOnTurnStart",
        "FactionBeginTurnPhaseNormal",
        function(context)
            return context:faction():is_human() and context:faction():name() == cm:get_local_faction(true)
        end,
        function(context)
            CampaignUI.ClearSelection();
        end,
        true)
    local is_first_turn = cm:model():turn_number() == 1
    if is_first_turn then
        local panel = nil --:CA_UIC
        cm:add_listener(
            "RecHandlerPanelOpenedCampaign",
            "PanelOpenedCampaign",
            function(context)
                return context.string == "recruitment"
            end,
            function(context)
                local is_first_turn = cm:model():turn_number() == 1
                if is_first_turn then
                panel = UIComponent(context.component)
                local list_box = find_uicomponent(panel, "recuitment_list", "listview", "list_clip", "list_box")
                    if list_box then
                        for i = 0, list_box:ChildCount() - 1 do
                            local recruitmentCategory = UIComponent(list_box:Find(i))
                            local units_box = find_uicomponent(recruitmentCategory, "units_box")
                            for j = 0, units_box:ChildCount() - 1 do
                                local UnitCard = UIComponent(units_box:Find(j))
                                local max = find_uicomponent(UnitCard, "max_units")
                                if max then
                                    local new_text = string.gsub(max:GetStateText(), "/100", " ")
                                    max:SetStateText(new_text)
                                end
                            end
                        end
                    end
                end
            end, true)
        cm:add_listener(
            "RecHandlerComponentLClickUp",
            "ComponentLClickUp",
            true,
            function(context)
                local is_first_turn = cm:model():turn_number() == 1
                if is_first_turn and panel then
                    local component = UIComponent(context.component)
                    local component_ID = tostring(component:Id())
                    if string.find(component_ID, "temp_merc_") or string.find(component_ID, "_mercenary") then
                        dev_callback(function()
                            local list_box = find_uicomponent(panel, "recuitment_list", "listview", "list_clip", "list_box")
                            if list_box then
                                for i = 0, list_box:ChildCount() - 1 do
                                    local recruitmentCategory = UIComponent(list_box:Find(i))
                                    local units_box = find_uicomponent(recruitmentCategory, "units_box")
                                    for j = 0, units_box:ChildCount() - 1 do
                                        local UnitCard = UIComponent(units_box:Find(j))
                                        local max = find_uicomponent(UnitCard, "max_units")
                                        if max then
                                            local new_text = string.gsub(max:GetStateText(), "/100", " ")
                                            max:SetStateText(new_text)
                                        end
                                        
                                    end
                                end
                            end
                        end, 0.1)
                    end
                end
            end, true)
    end
    MODLOG("===================================================================================", "FTC")
    MODLOG("===================================================================================", "FTC")
    MODLOG("===============THE GAME IS STARTING: RUNNING FIRST TICK CALLBACK===================", "FTC")
    MODLOG("===================================================================================", "FTC")
    MODLOG("===================================================================================", "FTC")
    local x = os.clock()
    for i = 1, #pre_first_tick_callbacks do
        local ok, err = pcall( function()
            pre_first_tick_callbacks[i](context)
        end)
        if not ok then
            MODLOG("ERROR IN FIRST TICK", "ERR")
            MODLOG(tostring(err), "ERR")
        end
    end
    if not cm:get_saved_value("dev_new_game_callback") then
        MODLOG("===================================================================================", "FTC")
        MODLOG("===================================================================================", "FTC")
        MODLOG("===============NEW GAME STARTED: RUNNING NEW GAME START CALLBACK===================", "FTC")
        MODLOG("===================================================================================", "FTC")
        MODLOG("===================================================================================", "FTC")
        for i = 1, #new_game_callbacks do
            local ok, err = pcall( function()
            new_game_callbacks[i](context)
            end)
            if not ok then
                MODLOG("ERROR IN FIRST TICK", "ERR")
                MODLOG(tostring(err), "ERR")
            end
        end
    end
    for i = 1, #first_tick_callbacks do
        local ok, err = pcall( function()
            first_tick_callbacks[i](context)
        end)
        if not ok then
            MODLOG("ERROR IN FIRST TICK", "ERR")
            MODLOG(tostring(err), "ERR")
        end
    end
    for i = 1, #post_first_tick_callbacks do
        local ok, err = pcall( function()
        post_first_tick_callbacks[i](context)
        end)
        if not ok then
            MODLOG("ERROR IN FIRST TICK", "ERR")
            MODLOG(tostring(err), "ERR")
        end
    end
    cm:set_saved_value("dev_new_game_callback", true)
    MODLOG(string.format("First tick complete: elapsed time: %.4f\n", os.clock() - x), "FTC")
    for i = 1, #char_completed_battle_cache do
        local char_cqi = char_completed_battle_cache[i]
        local char = dev_get_character(char_cqi)
        if char then
            MODLOG("Firing Queued CharacterCompletedBattle event for "..tostring(char_cqi))
            get_eh():trigger_event("ShieldwallCharacterCompletedBattle", char)
        else
            MODLOG("Failed to acquire character in ShieldwallCharacterCompletedBattle event for "..tostring(char_cqi))
        end
    end
end)
--v function() --> boolean
local function dev_game_created()
    return _G.game_created
end

--v function(faction_name: string, callback:(function(context: WHATEVER)))
local function dev_turn_start(faction_name, callback)
    get_eh():add_listener("DevTurnStart"..faction_name, "FactionTurnStart", function(context) return context:faction():name() == faction_name end,
    callback, true)
end

--v function(region_name: string, callback:(function(context: WHATEVER)))
local function dev_region_turn_start(region_name, callback)
    get_eh():add_listener("DevTurnStart"..region_name, "RegionTurnStart", function(context) return context:region():name() == region_name end,
    callback, true)
end

--v function(trait_name: string, callback:(function(context: WHATEVER)))
local function dev_char_with_trait_turn_start(trait_name, callback)
    get_eh():add_listener("DevTurnStart"..tostring(trait_name), "CharacterTurnStart", function(context) return context:character():has_trait(trait_name) end,
    callback, true)
end

--v function(event_key: string, callback: function(context: WHATEVER), persist: boolean?)
local function dev_respond_to_incident(event_key, callback, persist)
    get_eh():add_listener(
		event_key.."_response",
		"IncidentOccuredEvent",
		function(context)
			return context:dilemma() == event_key
		end,
        function(context)
            MODLOG("Responding to incident: "..event_key)
			callback(context)
		end,
		not not persist
	)
end

--v function(event_key: string, callback: function(context: WHATEVER), persist: boolean?)
local function dev_respond_to_dilemma(event_key, callback, persist)
    get_eh():add_listener(
		event_key.."_response",
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma() == event_key
		end,
        function(context)
            MODLOG("Responding to dilemma: "..event_key)
			callback(context)
		end,
		not not persist
	)
end

--v function(event_key: string, callback: function(context: WHATEVER), persist: boolean?)
local function dev_respond_to_mission_issued(event_key, callback, persist)
    get_eh():add_listener(
		event_key.."_response",
		"MissionIssued",
		function(context)
			return context:mission():mission_record_key() == event_key
		end,
        function(context)
            MODLOG("Responding to dilemma: "..event_key)
			callback(context)
		end,
		not not persist
	)
end

local last_time_settlement_sacked = {} --:map<string, number>
--v function(settlement: string) --> number
local function dev_last_time_sacked(settlement)
    return last_time_settlement_sacked[settlement] or -10
end

local invasions_number = 0
--v function() --> number
local function dev_invasion_number()
    invasions_number = invasions_number + 1;
    return invasions_number - 1;
end

--v [NO_CHECK] function(txt: string) --> string
local function dev_get_numbers_from_text(txt)
    local str = "" --:string
    string.gsub(txt,"%d+",function(e)
     str = str .. e
    end)
    return str
end


cm:register_loading_game_callback(function(context)
    last_time_settlement_sacked = cm:load_value("last_time_settlement_sacked", {}, context)
    invasions_number = cm:load_value("invasions_number", 0, context)
end)

cm:register_saving_game_callback(function(context)
    cm:save_value("last_time_settlement_sacked", last_time_settlement_sacked, context)
    cm:save_value("invasions_number", invasions_number, context)
end)

get_eh():add_listener(
    "DevCharacterPerformsOccupationDecisionSack",
    "CharacterPerformsOccupationDecisionSack",
    true,
    function(context)
        local region_key = dev_closest_settlement_to_char(context:character())
        if region_key then
            last_time_settlement_sacked[region_key] = cm:model():turn_number()
        end
    end,
    true
)

local caste_strengths = {
    very_light = 0.7,
    medium = 0.9,
    light = 0.8,
    very_heavy = 1.8,
    heavy = 1.5
} --:map<string, number>

--v function(character: CA_CHAR, use_value: boolean?) --> number
local function dev_army_size(character, use_value)
    if not dev_is_char_normal_general(character) then
        return 0
    end
    local size = 0 --:number
    local force = character:military_force()
    local cache_entry = {} --:map<string, number>
    for i=0,force:unit_list():num_items()-1 do
        size = size + force:unit_list():item_at(i):percentage_proportion_of_full_strength()
    end
    return size
end

--v function(character: CA_CHAR, use_value: boolean?) --> map<string, number>
local function dev_generate_force_cache_entry(character, use_value)
    if not dev_is_char_normal_general(character) then
        return {}
    end
    local force = character:military_force()
    local cache_entry = {} --:map<string, number>
    for i=0,force:unit_list():num_items()-1 do
        local unit_key = force:unit_list():item_at(i):unit_key()
        cache_entry[unit_key] = cache_entry[unit_key] or 0
        if not use_value then
            cache_entry[unit_key] = cache_entry[unit_key] + force:unit_list():item_at(i):percentage_proportion_of_full_strength()
        else
            local data = Gamedata.unit_info.main_unit_size_caste_info[unit_key]
            cache_entry[unit_key] = cache_entry[unit_key] + (data.num_men * force:unit_list():item_at(i):percentage_proportion_of_full_strength() * caste_strengths[data.caste])
        end
    end
    return cache_entry
end

--v function(unit_table: map<string, map<string, {int, int, int}>>, region_intensity: number, army_type: string) --> string
local function dev_create_army(unit_table, region_intensity, army_type)
    local force_vector = {} --:vector<string>
    local size = 5
    local turn_increment = math.ceil(cm:model():turn_number()/20)
    local size = size + (cm:model():difficulty_level()*-1) + (region_intensity)
    local army_record = unit_table[army_type]
    for unit_key, settings in pairs(army_record) do
        local min_level, recharge_rate, chance = settings[1], settings[2], settings[3]
        if size > min_level then
            if cm:random_number(100) < chance then
                force_vector[#force_vector+1] = unit_key
            end
            local bonus_units = math.floor((size-min_level)/recharge_rate)
            if bonus_units >= 1 then
                for i = 1, bonus_units do
                    if cm:random_number(100) < chance then
                        force_vector[#force_vector+1] = unit_key
                    end
                end
            end
        end
    end
    local force_key = force_vector[1]
    for i = 2, #force_vector do
        --# assume i: int
        if i > 19 then
            break
        end
        force_key = force_key .. "," .. force_vector[i]
    end
    return force_key
end

--v function(character_lookup: CA_CQI | CA_CHAR, trait_key: string, show_message: boolean, is_flag: boolean?)
local function dev_add_trait(character_lookup, trait_key, show_message, is_flag)
    local character = nil --:CA_CHAR
    if type(character_lookup) == "number" then
        --# assume character_lookup: CA_CQI
        character = dev_get_character(character_lookup)
    else
        --# assume character_lookup: CA_CHAR
        character = character_lookup
    end
    if not type(trait_key) == "string"  then
        MODLOG("Add trait called with badly typed args", "dev")
        debug.traceback(1)
    end
    if not character:has_trait(trait_key) then
        cm:force_add_trait(char_lookup_str(character), trait_key, not not show_message)
        if not is_flag then
            get_eh():trigger_event("CharacterGainsTrait", trait_key, character)
        end
    end
end

--v function(character_lookup: CA_CQI | CA_CHAR, trait_key: string)
local function dev_remove_trait(character_lookup, trait_key)
    local character = nil --:CA_CHAR
    if type(character_lookup) == "number" then
        --# assume character_lookup: CA_CQI
        character = dev_get_character(character_lookup)
    else
        --# assume character_lookup: CA_CHAR
        character = character_lookup
    end
    if not type(trait_key) == "string"  then
        MODLOG("remove trait called with badly typed args", "dev")
        debug.traceback(1)
    end
    if character:has_trait(trait_key) then
        cm:force_remove_trait(char_lookup_str(character), trait_key)
        get_eh():trigger_event("CharacterLostTrait", trait_key, character)
    end
end






local PB_army_locations = {} --:map<CA_CQI, {int, int}>
local did_retreat = {} --:map<CA_CQI, boolean>

dev_first_tick(function(context)
    local eh = get_eh()
    eh:add_listener("PendingBattle", "PendingBattle", true, function(context)
        local attacker = context:pending_battle():attacker() --:CA_CHAR
        local defender = context:pending_battle():defender() --:CA_CHAR
        PB_army_locations[attacker:command_queue_index()] = {attacker:logical_position_x(), attacker:logical_position_y()}
        PB_army_locations[defender:command_queue_index()] = {defender:logical_position_x(), defender:logical_position_y()}
    end, true)
    eh:add_listener("BattleCompleted", "BattleCompleted", true, function(context)
        local attacker_result = cm:model():pending_battle():attacker_battle_result();
        local defender_result = cm:model():pending_battle():defender_battle_result();

        if attacker_result == "close_defeat" and defender_result == "close_defeat" then
            local largest_distance = 0 --:number
            local who_retreated = -1 --# assume who_retreated: CA_CQI
            for i = 1, cm:pending_battle_cache_num_attackers() do
                local char_cqi, force_cqi, faction_key = cm:pending_battle_cache_get_attacker(i)
                if PB_army_locations[char_cqi] then
                    local character = dev_get_character(char_cqi)
                    local pos_x, pos_y = character:logical_position_x(), character:logical_position_y()
                    local old_pos_x, old_pos_y = PB_army_locations[char_cqi][1], PB_army_locations[char_cqi][2]
                    MODLOG("Character "..tostring(char_cqi).." had the pre-battle positions ["..old_pos_x.." "..old_pos_y.."].", "RETREATS")
                    MODLOG("Character "..tostring(char_cqi).." had the post-battle positions ["..pos_x.." "..pos_y.."].", "RETREATS")
                    local distance = dev_distance_2D(pos_x, pos_y, old_pos_x, old_pos_y)
                    MODLOG("Character "..tostring(char_cqi).." ended the battle ["..distance.."] from where they started it.", "RETREAT")
                    if distance > largest_distance then
                        largest_distance = distance
                        who_retreated = char_cqi
                    end
                else
                    MODLOG("Character "..tostring(char_cqi).." was in the post battle but didn't have a pre battle position saved.", "RETREATS")
                end
            end
            for i = 1, cm:pending_battle_cache_num_defenders() do
                local char_cqi, force_cqi, faction_key = cm:pending_battle_cache_get_defender(i)
                if PB_army_locations[char_cqi] then
                    local character = dev_get_character(char_cqi)
                    local pos_x, pos_y = character:logical_position_x(), character:logical_position_y()
                    local old_pos_x, old_pos_y = PB_army_locations[char_cqi][1], PB_army_locations[char_cqi][2]
                    MODLOG("Character "..tostring(char_cqi).." had the pre-battle positions ["..old_pos_x.." "..old_pos_y.."].", "RETREATS")
                    MODLOG("Character "..tostring(char_cqi).." had the post-battle positions ["..pos_x.." "..pos_y.."].", "RETREATS")
                    local distance = dev_distance_2D(pos_x, pos_y, old_pos_x, old_pos_y)
                    MODLOG("Character "..tostring(char_cqi).." ended the battle ["..distance.."] from where they started it.", "RETREAT")
                    if distance > largest_distance then
                        largest_distance = distance
                        who_retreated = char_cqi
                    end
                else
                    MODLOG("Character "..tostring(char_cqi).." was in the post battle but didn't have a pre battle position saved.", "RETREATS")
                end
            end
            if largest_distance > 0 then
                MODLOG("Character "..tostring(who_retreated).." retreated from the battle ["..largest_distance.."]", "RETREAT")
                did_retreat[who_retreated] = true
            end
        end
    end, true)
end)
--v function(character: CA_CHAR)--> boolean
function dev_did_character_retreat_from_last_battle(character)
    return did_retreat[character:command_queue_index()] or false
end

--[[ this functionality is currently only used for detecting character retreats, 
so saving and loading are unncessary.
cm:register_loading_game_callback(function(context)
    PB_army_locations = cm:load_value("PB_army_locations", {}, context)
end)

cm:register_saving_game_callback(function(context)
    cm:save_value("PB_army_locations", PB_army_locations, context)
end)
--]]
local SPAWN_BLOCKERS = {}--:  map<int, map<int, int>>
local function dev_clear_spawn_blockers()
    local turn = cm:model():turn_number()
    for x, yt in pairs(SPAWN_BLOCKERS) do
        for y, t in pairs(yt) do
            if t - turn <= -3 then
                SPAWN_BLOCKERS[x][y] = nil
            end
        end
    end
end

cm:register_loading_game_callback(function(context)
    SPAWN_BLOCKERS = cm:load_value("SPAWN_BLOCKERS", {}, context)
end)

cm:register_saving_game_callback(function(context)
    cm:save_value("SPAWN_BLOCKERS", SPAWN_BLOCKERS, context)
end)

if not dev_is_new_game() then
    dev_post_first_tick(function(context) dev_clear_spawn_blockers() end)
end


local faction_hostile_pairs = {} --:map<string, map<string, boolean>>

--v [NO_CHECK] function(faction1: string, faction2: string)
local function dev_SetFactionsHostile(faction1, faction2)
    faction_hostile_pairs[faction1] = faction_hostile_pairs[faction1] or {}
    faction_hostile_pairs[faction1][faction2] = true
	cm:cai_strategic_stance_manager_clear_all_promotions_between_factions(faction1, faction2);
	cm:cai_strategic_stance_manager_clear_all_blocking_between_factions(faction1, faction2);
	cm:cai_strategic_stance_manager_clear_all_promotions_between_factions(faction2, faction1);
	cm:cai_strategic_stance_manager_clear_all_blocking_between_factions(faction2, faction1);
	cm:cai_strategic_stance_manager_promote_specified_stance_towards_target_faction(faction1, faction2, "CAI_STRATEGIC_STANCE_BITTER_ENEMIES");
	cm:cai_strategic_stance_manager_block_all_stances_but_that_specified_towards_target_faction(faction1, faction2, "CAI_STRATEGIC_STANCE_BITTER_ENEMIES"); 
	cm:cai_strategic_stance_manager_promote_specified_stance_towards_target_faction(faction2, faction1, "CAI_STRATEGIC_STANCE_BITTER_ENEMIES");
	cm:cai_strategic_stance_manager_block_all_stances_but_that_specified_towards_target_faction(faction2, faction1, "CAI_STRATEGIC_STANCE_BITTER_ENEMIES"); 
end

--v [NO_CHECK] function(faction1: string, faction2: string)
local function dev_ResetFactionDiplomaticStance(faction1, faction2)
    if faction_hostile_pairs[faction1] then
        faction_hostile_pairs[faction1][faction2] = nil
    end
	cm:cai_strategic_stance_manager_clear_all_promotions_between_factions(faction1, faction2);
	cm:cai_strategic_stance_manager_clear_all_blocking_between_factions(faction1, faction2);
	cm:cai_strategic_stance_manager_clear_all_promotions_between_factions(faction2, faction1);
	cm:cai_strategic_stance_manager_clear_all_blocking_between_factions(faction2, faction1);
	
end


cm:register_loading_game_callback(function(context)
    faction_hostile_pairs = cm:load_value("FACTION_HOSTILITY", {}, context)
end)

cm:register_saving_game_callback(function(context)
    cm:save_value("FACTION_HOSTILITY", faction_hostile_pairs, context)
end)

dev_first_tick(function(context)
    for faction1, faction_list in pairs(faction_hostile_pairs) do
        for faction2, _ in pairs(faction_list) do
            if dev_get_faction(faction1):is_dead() or dev_get_faction(faction2):is_dead() then

            else
                dev_SetFactionsHostile(faction1, faction2)
            end
        end
    end
end)


--v function(faction: CA_FACTION, lock: boolean)
function dev_lockWarDeclarationsForFaction(faction, lock)
    local faction_list = dev_faction_list()
    for i = 0, faction_list:num_items() - 1 do
        local current_faction = faction_list:item_at(i)
        if current_faction:name() ~= faction:name() then
            cm:force_diplomacy(faction:name(), current_faction:name(), "war", not lock, true)
        end
    end
end

--v function(faction: CA_FACTION, lock: boolean)
function dev_lockConfederationForFaction(faction, lock)
    local faction_list = dev_faction_list()
    for i = 0, faction_list:num_items() - 1 do
        local current_faction = faction_list:item_at(i)
        if current_faction:name() ~= faction:name() and current_faction:subculture() == faction:subculture() then
            cm:force_diplomacy(faction:name(), current_faction:name(), "form confederation", not lock, true)
        end
    end
end

--v function(faction: CA_FACTION, lock: boolean)
function dev_LockDiplomacyForFaction(faction, lock)

	local diplomacy_types = {
		"hard military access",
		"cancel hard military access",
		"military alliance",
		"vassal",
		"peace",
		"war",
		"join war",
		"break alliance",
		"hostages",
		"marriage",
		"non aggression pact",
		"soft military access",
		"cancel soft military access",
		"defensive alliance",
		"form confederation",
		"break non aggression pact",
		"break soft military access",
		"break defensive alliance",
		"break vassal"
	} --:vector<string>

    local faction_list = dev_faction_list()
    for i = 0, faction_list:num_items() - 1 do
        local current_faction = faction_list:item_at(i)
        if current_faction:name() ~= faction:name() and current_faction:subculture() == faction:subculture() then
            for j = 1, #diplomacy_types do
                cm:force_diplomacy(faction:name(), current_faction:name(), diplomacy_types[j], not lock, true)
            end
        end
    end
end

--this is to get Kailua to accept how fucking stupid table.insert's alt call is.
--v [NO_CHECK] function(t: vector<WHATEVER>, pos: int, item: any)
function dev_insert(t, pos, item)
    table.insert(t, pos, item)
end

return {
    log = MODLOG,
    export = RAWPRINT,
    callback = dev_callback,
    remove_callback = remove_callback,
    add_trait = dev_add_trait,
    remove_trait = dev_remove_trait,
    eh = get_eh(),
    out_children = dev_print_all_uicomponent_children,
    out_details_for_children = dev_print_all_uicomponent_details,
    get_uic = find_uicomponent,
    uic_from_vec = find_uicomponent_by_table,
    chance = dev_chance,
    get_faction = dev_get_faction,
    get_region = dev_get_region,
    get_character = dev_get_character,
    is_char_normal = dev_is_normal_character,
    is_char_normal_general = dev_is_char_normal_general,
    turn = dev_turn,
    get_force = dev_get_force,
    lookup = char_lookup_str,
    closest_settlement_to_char = dev_closest_settlement_to_char,
    closest_char_to_own_settlement = dev_closest_char_to_own_settlement,
    region_list = dev_region_list,
    faction_list = dev_faction_list,
    clamp = dev_clamp,
    mround = dev_mround,
    insert = dev_insert,
    arg = dev_pack_args,
    split_string = dev_split_string,
    add_settlement_selected_log = dev_add_settlement_select_log_call,
    add_character_selected_log = dev_add_character_select_log_call,
    as_read_only = dev_readonlytable,
    first_tick = dev_first_tick,
    new_game = dev_new_game_callback,
    pre_first_tick = dev_pre_first_tick,
    post_first_tick = dev_post_first_tick,
    is_game_created = dev_game_created,
    is_new_game = dev_is_new_game,
    turn_start = dev_turn_start,
    trait_turn_start = dev_char_with_trait_turn_start,
    region_turn_start = dev_region_turn_start,
    respond_to_incident = dev_respond_to_incident,
    respond_to_dilemma = dev_respond_to_dilemma,
    respond_to_mission_issued = dev_respond_to_mission_issued,
    last_time_sacked = dev_last_time_sacked,
    get_numbers_from_text = dev_get_numbers_from_text,
    invasion_number = dev_invasion_number,
    army_size = dev_army_size,
    generate_force_cache_entry = dev_generate_force_cache_entry,
    create_army = dev_create_army,
    distance = dev_distance_2D,
    is_character_near_region = dev_is_character_near_region, 
    did_character_retreat_from_last_battle = dev_did_character_retreat_from_last_battle,
    spawn_blockers = SPAWN_BLOCKERS,
    clear_spawn_blockers = dev_clear_spawn_blockers,
    set_factions_hostile =  dev_SetFactionsHostile,
    reset_faction_diplomatic_stance = dev_ResetFactionDiplomaticStance,
    lock_war_declaration_for_faction = dev_lockWarDeclarationsForFaction,
    lock_confederation_for_faction = dev_lockConfederationForFaction,
    lock_diplomacy_for_faction = dev_LockDiplomacyForFaction
}