local tm = trait_manager.new("shield_elder_beloved")

tm:set_base_chance(0)
tm:set_anti_traits("shield_tyrant_opressor")

dev.first_tick(function(context)
    tm:add_chance_modifier(function(char)
        local pol_char = PettyKingdoms.CharacterPolitics.get(char)
        if pol_char then
            local turns = pol_char:get_character_history("turns_without_riot_while_governor")
            if turns > 18 then
                return turns
            end
        end
        return 0
    end)


    tm:add_trait_gained_dilemma("sw_traits_beloved", function(character)
        local region = character:region()
        if not region:is_null_interface() then
            local public_order = region:sanitation() - region:squalor()
            return public_order > 2
        end
        return false
    end, true)

end)