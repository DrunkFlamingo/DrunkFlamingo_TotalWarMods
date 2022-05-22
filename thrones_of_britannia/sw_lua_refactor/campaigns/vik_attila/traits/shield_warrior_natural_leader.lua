local tm = trait_manager.new("shield_warrior_natural_leader")

dev.first_tick(function(context)
    tm:add_trait_gain_condition_without_event(function(char)
        local pol_char = PettyKingdoms.CharacterPolitics.get(char)
        if char:won_battle() and pol_char then
            local points = 0
            local heroic_victories = pol_char:get_character_history("num_heroic_victory")
            points = points + heroic_victories*50
            local significant_victories = pol_char:get_character_history("significant_battles_won")
            points = points + significant_victories*10
            if points >= 100 then
                return true
            end
        end
        return false
    end, false, "ShieldwallCharacterCompletedBattle")
end)