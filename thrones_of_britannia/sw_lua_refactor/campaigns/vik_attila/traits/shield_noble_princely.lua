local tm = trait_manager.new("shield_noble_princely")

local succession_event = dev.GameEvents:create_event("shield_trait_event_prince_assumes_throne", "incident", "standard")
dev.first_tick(function(context)
    tm:add_trait_gained_dilemma("sw_traits_grooming_heir", function(character)
        local is_heir = character:is_heir()
        local has_authority = character:faction():faction_leader():gravitas() > 5
        return is_heir and has_authority
    end, false)

    dev.trait_turn_start("shield_noble_princely", function(context)
        local character = context:character() --:CA_CHAR
        if character:is_faction_leader() then
            dev.remove_trait(character, "shield_noble_princely")
            local context = dev.GameEvents:build_context_for_event(character:faction(), character)
            dev.GameEvents:force_check_and_trigger_event_immediately(succession_event, context)
        elseif not character:is_heir() then
            dev.remove_trait(character, "shield_noble_princely")
        end
    end)

end)
