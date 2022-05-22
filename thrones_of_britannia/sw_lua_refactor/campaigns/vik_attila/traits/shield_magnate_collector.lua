local tm = trait_manager.new("shield_magnate_collector")

tm:set_anti_traits("shield_faithful_charitable", "shield_elder_beloved")

tm:set_base_chance(0)
dev.first_tick(function(context)
    tm:add_chance_modifier(function(char)
        local retval = 0
        if char:has_trait("shield_magnate_greedy") then
            retval = retval + 20
        end
        if char:has_trait("shield_tyrant_oppressor") then
            retval = retval + 20
        end
        retval = retval + dev.mround(char:faction():tax_category() * 2, 1)

        return retval
    end)


    tm:add_trait_gained_dilemma("sw_traits_collector", function(character)
        local pol_char = PettyKingdoms.CharacterPolitics.get(character)
            if pol_char and character:faction():has_faction_leader() then
                local time_as_gov = pol_char:get_character_history("turns_as_governor_in_row") > 6
                local not_already_charitable = not character:faction():faction_leader():has_trait("shield_faithful_charitable")
                return time_as_gov and not_already_charitable and character:has_trait("shield_trait_loyal")
            end
            return false
        end, 
        true, 
        function(context)
            local faction = context:faction() --:CA_FACTION
            local pol_char = PettyKingdoms.CharacterPolitics.get_faction_leader(faction)
            if faction:has_faction_leader() then
                if context:choice() == 1 then
                    dev.add_trait(faction:faction_leader(), "shield_faithful_charitable", true)
                end
            end
        end)
end)