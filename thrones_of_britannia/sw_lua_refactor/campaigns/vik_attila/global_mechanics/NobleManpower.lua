MANPOWER_NOBLE = {} --:map<string, FACTION_RESOURCE>


local region_factor = "manpower_region_population" --:string
local sacking_factor = "manpower_region_sacked_or_occupied" --:string
local recruitment_factor = "manpower_recruitment" --:string
local raiding_factor = "manpower_region_raided" --:string
local growth_factor = "manpower_growth" --:string
local famine_factor = "manpower_famine" --:string
local riots_factor = "manpower_rioting" --:string
local allegiance_factor = "manpower_region_allegiance" --:string
local estates_factor = "manpower_estates" --:string
local overcrowding_factor = "manpower_overcrowding_lord"

local base_growth = 0.15
local famine_loss = 3 
local unit_size_mode_scalar = CONST.__unit_size_scalar

local noble_castes = {
    very_heavy = true,
    heavy = true
}--:map<string, boolean>

--v function(total_food: number) --> (number, string)
local function get_food_effect(total_food)
    local thresholds_to_returns = {
        [-150] = {0, "Famine"}, --min food, famine, handled elsewhere
        [-50] = {-0.1, "Food Shortages"},
        [0] = {-0.05, "Food Shortages"},
        [100] = {0.1, "Food Surplus"}, --default level
        [250] = {0.25, "Food Surplus"}
    }--:map<number, {number, string}>
    local thresholds = {-150, -50, 0, 100, 250} --:vector<number>
    for n = 1, #thresholds do
        if total_food < thresholds_to_returns[thresholds[n]][1] then
            return thresholds_to_returns[thresholds[n]][1], thresholds_to_returns[thresholds[n]][2]
        end
    end
    --if we are above 250 food
    return 0.5, "Food Surplus"
end

local estate_pop_effects = {
	["vik_apple_ash_1"] = { ["building"] = "vik_apple_ash_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
	["vik_apple_ash_2"] = { ["building"] = "vik_apple_ash_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
	["vik_apple_ash_3"] = { ["building"] = "vik_apple_ash_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 120, ["value_damaged"] = 120, ["value_ruined"] = 0 },
	["vik_estate_1"] = { ["building"] = "vik_estate_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
	["vik_estate_2"] = { ["building"] = "vik_estate_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
	["vik_estate_3"] = { ["building"] = "vik_estate_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 120, ["value_damaged"] = 120, ["value_ruined"] = 0 },
	["vik_farm_b_2"] = { ["building"] = "vik_farm_b_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
	["vik_farm_b_3"] = { ["building"] = "vik_farm_b_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 60, ["value_damaged"] = 60, ["value_ruined"] = 0 },
	["vik_hunting_b_2"] = { ["building"] = "vik_hunting_b_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
	["vik_hunting_b_3"] = { ["building"] = "vik_hunting_b_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
	["vik_orchard_b_2"] = { ["building"] = "vik_orchard_b_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
	["vik_orchard_b_3"] = { ["building"] = "vik_orchard_b_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
	["vik_pasture_b_2"] = { ["building"] = "vik_pasture_b_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 20, ["value_damaged"] = 20, ["value_ruined"] = 0 },
	["vik_pasture_b_3"] = { ["building"] = "vik_pasture_b_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
	["vik_great_hall_4"] = { ["building"] = "vik_great_hall_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
	["vik_great_hall_5"] = { ["building"] = "vik_great_hall_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 120, ["value_damaged"] = 120, ["value_ruined"] = 0 },
	["vik_offas_hall_1"] = { ["building"] = "vik_offas_hall_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
	["vik_offas_hall_2"] = { ["building"] = "vik_offas_hall_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
	["vik_offas_hall_3"] = { ["building"] = "vik_offas_hall_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 120, ["value_damaged"] = 120, ["value_ruined"] = 0 },
	["vik_offas_hall_4"] = { ["building"] = "vik_offas_hall_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
	["vik_offas_hall_5"] = { ["building"] = "vik_offas_hall_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 200, ["value_damaged"] = 200, ["value_ruined"] = 0 },
	["vik_rock_caisil_1"] = { ["building"] = "vik_rock_caisil_1", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 40, ["value_damaged"] = 40, ["value_ruined"] = 0 },
	["vik_rock_caisil_2"] = { ["building"] = "vik_rock_caisil_2", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 80, ["value_damaged"] = 80, ["value_ruined"] = 0 },
	["vik_rock_caisil_3"] = { ["building"] = "vik_rock_caisil_3", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 120, ["value_damaged"] = 120, ["value_ruined"] = 0 },
	["vik_rock_caisil_4"] = { ["building"] = "vik_rock_caisil_4", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 160, ["value_damaged"] = 160, ["value_ruined"] = 0 },
	["vik_rock_caisil_5"] = { ["building"] = "vik_rock_caisil_5", ["effect"] = "shield_scripted_pop_cap_lord", ["effect_scope"] = "region_to_region_own", ["value"] = 200, ["value_damaged"] = 200, ["value_ruined"] = 0 }
} --:map<string, {building: string, effect: string, effect_scope: string, value: number, value_damaged:number, value_ruined: number}>



--v function(faction: CA_FACTION)
local function apply_turn_start(faction)
    local region_pop_factor = 0
    local nobles = MANPOWER_NOBLE[faction:name()]
    local past_growth = nobles:get_factor(growth_factor)
    local past_famine = nobles:get_factor(famine_factor) --this will be a negative number
    local past_levy = nobles:get_factor(recruitment_factor) --this will be a negative number
    local past_raids = nobles:get_factor(raiding_factor) --this will be a negative number
    local past_overcrowding = nobles:get_factor(overcrowding_factor)
    local region_base = nobles:get_factor(region_factor) + nobles:get_factor(estates_factor)
    local past_riots = nobles:get_factor(riots_factor)
    local allegiance = 0 --:number
    local region_list = dev.region_list(faction)
    for j = 0, region_list:num_items() - 1 do
        local current_region = region_list:item_at(j)     
        local manpower_obj = PettyKingdoms.RegionManpower.get(current_region:name())
        if current_region:majority_religion() == faction:state_religion() then
            allegiance = allegiance + (current_region:majority_religion_percentage()/100)*manpower_obj.base_lord()
        else
            allegiance = allegiance - dev.mround(manpower_obj.base_lord()/2, 1)
        end
    end
    nobles:set_factor(allegiance_factor, dev.mround(allegiance, 1))
    local actual_pop_base = past_growth + past_famine + past_overcrowding + past_levy + region_base + past_raids + past_riots + allegiance
    local growth = 0 --:int
    --growth and famine
    local total_food = faction:total_food()
    if total_food >= -50 then
        if actual_pop_base < 200 then
            actual_pop_base = 200 --to prevent people from permanently running out of pop
        end
        local growth_perc_this_turn = base_growth + get_food_effect(total_food)
        growth = dev.mround(actual_pop_base * (growth_perc_this_turn/100), 1)
        nobles:change_value(growth, growth_factor)
    else
        local loss = dev.mround(-1*(actual_pop_base * (famine_loss/100)), 1)
        nobles:change_value(loss, overcrowding_factor)
    end

    --overpopulation
    local pop_effective_cap = (region_base) * 4
    local cap_perc = actual_pop_base / pop_effective_cap
    if cap_perc > 1 then 
        --lose everything over the cap.
        local difference = pop_effective_cap - actual_pop_base
        nobles:change_value(difference, overcrowding_factor)
    elseif cap_perc > 0.80 then
        --lose 5% of growth per 1% over 80% of cap.
        local loss = (cap_perc - 0.8) * growth * -1
        nobles:change_value(loss, overcrowding_factor)
    end
end


--v function(resource: FACTION_RESOURCE) --> string
local function value_converter(resource)
    if resource.value == 0 then
        return "1"
    elseif resource.value < dev.mround(MANPOWER_SERF[resource.owning_faction].value/10, 1) then
        return "2"
    else
        return "3"
    end
end


dev.first_tick(function(context)
    local human_factions = cm:get_human_factions()
    for i = 1, #human_factions do
        MANPOWER_NOBLE[human_factions[i]] = PettyKingdoms.FactionResource.new(human_factions[i], "sw_pop_noble", "population", 0, 30000, {}, value_converter)
        local nobles = MANPOWER_NOBLE[human_factions[i]]
        nobles.uic_override = {"layout", "top_center_holder", "resources_bar2", "culture_mechanics"} 
        local faction = dev.get_faction(human_factions[i])
        local region_list = dev.region_list(faction)
        local region_base_pop = 0 --:number
        local estate_pop = 0 --:number
        local allegiance = 0 --:number
        for j = 0, region_list:num_items() - 1 do
            local current_region = region_list:item_at(j)     
            local manpower_obj = PettyKingdoms.RegionManpower.get(current_region:name())
            region_base_pop = region_base_pop + manpower_obj.base_lord()
            estate_pop = estate_pop + manpower_obj.estate_lord_bonus
            if current_region:majority_religion() == faction:state_religion() then
                allegiance = allegiance + (current_region:majority_religion_percentage()/100)*manpower_obj.base_lord()
            else
                allegiance = allegiance - dev.mround(manpower_obj.base_lord()/2, 1)
            end
        end
        nobles:set_factor(allegiance_factor, dev.mround(allegiance, 1))
        nobles:set_factor(region_factor, dev.mround(region_base_pop, 1))
        nobles:set_factor(estates_factor, dev.mround(estate_pop, 1))
        nobles:reapply()
    end


    PettyKingdoms.RegionManpower.activate("lord", function(faction_key, factor_key, change)
        local pop = PettyKingdoms.FactionResource.get("sw_pop_noble", dev.get_faction(faction_key))
        dev.log("Changing sw_pop_noble population by ["..change.."] in "..factor_key)
        if pop then
            pop:change_value(change, factor_key)
        end
    end)
    for building_key, info in pairs(estate_pop_effects) do
        PettyKingdoms.RegionManpower.add_estate_pop_bonus(building_key, info.value)
    end

    dev.eh:add_listener(
        "LordsFactionTurnStart",
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
            local nobles = MANPOWER_NOBLE[human_factions[i]]
            nobles:set_factor(famine_factor, 0)
            nobles:set_factor(recruitment_factor, 0)
            nobles:set_factor(riots_factor, 0)
            nobles:set_factor(raiding_factor, 0)
        end
        apply_turn_start(cm:model():world():whose_turn_is_it())
    end

    local rec_handler = UIScript.recruitment_handler.add_resource("sw_pop_noble", function(faction_name)
        return PettyKingdoms.FactionResource.get("sw_pop_noble", dev.get_faction(faction_name)).value
    end, 
    function(faction_name, quantity)
        PettyKingdoms.FactionResource.get("sw_pop_noble", dev.get_faction(faction_name)):change_value(quantity, recruitment_factor)
    end, "dy_pop_lord")
    for k, entry in pairs(Gamedata.unit_info.main_unit_size_caste_info) do
        if noble_castes[entry.caste] and (not Gamedata.unit_info.mercenary_units[k]) and (not Gamedata.unit_info.slave_units[k]) then
            rec_handler:set_cost_of_unit(entry.unit_key, dev.mround(entry.num_men*unit_size_mode_scalar, 1))
        end
    end
    rec_handler:set_resource_tooltip("Noble units, including Household units, require Noble population to recruit.")
    rec_handler.image_state = "noble"
end)