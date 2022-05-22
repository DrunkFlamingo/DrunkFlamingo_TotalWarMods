local tm = trait_manager.new("shield_elder_dutifull")

dev.first_tick(function(context)
    tm:add_trait_gain_condition_without_event(function(char)
        local pol_char = PettyKingdoms.CharacterPolitics.get(char)
        if pol_char then
            if pol_char:get_character_history("turns_as_general") > 24 and char:age() < 20 then
                return true
            end
        end
        return false
    end, false, "CharacterTurnStart")

    tm:add_trait_effect_condition("_loyalty_event", 10, function(context)
        local faction = context:faction() --:CA_FACTION
        if faction:has_faction_leader() then
            local faction_leader = faction:faction_leader()
            local pol_char = PettyKingdoms.CharacterPolitics.get_faction_leader(faction)
            if pol_char then
                local bandits_alive_for_turns = pol_char:get_faction_history("bandits_alive_for_turns")
                return bandits_alive_for_turns > 12, faction
            end
        end
        return false, faction
    end, "FactionTurnStart",
    "shield_loyalty_event_rampant_banditry")
end)