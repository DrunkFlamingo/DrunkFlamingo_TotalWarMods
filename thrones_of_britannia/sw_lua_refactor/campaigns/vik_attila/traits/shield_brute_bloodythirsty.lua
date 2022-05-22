local tm = trait_manager.new("shield_brute_bloodythirsty")

tm:set_anti_traits("shield_elder_dutiful", "shield_faithful_repentant", "shield_scholar_wise")


tm:set_base_chance(0)

tm:add_chance_modifier(function(char)
    local pol_char = PettyKingdoms.CharacterPolitics.get(char)
    if pol_char then
        pyrrhic_victories = pol_char:get_character_history("num_pyrrhic_victory")
        if pyrrhic_victories > 2 then
            local multiplier = 0
            if char:has_trait("shield_brute_violent") then
                multiplier = multiplier + 10
            end
            return pyrrhic_victories*multiplier
        end
    end
    return 0
end)


tm:add_trait_gain_condition_without_event(function(char)
    local pol_char = PettyKingdoms.CharacterPolitics.get(char)
    if char:won_battle() then
        local pb = char:model():pending_battle()
        local attacker_won = pb:attacker():won_battle()
        if attacker_won and pb:attacker_battle_result() == "pyrrhic_victory" then
            return true
        elseif pb:defender_battle_result() == "pyrrhic_victory" then
            return true
        end
    end
    return false
end, false, "ShieldwallCharacterCompletedBattle")
