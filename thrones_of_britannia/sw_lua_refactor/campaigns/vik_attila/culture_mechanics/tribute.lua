local TRIBUTE = {} --:map<string, FACTION_RESOURCE>

local tribute_max = 30

local tribute_decay = -3
local decay_factor = "factor_decay_tribute"
local tribute_raiding = 1
local raiding_factor = "factor_raiding_tribute"
local tribute_sacking = 10
local sacking_factor = "factor_looting_tribute"
local tribute_vassal = 2
local vassal_factor = "factor_vassals_tribute"
local tribute_factions = {
    ["vik_fact_sudreyar"] = {
        ["factor_raiding_tribute"] = 5,
        ["factor_looting_tribute"] = 10,
        ["factor_decay_tribute"] = 0,
        ["factor_vassals_tribute"] = 0,
        ["factor_events_tribute"] = 0
    },
    ["vik_fact_dyflin"] = {
        ["factor_raiding_tribute"] = 6,
        ["factor_looting_tribute"] = 10,
        ["factor_decay_tribute"] = 0,
        ["factor_vassals_tribute"] = 0,
        ["factor_events_tribute"] = 0
    }
} --:map<string, map<string, int>>

--v function(resource: FACTION_RESOURCE) --> string
local function value_converter(resource)
    return tostring(math.floor(resource.value/6))
end

--v function(faction:CA_FACTION)
local function tribute_turn_start(faction)
    local tribute = TRIBUTE[faction:name()]
    for i = 0, faction:character_list():num_items() - 1 do
        local char = faction:character_list():item_at(i)
        if char:has_military_force() and char:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" then
            tribute:change_value(tribute_raiding, raiding_factor)
        end
    end
end
	
dev.first_tick(function(context) 
    dev.log("#### Adding TRIBUTE Mechanics Listeners ####", "TRIBUTE")
    local humans = cm:get_human_factions()
    for i = 1, #humans do
        local h_name = humans[i]
        local h_faction = dev.get_faction(h_name)
        local tribute --:FACTION_RESOURCE
        if tribute_factions[h_name] then
            tribute = PettyKingdoms.FactionResource.new(h_name, "vik_tribute", "resource_bar", 0, tribute_max, {}, value_converter)
            TRIBUTE[h_name] = tribute
            if dev.is_new_game() then
                for key, value in pairs(tribute_factions[h_name]) do
                    tribute:set_factor(key, value)
                end
            end
            tribute:reapply()
            dev.eh:add_listener(
                "TributeTurnStart",
                "FactionTurnStart",
                function(context)
                    local faction = context:faction()--:CA_FACTION
                    return faction:is_vassal_of(h_faction) 
                end,
                function(context)
                    
                    tribute:change_value(tribute_vassal, vassal_factor)
                end,
                true)
            dev.eh:add_listener(
                "TributeTurnStart",
                "FactionTurnStart",
                function(context)
                    return context:faction():name() == h_name 
                end,
                function(context)
                    tribute_turn_start(context:faction())
                end,
                true)

        end

        local tribute_events = dev.GameEvents:create_new_condition_group("TributeEvents", function(context)
            if TRIBUTE[context:faction():name()] then
                if CONST.__testcases.__test_tribute_events == true then
                    return true
                end
                return TRIBUTE[context:faction():name()].value >= 25
            else
                return false
            end
        end)
        tribute_events:set_number_allowed_in_queue(1)
        if not CONST.__testcases.__test_tribute_events then
            tribute_events:set_cooldown(10)
        end
        dev.GameEvents:register_condition_group(tribute_events, "FactionTurnStart")

        local auth_or_foreigners = dev.GameEvents:create_event("sw_spend_tribute_authority_or_foreigners", "dilemma", "standard")
        auth_or_foreigners:add_callback(function(context)
            dev.log("About to fire payload for tribute event")
            if context:choice() < 2 then
                if context:choice() == 1 then
                    MANPOWER_FOREIGN[context:faction():name()]:change_value(120, "factor_events_tribute")
                end
                TRIBUTE[context:faction():name()]:change_value(-12, "factor_events_tribute")
            end
        end)
        auth_or_foreigners:set_cooldown(15)
        auth_or_foreigners:join_groups("TributeEvents")

        local sea_captain = dev.GameEvents:create_event("sw_spend_tribute_sea_captain", "dilemma", "standard")
        sea_captain:add_queue_time_condition(function(context)
            return context:faction():name() == "vik_fact_sudreyar"
        end)
        sea_captain:add_callback(function(context)
            if context:choice() == 0 then
                TRIBUTE[context:faction():name()]:change_value(-12, "factor_events_tribute")
            end
        end)
        sea_captain:set_cooldown(15)
        sea_captain:join_groups("TributeEvents")

        local sea_king = dev.GameEvents:create_event("sw_spend_tribute_sea_king", "dilemma", "standard")
        sea_king:add_queue_time_condition(function(context)
            return context:faction():has_technology("vik_mil_melee_5")
        end)
        sea_king:add_callback(function(context)
            TRIBUTE[context:faction():name()]:change_value(-20, "factor_events_tribute")
        end)
        sea_king:set_cooldown(15)
        sea_king:join_groups("TributeEvents")

        local vikingar = dev.GameEvents:create_event("sw_spend_tribute_vikingar", "dilemma", "standard")
        vikingar:add_callback(function(context)
            TRIBUTE[context:faction():name()]:change_value(-8, "factor_events_tribute")
        end)
        vikingar:set_cooldown(15)
        vikingar:join_groups("TributeEvents")

        dev.eh:add_listener( -- settlement sacking
		"CharacterPerformsOccupationDecisionSackTribute",
		"CharacterPerformsOccupationDecisionSack",
		function(context) return not not TRIBUTE[context:character():faction():name()] end,
		function(context)
            TRIBUTE[context:character():faction():name()]:change_value(tribute_sacking, sacking_factor)
        end,
		true
	);
    end




end)

