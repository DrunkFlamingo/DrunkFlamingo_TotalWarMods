local tm = trait_manager.new("shield_noble_high_born")

tm:set_base_chance(20)
tm:add_trait_gain_condition_without_event(function(char)
    if char:family_member():has_father() and char:family_member():father():has_trait("shield_noble_high_born") then
        return true
    end
    return false
end, false, "CharacterComesOfAge")

tm:add_trait_gain_condition_without_event(function(char)
    if char:age() > 20 and char:is_male() then
        return true
    end
    return false
end, true, "CharacterCreated")



tm:set_start_pos_characters(
    "faction:vik_fact_west_seaxe,forename:2147363229",
    "faction:vik_fact_west_seaxe,forename:2147363123",
    "faction:vik_fact_west_seaxe,forename:2147363108",
    "faction:vik_fact_west_seaxe,forename:2147363513",
    "faction:vik_fact_mierce,forename:2147363290",
    "faction:vik_fact_mierce,forename:2147363513",
    "faction:vik_fact_mierce,forename:2147363335",
    "faction:vik_fact_mierce,forename:2147363481"
)

tm:set_cross_loyalty("shield_noble_high_born", 1)