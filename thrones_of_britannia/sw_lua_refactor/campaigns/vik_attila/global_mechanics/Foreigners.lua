MANPOWER_FOREIGN = {} --:map<string, FACTION_RESOURCE>
FOREIGN_WARRIORS = {
    hostility = -3,
    last_foreigner_event_turn = -1,
    provinces_with_foreigners = {}
} --:{hostility: int, last_foreigner_event_turn: int, provinces_with_foreigners: map<string, boolean>}
dev.Save.attach_to_table(FOREIGN_WARRIORS, "FOREIGN_WARRIORS_INFO")

--v function(t: string)
local function log(t)
    dev.log(tostring(t), "FW_POP")
end


local hostility_major_war = 5
local hostility_capital_captured = 5
local hostility_threshold_low = 5
local hostility_threshold_high = 30

local per_turn_change_limit = 20
local per_turn_change_limit_negative = -40
local per_turn_change_rate = 10 --percentage of growth/decay room used per turn.

local recruitment_factor = "manpower_recruitment" --:string
local character_factor = "foreigners_characters" --:string
local here_king_factor = "foreigners_faction_leader" --:string
local replenishment_factor = "foreigners_replenishment" --:string
local events_factor = "foreigners_events" --:string

local unit_size_mode_scalar = CONST.__unit_size_scalar
local foreign_major_settlement_building = "vik_borough"
local major_settlement_popcap = 300 
local foreign_minor_settlement_building = "vik_foreigners"
local minor_settlement_popcap = 120
local alehouse_minor_settlement_building = "vik_alehouse"
local alehouse_settlement_popcap = 40

local trait_to_foreigner_popcaps = {
    ["shield_heathen_old_ways"] = 30
} --:map<string, int>

local building_foreigner_effects = {
    ["vik_borough"] = {{160, 200, 240, 300, 450}, "foreigners_borough"},
    ["vik_foreigners"] = {{80, 120, 160}, "foreigners_village"},
    ["vik_alehouse"] = {30, "foreigners_alehouse"},
    ["vik_longphort"] = {{80, 100, 120, 160, 200}, "foreigners_longphorts"},
    ["vik_hof"] = {60, "foreigners_hof", "vik_sub_cult_viking_gael"}
}--:map<string, {int|vector<int>, string, string?}>

local here_king_to_foreigner_popcaps = {
    [1] = 0,
    [2] = 30,
    [3] = 80,
    [4] = 80,
    [5] = 150,
    [6] = 300
}--:map<number, int>

--v function(faction: CA_FACTION)
local function process_turn_start(faction)
    log("Processing turn start for "..faction:name())
    local foreigners = MANPOWER_FOREIGN[faction:name()]

    --add up our foreigner sources to get our target cap
    --from regions
    local region_list = faction:region_list()
    local from_buildings = {} --:map<string, int>
    for key, value in pairs(building_foreigner_effects) do
        if value[3] then
            if faction:subculture() == value[3] then
                from_buildings[value[2]] = 0
            end
        else
            from_buildings[value[2]] = 0
        end
    end
    for j = 0, region_list:num_items() - 1 do
        local region = region_list:item_at(j)
        local slot_list = region:settlement():slot_list()
        for i = 0, slot_list:num_items() - 1 do 
            local slot = slot_list:item_at(i)
            if slot:has_building() then
                local key  = slot:building():superchain()
                if building_foreigner_effects[key] then
                    local quantities = building_foreigner_effects[key][1]
                    local quantity --:int
                    if is_table(quantities) then
                        --# assume quantities: map<number, int>
                        local level = tonumber(dev.get_numbers_from_text(slot:building():name()))
                        quantity = quantities[level]
                        if not quantities[level] then
                            quantity = 0
                        end
                    else
                        --# assume quantities: int
                        quantity = quantities
                    end
                    local factor = building_foreigner_effects[key][2]
                    log(key.. " at "..region:name().. " worth "..tostring(quantity) .. " in "..factor)
                    if from_buildings[factor] then
                        FOREIGN_WARRIORS.provinces_with_foreigners[region:province_name()] = true
                        from_buildings[factor] = (from_buildings[factor]) + quantity
                    end
                end
            end
        end
    end

    --from traits
    local from_characters = 0
    local character_list = faction:character_list()
    for j = 0, character_list:num_items() - 1 do
        local character = character_list:item_at(j)
        for trait_key, popcap in pairs(trait_to_foreigner_popcaps) do
            if character:has_trait(trait_key) then
                from_characters = from_characters + popcap
            end
        end
    end
    foreigners:set_factor(character_factor, from_characters)
    --from faction mechanics
    local from_faction = 0
    if faction:subculture() == "vik_sub_cult_anglo_viking" then 
        local hk_english = PettyKingdoms.FactionResource.get("vik_here_king_english", faction)
        local hk_english_value_to_foreigners = {
            [1] = 0,
            [2] = 0,
            [3] = 80,
            [4] = 120,
            [5] = 240,
            [6] = 600
        }--:map<int, int>
        if hk_english then
            from_faction = hk_english_value_to_foreigners[hk_english.value]  or 0
        end
        foreigners:set_factor(here_king_factor, from_faction)
    end



    local from_events = foreigners:get_factor(events_factor) --set by events through scripted payload system.



    local target_foreigners = from_characters + from_faction + from_events

    for factor_key, quantity in pairs(from_buildings) do
        target_foreigners = target_foreigners + quantity
        foreigners:set_factor(factor_key, quantity)
    end

    log("Set regional, character, and faction factors")
    log("Total Target Foreigners is: "..target_foreigners)
    if target_foreigners > 0 then
        local actual_foreigners = foreigners.value
        log("Actual foreigners total is "..actual_foreigners)
        local growth_room = dev.mround((1 - (actual_foreigners/target_foreigners)) * target_foreigners, 1)
        log("Growth or decay room is "..growth_room)
        local old_replenishment = foreigners:get_factor(replenishment_factor)
        local change_value = dev.mround(dev.clamp(growth_room*(per_turn_change_rate/100), per_turn_change_limit_negative, per_turn_change_limit), 1)
        log("Change value this turn is "..change_value)
        if change_value < 5 and change_value > 0 then
            log("adjusted change value up to minimum 5")
            change_value = 5
        elseif change_value < 0 and change_value > -5 then
            log("adjusted change value down to minimum -5")
            change_value = -5
        end
        if not dev.is_new_game() then
            log("setting new migration factor")
            foreigners:change_value(change_value, replenishment_factor)
        else
            log("New game foreigner setup, set migration to 0")
            foreigners:set_factor(replenishment_factor, 0)
            foreigners:reapply()
        end

    else
        foreigners:reapply()
    end
end



--v function(resource: FACTION_RESOURCE) --> string
local function value_converter(resource)
        --[[
        1: No foreigners around
        2-8: default foreigners bundles
    ]]
    local faction = dev.get_faction(resource.owning_faction)
    local is_viking_aligned = faction:subculture() == "vik_sub_cult_viking_gael" or 
    (faction:subculture() == "vik_sub_cult_anglo_viking" and 
    (faction:has_effect_bundle("vik_here_king_english_1") 
    or faction:has_effect_bundle("vik_here_king_army_1") 
    or faction:has_effect_bundle("vik_here_king_army_2") 
    or faction:has_effect_bundle("vik_here_king_army_3")))

    local bundle_val = dev.clamp(math.ceil(resource.value/180) + 1, 1, 8)
    if is_viking_aligned and bundle_val > 1 then
        bundle_val = bundle_val + 7
    end
    return tostring(bundle_val)
end


dev.first_tick(function(context)
    local human_factions = cm:get_human_factions()

    for i = 1, #human_factions do
        MANPOWER_FOREIGN[human_factions[i]] = PettyKingdoms.FactionResource.new(human_factions[i], "sw_pop_foreign", "population", 0, 30000, {}, value_converter)
        local foreigners = MANPOWER_FOREIGN[human_factions[i]]
        foreigners.uic_override = {"layout", "top_center_holder", "resources_bar2", "culture_mechanics"} 
        if dev.is_new_game() then
            process_turn_start(dev.get_faction(human_factions[i]))
        else
            foreigners:reapply()
        end
    end

    dev.eh:add_listener(
        "ForeignWarriorsTurnStart",
        "FactionTurnStart",
        function(context)
            return context:faction():is_human()
        end,
        function(context)
            process_turn_start(context:faction())
            MANPOWER_FOREIGN[context:faction():name()]:reapply()
        end,
        true)


    local rec_handler = UIScript.recruitment_handler.add_resource("sw_pop_foreign", function(faction_name)
        return PettyKingdoms.FactionResource.get("sw_pop_foreign", dev.get_faction(faction_name)).value
    end, 
    function(faction_name, quantity)
        PettyKingdoms.FactionResource.get("sw_pop_foreign", dev.get_faction(faction_name)):change_value(quantity, recruitment_factor)
    end, "dy_pop_foreign")
    for k, entry in pairs(Gamedata.unit_info.main_unit_size_caste_info) do
        if Gamedata.unit_info.mercenary_units[k] then
            rec_handler:set_cost_of_unit(entry.unit_key, dev.mround(entry.num_men*unit_size_mode_scalar, 1))
        end
    end
    rec_handler:set_resource_tooltip("Foreign Mercenary and Vikingar units require Foreigner population to recruit")
    rec_handler.image_state = "foreigner"
    PettyKingdoms.RegionManpower.activate("foreign", function(faction_key, factor_key, change)
        local pop = PettyKingdoms.FactionResource.get("sw_pop_foreign", dev.get_faction(faction_key))
        if pop then
            pop:change_value(change, factor_key)
        end
    end)

end)