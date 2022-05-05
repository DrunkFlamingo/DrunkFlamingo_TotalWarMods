local log_tab = 0
--v function(t: any, loud: boolean?)
local function log(t, loud)
    if (not CONST.__should_output_save_load) and (not loud) then
        return
    end
    output_text = tostring(t) --:string
   
    dev.log(output_text, "SAVEGAME")
end



local GAME_LOADED = false --:boolean
local OBJECTS_PENDING = {} --:vector<WHATEVER>
local SAVED_DATA = {} --:map<string, table>
local SAVE_CALLBACKS = {} --:vector<function(context:WHATEVER)>
local DATA_TO_LOAD = {} --:vector<string>

--v function(name: string, data: any, context: WHATEVER)
local function save_data(name, data, context)
    cm:save_value(name, data, context)
    table.insert(DATA_TO_LOAD, name)
end

--v function(name: string) --> WHATEVER
local function load_data(name)
    return SAVED_DATA[name] or {}
end

--v function(callback: function(context:WHATEVER))
local function add_saving_callback(callback)
    table.insert(SAVE_CALLBACKS, callback)
end


--v function(obj: WHATEVER)
local function load_object(obj)
    --load callback on attachment
    local ok, err = pcall(function()
        local saved_table = load_data(obj.save.name)
        log("loading object: "..obj.save.name)
        if obj.save.is_tabsvr_dummy then
            for k, v in pairs(saved_table.tabsvr or {}) do
                log("\tLoading field: "..k.." with type "..type(v).." value "..tostring(v))
                obj.tabsvr[k] = v
            end
        else
            for k,v in pairs(saved_table) do
                if CONST.__should_output_save_load then
                    if type(v) == table then
                        log("\tLoading field: "..k.." with type "..type(v))
                    else
                        log("\tLoading field: "..k.." with type "..type(v).." value "..tostring(v))
                    end
                end
                obj[k] = v
            end
        end
    end) 
    if not ok then
        log("Error loading object:", true)
        log(err, true)
        log(debug.traceback(), true)
        log_tab = 0 
    elseif obj.save.callback then
        local ok, err = pcall(function()
            obj.save.callback(obj)
        end)
        if not ok then
            log("Error in object load callback:", true)
            log(err, true)
            log(debug.traceback(), true)
        end
    end
end




--v function(obj: WHATEVER)
local function attach(obj)
    if not obj.save then
        log("Attempted to attach to an object without a savable fields schema", true)
        return
    end
    --save callback
    add_saving_callback(function(context) 
        local ok, err = pcall(function()
            local savable_table = {} --:map<string, WHATEVER>
            log("Saving object: "..obj.save.name)
            for i = 1, #obj.save.for_save do
                log("\tSaving field: ".. obj.save.for_save[i] .." of type "..type(obj[obj.save.for_save[i]]))
                savable_table[obj.save.for_save[i]] = obj[obj.save.for_save[i]]
            end
            save_data(obj.save.name, savable_table, context)
        end) 
        if not ok then
            log("Error savng object:")
            log(err, true) log(debug.traceback())
            log_tab = 0  
        end
    end)
    --load any data about this object we happen to be storing.
    if GAME_LOADED then
        load_object(obj)
    else
        OBJECTS_PENDING[#OBJECTS_PENDING+1] = obj
    end
end

if not CONST.__do_not_save_or_load then
    cm:register_loading_game_callback(function(context)
        local x = os.clock()
        local data_to_load = cm:load_value("SHIELDWALL_SAVE", {}, context)
        --# assume data_to_load: vector<string>
        log("Loading the game!", true)
        for i = 1, #data_to_load do
            SAVED_DATA[data_to_load[i]] = cm:load_value(data_to_load[i], {}, context)
        end
        GAME_LOADED = true
        for i = 1, #OBJECTS_PENDING do
            load_object(OBJECTS_PENDING[i])
        end
        log(string.format("Loading game complete: elapsed time: %.4f\n", os.clock() - x))
    end)

    cm:register_saving_game_callback(function(context)
        local x = os.clock()
        DATA_TO_LOAD = {}
        for i = 1, #SAVE_CALLBACKS do
            SAVE_CALLBACKS[i](context)
        end
        cm:save_value("SHIELDWALL_SAVE", DATA_TO_LOAD, context)
        log(string.format("Saving game complete: elapsed time: %.4f\n", os.clock() - x))
    end)
end

--v function(t: WHATEVER, t_name: string)
local function create_dummy_object_for_table_and_attach(t, t_name)
    local dummy_object = {}

    dummy_object.tabsvr = t
    dummy_object.save = {
            name = t_name,
            for_save = {"tabsvr"},
            is_tabsvr_dummy = true
        }
    attach(dummy_object)
end



--v [NO_CHECK] function(t:table, name: string, loadcall: function(t: WHATEVER))
local function persist_table(t, name, loadcall)
    log("Registered persistant table: "..name)
    cm:register_loading_game_callback(function(context)
        local temp = cm:load_value(name, t, context)
        loadcall(temp)
    end)

    cm:register_saving_game_callback(function(context)
        cm:save_value(name, t, context)
    end)
end

--v function(name: string, savecall: function() --> WHATEVER, loadcall: function(t: WHATEVER))
function save_value(name, savecall, loadcall)
    cm:register_loading_game_callback(function(context)
        local temp = cm:load_value(name, savecall(), context)
        log("Loaded simple value: "..name.." as "..tostring(temp))
        loadcall(temp)
    end)

    cm:register_saving_game_callback(function(context)
        local item = savecall()
        log("Saving simple value: "..name.." as "..tostring(item))
        cm:save_value(name, item, context)
    end)
end

return {
    attach_to_object = attach,
    attach_to_table = create_dummy_object_for_table_and_attach,
    save_value = save_value
}