local tm = trait_manager.new("shield_heathen_pagan")

tm:add_trait_gain_condition_without_event(function(character)
    if character:is_male() and character:family_member():has_father() and character:family_member():father():has_trait("shield_heathen_pagan") then
        return true
    end
    return false
end, false, "CharacterComesOfAge")


tm:set_start_pos_characters(
    "faction:vik_fact_sudreyar,forename:2147365942",
    "faction:vik_fact_sudreyar,forename:2147366135",
    "faction:vik_fact_sudreyar,forename:2147365979",
    "faction:vik_fact_sudreyar,forename:2147365995",
    "faction:vik_fact_sudreyar,forename:2147366152",
    "faction:vik_fact_dyflin,forename:2147365881",
    "faction:vik_fact_dyflin,forename:2147366107",
    "faction:vik_fact_dyflin,forename:2147366232",
    "faction:vik_fact_dyflin,forename:2147366227"
)