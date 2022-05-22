--the south of england has the following allegiance groups:
--1. The Saxons: they will unite when under heavy attack.
--2. The Welsh: they will be more likely to attack Saxons when united and they will be more likely to attack people already engaged in a war.
--3. The Great Viking Army: will be more likely to devolve into infighting when they are winnning.
--4. The Boroughs will hate people who conquer them.
local boroughs = {
    "vik_fact_hellirborg",
    "vik_fact_steinnborg",
    "vik_fact_hylrborg",
    "vik_fact_djurby",
    "vik_fact_ledeborg"
} --:vector<string>
local borough_home = {} --:map<string, string>
local boroughs_vs = {} --:map<string, {FACTION_RESOURCE, FACTION_RESOURCE, FACTION_RESOURCE}>


--v function(faction: CA_FACTION) --> boolean
local function is_borough(faction)
    return faction:state_religion() == "vik_religion_boroughs"
end

--v function(own: int?, sax: int?, dane: int?)
local function set_boroughs(own, sax, dane)
    for faction, resources in pairs(boroughs_vs) do
        if own then --# assume own: int!
            resources[1]:set_new_value(own)
        end
        if sax then --# assume sax: int!
            resources[2]:set_new_value(sax)
        end
        if dane then --# assume dane: int!
            resources[3]:set_new_value(dane)
        end
    end
end

local function borough_refresh()
    local conflicts_own = 0
    local conflicts_sax = 0
    local conflicts_dane = 0
    local non_conflict = 0 
    for i = 0, dev.region_list():num_items() - 1 do
        local region = dev.region_list():item_at(i)
        if borough_home[region:name()] then
            if region:owning_faction():name() == borough_home[region:name()] then
                non_conflict = non_conflict + 1
            elseif region:owning_faction():subculture() == "vik_sub_cult_english" then
                conflicts_sax = conflicts_sax + 1
            elseif region:owning_faction():subculture() == "vik_sub_cult_anglo_viking" then
                if is_borough(region:owning_faction()) then
                    conflicts_own = conflicts_own + 1
                else
                    conflicts_dane = conflicts_dane + 1
                end
            end
        end
    end
    local conflicts = {conflicts_own, conflicts_sax, conflicts_dane}
    local others_are_threat = conflicts_dane > 0 or conflicts_sax > 0 
    local can_ally_sax = conflicts_sax == 0 
    local can_ally_dane = conflicts_dane == 0
    local can_ally_own = conflicts_own < conflicts_dane and conflicts_own < conflicts_sax
    local own_is_threat = conflicts_own > conflicts_dane + conflicts_sax
    --determine opinion to self
    if own_is_threat then
        set_boroughs(3,nil,nil)
    elseif others_are_threat and can_ally_own then
        set_boroughs(1,nil,nil)
    else
        set_boroughs(2,nil,nil)
    end
    --determine opinion of saxons
    if can_ally_sax and (own_is_threat or others_are_threat) then
        set_boroughs(nil,3,nil)
    elseif others_are_threat and not can_ally_sax then
        set_boroughs(nil,1,nil)
    else
        set_boroughs(nil,2,nil)
    end
    --determine opinion of Vikings
    if can_ally_dane and (own_is_threat or others_are_threat) then
        set_boroughs(nil,nil,3)
    elseif others_are_threat and not can_ally_dane then
        set_boroughs(nil,nil,1)
    else
        set_boroughs(nil,nil,2)
    end
end

dev.first_tick(function(context)
    --set up a borough resource
    for i = 1, #boroughs do
        local faction = dev.get_faction(boroughs[i])
        if faction and not faction:is_human() then
            vs_own = PettyKingdoms.FactionResource.new(boroughs[i], "boroughs_vs_saxons","imaginary",  0, 3, {})
            vs_english = PettyKingdoms.FactionResource.new(boroughs[i], "boroughs_vs_danes","imaginary",  0, 3, {})
            vs_danish = PettyKingdoms.FactionResource.new(boroughs[i], "boroughs_vs_boroughs","imaginary",  0, 3, {})
            boroughs_vs[boroughs[i]] = {vs_own, vs_english, vs_danish}
        end
    end
    if dev.is_new_game() then
        for i = 1, #boroughs do
            local faction = dev.get_faction(boroughs[i])
            if faction and not faction:home_region():is_null_interface() then 
                borough_home[faction:home_region():name()] = faction:name()
            end
        end
    end
end)

dev.Save.persist_table(borough_home, "BOROUGH_HOME", function(t) borough_home = t end)