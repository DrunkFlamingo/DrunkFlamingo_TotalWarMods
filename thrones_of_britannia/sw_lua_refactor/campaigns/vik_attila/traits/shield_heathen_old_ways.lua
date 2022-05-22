local tm = trait_manager.new("shield_heathen_old_ways")

tm:add_prohibiter(function(character)
    return not dev.Check.is_char_from_viking_faction(character)
end)

tm:set_anti_traits("shield_faithful_friend_of_the_church")

tm:set_base_chance(0)

dev.first_tick(function(context)
    tm:add_chance_modifier(function(character)
        local retval = 0
        if character:region():is_null_interface() then
            return retval
        end
        local adjacent_list = character:region():adjacent_region_list()
        for i = 0, adjacent_list:num_items() - 1 do
            local current = adjacent_list:item_at(i)
            --is the region owned by a viking we are *not* are war with?
            if (not character:faction():at_war_with(current:owning_faction())) and dev.Check.is_faction_viking_faction(current:owning_faction()) then
                retval = retval + 15
            end
        end
        return retval
    end)



    tm:add_trait_gained_dilemma("sw_traits_foreign_settlers", function(character)
        return character:faction():treasury() > 500
    end, true)

    tm:add_trait_gained_dilemma("sw_traits_strange_friends", function(character)
        local vikings_at_war_with = 0
        local war_with = character:faction():factions_at_war_with()
        for i = 0, war_with:num_items() - 1 do 
            local faction = war_with:item_at(i)
            if not dev.Check.is_faction_raider_faction(faction) and dev.Check.is_faction_viking_faction(faction) then
                vikings_at_war_with = vikings_at_war_with + 1
            end
        end
        return vikings_at_war_with == 0
    end, true)

    tm:add_trait_effect_condition("_loyalty_event", 10, function(context)
        local faction = context:faction() --:CA_FACTION
        local other_faction = context:other_faction() --:CA_FACTION
        return dev.Check.is_faction_viking_faction(other_faction), faction
    end, "FactionVassalRebelled",
    "shield_loyalty_event_treaties_broken_vikings")

    tm:add_trait_effect_condition("_loyalty_event", 10, function(context)
        local faction = context:faction() --:CA_FACTION
        local other_faction = context:other_faction() --:CA_FACTION
        return dev.Check.is_faction_viking_faction(other_faction), faction
    end, "FactionAllianceBroken",
    "shield_loyalty_event_treaties_broken_vikings")

end)
tm:set_start_pos_characters(
    --northanhymbre viking sympathizer
    "faction:vik_fact_northleode,forename:2147363531"
)