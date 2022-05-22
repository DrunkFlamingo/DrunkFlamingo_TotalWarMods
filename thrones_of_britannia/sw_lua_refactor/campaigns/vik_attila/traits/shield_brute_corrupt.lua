local tm = trait_manager.new("shield_brute_corrupt")

tm:set_anti_traits("shield_faithful_charitable", "shield_elder_dutiful",
 "shield_judge_honourable", "shield_judge_just", "shield_judge_lawful",
"shield_faithful_repentant")

tm:set_base_chance(5)

dev.first_tick(function(context)
    tm:add_chance_modifier(function(char)
        local retval = 0
        if char:has_trait("shield_magnate_greedy") then
            retval = retval + 20
        end
        if char:has_trait("shield_magnate_collector") then
            retval = retval + 20
        end
        if char:has_trait("shield_tyrant_treasonous") then
            retval = retval + 20
        end
        local region = char:region()
        if not region:is_null_interface() then
            --merchants
            if region:building_superchain_exists("vik_merchant") then
                retval = retval + 20
            end
        end
        local pol_char = PettyKingdoms.CharacterPolitics.get(char)

        return retval
    end)

    tm:add_trait_gained_dilemma("sw_traits_corruption", function(character)
        local pol_char = PettyKingdoms.CharacterPolitics.get(character)
        if pol_char then
            return pol_char:get_character_history("turns_disloyal_in_row") > 5 
        end
        return false
    end, true)

end)