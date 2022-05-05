local tm = trait_manager.new("shield_tyrant_treasonous")


tm:set_anti_traits("shield_faithful_charitable", 
 "shield_judge_honourable", "shield_judge_just", "shield_judge_lawful",
"shield_faithful_repentant")

tm:set_base_chance(0)
dev.first_tick(function(context)
    tm:add_chance_modifier(function(char)
        local retval = 0
        if char:has_trait("shield_tyrant_subjugator") then
            retval = retval + 20
        end
        if char:has_trait("shield_brute_violent") then
            retval = retval + 20
        end
        if char:has_trait("shield_brute_corrupt") then
            retval = retval + 20
        end
        local region = char:region()
        if not region:is_null_interface() then
            --usurper allegiance.
            if string.find(region:majority_religion(), "usurper") then
                retval = retval + 20
            end
        end
        local pol_char = PettyKingdoms.CharacterPolitics.get(char)

        return retval
    end)

    tm:add_trait_gained_dilemma("sw_traits_treason", function(character)
        local pol_char = PettyKingdoms.CharacterPolitics.get(character)
            if pol_char then
                return pol_char:get_character_history("turns_disloyal_in_row") > 5 
            end
            return false
        end, 
        true, 
        function(context)
            local faction = context:faction() --:CA_FACTION
            local pol_char = PettyKingdoms.CharacterPolitics.get_faction_leader(faction)
            if pol_char then
                if context:choice() == 1 then
                    pol_char:increment_character_history("violent_political_actions")
                    pol_char:increment_faction_history("violent_political_actions")
                end
            end
        end)

end)