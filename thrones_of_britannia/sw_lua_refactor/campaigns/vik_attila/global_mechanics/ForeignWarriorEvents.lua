

local foreigner_riot_events = {
   --[[{
        name = "sw_foreign_army_",
        required_hostility = -3,
        hostility_change = 6,
        condition = function(context) --:WHATEVER
            return true
        end,
        response = function(context) --:WHATEVER
            local region = context:region() --:CA_REGION
            cm:set_public_order_of_province_for_region(region:name(), -500);
        end,
        is_dilemma = false,
        is_village = true

    }, --]]
    {
        name = "sw_foreign_esc_gothi_",
        required_hostility = 3,
        hostility_change = 6,
        condition = function(context) --:WHATEVER
            return false
        end,
        response = function(context) --:WHATEVER

        end,
        is_dilemma = false,
        is_village = true

    },
    {
        name = "sw_foreign_dead_wife_",
        required_hostility = -3,
        hostility_change = 1,
        condition = function(context) --:WHATEVER
            return FOREIGN_WARRIORS.hostility == -3
        end,
        response = function(context) --:WHATEVER

        end,
        is_dilemma = false,
        is_village = false
    },
    {
        name = "sw_foreign_grumpy_neighbours_",
        required_hostility = -2,
        hostility_change = 1,
        condition = function(context) --:WHATEVER
            local region = context:region()
            return FOREIGN_WARRIORS.hostility == -2 
        end,
        response = function(context) --:WHATEVER

        end,
        is_dilemma = false,
        is_village = false
    },
    {
        name = "sw_foreign_esc_tar_and_feather_",
        required_hostility = -1,
        hostility_change = 1,
        condition = function(context) --:WHATEVER
            return FOREIGN_WARRIORS.hostility == -1
        end,
        response = function(context) --:WHATEVER

        end,
        is_dilemma = false,
        is_village = false
    },
    {
        name = "sw_foreign_banditry_",
        required_hostility = 0,
        hostility_change = 1,
        condition = function(context) --:WHATEVER
            return not not BANDITS.regions[context:region():name()]
        end,
        response = function(context) --:WHATEVER

        end,
        is_dilemma = false,
        is_village = true
    },
    {
        name = "sw_foreign_cows_",
        required_hostility = 0,
        hostility_change = 1,
        condition = function(context) --:WHATEVER
            local region = context:region() --:CA_REGION
            return region:building_superchain_exists("vik_pasture")
        end,
        response = function(context) --:WHATEVER

        end,
        is_dilemma = false,
        is_village = true
    },
    {
        name = "sw_foreign_fields_",
        required_hostility = 0,
        hostility_change = 1,
        condition = function(context) --:WHATEVER
            local region = context:region() --:CA_REGION
            return region:building_superchain_exists("vik_farm")
        end,
        response = function(context) --:WHATEVER

        end,
        is_dilemma = false,
        is_village = true
    },
    {
        name = "sw_foreign_sheep_",
        required_hostility = 0,
        hostility_change = 1,
        condition = function(context) --:WHATEVER
            local region = context:region() --:CA_REGION
            return region:building_exists("vik_sheep_1") or region:building_exists("vik_sheep_2") or region:building_exists("vik_sheep_3")
        end,
        response = function(context) --:WHATEVER

        end,
        is_dilemma = false,
        is_village = true
    },
    {
        name = "sw_foreign_food_stores_",
        required_hostility = 0,
        hostility_change = 1,
        condition = function(context) --:WHATEVER
            local region = context:region()
            return PettyKingdoms.FoodStorage.get(region:owning_faction():name()):does_region_have_food_storage(region)
        end,
        response = function(context) --:WHATEVER
            local region = context:region() --:CA_REGION
            PettyKingdoms.FoodStorage.get(region:owning_faction():name()):lose_food_from_region(region)
        end,
        is_dilemma = false,
        is_village = false
    },

    {
        name = "sw_foreign_drunk_brawl_",
        required_hostility = 0,
        hostility_change = 1,
        condition = function(context) --:WHATEVER
            return false
        end,
        response = function(context) --:WHATEVER

        end,
        is_dilemma = false,
        is_village = true

    }
}--:vector<{name: string, required_hostility: int, hostility_change: int, condition: (function(context: WHATEVER) --> boolean), response: (function(context: WHATEVER)), is_dilemma: boolean, is_village: boolean}>



dev.first_tick(function(context)
    local riot_manager = PettyKingdoms.RiotManager
    local event_manager = dev.GameEvents
    local fw = FOREIGN_WARRIORS

    local ForeignerRiotEvents = event_manager:create_new_condition_group("ForeignerRiotEvent", function(context)
        local region = context:region() --:CA_REGION
        local public_order = region:sanitation() - region:squalor()
        local chance = dev.mround(dev.clamp(public_order*-4, 0, 50), 1)
        local is_foreign_province = not not fw.provinces_with_foreigners[region:province_name()]
        local blocked_by_trait = false
        if region:has_governor() then
            blocked_by_trait = region:governor():has_trait("shield_heathen_old_ways")
        end
        return (CONST.__testcases.__test_foreigner_events) or (is_foreign_province and (not blocked_by_trait) and dev.chance(chance))
    end) 
    ForeignerRiotEvents:set_number_allowed_in_queue(1)
    ForeignerRiotEvents:set_cooldown(2)
    event_manager:register_condition_group(ForeignerRiotEvents, "RegionTurnStart")



    for i = 1, #foreigner_riot_events do
        local event_info = foreigner_riot_events[i]
        local event_type = "incident" --:GAME_EVENT_TYPE
        if event_info.is_dilemma then
            event_type = "dilemma" 
        end
        local event = event_manager:create_event(event_info.name, event_type, "concatenate_region")
        event:set_number_allowed_in_queue(1)
        event:add_queue_time_condition(function(context) 
            return (fw.hostility >= event_info.required_hostility) and event_info.condition(context)
        end)
        if CONST.__testcases.__test_foreigner_events then
            event:add_queue_time_condition(function(context)
                local result = event_info.condition(context)
                dev.log("Test for foreigner event: "..event_info.name.." resulted in ".. tostring(result).." (tests ignore hostility req)", "__test_foreigner_events")
                return true
            end)
        end
        event:add_callback(function(context)
            fw.hostility = fw.hostility + event_info.hostility_change
            event_info.response(context)
        end)
        local region_group = "ProvinceCapitals"
        if event_info.is_village then
            region_group = "NotProvinceCapitals"
        end
        event:join_groups(region_group, "ForeignerRiotEvent")
    end

end)