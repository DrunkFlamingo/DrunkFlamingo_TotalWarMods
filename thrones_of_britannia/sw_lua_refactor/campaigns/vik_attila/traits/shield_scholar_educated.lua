local tm = trait_manager.new("shield_scholar_educated")

local event_manager = dev.GameEvents

dev.first_tick(function(context)
    tm:add_trait_gained_dilemma("sw_traits_educating_heir", function(character)
        --needs to have a dad
        local has_dad = character:family_member():has_father()
        --needs to have tuition money
        local has_money = character:faction():treasury() > 500
        --needs to be a potential general/governor
        local period_accurate_sexism = character:is_male()
        --needs to be the correct age
        local age_window = character:age() > 10 and character:age() < 20
        return has_dad and has_money and period_accurate_sexism and age_window
    end, false)

    tm:add_trait_effect_condition("_loyalty_event", 10, function(context)
        local building = context:building() --:CA_BUILDING
        if building:superchain() == "vik_library" or building:superchain() == "vik_court_school" then
            return true, building:faction()
        end
        return false, building:faction()
    end, "BuildingCompleted",
    "shield_loyalty_event_treaties_broken_vikings")

end)



tm:set_cross_loyalty("shield_scholar_wise", 1)

tm:set_start_pos_characters(
    "faction:vik_fact_west_seaxe,forename:2147363229",
    "faction:vik_fact_west_seaxe,forename:2147363108",
    "faction:vik_fact_gwined,forename:2147367296"
)