MANPOWER_SERF = {} --:map<string, FACTION_RESOURCE>

local region_factor = "manpower_region_population" --:string
local sacking_factor = "manpower_region_sacked_or_occupied" --:string
local recruitment_factor = "manpower_recruitment" --:string
local raiding_factor = "manpower_region_raided" --:string
local growth_factor = "manpower_growth" --:string
local famine_factor = "manpower_famine" --:string
local riots_factor = "manpower_rioting" --:string
local buildings_factor = "manpower_settlement_upgrades" --:string
local overcrowding_factor = "manpower_overcrowding_serf"

local base_growth = 0.5 
local famine_loss = 6 
local unit_size_mode_scalar = CONST.__unit_size_scalar

local peasant_castes = {
    very_light = true,
    medium = true,
    light = true
}--:map<string, boolean>

--v function(t: any)
local function log(t)
    dev.log(tostring(t), "PEASANTS")
end

--v function(total_food: number) --> (number, string)
local function get_food_effect(total_food)
    local thresholds_to_returns = {
        [-150] = {0, "Famine"}, --min food, famine, handled elsewhere
        [-50] = {-0.3, "Food Shortages"},
        [0] = {-0.1, "Food Shortages"},
        [100] = {0.25, "Food Surplus"}, --default level
        [250] = {0.5, "Food Surplus"}
    }--:map<number, {number, string}>
    local thresholds = {-150, -50, 0, 100, 250} --:vector<number>
    for n = 1, #thresholds do
        if total_food < thresholds_to_returns[thresholds[n]][1] then
            return thresholds_to_returns[thresholds[n]][1], thresholds_to_returns[thresholds[n]][2]
        end
    end
    --if we are above 250 food
    return 1, "Food Surplus"
end

--v function(faction: CA_FACTION)
local function apply_turn_start(faction)
    local serfs = MANPOWER_SERF[faction:name()]
    local past_growth = serfs:get_factor(growth_factor)
    local past_famine = serfs:get_factor(famine_factor) --this will be a negative number
    local past_levy = serfs:get_factor(recruitment_factor) --this will be a negative number
    local past_raids = serfs:get_factor(raiding_factor) --this will be a negative number
    local past_overcrowding = serfs:get_factor(overcrowding_factor) --this will be a negative number
    local region_base = serfs:get_factor(region_factor) + serfs:get_factor(buildings_factor) --both are set by Regional Manpower Objects.
    local past_riots = serfs:get_factor(riots_factor)
    local actual_pop_base = past_growth + past_famine + past_levy + region_base + past_raids + past_riots + past_overcrowding
    local growth = 0 --:int
    --growth and famine
    local total_food = faction:total_food()
    if total_food >= -50 then
        if actual_pop_base < 200 then
            actual_pop_base = 200 --to prevent people from permanently running out of pop
        end
        local growth_perc_this_turn = base_growth + get_food_effect(total_food)
        growth = dev.mround(actual_pop_base * (growth_perc_this_turn/100), 1)
        serfs:change_value(growth, growth_factor)
    else
        local loss = dev.mround(-1*(actual_pop_base * (famine_loss/100)), 1)
        serfs:change_value(loss, famine_factor)
    end

    --overpopulation
    local pop_effective_cap = (region_base) * 2
    local cap_perc = actual_pop_base / pop_effective_cap
    log("Serf overpopulation calculation factors: actual_pop_base is "..tostring(actual_pop_base) ..", cap perc is "..tostring(cap_perc)..", pop_effective_cap is "..tostring(pop_effective_cap))
    if cap_perc > 1 then 
        --lose everything over the cap.
        local difference = pop_effective_cap - actual_pop_base
        serfs:change_value(difference, overcrowding_factor)
    elseif cap_perc > 0.75 then
        --lose 4% of growth per 1% over 75% of cap.
        local loss = (cap_perc - 0.75) * growth * -1
        serfs:change_value(loss, overcrowding_factor)
    end
end

--v function(resource: FACTION_RESOURCE) --> string
local function value_converter(resource)
    return tostring(dev.clamp(math.ceil(resource.value/500) + 1, 1, 16))
end

local peasant_manpower_effects = {
	["vik_market_2"] = { ["building"] = "vik_market_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 125, ["value_damaged"] = 60, ["value_ruined"] = 0 },
	["vik_market_3"] = { ["building"] = "vik_market_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 250, ["value_damaged"] = 80, ["value_ruined"] = 0 },
	["vik_market_4"] = { ["building"] = "vik_market_4", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 375, ["value_damaged"] = 100, ["value_ruined"] = 0 },
	["vik_market_5"] = { ["building"] = "vik_market_5", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 500, ["value_damaged"] = 120, ["value_ruined"] = 0 },
	["vik_guildhall_1"] = { ["building"] = "vik_guildhall_1", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 125, ["value_damaged"] = 125, ["value_ruined"] = 0 },
	["vik_guildhall_2"] = { ["building"] = "vik_guildhall_2", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 250, ["value_damaged"] = 250, ["value_ruined"] = 0 },
	["vik_guildhall_3"] = { ["building"] = "vik_guildhall_3", ["effect"] = "shield_scripted_pop_cap_serf", ["effect_scope"] = "region_to_region_own", ["value"] = 375, ["value_damaged"] = 375, ["value_ruined"] = 0 }
} --:map<string, {building: string, effect: string, effect_scope: string, value: number, value_damaged:number, value_ruined: number}>

dev.first_tick(function(context) 

    local human_factions = cm:get_human_factions()

    for i = 1, #human_factions do
        MANPOWER_SERF[human_factions[i]] = PettyKingdoms.FactionResource.new(human_factions[i], "sw_pop_serf", "population", 0, 30000, {}, value_converter)
        local serfs = MANPOWER_SERF[human_factions[i]]
        serfs.uic_override = {"layout", "top_center_holder", "resources_bar2", "culture_mechanics"} 
        local region_list = dev.get_faction(human_factions[i]):region_list()
        local region_base_pop = 0 --:number
        local building_pop_contribution = 0 --:number
        for j = 0, region_list:num_items() - 1 do
            local current_region = region_list:item_at(j)     
            local manpower_obj = PettyKingdoms.RegionManpower.get(current_region:name())
            region_base_pop = region_base_pop + manpower_obj.base_serf()
            building_pop_contribution = building_pop_contribution + manpower_obj.settlement_serf_bonus
        end
        serfs:set_factor(region_factor, dev.mround(region_base_pop, 1))
        serfs:reapply()
    end    
    PettyKingdoms.RegionManpower.activate("serf", function(faction_key, factor_key, change)
        local pop = PettyKingdoms.FactionResource.get("sw_pop_serf", dev.get_faction(faction_key))
        log("Changing sw_pop_serf population by ["..change.."] in "..factor_key)
        if pop then 
            pop:change_value(change, factor_key)
        end
    end)
    for k, v in pairs(peasant_manpower_effects) do
        PettyKingdoms.RegionManpower.add_settlement_pop_bonus(k, v.value)
    end
    dev.eh:add_listener(
        "SerfsFactionTurnStart",
        "FactionTurnStart",
        function(context)
            return context:faction():is_human() 
        end,
        function(context)
            local faction = context:faction()
            apply_turn_start(faction)
        end,
        true)
    
    if dev.is_new_game() then
        for i = 1, #human_factions do
            local serf = MANPOWER_SERF[human_factions[i]]
            serf:set_factor(famine_factor, 0)
            serf:set_factor(recruitment_factor, 0)
            serf:set_factor(riots_factor, 0)
            serf:set_factor(raiding_factor, 0)
        end
        apply_turn_start(cm:model():world():whose_turn_is_it())
    end

    local rec_handler = UIScript.recruitment_handler.add_resource("sw_pop_serf", function(faction_name)
        return PettyKingdoms.FactionResource.get("sw_pop_serf", dev.get_faction(faction_name)).value
    end, 
    function(faction_name, quantity)
        PettyKingdoms.FactionResource.get("sw_pop_serf", dev.get_faction(faction_name)):change_value(quantity, recruitment_factor)
    end, "dy_pop_peasant")
    for k, entry in pairs(Gamedata.unit_info.main_unit_size_caste_info) do
        if peasant_castes[entry.caste] and (not Gamedata.unit_info.mercenary_units[k]) and (not Gamedata.unit_info.slave_units[k]) then
            rec_handler:set_cost_of_unit(entry.unit_key, dev.mround(entry.num_men*unit_size_mode_scalar, 1))
        end
    end
    rec_handler:set_resource_tooltip("Levy, Militia, and other Peasant units consume Peasant Population when recruited.")
    rec_handler.image_state = "peasant"
        
end)




