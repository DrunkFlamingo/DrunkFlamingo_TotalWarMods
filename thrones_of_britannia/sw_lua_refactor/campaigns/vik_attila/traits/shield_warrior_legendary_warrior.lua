local tm = trait_manager.new("shield_warrior_legendary_warrior")

local great_capitals = {
    ["vik_reg_northwic"] = true,
    ["vik_reg_wintanceaster"] = true,
    ["vik_reg_scoan"] = true,
    ["vik_reg_caisil"] = true,
    ["vik_reg_eoferwic"] = true
} --:map<string, boolean>

dev.first_tick(function(context)
    tm:add_trait_gain_condition_without_event(function(char)
        local pol_char = PettyKingdoms.CharacterPolitics.get(char)
        local region =  char:region():name()
        local has_traits = char:has_trait("shield_warrior_natural_leader")
        --and char:has_trait("shield_warrior_proven_warrior") 
        --and char:has_trait("shield_warrior_champion")
        if pol_char and great_capitals[region] then
            pol_char:increment_character_history("great_capitals_captured")
            local points = 0 + (pol_char:get_character_history("great_capitals_captured")*50)
            local heroic_victories = pol_char:get_character_history("num_heroic_victory")
            points = points + heroic_victories*8
            local significant_victories = pol_char:get_character_history("significant_battles_won")
            points = points + significant_victories*4
            if points >= 100 then
                return true
            end
        end
        return false
    end, false, "CharacterPerformsOccupationDecisionOccupy")

end)