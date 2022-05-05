local diplomacy_faction = {} --# assume diplomacy_faction: DIPLOMACY_FACTION
local cache_turn = 1

--v function(t: string)
local function log(t)
    dev.log(t, "DIPLO")
end

--v function(key: string) --> DIPLOMACY_FACTION
function diplomacy_faction.new(key)
    local self = {}
    setmetatable(self, {
        __index = diplomacy_faction
    }) --# assume self: DIPLOMACY_FACTION

    self.key = key
    self.is_vassal = false --:boolean
    self.vassals = {} --:map<string, boolean>
    self.num_vassals = 0
    self.allies = {} --:map<string, boolean>
    self.liege = "" --:string

    return self
end

local instances = {} --:map<string, DIPLOMACY_FACTION>




--v function(proposer: CA_FACTION?)
local function refresh_diplomacy_cache(proposer)
    local faction_list = dev.faction_list()
    local old_vassals = {} --:vector<string>
    local old_allies = {} --:vector<string>
    for i = 0, faction_list:num_items() - 1 do
        local faction = faction_list:item_at(i)
        local this_instance = instances[faction:name()]
        if not this_instance.is_vassal then
            for j = 0, faction_list:num_items() - 1 do
                local other_faction = faction_list:item_at(j)
                if other_faction:is_vassal_of(faction) then
                    local notify = true --:boolean
                    if this_instance.vassals[other_faction:name()]  then 
                        notify = false --if we already have the vassalage recorded, we don't need to notify.
                    end
                    instances[other_faction:name()].is_vassal = true
                    instances[other_faction:name()].liege = this_instance.key
                    this_instance.vassals[other_faction:name()] = true
                    this_instance.num_vassals = this_instance.num_vassals + 1
                    if notify and proposer then
                        log("Faction "..faction:name().." Gained Vassal "..other_faction:name())
                        dev.eh:trigger_event("FactionVassalGained", faction, other_faction)
                    end
                elseif this_instance.vassals[other_faction:name()] then
                    instances[other_faction:name()].is_vassal = false
                    instances[other_faction:name()].liege = ""
                    this_instance.vassals[other_faction:name()] = false
                    this_instance.num_vassals = this_instance.num_vassals - 1
                    if proposer then
                        --# assume proposer: CA_FACTION
                        if proposer:name() == faction:name() then
                            log("Faction "..faction:name().." Released Vassal "..other_faction:name())
                            dev.eh:trigger_event("FactionVassalReleased", faction, other_faction)
                        elseif proposer:name() == other_faction:name() then
                            log("Faction "..other_faction:name().." Rebelled Against Vassal Overlord "..faction:name())
                            dev.eh:trigger_event("FactionVassalRebelled", other_faction, faction)
                        end
                    end
                end
                if other_faction:allied_with(faction) then
                    local notify = true
                    if this_instance.allies[other_faction:name()] then
                        notify = false --if we already have the vassalage recorded, we don't need to notify.
                    end
                    instances[other_faction:name()].allies[this_instance.key] = true
                    this_instance.allies[other_faction:name()] = true
                    if notify and proposer then
                        log("Faction "..faction:name().." formed an alliance with "..other_faction:name())
                        dev.eh:trigger_event("FactionAllianceFormed", faction, other_faction)
                    end
                elseif this_instance.allies[other_faction:name()] then
                    instances[other_faction:name()].allies[this_instance.key] = false
                    this_instance.allies[other_faction:name()] = false
                    if proposer then
                        --# assume proposer: CA_FACTION
                        if proposer:name() == faction:name() then
                            dev.eh:trigger_event("FactionAllianceBroken", faction, other_faction)
                        elseif proposer:name() == other_faction:name() then
                            dev.eh:trigger_event("FactionAllianceBroken", other_faction, faction)
                        end
                    end

                end
            end
        end
    end
end

dev.pre_first_tick(function(context)
    local faction_list = dev.faction_list()
    for i = 0, faction_list:num_items() - 1 do
        local faction = faction_list:item_at(i)
        instances[faction:name()] = diplomacy_faction.new(faction:name())
    end
    refresh_diplomacy_cache()

    dev.eh:add_listener(
        "VassalsNegativeDiplomaticEvent",
        "PositiveDiplomaticEvent",
        true,
        function(context)
            refresh_diplomacy_cache(context:proposer())
        end,
        true)
    dev.eh:add_listener(
        "VassalsNegativeDiplomaticEvent",
        "NegativeDiplomaticEvent",
        true,
        function(context)
            refresh_diplomacy_cache(context:proposer())
        end,
        true)
        --[[
    dev.eh:add_listener(
        "VassalsFactionSubjugatesOtherFaction",
        "FactionSubjugatesOtherFaction",
        true,
        function(context)
            instances[context:other_faction():name()].is_vassal = true
            instances[context:faction():name()].vassals[context:other_faction():name()] = true
        end,
        true)
        --]]
end)

--v function(faction_key: string) --> boolean
local function is_faction_vassal(faction_key)
    return instances[faction_key].is_vassal
end

--v function(faction_key: string) --> string
local function get_faction_liege(faction_key) 
    local instance = instances[faction_key]
    if not instance.is_vassal then
        return nil
    end
    return instance.liege
end

--v function(faction_key: string) --> vector<string>
local function get_faction_allies(faction_key)
    local ret = {} for i, v in pairs(instances[faction_key].allies) do
        table.insert(ret, v)
    end
    return ret
end
--v function(faction_key: string) --> vector<string>
local function get_faction_vassals(faction_key) 
    local vassals = {} --:vector<string>
    for k,v in pairs(instances[faction_key].vassals) do
        table.insert(vassals, k)
    end
    return vassals
end

return {
    get_faction_allies = get_faction_allies,
    is_faction_vassal = is_faction_vassal,
    get_faction_liege = get_faction_liege,
    get_faction_vassals = get_faction_vassals
}
