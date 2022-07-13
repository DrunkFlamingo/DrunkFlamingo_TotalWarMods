---Section: Type Declarations

--demand return details.
---@alias DEMAND_RETURN_DETAIL {player: string, region: string, conqueror: string, elector_faction: string}


--faction states:
---@alias EOM_FACTION_STATE "emperor"|"normal"|"civil_war_leader"|"civil_war_enemy"|"civil_war_ally"|"rebel"|"minor" 
--[[
    Emperor: This is Karl Franz by default. 
    Normal: This faction is within the Empire.
    Civil War Leader: This faction is the main enemy of a civil war.
    Civil War Enemy: This faction is a secondary enemy in the civil war
    Civil War Ally: This faction is an ally in the civil war.
    Rebel: This faction is outside of the Empire.
    Minor: This faction obeys the emperor (for demanding region swaps, demanding peace, etc.) but otherwise does not act as an elector count. 
--]]
---@alias EOM_FACTION {key: string, state: EOM_FACTION_STATE, rival: string}

---Section: Utility Functions

---output to file
---@param t string|any
local function out(t)
    ModLog("DRUNKFLAMINGO: "..tostring(t).." (tabletopcaps)")
end
  
---output to file if passed statement is true
---@param statement boolean
---@param message string|any
local function out_if(statement, message)
    if statement then 
        out(message)
    end
end

--- load a lua file with the correct environment
--- ie. load_module("test", "script/my_folder/") to load script/my_folder/test.lua
---@param file_name string
---@param file_path string
---@return any
local function load_module(file_name, file_path)
    local full_path = file_path.. file_name.. ".lua"
    local file, load_error = loadfile(full_path)
  
    if not file then
        out("Attempted to load module with name ["..file_name.."], but loadfile had an error: ".. load_error .."")
    else
        out("Loading module with name [" .. file_name.. ".lua]")
  
        local global_env = core:get_env()
        setfenv(file, global_env)
        local lua_module = file(file_name)
  
        if lua_module ~= false then
            out("[" .. file_name.. ".lua] loaded successfully!")
        end
  
        return lua_module
    end
  
    -- run "require" to see what the specific error is
    local ok, msg = pcall(function() require(file_path .. file_name) end)
  
    if not ok then
        out("Tried to load module with name [" .. file_name .. ".lua], failed on runtime. Error below:")
        out(msg)
        return false
    end
  end
  
  ---load all of the lua files from a specific folder
  --- ie. load_modules("script/my_folder/") to load everything in ?.pack/script/my_folder/
  --- code shamelessly stolen from Vandy <3
  ---@param path string
  local function load_modules(path)
  local search_override = "*.lua" -- search for all files that end in .lua within this path
  local file_str = common.filesystem_lookup(path, search_override)
  
    for filename in string.gmatch(file_str, '([^,]+)') do
        local filename_for_out = filename
  
        local pointer = 1
        while true do
            local next_sep = string.find(filename, "\\", pointer) or string.find(filename, "/", pointer)
  
            if next_sep then
                pointer = next_sep + 1
            else
                if pointer > 1 then
                    filename = string.sub(filename, pointer)
                end
                break
            end
        end
  
        local suffix = string.sub(filename, string.len(filename) - 3)
  
        if string.lower(suffix) == ".lua" then
            filename = string.sub(filename, 1, string.len(filename) -4)
        end
  
  
        load_module(filename, string.gsub(filename_for_out, filename..".lua", ""))
    end
  end
  

---Section: Database entries

local fealty_resource_key = ""
local authority_resource_key = ""

---Section: Model

---@class EOM_MODEL
local eom = {} 

---called during startup when the script is loaded.
---@return EOM_MODEL
function eom.init()
    local self = {} ---@class EOM_MODEL
    setmetatable(self, {__index = eom})

    self.factions = {} ---@type table<string, EOM_FACTION>
    self.emperor_key = "" ---@type string
    --demand return system; mostly copied 1-1 from CAs demand return system.
    self.demand_return_queue = {} ---@type DEMAND_RETURN_DETAIL[]
    self.demand_return_details = {} ---@type DEMAND_RETURN_DETAIL
    --civil war system
    self.is_civil_war_active = false ---@type boolean
    self.civil_war_leader_faction_key = "" ---@type string
    self.civil_war_turn_occured = -1 ---@type integer

    --event supression - plot events use these fields to suppress other events.
    self.civil_war_supressors = {}
    self.feud_supressors = {}
    self.border_war_supressors = {}

    return self
end

---Get the EOM_FACTION entry for a given faction by key or by Game Interface Object.
---@param faction_key_or_object string|FACTION_SCRIPT_INTERFACE
---@return EOM_FACTION
function eom:get_faction(faction_key_or_object)
    --check validity of arguments
    local faction_key 
    if type(faction_key_or_object) == "string" then
        faction_key = faction_key_or_object
    elseif is_faction(faction_key_or_object) then
        faction_key = faction_key_or_object:name()
    end
    if not faction_key then
        out("get_faction: Invalid faction key or object passed to eom:get_faction")
        return nil
    end
    if not self.factions[faction_key] then
        out("get_faction: No faction with key ["..faction_key.."] found in eom:get_faction")
        return nil
    else
        return self.factions[faction_key]
    end
end

---Get the EOM_FACTION entry for the emperor.
---@return EOM_FACTION
function eom:get_emperor()
    if self.factions[self.emperor_key] then
        return self.factions[self.emperor_key]
    else
        out("Could not get the Emperor's EOM entry because there is no Emperor!")
        return nil
    end
end

---get the EOM_FACTION entry for the civil war leader
---@return EOM_FACTION
function eom:get_civil_war_leader()
    if self.factions[self.civil_war_leader_faction_key] then
        return self.factions[self.civil_war_leader_faction_key]
    else
        out("Could not get the Civil War Leader's EOM entry because there is no Civil War Leader!")
        return nil
    end
end

---get the fealty resource object for a given faction
---@param faction_arg string|EOM_FACTION|FACTION_SCRIPT_INTERFACE
---@return POOLED_RESOURCE_SCRIPT_INTERFACE
function eom:get_fealty_object_for_faction(faction_arg)
    --check validity of arguments
    local faction_key
    if type(faction_arg) == "string" then 
        faction_key = faction_arg
    elseif is_faction(faction_arg) then
        faction_key = faction_arg:name()
    elseif faction_arg.key then
        faction_key = faction_arg.key
    end
    if not faction_key then
        out("Failed to get the fealty object, the faction passed in was not FACTION_SCRIPT_INTERFACE, nor an EOM_FACTION object, nor a string key for a valid EOM_FACTION object.")
        return cm:null_interface()
    end
    --check that the faction is valid
    local faction_interface = cm:get_faction(faction_key)
    if not faction_interface or faction_interface:pooled_resource_manager():resource(fealty_resource_key):is_null_interface() then
        out("Failed to get fealty, the faction passed in ("..faction_key..") either did not exist or did not have a fealty resource.")
        return cm:null_interface()
    else
        return faction_interface:pooled_resource_manager():resource(fealty_resource_key)
    end
end

---get the fealty value for a given faction.
---@param faction string|EOM_FACTION|FACTION_SCRIPT_INTERFACE
---@return integer
function eom:get_fealty_value_for_faction(faction)
    local fealty =  eom:get_fealty_object_for_faction()
    if not fealty:is_null_interface() then
        return fealty:value()
    else
        return 0
    end
end

---modify the fealty value of the given faction
---@param faction_arg string|EOM_FACTION|FACTION_SCRIPT_INTERFACE
---@param factor string
---@param value integer
---@return boolean
function eom:modify_fealty(faction_arg, factor, value)
    --check validity of arguments
    local fealty_object = eom:get_fealty_object_for_faction(faction_arg)
    if fealty_object:is_null_interface() then
        out("Failed to modify fealty, the faction passed in ("..tostring(faction_arg)..") either did not exist or did not have a fealty resource.")
        return false
    end
    if not factor then
        --TODO: add a check to make sure the factor passed to this function is a valid factor.
        out("Failed to modify fealty, the factor passed ("..tostring(factor)..") in was not a valid factor")
        return false
    end
    if not is_integer(value) then
        out("Failed to modify fealty, the value passed in was not an integer.")
        return false
    end 
    local faction_key = fealty_object:manager():owning_faction():name()
    --apply fealty change
    cm:faction_add_pooled_resource(faction_key, fealty_resource_key, factor, value)
    out("Fealty modified for faction ["..faction_key.."] by ["..value.."] with factor ["..factor.."]")
    return true
end

---get the authority resource object for a given faction
---@param faction_arg string|EOM_FACTION|FACTION_SCRIPT_INTERFACE
---@return POOLED_RESOURCE_SCRIPT_INTERFACE
function eom:get_authority_object_for_faction(faction_arg)
    --check validity of arguments
    local faction_key
    if type(faction_arg) == "string" then 
        faction_key = faction_arg
    elseif is_faction(faction_arg) then
        faction_key = faction_arg:name()
    elseif faction_arg.key then
        faction_key = faction_arg.key
    end
    if not faction_key then
        out("Failed to get the authority object, the faction passed in was not FACTION_SCRIPT_INTERFACE, nor an EOM_FACTION object, nor a string key for a valid EOM_FACTION object.")
        return cm:null_interface()
    end
    --check that the faction is valid
    local faction_interface = cm:get_faction(faction_key)
    if not faction_interface or faction_interface:pooled_resource_manager():resource(authority_resource_key):is_null_interface() then
        out("Failed to get authority, the faction passed in ("..faction_key..") either did not exist or did not have a authority resource.")
        return cm:null_interface()
    else
        return faction_interface:pooled_resource_manager():resource(authority_resource_key)
    end
end

---get the authority value for a given faction.
---@param faction string|EOM_FACTION|FACTION_SCRIPT_INTERFACE
---@return integer
function eom:get_authority_value_for_faction(faction)
    local authority =  eom:get_authority_object_for_faction()
    if not authority:is_null_interface() then
        return authority:value()
    else
        return 0
    end
end

---modify the authority value of the given faction
---@param faction_arg string|EOM_FACTION|FACTION_SCRIPT_INTERFACE
---@param factor string
---@param value integer
---@return boolean
function eom:modify_authority(faction_arg, factor, value)
    --check validity of arguments
    local authority_object = eom:get_authority_object_for_faction(faction_arg)
    if authority_object:is_null_interface() then
        out("Failed to modify authority, the faction passed in ("..tostring(faction_arg)..") either did not exist or did not have a authority resource.")
        return false
    end
    if not factor then
        --TODO: add a check to make sure the factor passed to this function is a valid factor.
        out("Failed to modify authority, the factor passed ("..tostring(factor)..") in was not a valid factor")
        return false
    end
    if not is_integer(value) then
        out("Failed to modify authority, the value passed in was not an integer.")
        return false
    end 
    local faction_key = authority_object:manager():owning_faction():name()
    --apply authority change
    cm:faction_add_pooled_resource(faction_key, authority_resource_key, factor, value)
    out("authority modified for faction ["..faction_key.."] by ["..value.."] with factor ["..factor.."]")
    return true
end

---gets the intended diplomatic permission for the given faction to the given target faction based on their state.
---@param first_faction EOM_FACTION
---@param second_faction EOM_FACTION
function eom:apply_diplomacy_permission_between_factions(first_faction, second_faction)
    out("Updating diplomacy permissions for faction ["..first_faction.key.."]:["..first_faction.state.."] and ["..second_faction.key.."]:["..second_faction.state.."]")
    if first_faction.key == second_faction.key then
        out("Failed to update diplomacy permissions, the factions passed in were the same.")
        return
    end
    local first_faction_interface = cm:get_faction(first_faction.key)
    local first_faction_is_human = first_faction_interface:is_human()
    local second_faction_interface = cm:get_faction(second_faction.key)
    local second_faction_is_human = second_faction_interface:is_human()

    --confederation and vassalage
    if first_faction.state == "emperor" then
        --the emperor can confederate factions whose fealty is at maximum.
        if self:get_fealty_value_for_faction(second_faction) < 10 then
            cm:force_diplomacy(first_faction.key, second_faction.key, "vassal", false, true, false)
            cm:force_diplomacy(first_faction.key, second_faction.key, "form confederation", false, true, false)
        else
            cm:force_diplomacy(first_faction.key, second_faction.key, "vassal", true, true, false)
            cm:force_diplomacy(first_faction.key, second_faction.key, "form confederation", true, true, false)
        end
    else 
        --nobody else can confederate or vassalize within the Empire.
        cm:force_diplomacy(first_faction.key, second_faction.key, "vassal", false, true, false)
        cm:force_diplomacy(first_faction.key, second_faction.key, "form confederation", false, true, false)
        if second_faction.state == "emperor" then
            --whether or not they can break treaties with the Emperor is based on their fealty.
            local fealty = self:get_fealty_value_for_faction(first_faction) --this returns 0 if they have no access to this resource.
            if fealty > 6 then
                cm:force_diplomacy(first_faction.key, second_faction.key, "break non aggression pact", false, true, false)
                cm:force_diplomacy(first_faction.key, second_faction.key, "break defensive alliance", false, true, false)
                cm:force_diplomacy(first_faction.key, second_faction.key, "break trade", false, true, false)
                if fealty > 8 then
                    cm:force_diplomacy(first_faction.key, second_faction.key, "break vassal", false, true, false)
                    cm:force_diplomacy(first_faction.key, second_faction.key, "break alliance", false, true, false)
                else
                    cm:force_diplomacy(first_faction.key, second_faction.key, "break vassal", true, true, false)
                    cm:force_diplomacy(first_faction.key, second_faction.key, "break alliance", true, true, false)
                end
            else
                cm:force_diplomacy(first_faction.key, second_faction.key, "break non aggression pact", true, true, false)
                cm:force_diplomacy(first_faction.key, second_faction.key, "break defensive alliance", true, true, false)
                cm:force_diplomacy(first_faction.key, second_faction.key, "break trade", true, true, false)
            end
        end
    end

    --war and peace.
    if first_faction.state == "emperor" then
        --The Emperor...
        if second_faction.state == "civil_war_leader" or second_faction.state == "civil_war_ally" then
            --cannot make peace with civil war enemies.
            cm:force_diplomacy(first_faction.key, second_faction.key, "war", true, true, false)
            cm:force_diplomacy(first_faction.key, second_faction.key, "peace", false, true, false)
        else
            --but otherwise has free diplomacy
            cm:force_diplomacy(first_faction.key, second_faction.key, "war", true, true, false)
            cm:force_diplomacy(first_faction.key, second_faction.key, "peace", true, true, false)
        end
    elseif first_faction.state == "rebel" or first_faction.state == "minor" then
        --rebel and minor factions have free diplomacy
        cm:force_diplomacy(first_faction.key, second_faction.key, "war", true, true, false)
        cm:force_diplomacy(first_faction.key, second_faction.key, "peace", true, true, false)
    elseif first_faction.state == "civil_war_leader" then
        --civil war leaders cannot make peace with the Emperor, and cannot declare war on civil war enemies.
        if second_faction.state == "emperor" or second_faction.state == "civil_war_ally" then
            --cannot make peace with the emperor or other civil war allies.
           cm:force_diplomacy(first_faction.key, second_faction.key, "peace", false, true, false)
           cm:force_diplomacy(first_faction.key, second_faction.key, "war", true, true, false)
        elseif second_faction.state == "civil_war_leader" or second_faction.state == "civil_war_enemy" then
            --cannot declare war on other civil war enemies, unless they're human.
            cm:force_diplomacy(first_faction.key, second_faction.key, "war", first_faction_is_human, true, false)
            cm:force_diplomacy(first_faction.key, second_faction.key, "peace", true, true, false)
        end
    elseif first_faction.state == "civil_war_enemy" then
        --civil war enemies...
        if second_faction.state == "emperor" or second_faction.state == "civil_war_ally" then
            --cannot make peace with the emperor or other civil war allies.
           cm:force_diplomacy(first_faction.key, second_faction.key, "peace", false, true, false)
           cm:force_diplomacy(first_faction.key, second_faction.key, "war", true, true, false)
        elseif second_faction.state == "civil_war_leader" or second_faction.state == "civil_war_enemy" then
            --cannot declare war on other civil war enemies, or the leader, unless they're human.
            cm:force_diplomacy(first_faction.key, second_faction.key, "war", first_faction_is_human, true, false)
            cm:force_diplomacy(first_faction.key, second_faction.key, "peace", true, true, false)
        end
     elseif first_faction.state == "civil_war_ally" then
        --civil war allies...
        if second_faction.state == "emperor" or second_faction.state == "civil_war_ally" then
            --cannot declare war on the Emperor or his other allies, unless they're human.
            cm:force_diplomacy(first_faction.key, second_faction.key, "war", first_faction_is_human, true, false)
            cm:force_diplomacy(first_faction.key, second_faction.key, "peace", true, true, false)
        elseif second_faction.state =="civil_war_leader" or second_faction.state == "civil_war_enemy" then
            --can declare war on civil war enemies, leaders and cannot make peace with them
            cm:force_diplomacy(first_faction.key, second_faction.key, "war", true, true, false)
            cm:force_diplomacy(first_faction.key, second_faction.key, "peace", false, true, false)
        elseif second_faction.state == "rebel" then
            --can declare war and peace with rebels
            cm:force_diplomacy(first_faction.key, second_faction.key, "war", true, true, false)
            cm:force_diplomacy(first_faction.key, second_faction.key, "peace", true, true, false)
        end
    elseif first_faction.state == "normal" then
        --normal factions...
        if second_faction.state == "emperor" then
            --cannot declare war on the Emperor unless they're human, but can always make peace with them.
            cm:force_diplomacy(first_faction.key, second_faction.key, "war", first_faction_is_human, true, false)
            cm:force_diplomacy(first_faction.key, second_faction.key, "peace", true, true, false)
        elseif second_faction.state == "rebel" then
            --can declare war on rebels or make peace with them
            cm:force_diplomacy(first_faction.key, second_faction.key, "war", true, true, false)
            cm:force_diplomacy(first_faction.key, second_faction.key, "peace", true, true, false)
        else
            if first_faction_is_human or eom:get_authority_value_for_faction(eom:get_emperor()) < 0 then
                --can declare war on normal factions if the emperor has negative authority, or if they're human.
                cm:force_diplomacy(first_faction.key, second_faction.key, "war", true, true, false)
                cm:force_diplomacy(first_faction.key, second_faction.key, "peace", true, true, false)
            elseif first_faction.rival == second_faction.key then
                -- can declare war on their rivals.
                cm:force_diplomacy(first_faction.key, second_faction.key, "war", true, true, false)
                cm:force_diplomacy(first_faction.key, second_faction.key, "peace", true, true, false)
            else
                --cannot declare war on normal factions if the emperor has positive authority and they are not rivals.
                cm:force_diplomacy(first_faction.key, second_faction.key, "war", false, true, false)
                cm:force_diplomacy(first_faction.key, second_faction.key, "peace", true, true, false)
            end
        end
    end
end

---updates all diplomacy permissions between a specific faction and all other factions.
---@param faction EOM_FACTION
function eom:update_diplomacy_permissions_for_faction(faction)
    out("Updating diplomacy permissions for faction ["..faction.key.."]")
    for other_key, other_faction in pairs(self.factions) do
        if other_key ~= faction.key then
            self:apply_diplomacy_permission_between_factions(faction, other_faction)
        end
    end
end

---loops through the list of factions in the model and sets up their diplomacy with each other.
function eom:update_all_diplomacy_permissions()
    for first_faction_key, first_faction in pairs(self.factions) do
        out("Updating diplomacy permissions for faction ["..first_faction_key.."]")
        for second_faction_key, second_faction in pairs(self.factions) do
            if first_faction_key ~= second_faction_key then
                self:apply_diplomacy_permission_between_factions(first_faction, second_faction)
            end
        end
    end
end

--changes a factions state to civil war enemy, aligning them with the civil war leader.
---@param faction EOM_FACTION
function eom:set_faction_to_civil_war_enemy(faction)
    local leader = self:get_civil_war_leader()
    if (not leader) then
        out("No civil war leader found, cannot set faction ["..faction.key.."] to civil war enemy. Check that a civil war is currently active!")
        return
    end
    out("Setting faction ["..faction.key.."] to civil war enemy, joining the civil war led by ["..leader.key.."]")
    faction.state = "civil_war_enemy"
    --TODO join the civil war.
    self:update_diplomacy_permissions_for_faction(faction)
end

--changes a factions state to civil war leader, finds allies and enemies and applies related changes.
---@param faction EOM_FACTION
function eom:change_state_to_civil_war_leader(faction)
    out("Making faction ["..faction.key.."] civil war leader.")
    faction.state = "civil_war_leader"
    self.civil_war_leader_faction_key = faction.key
    --TODO: find civil war allies and enemies.
    self:update_all_diplomacy_permissions()
end


--changes a faction's state to rebel and applies related changes.
---@param faction EOM_FACTION
function eom:change_state_to_rebel(faction)
    out("Making faction ["..faction.key.."] rebel.")
    if faction.state == "rebel" then
        out("Faction ["..faction.key.."] is already rebel.")
        return
    elseif faction.state == "emperor" or faction.state == "minor" or faction.state == "civil_war_leader" then
        out("Faction ["..faction.key.."] cannot become a rebel from their current state: ["..faction.state.."].")
    elseif faction.state == "civil_war_ally" then
        --if a civil war ally meets conditions to become rebel, they become a civil war enemy instead.
        out("Faction ["..faction.key.."] is a civil war ally, changing state to civil war enemy.")
    end
    faction.state = "rebel"
    self:update_diplomacy_permissions_for_faction(faction)
    --TODO secession events
end

---changes a factions' state to Emperor, ends the related civil war, and applies related changes.
---@param faction EOM_FACTION
function eom:change_state_to_emperor(faction)
    out("Making faction ["..faction.key.."] emperor.")
    faction.state = "emperor"
    --TODO civil war resolution
end




---called on FirstTickAfterWorldCreated, only in new campaigns.
---loads data from the /eom folder to set the starting scenario.
function eom:setup_new_game()
    local faction_data = load_module("eom_faction_data", "script/eom/")
    --unpack the starting situation data 
    for _, this_faction_data in pairs(faction_data) do
        --create an entry in the model for this faction
        out("Creating faction entry for "..this_faction_data.key)
        local faction_interface = cm:get_faction(this_faction_data.key)
        if not faction_interface or faction_interface:is_null_interface() then
            out("Faction "..this_faction_data.key.." is not available in the current campaign.")
            out("New Game Setup Failed")
            script_error("Empire of Man Script Startup Failure. See ModLog")
        end
        local this_faction_object = {} ---@type EOM_FACTION
        this_faction_object.key = this_faction_data.key

        --For AI, select a random rival from the potential rivals to assign
        if not faction_interface:is_human() then
            local rival_index = cm:random_number(#this_faction_data.potential_rivals)
            this_faction_object.rival = this_faction_data.potential_rivals[rival_index]
            out("Assigning rival "..this_faction_object.rival.." to "..this_faction_object.key)
        end

        --set the faction state
        this_faction_object.state = this_faction_data.state
        out("Faction state starts in state: "..this_faction_object.state)
        if this_faction_object.state == "emperor" then
            self.emperor_key = this_faction_object.key
            out("Setting starting emperor key to "..self.emperor_key)
        end

        --apply the base fealty amount to the faction
        if this_faction_data.base_fealty > 0 then
            self:modify_fealty(this_faction_object, "base_fealty", this_faction_data.base_fealty)
        end
        --add the entry to the model
        self.factions[this_faction_object.key] = this_faction_object
        out("Faction "..this_faction_object.key.." created successfully!")
    end
    --update all diplomacy permissions
    self:update_all_diplomacy_permissions()
end

---called at FirstTickAfterWorldCreated
function eom:start()
    --load the starting situation data if this is a new campaign.
    if cm:is_new_game() then
        eom.setup_new_game()
    end
end

function eom:add_first_tick_callback()
    cm:add_first_tick_callback(function()
        self:start()
    end)
end

eom.init():add_first_tick_callback()