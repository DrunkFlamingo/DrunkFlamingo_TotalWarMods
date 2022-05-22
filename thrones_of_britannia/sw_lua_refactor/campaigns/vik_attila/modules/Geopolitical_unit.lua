--a geopolitical unit consists of a series of factions and a series of behaviours when certain factions are AI or human.
--They track territory which each faction claims and use determine which effects they apply to behaviour.

local forces_capture_radius = 21
local vassal_recovery_window = 24
local vassal_recovery_event = "sw_gifts_vassal_region_"
local ally_recovery_window = 12
local ally_recovery_event = "sw_gifts_ally_region_"
local region_defection_bundle = ""
local region_defection_surrender_chance = 35
local region_defection_surrender_surrounded_bonus = 10
local region_defection_surrender_bonus_values = {}
local region_defection_surrender_event = "sw_region_defection_surrender_"
local region_defection_village_event = "sw_gifts_village_defection_"
local region_defection_our_village_event = "sw_gifts_our_village_defects_"
local region_defection_village_bonus_values = {
    ["brute_legendary_brute"] = 15,
    ["shield_elder_beloved"] = 15,
    ["shield_tyrant_subjugator"] = 35,
    ["shield_heathen_pagan"] = 15
} --:map<string, int>
local region_defection_village_chance = 65
local region_defection_village_own_allegiance_bonus = -50
local region_defection_village_wrong_allegiance_penalty = 35
local region_defection_riots_chance = 20
local region_defection_riots_event = "sw_gifts_our_region_defects_riots_"
local region_defection_defeats_event = "sw_gifts_our_region_defects_defeat_"
local region_defection_victories_event = "sw_gifts_region_defection_victories_"
local region_defection_victories_chance = 15
local region_defection_victories_own_allegiance_bonus = -50
local region_defection_victories_wrong_allegiance_penalty = 90
local region_defection_victories_bonus_values = {}
local region_defection_war_chance = 50
local region_defection_ally_gift_choice = "sw_gifts_region_to_ally_"
local region_defection_ally_gift_levels = 3
local region_defection_ally_time_between_requests = 4;
local region_defection_ally_time_between_requests_scaling = 2;

local events = dev.GameEvents


local event_functions = {} --:map<string, function(geo: GEOPOLITICS, faction_considering: string, region_being_considered: string, previous_owner: string, is_human_victory_region: boolean, whose_victory_region: string)>

local region_to_included_geopols = {} --:map<string, GEOPOLITICS>
local faction_to_included_geopols = {} --:map<string, GEOPOLITICS>

local geopolitics = {} --# assume geopolitics: GEOPOLITICS

--v function(name: string) --> GEOPOLITICS
function geopolitics.new(name)
    local self = {}
    setmetatable(self, {
        __index = geopolitics
    }) --# assume self: GEOPOLITICS
    self.regions = {} --:vector<string>
    self.faction_kingdom_regions = {} --:map<string, vector<string>>
    self.faction_to_kingdom_sympathy = {} --:map<string, map<string, int>>
    self.faction_to_nation_sympathy = {} --:map<string, map<string, int>>
    self.kingdom_threatened_responses = {} --:map<string, function(faction: string, other_faction: string, regions_lost: number, regions_conquered: number, region_moved: string)>
    self.kingdom_expands_responses = {} --:map<string, function(faction: string, other_faction: string, regions_lost: number, regions_conquered: number, region_moved: string)>
    self.use_behaviour_whitelist = false --:boolean
    self.faction_to_permitted_behaviours = {} --:map<string, vector<string>>
    self.regions_active = {} --:map<string, boolean>
    self.faction_controlled_regions = {} --:map<string, map<string, number>>
    self.faction_lost_regions = {} --:map<string, map<string, number>>
    self.region_to_last_major_owner = {}
    self.other_regions = 0 --:int
    self.faction_anger = {} --:map<string, map<string, int>>

    self.save = {
        name = name,
        for_save = {
            "faction_kingdom_names", "faction_to_kingdom_sympathy", "faction_to_nation_sympathy"
        }
    }

    return self
end


--v function(self: GEOPOLITICS, faction: string, other_faction: string, location: string) --> (number, number, number, number)
function geopolitics.compare_nearby_strengths(self, faction, other_faction, location)
    local total_1 = 0 --:number
    local size_1 = 0 --:number
    local total_2 = 0 --:number
    local size_2 = 0 --:number

    local character_list = dev.get_faction(faction):character_list()
    for i = 0, character_list:num_items() - 1 do
        local character = character_list:item_at(i)
        if dev.is_character_near_region(character, dev.get_region(location), forces_capture_radius) then
            local cache = dev.generate_force_cache_entry(character, true)
            for unit, power in pairs(cache) do
                total_1 = total_1 + power
                size_1 = size_1 + 1
            end
        end
    end
    local character_list = dev.get_faction(other_faction):character_list()
    for i = 0, character_list:num_items() - 1 do
        local character = character_list:item_at(i)
        if dev.is_character_near_region(character, dev.get_region(location), forces_capture_radius) then
            local cache = dev.generate_force_cache_entry(character, true)
            for unit, power in pairs(cache) do
                total_2 = total_2 + power
                size_2 = size_2 + 1
            end
        end
    end

    return dev.mround(total_1, 1), dev.mround(size_1, 1), dev.mround(total_2, 1), dev.mround(size_2, 1)
end


--v function(self: GEOPOLITICS, faction: string, other_faction: string, anger_level: int)
function geopolitics.set_faction_to_faction_anger(self, faction, other_faction, anger_level)
    self.faction_anger[faction] = self.faction_anger[faction] or {}
    self.faction_anger[faction][other_faction] = anger_level
end

--v function(self: GEOPOLITICS, faction: string, kingdom: vector<string>, faction_to_kingdom_sympathy: map<string, int>, faction_to_nation_sympathy: map<string, int>)
function geopolitics.add_faction(self, faction, kingdom, faction_to_kingdom_sympathy, faction_to_nation_sympathy)
    self.faction_kingdom_regions[faction] = kingdom
    self.faction_to_kingdom_sympathy[faction] = faction_to_kingdom_sympathy
    self.faction_to_nation_sympathy[faction] = faction_to_nation_sympathy
    for i = 1, #kingdom do table.insert(self.regions, kingdom[i]) end
end

--v function(self: GEOPOLITICS, behaviour_key: string, callback: function(faction: string, other_faction: string, regions_lost: number, regions_conquered: number, region_moved: string))
function geopolitics.add_expanding_behaviour(self, behaviour_key, callback)
    self.kingdom_expands_responses[behaviour_key] = callback
end

--v function(self: GEOPOLITICS, behaviour_key: string, callback: function(faction: string, other_faction: string, regions_lost: number, regions_conquered: number, region_moved: string))
function geopolitics.add_threatened_behaviour(self, behaviour_key, callback)
    self.kingdom_threatened_responses[behaviour_key] = callback
end

--v function(self: GEOPOLITICS, faction: string, behaviours: vector<string>)
function geopolitics.whitelist_behaviours_for_faction(self, faction, behaviours)
    self.use_behaviour_whitelist = true
    self.faction_to_permitted_behaviours[faction] = behaviours
end

--v function(self: GEOPOLITICS, thinker: string, other_faction: string, regions_to_consider: vector<string>, other_factions_regions: vector<string>, region_moved: string)
function geopolitics.think(self, thinker, other_faction, regions_to_consider, other_factions_regions, region_moved)

    local regions_owned = 0
    local regions_total = #regions_to_consider + #other_factions_regions
    local regions_conquered = 0
    local regions_lost = 0
    local was_human_victory_mission = false --:boolean
    local whose_victory_region = "" --:string
    for faction, regions in pairs(self.faction_kingdom_regions) do
        for i = 1, #regions do
            if regions[i] == region_moved and Gamedata.kingdoms.is_region_in_kingdom(region_moved,faction) then
                whose_victory_region = faction
                if dev.get_faction(faction):is_human() then
                    was_human_victory_mission = true
                end
            end
        end
    end
    local was_loss = false --:boolean
    for i = 1, #regions_to_consider do
        local region = dev.get_region(regions_to_consider[i])
        if region:owning_faction():name() == thinker then
            regions_owned = regions_owned + 1;
            
        else
            regions_lost = regions_lost + 1;
            if region_moved == region:name() then
                was_loss = true
                
            end
        end
    end
    local white_list = {}
    local was_event = false --:boolean
    --fire behaviours
    if was_loss then
        if not self.use_behaviour_whitelist then
            for behaviour, callback in pairs(self.kingdom_threatened_responses) do
                was_event = callback(thinker, other_faction, regions_lost, regions_conquered, region_moved) or false
            end
        else
            for i = 1, #self.faction_to_permitted_behaviours[thinker] do
                local callback = self.kingdom_threatened_responses[self.faction_to_permitted_behaviours[thinker][i]]
                was_event = callback(thinker, other_faction, regions_lost, regions_conquered, region_moved) or false
            end
        end
    else
        if not self.use_behaviour_whitelist then
            for behaviour, callback in pairs(self.kingdom_expands_responses) do
                was_event = callback(thinker, other_faction, regions_lost, regions_conquered, region_moved) or false
            end
        else
            for i = 1, #self.faction_to_permitted_behaviours[thinker] do
                local callback = self.kingdom_expands_responses[self.faction_to_permitted_behaviours[thinker][i]]
                was_event = callback(thinker, other_faction, regions_lost, regions_conquered, region_moved) or false
            end
        end
    end
    if was_event then
        return
    end
    if not was_loss then
        for event_prefix, event_func in pairs(event_functions) do
            was_event = event_func(self, thinker, region_moved, other_faction, was_human_victory_mission, whose_victory_region)
        end
    end
    --if the human took this settlement:
    if (dev.get_faction(thinker):is_human() and was_loss == false) or (dev.get_faction(other_faction):is_human() and not was_loss) then
        local ally = other_faction
        if was_loss then
            ally = thinker
        end
        local allies = PettyKingdoms.VassalTracking.get_faction_allies(ally)
        for a = 1, #allies do
            local human = allies[a]
            if dev.get_faction(human):is_human() and self.faction_lost_regions[human][region_moved]
            and self.faction_lost_regions[human][region_moved] > cm:model():turn_number() - ally_recovery_window then
                local capital = Gamedata.regions.get_province_capital_of_regions_province(region_moved)
                local owns_region = capital:owning_faction():name() == human
                if not owns_region then
                    --or have a region bordering this one
                    for k = 0, capital:adjacent_region_list():num_items() - 1 do
                        if capital:adjacent_region_list():item_at(k):owning_faction() == ally then
                            owns_region = true
                        end
                    end
                end
                if owns_region then
                    --TODO dilemma
                    return
                end
            end
        end
    end

end


--v function(self: GEOPOLITICS)
function geopolitics.activate(self)

    --TODO initialize events

    for i = 1, #self.regions do self.regions_active[self.regions[i]] = true end
    for faction_key, region_list in pairs(self.faction_kingdom_regions) do
        for j = 0, dev.get_faction(faction_key):region_list():num_items() - 1 do
            local region = dev.get_faction(faction_key):region_list():item_at(j)
            self.faction_controlled_regions[faction_key] = self.faction_controlled_regions[faction_key] or {}
            self.faction_controlled_regions[faction_key][region:name()] = cm:model():turn_number()
        end
        dev.eh:add_listener(
            "GeopoliticsRegionChangesOwnership",
            "RegionChangesOwnership",
            function(context)
                return context:prev_faction():name() == faction_key
            end,
            function(context)
                local region = context:region()
                local other_faction = region:owning_faction():name()
                local faction_key = context:prev_faction():name() 
                self.faction_lost_regions[faction_key] = self.faction_lost_regions[faction_key] or {}
                self.faction_lost_regions[faction_key][region:name()] = cm:model():turn_number()
                self.faction_controlled_regions[faction_key] = self.faction_controlled_regions[faction_key] or {}
                self.faction_controlled_regions[faction_key][region:name()] = nil
                self:think(faction_key, other_faction, self.faction_kingdom_regions[faction_key], self.faction_kingdom_regions[other_faction], region:name())
            end,
            true)
        dev.eh:add_listener(
            "GeopoliticsRegionChangesOwnership",
            "RegionChangesOwnership",
            function(context)
                return context:region():owning_faction():name() == faction_key
            end,
            function(context)
                local faction_key = context:region():owning_faction():name()
                local region = context:region()
                local other_faction = context:prev_faction():name()
                self.faction_controlled_regions[faction_key] = self.faction_controlled_regions[faction_key] or {}
                self.faction_controlled_regions[faction_key][region:name()] = cm:model():turn_number()
                self.faction_lost_regions[faction_key] = self.faction_controlled_regions[faction_key] or {}
                self.faction_lost_regions[faction_key][region:name()] = nil
                self:think(faction_key, other_faction, self.faction_kingdom_regions[faction_key], self.faction_kingdom_regions[other_faction], region:name())
            end,
            true)
    end
end


local instances = {}--:map<string, GEOPOLITICS> 

--v function(geo: GEOPOLITICS, faction_considering: string, region_being_considered: string, previous_owner: string, is_human_victory_region: boolean, whose_victory_region: string)
function event_functions.sw_gifts_vassal_region_(geo, faction_considering, region_being_considered, previous_owner, is_human_victory_region, whose_victory_region)
    --we just took a region, are we a vassal?
    if not PettyKingdoms.VassalTracking.is_faction_vassal(faction_considering) then
        return
    end
    --we are. Did our liege used to own this place?
    local liege = PettyKingdoms.VassalTracking.get_faction_liege(faction_considering)
    if geo.faction_lost_regions[liege][region_being_considered]
    and geo.faction_lost_regions[liege][region_being_considered] > cm:model():turn_number() - vassal_recovery_window then
        --does our liege still own the capital nearby?
        local capital = Gamedata.regions.get_province_capital_of_regions_province(region_being_considered)
        local owns_region = capital:owning_faction():name() == liege
        if not owns_region then
            --or have a region bordering this one
            for k = 0, capital:adjacent_region_list():num_items() - 1 do
                if capital:adjacent_region_list():item_at(k):owning_faction() == liege then
                    owns_region = true
                end
            end
            --or if we don't border this one (We're a vassal)
            if not owns_region then
                owns_region = true -- assume we don't have any
                for k = 0, capital:adjacent_region_list():num_items() - 1 do
                    if capital:adjacent_region_list():item_at(k):owning_faction() == faction_considering then
                        owns_region = false --we have one
                    end
                end
            end
        end
        if owns_region then
            if dev.get_faction(liege):is_human() then
                cm:trigger_incident(liege, vassal_recovery_event ..region_being_considered, true)
            end
            cm:transfer_region_to_faction(region_being_considered, liege)
            return
        end
    end
end

--v function(geo: GEOPOLITICS, faction_considering: string, region_being_considered: string, previous_owner: string, is_human_victory_region: boolean, whose_victory_region: string)
function event_functions.sw_gifts_ally_region_(geo, faction_considering, region_being_considered, previous_owner, is_human_victory_region, whose_victory_region)
    --we just took a region, get our allies list.
    local allies = PettyKingdoms.VassalTracking.get_faction_allies(faction_considering)
    for a = 1, #allies do
        local other_faction = allies[a]
        --make sure we aren't angry with them
        if (not geo.faction_anger[faction_considering]) or (not geo.faction_anger[faction_considering][other_faction]) or (geo.faction_anger[faction_considering][other_faction] == 0) then
            --did this region used to belong to our friend, or is it one of their victory regions?
            if (geo.faction_lost_regions[other_faction][region_being_considered]
            and geo.faction_lost_regions[other_faction][region_being_considered] > cm:model():turn_number() - ally_recovery_window)
            or whose_victory_region == other_faction then
                --does our ally still own the capital nearby?
                local capital = Gamedata.regions.get_province_capital_of_regions_province(region_being_considered)
                local owns_region = capital:owning_faction():name() == faction_considering
                if not owns_region then
                    --or have a region bordering this one
                    for k = 0, capital:adjacent_region_list():num_items() - 1 do
                        if capital:adjacent_region_list():item_at(k):owning_faction() == other_faction then
                            owns_region = true
                        end
                    end
                end
                if owns_region then
                    if dev.get_faction(other_faction):is_human() then
                        cm:trigger_incident(other_faction, ally_recovery_event..region_being_considered, true)
                    end
                    cm:transfer_region_to_faction(region_being_considered, other_faction)
                    return
                end
            end
        end
    end
end

--v function(geo: GEOPOLITICS, faction_considering: string, region_being_considered: string, previous_owner: string, is_human_victory_region: boolean, whose_victory_region: string)
function event_functions.sw_gifts_region_to_ally_(geo, faction_considering, region_being_considered, previous_owner, is_human_victory_region, whose_victory_region)
    local allies = PettyKingdoms.VassalTracking.get_faction_allies(faction_considering)
    if not dev.get_faction(faction_considering):is_human() then
        return
    end
    local human = dev.get_faction(faction_considering)
    if is_human_victory_region then
        return
    end
    for a = 1, #allies do
        local ally = allies[a]
        --did our ally used to own this region or is it one of their victory regions?
        if (geo.faction_lost_regions[ally][region_being_considered]
        and geo.faction_lost_regions[ally][region_being_considered] > cm:model():turn_number() - ally_recovery_window) 
        or whose_victory_region == ally then
            local capital = Gamedata.regions.get_province_capital_of_regions_province(region_being_considered)
            local owns_region = capital:owning_faction():name() == ally
            if not owns_region then
                --or have a region bordering this one
                for k = 0, capital:adjacent_region_list():num_items() - 1 do
                    if capital:adjacent_region_list():item_at(k):owning_faction() == ally then
                        owns_region = true
                    end
                end
            end
            if owns_region then
                if not dev.get_faction(ally):is_human() then
                    --are they already mad at us?
                    local level = 1
                    if (not geo.faction_anger[ally]) or (not geo.faction_anger[ally][faction_considering]) or (geo.faction_anger[ally][faction_considering] == 0) then 
                        level = level + geo.faction_anger[ally][faction_considering]
                    end
                    local event_key = region_defection_ally_gift_choice .. level .."_"..region_being_considered
                    dev.respond_to_dilemma(event_key, function(context)
                        if context:choice() == 0 then
                            geo.faction_anger[ally] = geo.faction_anger[ally] or {}
                            geo.faction_anger[ally][faction_considering] = 0
                            cm:transfer_region_to_faction(region_being_considered, faction_considering)
                        else
                            geo.faction_anger[ally] = geo.faction_anger[ally] or {}
                            geo.faction_anger[ally][faction_considering] = 1 + (geo.faction_anger[ally][faction_considering] or 0)
                        end
                        if geo.faction_anger[ally] and geo.faction_anger[ally][faction_considering] and geo.faction_anger[ally][faction_considering] > 2 then
                            cm:force_break_alliance(faction_considering, ally)
                            geo.faction_anger[ally] = geo.faction_anger[ally] or {}
                            geo.faction_anger[ally][faction_considering] = 0
                        end
                    end)
                    --TODO dilemma
                    --dev.Events.trigger_turnstart_dilemma(event_key, faction_considering, true)
                end
                return
            end
        end
    end
end


--v function(geo: GEOPOLITICS, faction_considering: string, region_being_considered: string, previous_owner: string, is_human_victory_region: boolean, whose_victory_region: string)
function event_functions.sw_gifts_village_defection_(geo, faction_considering, region_being_considered, previous_owner, is_human_victory_region, whose_victory_region)
    --we are a huamn faction who has just captured a major settlement. We may also be an AI faction, but we cannot have captured *from* a human.
    if dev.get_faction(previous_owner):is_human() then
        return
    end
    local traits_val = 0 --:number
    local closest_char_cqi, distance = dev.closest_char_to_own_settlement(dev.get_region(region_being_considered):settlement())
    for key, value in pairs(region_defection_village_bonus_values) do
        if dev.get_character(closest_char_cqi):has_trait(key) and distance < 20 then
            traits_val = traits_val + value
        end
    end
    local captured_region = dev.get_region(region_being_considered)
    for i = 0, captured_region:adjacent_region_list():num_items() - 1 do
        local candidate = captured_region:adjacent_region_list():item_at(i)
        --good villages to defect are in the same province and are owned by the guy we just stole a province cap from.
        if not candidate:is_province_capital() and candidate:province_name() == captured_region:province_name() and candidate:owning_faction():name() == previous_owner and dev.get_faction(faction_considering):at_war_with(candidate:owning_faction()) then
            local chance = region_defection_village_chance --:number
            local majority_allegiance = candidate:majority_religion()
            if majority_allegiance == dev.get_faction(faction_considering):state_religion() then
                chance = chance + region_defection_village_own_allegiance_bonus
            elseif majority_allegiance == candidate:owning_faction():state_religion() then
                chance = chance + region_defection_village_wrong_allegiance_penalty
            end
            chance = chance + traits_val
            local army_strength, army_size, enemy_strength, enemy_size = geo:compare_nearby_strengths(faction_considering, previous_owner, candidate:name())
            --if they have more than 8 units nearby, or we have fewer than 8, villages won't defect
            if enemy_size < 9 or army_size > 7 then
                --we need to be at least twice as strong nearby:
                if army_strength > enemy_strength * 2 and cm:random_number(100) < chance then
                    if dev.get_faction(faction_considering):is_human() then
                        cm:trigger_incident(region_defection_village_event..region_being_considered, faction_considering, true)
                    end
                    cm:transfer_region_to_faction(region_being_considered, faction_considering)
                end
            end 
        end
    end
end

--v function(geo: GEOPOLITICS, faction_considering: string, region_being_considered: string, previous_owner: string, is_human_victory_region: boolean, whose_victory_region: string)
function event_functions.sw_gifts_our_village_defects_(geo, faction_considering, region_being_considered, previous_owner, is_human_victory_region, whose_victory_region)
    --We are an AI who just captured from a human.
    if (not dev.get_faction(previous_owner):is_human()) or dev.get_faction(faction_considering):is_human() then
        return
    end
    local traits_val = 0 --:number
    local closest_char_cqi, distance = dev.closest_char_to_own_settlement(dev.get_region(region_being_considered):settlement())
    for key, value in pairs(region_defection_village_bonus_values) do
        if dev.get_character(closest_char_cqi):has_trait(key) and distance < 20 then
            traits_val = traits_val + value
        end
    end
    local captured_region = dev.get_region(region_being_considered)
    for i = 0, captured_region:adjacent_region_list():num_items() - 1 do
        local candidate = captured_region:adjacent_region_list():item_at(i)
        --good villages to defect are in the same province and are owned by the guy we just stole a province cap from.
        if not candidate:is_province_capital() and candidate:province_name() == captured_region:province_name() and candidate:owning_faction():name() == previous_owner and dev.get_faction(faction_considering):at_war_with(candidate:owning_faction()) then
            local chance = region_defection_village_chance --:number
            local majority_allegiance = candidate:majority_religion()
            if majority_allegiance == dev.get_faction(faction_considering):state_religion() then
                chance = chance + region_defection_village_own_allegiance_bonus
            elseif majority_allegiance == candidate:owning_faction():state_religion() then
                chance = chance + region_defection_village_wrong_allegiance_penalty
            end
            chance = chance + traits_val
            local army_strength, army_size, enemy_strength, enemy_size = geo:compare_nearby_strengths(faction_considering, previous_owner, candidate:name())
            --they need more than 7 nearby units and we need less than 9.
            if enemy_size > 7 or army_size < 9 then
                --we need to be at least twice as strong nearby:
                if army_strength * 2 < enemy_strength  and cm:random_number(100) < chance then
                    if dev.get_faction(previous_owner):is_human() then
                        cm:trigger_incident(region_defection_our_village_event..region_being_considered, previous_owner, true)
                    end
                    cm:transfer_region_to_faction(region_being_considered, faction_considering)
                end
            end 
        end
    end
end


--v function(geo: GEOPOLITICS, faction_considering: string, region_being_considered: string, previous_owner: string, is_human_victory_region: boolean, whose_victory_region: string)
function event_functions.event(geo, faction_considering, region_being_considered, previous_owner, is_human_victory_region, whose_victory_region)

end

return {
    new = function(name) --:string
        instances[name] = geopolitics.new(name)
        return instances[name]
    end,
    get = function(name) --:string
        return instances[name] or geopolitics.new(name)
    end
}