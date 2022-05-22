local riot_soldiers_arrive = "sw_rebellion_soldiers_arrive_"
local riot_events = {
    {
        name = "sw_rebellion_rioting_household_guard_",
        condition = function(context) --:WHATEVER
            local region = context:region()
            return region:has_governor() and dev.chance(50) and dev.Check.does_char_have_household_guard(region:governor()) == true
        end,
        response = function(context) --:WHATEVER
            local region = context:region() --:CA_REGION
            local region_manpower = PettyKingdoms.RegionManpower.get(region:name())
            if context:choice() == 1 then
                region_manpower:mod_population_through_region(-20, "manpower_riots", true, false)
            end
        end,
        is_dilemma = true
    },
    {
        name = "sw_rebellion_bad_governor_",
        condition = function(context) --:WHATEVER
            local region = context:region()
            return region:has_governor() and dev.chance(33) and dev.Check.does_char_have_household_guard(region:governor()) == false and region:governor():has_trait("shield_elder_beloved") == false
        end,
        response = function(context) --:WHATEVER
            local region = context:region() --:CA_REGION
            if not region:has_governor() then
                return --when we run this with the test variable we don't want crashes due to lack of governors.
            end
            local gov = region:governor():command_queue_index()
            cm:kill_character("character_cqi:"..tostring(gov), false, true)
        end,
        is_dilemma = false
    },
    {
        name = "sw_rebellion_food_stores_",
        condition = function(context) --:WHATEVER
            local region = context:region()
            return PettyKingdoms.FoodStorage.get(region:owning_faction():name()):does_region_have_food_storage(region)
        end,
        response = function(context) --:WHATEVER
            local region = context:region() --:CA_REGION
            PettyKingdoms.FoodStorage.get(region:owning_faction():name()):lose_food_from_region(region)
        end,
        is_dilemma = false
    },
    {
        name = "sw_rebellion_lost_clergy_",
        condition = function(context) --:WHATEVER
            local all_regions_in_province = Gamedata.regions.get_regions_in_regions_province(context:region():name())
            local retval = false --:boolean
            for i = 1, #all_regions_in_province do
                local region = PettyKingdoms.RegionManpower.get(context:region():name())
                if region.monk_pop and region.monk_pop > 0 then
                    return true
                end
            end
            return retval
        end,
        response = function(context) --:WHATEVER
            local region = context:region() --:CA_REGION
            local all_regions_in_province = Gamedata.regions.get_regions_in_regions_province(region:name())
            for i = 1, #all_regions_in_province do
                local mp_region = PettyKingdoms.RegionManpower.get(region:name())
                if mp_region.monk_pop and mp_region.monk_pop > 0 then
                    local loss = dev.clamp(PettyKingdoms.RegionManpower.get(region:name()).monk_pop * -1, -40, 0)
                    PettyKingdoms.RegionManpower.get(region:name()):mod_monks(dev.mround(loss, 1), true, "monk_riots")
                end
            end
        end,
        is_dilemma = false
    },
    {
        name = "sw_rebellion_lost_nobles_",
        condition = function(context) --:WHATEVER
           
            local all_regions_in_province = Gamedata.regions.get_regions_in_regions_province(context:region():name())
            local retval = false --:boolean
            for i = 1, #all_regions_in_province do
                local region = PettyKingdoms.RegionManpower.get(context:region():name())
                if region.estate_lord_bonus and region.estate_lord_bonus > 0 then
                    return true
                end
            end
            return retval
        end,
        response = function(context) --:WHATEVER
            local region_key = context:region():name() --:string
            local all_regions_in_province = Gamedata.regions.get_regions_in_regions_province(region_key)
            local retval = false --:boolean
            for i = 1, #all_regions_in_province do
                local region = PettyKingdoms.RegionManpower.get(context:region():name())
                if region.estate_lord_bonus and region.estate_lord_bonus > 0 then
                    region:mod_population_through_region(-20, "manpower_riots", false, true)
                end
            end
        end,
        is_dilemma = false
    },
    {
        name = "shield_rebellion_corruption_",
        condition = function(context) --:WHATEVER
            local region = context:region() --:CA_REGION
            local eligible = region:has_governor() and not region:governor():has_trait("shield_brute_corrupt") 
            local allegiance = (region:majority_religion() == "vik_religion_banditry") or (not not string.find(region:majority_religion(), "usurper"))
            return eligible and allegiance
        end,
        response = function(context) --:WHATEVER
            local region = context:region() --:CA_REGION
            if not region:has_governor() then
                return --when we run this with the test variable we don't want crashes due to lack of governors.
            end
            if not region:governor():has_trait("shield_brute_corrupt")  then
                dev.add_trait(region:governor(), "sheild_brute_corrupt", true)
            end
        end,
        is_dilemma = false
    },
    {
        name = "shield_rebellion_become_berserker_",
        condition = function(context) --:WHATEVER
            local region = context:region() --:CA_REGION
            if not region:has_governor() then
                return 
            end
            local governor = region:governor() 
            local governor_eligible = governor:has_trait("shield_heathen_pagan")
            local chance = 25
            if governor_eligible and (region:governor():has_trait("shield_warrior_champion") or region:governor():has_trait("shield_warrior_proven_warrior")) then
                chance = chance + 25
            end
            if governor_eligible and region:governor():has_trait("shield_heathen_beast_slayer") then
                chance = chance + 15
            end
            if governor_eligible and region:governor():has_trait("shield_brute_bloodythirsty") then
                chance = chance + 15
            end
            return governor_eligible and cm:random_number(100) <= chance
        end,
        response = function(context) --:WHATEVER
            local region = context:region() --:CA_REGION
            if not region:has_governor() then
                return --when we run this with the test variable we don't want crashes due to lack of governors.
            end
            local trait = "shield_heathen_legendary_wolfskin"
            if region:owning_faction():subculture() == "vik_sub_cult_anglo_viking" then
                trait = "shield_heathen_legendary_bearskin"
            end
            if not region:governor():has_trait(trait)  then
                dev.add_trait(region:governor(), trait, true)
            end
        end,
        is_dilemma = false
    },
    {
        name = "sw_rebellion_tyrannical_",
        condition = function(context) --:WHATEVER
            local region = context:region() --:CA_REGION
            if region:owning_faction():has_faction_leader() then
                if region:has_governor() then
                    return region:governor():is_faction_leader() and dev.chance(50) and dev.Check.does_char_have_henchmen(region:governor()) == true 
                elseif region:owning_faction():faction_leader():is_politician() and region:owning_faction():has_home_region() then
                    return region:owning_faction():home_region():name() == region:name()
                end
            end
            return false 
        end,
        response = function(context) --:WHATEVER
            if context:choice() == 0 then
                local region = context:region() --:CA_REGION
                local faction = region:owning_faction()
                if faction:has_faction_leader() then
                    dev.add_trait(faction:faction_leader(), "shield_tyrant_opressor", true)
                end
            end
        end,
        is_dilemma = true
    },
    {
        name = "sw_rebellion_henchmen_",
        condition = function(context) --:WHATEVER
            local region = context:region()
            return region:has_governor() and dev.chance(50) and dev.Check.does_char_have_henchmen(region:governor()) == true
        end,
        response = function(context) --:WHATEVER
            local region = context:region() --:CA_REGION
            if not region:has_governor() then
                return --when we run this with the test variable we don't want crashes due to lack of governors.
            end
            local trait = "shield_tyrant_opressor"
            if context:choice() == 0 then
                local pol_char = PettyKingdoms.CharacterPolitics.get(region:governor())
                local pol_faction_leader = PettyKingdoms.CharacterPolitics.get_faction_leader(region:owning_faction())
                if pol_char then
                    pol_char:increment_character_history("riots_ended_violently")
                    pol_char:increment_faction_history("riots_ended_violently")
                end
                if pol_faction_leader then
                    pol_char:increment_character_history("riots_ended_violently_while_king")
                end
                local region_manpower = PettyKingdoms.RegionManpower.get(region:name())
                region_manpower:mod_population_through_region(-20, "manpower_riots", true, false)
                dev.add_trait(region:governor(), trait, true)
            end
        end,
        is_dilemma = true
    },
    {
        name = "sw_rebellion_oppressor_",
        condition = function(context) --:WHATEVER
            local region = context:region() --:CA_REGION
            return region:has_governor() and dev.chance(50) and region:governor():has_trait("shield_tyrant_opressor")
        end,
        response = function(context) --:WHATEVER
            local region = context:region() --:CA_REGION
            if not region:has_governor() then
                return --when we run this with the test variable we don't want crashes due to lack of governors.
            end
            if context:choice() == 0 then
                local pol_char = PettyKingdoms.CharacterPolitics.get(region:governor())
                local pol_faction_leader = PettyKingdoms.CharacterPolitics.get_faction_leader(region:owning_faction())
                if pol_char then
                    pol_char:increment_character_history("riots_ended_violently")
                    pol_char:increment_faction_history("riots_ended_violently")
                end
                if pol_faction_leader then
                    pol_char:increment_character_history("riots_ended_violently_while_king")
                end
                local region_manpower = PettyKingdoms.RegionManpower.get(region:name())
                region_manpower:mod_population_through_region(-20, "manpower_riots", true, false)
            end
        end,
        is_dilemma = true
    },
    {
        name = "sw_rebellion_beloved_demagogue_",
        condition = function(context) --:WHATEVER
            local region = context:region()
            return region:has_governor() and dev.chance(50) and region:governor():has_trait("shield_trait_disloyal") == true and region:governor():has_trait("shield_elder_beloved") == true
        end,
        response = function(context) --:WHATEVER
            --nada
        end,
        is_dilemma = false
    },
    {
        name = "sw_rebellion_beloved_lost_love_",
        condition = function(context) --:WHATEVER
            local region = context:region()
            return region:has_governor() and dev.chance(50) and region:governor():has_trait("shield_elder_beloved") == true
        end,
        response = function(context) --:WHATEVER
            local region = context:region() --:CA_REGION
            if not region:has_governor() then
                return --when we run this with the test variable we don't want crashes due to lack of governors.
            end

            local trait = "shield_elder_beloved"
            local governor_cqi = region:governor():command_queue_index()
            dev.remove_trait(governor_cqi, "shield_elder_beloved")
        end,
        is_dilemma = false
    },
    {
        name = "sw_rebellion_beloved_talked_down_",
        condition = function(context) --:WHATEVER
            local region = context:region()
            return region:has_governor() and dev.chance(50) and region:governor():has_trait("shield_trait_loyal") == true and region:governor():has_trait("shield_elder_beloved") == true
        end,
        response = function(context) --:WHATEVER
            local region = context:region() --:CA_REGION
            local rm = PettyKingdoms.RiotManager.get(region:name())
            rm:end_riot(region, true)
        end,
        is_dilemma = false
    },

}--:vector<{name: string, condition: (function(context: WHATEVER) --> boolean), response: (function(context: WHATEVER)), is_dilemma: boolean}>

dev.first_tick(function(context)
    local riot_manager = PettyKingdoms.RiotManager
    local event_manager = dev.GameEvents

    local PanicOnTheStreetsOfLondon = event_manager:create_new_condition_group("StandardRiotEvent", function(context)
        local region = Gamedata.regions.get_province_capital_of_regions_province(context:region():name())
        if region:owning_faction():name() ~= context:region():owning_faction():name() then
            return false
        end
        local rm = riot_manager.get(region:name())
        local is_rioting = rm.riot_in_progress
        local is_off_cd = rm.riot_event_cooldown == 0 
        local no_armies_near = not rm:is_army_in_region()
        return is_rioting and (is_off_cd or CONST.__testcases.__test_riots) and no_armies_near
    end) 
    PanicOnTheStreetsOfLondon:set_number_allowed_in_queue(3)
    PanicOnTheStreetsOfLondon:add_callback_on_queue(function(context)
        local rm = riot_manager.get(context:region():name())
        rm.riot_event_cooldown = 2
    end)
    PanicOnTheStreetsOfLondon:add_callback_on_unqueue(function(context)
        local rm = riot_manager.get(context:region():name())
        rm.riot_event_cooldown = 0
    end)
    event_manager:register_condition_group(PanicOnTheStreetsOfLondon, "RegionTurnStart")

    for i = 1, #riot_events do
        local event_info = riot_events[i]
        local event_type = "incident" --:GAME_EVENT_TYPE
        if event_info.is_dilemma then
            event_type = "dilemma" 
        end
        local PanicOnTheStreetsOfBirmingham = event_manager:create_event(event_info.name, event_type, "concatenate_region")
        PanicOnTheStreetsOfBirmingham:set_number_allowed_in_queue(1)
        PanicOnTheStreetsOfBirmingham:add_queue_time_condition(event_info.condition)
        if CONST.__testcases.__test_riots then
            PanicOnTheStreetsOfBirmingham:add_queue_time_condition(function(context)
                local result = event_info.condition(context)
                dev.log("Test for riot event: "..event_info.name.." resulted in ".. tostring(result), "__test_riots")
                return true
            end)
        end
        PanicOnTheStreetsOfBirmingham:add_callback(event_info.response)
        PanicOnTheStreetsOfBirmingham:join_groups("ProvinceCapitals", "StandardRiotEvent")
    end

    local soldiers_arrive_group = event_manager:create_new_condition_group("RiotSoldiersArriveGroup", function(context)
        local region = context:region() --:CA_REGION
        local rm = riot_manager.get(region:name())
        if rm then
            return rm.riot_in_progress
        else
            return false
        end
    end)
    event_manager:register_condition_group(soldiers_arrive_group, "CharacterEntersGarrison")
    local soldiers_arrive = event_manager:create_event(riot_soldiers_arrive, "dilemma", "concatenate_region")
    soldiers_arrive:add_callback(function(context)
        if context:choice() == 0 then
            local region_manpower = PettyKingdoms.RegionManpower.get(context:region():name())
            region_manpower:mod_population_through_region(-20, "manpower_riots", true, false)
        end
    end)
    soldiers_arrive:join_groups("ProvinceCapitals", "RiotSoldiersArriveGroup")
end)