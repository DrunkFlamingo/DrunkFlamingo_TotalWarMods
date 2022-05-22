--handles script simulated resources (ex. heroism, population, hoards)
local faction_resource = {} --# assume faction_resource: FACTION_RESOURCE


--v function(faction_name: string, resource_key: string, kind: RESOURCE_KIND, default_value: int, cap_value: int,
--v converter: (function(self: FACTION_RESOURCE)--> string)?) --> FACTION_RESOURCE
function faction_resource.new(faction_name, resource_key, kind, default_value, cap_value, converter)
    local self = {}
    setmetatable(self, {
        __index = faction_resource
    }) --# assume self: FACTION_RESOURCE
    dev.log("Creating resource ["..resource_key.."] for faction ["..faction_name.."] of kind ["..kind.."]")
    self.owning_faction = faction_name
    self.key = resource_key
    self.kind = kind
    self.value = default_value
    self.cap_value = cap_value
    self.last_bundle = nil --:string
    self.full_cap_is_negative = false --:boolean
    self.human_only = true --:boolean
    self.conversion_function = converter or function(self) --:FACTION_RESOURCE
         return tostring(self.value) 
    end
    self.breakdown_factors = {} --:map<string, int>
    self.uic_override = nil --:vector<string>
    self.save = {
        name = self.key .. self.owning_faction, 
        for_save = {"breakdown_factors", "value", "last_bundle", "cap_value"}
    }--:SAVE_SCHEMA
    dev.Save.attach_to_object(self)
    return self
end

--v function(self: FACTION_RESOURCE, t: any)
function faction_resource.log(self, t)
    dev.log(tostring(t), self.key)
end

--v function(kind: RESOURCE_KIND) --> function(self: FACTION_RESOURCE)
local function get_applicator_for_kind(kind)
    local switch = {
        population = function(self) --:FACTION_RESOURCE
            local setter = UIScript.culture_mechanics["population"]
            if setter then
                local new_bundle = self.key .. "_" .. self.conversion_function(self)
                if self.last_bundle then
                    cm:remove_effect_bundle(self.last_bundle, self.owning_faction)
                end
                setter(self.owning_faction, new_bundle, self.value, self.breakdown_factors, self.uic_override)
                self.last_bundle = new_bundle
            else
                self:log("Could not find a setter function for this kind!")
            end
        end,
        capacity_fill = function(self) --:FACTION_RESOURCE
            local setter = UIScript.culture_mechanics["capacity_fill"]
            if setter then
                local new_bundle = self.key .. "_" .. self.conversion_function(self)
                if self.last_bundle then
                    cm:remove_effect_bundle(self.last_bundle, self.owning_faction)
                end
                setter(self.owning_faction, new_bundle, self.value, self.cap_value)
                self.last_bundle = new_bundle
            else
                self:log("Could not find a setter function for this kind!")
            end
        end,
        resource_bar = function(self) --:FACTION_RESOURCE
            local setter = UIScript.culture_mechanics["resource_bar"]
            if setter then
                local new_bundle = self.key .. "_" .. self.conversion_function(self)
                if self.last_bundle then
                    cm:remove_effect_bundle(self.last_bundle, self.owning_faction)
                end
                setter(self.owning_faction, new_bundle, self.value, self.cap_value, self.breakdown_factors)
                self.last_bundle = new_bundle
            else
                self:log("Could not find a setter function for this kind!")
            end
        end,
        faction_focus = function(self) --:FACTION_RESOURCE
            local setter = UIScript.culture_mechanics["faction_focus"]
            if setter then
                local true_value = self.conversion_function(self)
                local new_bundle = self.key .. "_" .. true_value
                if self.last_bundle then
                    cm:remove_effect_bundle(self.last_bundle, self.owning_faction)
                end
                if tonumber(true_value) > 0 then
                    cm:apply_effect_bundle(new_bundle, self.owning_faction, 0)
                    self.last_bundle = new_bundle
                end
                setter(self.owning_faction, new_bundle, self.value, self.cap_value, self.breakdown_factors)
            else
                self:log("Could not find a setter function for this kind!")
            end
        end,
        imaginary = function(self) --:FACTION_RESOURCE
            local new_bundle = self.key .. "_" .. self.conversion_function(self)
            if self.last_bundle and self.last_bundle ~= new_bundle then
                cm:remove_effect_bundle(self.last_bundle, self.owning_faction)
            end
            cm:apply_effect_bundle(new_bundle, self.owning_faction, 0)
        end
    }--:map<RESOURCE_KIND, function(self: FACTION_RESOURCE)>
    return switch[kind]
end

--v [NO_CHECK] function(kind: RESOURCE_KIND) --> (function(self: FACTION_RESOURCE, arg: WHATEVER))
local function get_setter_for_kind(kind)
    local switch = {
        population = function(self, arg)
            if not (type(arg[1]) == "number") then
                self:log("Set new value for called but supplied arg #2 is not a number")
            else
                self.value = arg[1]
            end
        end,
        capacity_fill = function(self, arg)
            if type(arg[1]) == "number" and type(arg[2]) == "number" then
                self.value = arg[1]
                self.cap_value = arg[2]
            else
                self:log("Set new value called but supplied args are incorrectly typed: expected two numbers")
            end
        end,
        resource_bar = function(self, arg)
            if not (type(arg[1]) == "number") then
                self:log("Set new value for called but supplied arg #2 is not a number")
            else
                self.value = arg[1]
            end
        end,
        faction_focus = function(self, arg)
            if not (type(arg[1]) == "number") then
                self:log("Set new value for called but supplied arg #2 is not a number")
            else
                self.value = arg[1]
            end
        end,
        imaginary = function(self, arg)
            if not (type(arg[1]) == "number") then
                self:log("Set new value for called but supplied arg #2 is not a number")
            else
                self.value = arg[1]
            end
        end,
    }--:map<RESOURCE_KIND, function(self: FACTION_RESOURCE, any...)>
    return switch[kind]
end

--v function(self: FACTION_RESOURCE, ...:any)
function faction_resource.set_new_value(self, ...)
    local arg = dev.arg(...)
    local argtext =  "" for k,v in pairs(arg) do argtext = argtext..tostring(k)..":"..tostring(v)..";" end 
    self:log("Set new value called with args: "..argtext)
    
    if not dev.is_game_created() then
        self:log("Cannot apply values before first tick has begun!")
    elseif (not dev.get_faction(self.owning_faction):is_human()) and (not self.kind == "imaginary") then
        return --AI only get through using imaginary type
    end

    local value_func = get_setter_for_kind(self.kind)
    local applicator_func = get_applicator_for_kind(self.kind)
    if value_func and applicator_func then
        value_func(self, arg)
        applicator_func(self)
        dev.eh:trigger_event("FactionResourceValueChanged", dev.get_faction(self.owning_faction), self.key)
    else
        self:log("Set new value called with unrecognized mechanic kind: "..self.kind)
    end
end

--v function(self: FACTION_RESOURCE, change_value: number, factor: string?)
function faction_resource.change_value(self, change_value, factor)
    --round new value if it is not an integer, then clamp to maximum and 0.
    local new_value = dev.mround(dev.clamp(self.value + change_value, 0, self.cap_value), 1)
    if factor then
        --# assume factor: string!
        self.breakdown_factors[factor] =( self.breakdown_factors[factor] or 0) + dev.mround(change_value, 1)
    end
    --faction focus and resource bar have cap value, but those caps are static.
    if self.kind == "capacity_fill" then
        self:set_new_value(new_value, self.cap_value)
    else
        self:set_new_value(new_value)
    end
end

--this function DOES NOT reapply any bundles or make proper changes. It expects you to call *either* reapply or a change value.
--v function(self: FACTION_RESOURCE, factor: string)
function faction_resource.clear_factor(self, factor)
    local factor_value = self.breakdown_factors[factor] or 0
    self.value = dev.mround(self.value - factor_value, 1)
end

--this function DOES NOT reapply any bundles or make proper changes. It expects you to call *either* reapply or a change value.
--v function(self: FACTION_RESOURCE, factor: string, value: int)
function faction_resource.set_factor(self, factor, value)
    self:clear_factor(factor)
    self.breakdown_factors[factor] = value
    self.value = dev.mround(self.value + value, 1)
end

--v function(self: FACTION_RESOURCE, factor: string) --> int
function faction_resource.get_factor(self, factor)
    return self.breakdown_factors[factor] or 0
end


--v function(self: FACTION_RESOURCE)
function faction_resource.reapply(self)
    local applicator_func = get_applicator_for_kind(self.kind)
    if applicator_func then
        applicator_func(self)
    else
        self:log("Reapply called with unrecognized mechanic kind: "..self.kind)
    end
end


local instances = {} --:map<string, map<string, FACTION_RESOURCE>>

--v function(faction_name: string, resource_key: string, kind: RESOURCE_KIND, default_value: int, cap_value: int, breakdown_factors: map<string, int>,
--v converter: (function(self: FACTION_RESOURCE)--> string)?) --> FACTION_RESOURCE
local function new_instance(faction_name, resource_key, kind, default_value, cap_value,breakdown_factors, converter)
    instances[resource_key] = instances[resource_key] or {}
    instances[resource_key][faction_name] = faction_resource.new(faction_name, resource_key, kind, default_value, cap_value, converter)
    if converter and dev.is_game_created() then
        instances[resource_key][faction_name]:reapply()
    end
    UIScript.effect_bundles.remove_effect_bundles_with_root(resource_key)
    return instances[resource_key][faction_name]
end

--v function(resource_key: string, faction: CA_FACTION | string) --> FACTION_RESOURCE
local function get_faction_resource(resource_key, faction)
    --# assume is_faction: function(faction: any) --> boolean
    local faction_name = ""
    if is_string(faction) then
        --# assume faction: string
        faction_name = faction 
    elseif is_faction(faction) then
        --# assume faction: CA_FACTION
        faction_name = faction:name()
    else
        return nil
    end
    instances[resource_key] = instances[resource_key] or {}
    if not instances[resource_key][faction_name] then
        faction_resource:log("Asked for resource ["..resource_key.."] for faction ["..faction_name.."] which doesn't exist.")
    end
    return instances[resource_key][faction_name]
end


return {
    new = new_instance,
    get = get_faction_resource
}