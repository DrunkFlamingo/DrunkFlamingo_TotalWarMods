local HEROISM = {} --:map<string, FACTION_RESOURCE>
local heroism_factions = {
    ["vik_fact_gwined"] = {
        ["factor_follower_events_heroism"] = 0,
        ["factor_dilemmas_heroism"] = 0,
        ["factor_decrees_heroism"] = 0,
        ["factor_heroic_victories_heroism"] = 20,
        ["factor_valiant_defeats_heroism"] = 3,
        ["factor_bandits_heroism"] = -2,
        ["factor_riots_heroism"] = 0,
        --["factor_political_actions_heroism"] = 0, --not yet impl
        ["factor_champion_follower_heroism"] = 0,
        ["factor_defeats_heroism"] = -6,
        ["factor_missions_heroism"] = 0
    },
    ["vik_fact_strat_clut"] = {        
        ["factor_follower_events_heroism"] = 0,
        ["factor_dilemmas_heroism"] = 0,
        ["factor_decrees_heroism"] = 0,
        ["factor_heroic_victories_heroism"] = 20,
        ["factor_valiant_defeats_heroism"] = 3,
        ["factor_bandits_heroism"] = -2,
        ["factor_riots_heroism"] = 0,
        --["factor_political_actions_heroism"] = 0, --not yet impl
        ["factor_champion_follower_heroism"] = 0,
        ["factor_defeats_heroism"] = -6,
        ["factor_missions_heroism"] = 0
    }
} --:map<string, map<string, int>>
local heroism_max = 30

--v function(resource: FACTION_RESOURCE) --> string
local function value_converter(resource)
    return tostring(math.floor(resource.value/6))
end


local heroism_missions = {
	["vik_reg_aberffro"] = "sw_heroism_region_vik_reg_aberffro",
	["vik_reg_aberteifi"] = "sw_heroism_region_vik_reg_aberteifi",
	["vik_reg_cair_gwent"] = "sw_heroism_region_vik_reg_cair_gwent",
	["vik_reg_dinefwr"] = "sw_heroism_region_vik_reg_dinefwr",
	["vik_reg_guvan"] = "sw_heroism_region_vik_reg_guvan",
	["vik_reg_mathrafal"] = "sw_heroism_region_vik_reg_mathrafal",
	["vik_fact_aileach"] = "sw_heroism_vik_fact_aileach",
	["vik_fact_airer_goidel"] = "sw_heroism_vik_fact_airer_goidel",
	["vik_fact_airgialla"] = "sw_heroism_vik_fact_airgialla",
	["vik_fact_athfochla"] = "sw_heroism_vik_fact_athfochla",
	["vik_fact_bedeborg"] = "sw_heroism_vik_fact_bedeborg",
	["vik_fact_brechinauc"] = "sw_heroism_vik_fact_brechinauc",
	["vik_fact_brega"] = "sw_heroism_vik_fact_brega",
	["vik_fact_breifne"] = "sw_heroism_vik_fact_breifne",
	["vik_fact_caisil"] = "sw_heroism_vik_fact_caisil",
	["vik_fact_cent"] = "sw_heroism_vik_fact_cent",
	["vik_fact_cerneu"] = "sw_heroism_vik_fact_cerneu",
	["vik_fact_circenn"] = "sw_heroism_vik_fact_circenn",
	["vik_fact_connacht"] = "sw_heroism_vik_fact_connacht",
	["vik_fact_defena"] = "sw_heroism_vik_fact_defena",
	["vik_fact_dene"] = "sw_heroism_vik_fact_dene",
	["vik_fact_desmuma"] = "sw_heroism_vik_fact_desmuma",
	["vik_fact_djurby"] = "sw_heroism_vik_fact_djurby",
	["vik_fact_dorsaete"] = "sw_heroism_vik_fact_dorsaete",
	["vik_fact_dubgaill"] = "sw_heroism_vik_fact_dubgaill",
	["vik_fact_dyfet"] = "sw_heroism_vik_fact_dyfet",
	["vik_fact_dyflin"] = "sw_heroism_vik_fact_dyflin",
	["vik_fact_east_engle"] = "sw_heroism_vik_fact_east_engle",
	["vik_fact_east_seaxe"] = "sw_heroism_vik_fact_east_seaxe",
	["vik_fact_finngaill"] = "sw_heroism_vik_fact_finngaill",
	["vik_fact_fortriu"] = "sw_heroism_vik_fact_fortriu",
	["vik_fact_gallgoidel"] = "sw_heroism_vik_fact_gallgoidel",
	["vik_fact_gliwissig"] = "sw_heroism_vik_fact_gliwissig",
	["vik_fact_grantebru"] = "sw_heroism_vik_fact_grantebru",
	["vik_fact_gwent"] = "sw_heroism_vik_fact_gwent",
	["vik_fact_gwined"] = "sw_heroism_vik_fact_gwined",
	["vik_fact_haeden"] = "sw_heroism_vik_fact_haeden",
	["vik_fact_heimiliborg"] = "sw_heroism_vik_fact_heimiliborg",
	["vik_fact_hellirborg"] = "sw_heroism_vik_fact_hellirborg",
	["vik_fact_hlymrekr"] = "sw_heroism_vik_fact_hlymrekr",
	["vik_fact_holdrness"] = "sw_heroism_vik_fact_holdrness",
	["vik_fact_hwicce"] = "sw_heroism_vik_fact_hwicce",
	["vik_fact_hylrborg"] = "sw_heroism_vik_fact_hylrborg",
	["vik_fact_iarmuma"] = "sw_heroism_vik_fact_iarmuma",
	["vik_fact_laigin"] = "sw_heroism_vik_fact_laigin",
	["vik_fact_ledeborg"] = "sw_heroism_vik_fact_ledeborg",
	["vik_fact_mide"] = "sw_heroism_vik_fact_mide",
	["vik_fact_mierce"] = "sw_heroism_vik_fact_mierce",
	["vik_fact_myrrborg"] = "sw_heroism_vik_fact_myrrborg",
	["vik_fact_nordmann"] = "sw_heroism_vik_fact_nordmann",
	["vik_fact_normaunds"] = "sw_heroism_vik_fact_normaunds",
	["vik_fact_norse"] = "sw_heroism_vik_fact_norse",
	["vik_fact_northleode"] = "sw_heroism_vik_fact_northleode",
	["vik_fact_northymbre"] = "sw_heroism_vik_fact_northymbre",
	["vik_fact_orkneyar"] = "sw_heroism_vik_fact_orkneyar",
	["vik_fact_osraige"] = "sw_heroism_vik_fact_osraige",
	["vik_fact_powis"] = "sw_heroism_vik_fact_powis",
	["vik_fact_seisilwig"] = "sw_heroism_vik_fact_seisilwig",
	["vik_fact_steinnborg"] = "sw_heroism_vik_fact_steinnborg",
	["vik_fact_strat_clut"] = "sw_heroism_vik_fact_strat_clut",
	["vik_fact_sudreyar"] = "sw_heroism_vik_fact_sudreyar",
	["vik_fact_suth_seaxe"] = "sw_heroism_vik_fact_suth_seaxe",
	["vik_fact_tuadmuma"] = "sw_heroism_vik_fact_tuadmuma",
	["vik_fact_ulaid"] = "sw_heroism_vik_fact_ulaid",
	["vik_fact_vedrafjordr"] = "sw_heroism_vik_fact_vedrafjordr",
	["vik_fact_veidrborg"] = "sw_heroism_vik_fact_veidrborg",
	["vik_fact_veisafjordr"] = "sw_heroism_vik_fact_veisafjordr",
	["vik_fact_west_seaxe"] = "sw_heroism_vik_fact_west_seaxe",
	["vik_fact_westernas"] = "sw_heroism_vik_fact_westernas",
	["vik_fact_westmoringas"] = "sw_heroism_vik_fact_westmoringas",
	["vik_fact_wicing"] = "sw_heroism_vik_fact_wicing"
}--:map<string, string>






local em = dev.GameEvents
local ft = PettyKingdoms.ForceTracking

	
dev.first_tick(function(context) 
    dev.log("#### Adding Welsh Mechanics Listeners ####", "HERO")
    local humans = cm:get_human_factions()
    local was_human = false
    for i = 1, #humans do
        local h_name = humans[i]
        if heroism_factions[h_name] then
            local heroism = PettyKingdoms.FactionResource.new(h_name, "vik_heroism", "resource_bar", 0, heroism_max, {}, value_converter)
            HEROISM[h_name] = heroism
            was_human = true
            if dev.is_new_game() then
                for factor, value in pairs(heroism_factions[h_name]) do
                    heroism:set_factor(factor, value)
                end
                heroism:reapply()
            end
        end
    end
    if not was_human then
        return 
    end
    local bandit_mission = em:create_event("sw_heroism_defeat_bandits", "mission", "standard")
    bandit_mission:add_queue_time_condition(function(context)
        if (not cm:get_saved_value("start_mission_done")) or dev.get_faction("vik_fact_jorvik"):is_dead() then
            return false
        end
        if BANDITS.regions[context:region():name()] and dev.get_character(BANDITS.regions[context:region():name()])
        and dev.get_character(BANDITS.regions[context:region():name()]):has_military_force() then
            return true
        end
        return false
    end)
    bandit_mission:add_completion_condition("FactionDestroyed", function(context)
        return context:faction():name() == "vik_fact_jorvik", true
    end)
    bandit_mission:add_mission_complete_callback(function(context)
        HEROISM[context:faction():name()]:change_value(3, "factor_missions_heroism")
    end)
    bandit_mission:set_cooldown(12)
    bandit_mission:add_mission_success_callback(function(context)
        local heroism = HEROISM[context:faction():name()]
        heroism:change_value(5, "factor_missions_heroism")
    end)
    bandit_mission:schedule("RegionTurnStart")

    local war_mission = em:create_event("sw_heroism_", "mission", "concatenate_faction")
    war_mission:add_queue_time_condition(function(context)
        local faction = context:other_faction() --:CA_FACTION
        if heroism_missions[faction:name()] then
            return faction:has_faction_leader() and dev.is_char_normal_general(faction:faction_leader()) and dev.army_size(faction:faction_leader()) >= 400
        end
        return false
    end)
    war_mission:add_completion_condition("ShieldwallCharacterCompletedBattle", function(context) 
        local mission_context = war_mission:mission():context()
        local char = context:character() --:CA_CHAR
        if char:faction():name() == mission_context:faction():name() and char:won_battle() then
            local pb = char:model():pending_battle()
            local attacker_won = pb:attacker():won_battle()
            if attacker_won then
                for i = 1, cm:pending_battle_cache_num_defenders() do
                    local char_cqi, force_cqi, faction_key = cm:pending_battle_cache_get_defender(i)
                    if faction_key == mission_context:other_faction():name() and ft.was_char_cqi_a_faction_leader_in_last_battle(char_cqi) then
                        return true, true
                    end
                end
            else
                for i = 1, cm:pending_battle_cache_num_attackers() do
                    local char_cqi, force_cqi, faction_key = cm:pending_battle_cache_get_attacker(i)
                    if faction_key == mission_context:other_faction():name() and ft.was_char_cqi_a_faction_leader_in_last_battle(char_cqi) then
                        return true, true
                    end
                end
            end
        end
        return false, true
    end)
    war_mission:add_completion_condition("FactionDestroyed", function(context) 
        local mission_context = war_mission:mission():context()
        local faction = context:faction() --:CA_FACTION
        if faction:name() == mission_context:other_faction():name() then
            return true, false 
        end
        return false, true
    end)
    war_mission:add_mission_success_callback(function(context)
        local heroism = HEROISM[context:faction():name()]
        heroism:change_value(10, "factor_missions_heroism")
    end)
    war_mission:set_cooldown(12)
    war_mission:schedule("MissionTargetGeneratorFactionAtWarWith")    

    local land_mission = em:create_event("sw_heroism_region_", "mission", "concatenate_region")
    land_mission:add_completion_condition("RegionTurnStart", function(context)
        local mission_context = land_mission:mission():context()
        local region = context:region() --:CA_REGION
        if region:name() == mission_context:region():name() and (not region:owning_faction():is_null_interface()) then
            if region:owning_faction():subculture() == "vik_sub_cult_welsh" then
                return true, true
            end
        end
        return false, true
    end)
    land_mission:add_completion_condition("RegionChangesOwnership", function(context)
        local mission_context = land_mission:mission():context()
        local region = context:region() --:CA_REGION
        if region:name() == mission_context:region():name() and (not region:owning_faction():is_null_interface()) then
            if region:owning_faction():subculture() == "vik_sub_cult_welsh" then
                return true, true
            end
        end
        return false, true
    end)
    land_mission:add_mission_success_callback(function(context)
        local heroism = HEROISM[context:faction():name()]
        heroism:change_value(15, "factor_missions_heroism")
    end)
    land_mission:set_cooldown(12)
    for i = 1, #humans do
        local h_name = humans[i]
        if heroism_factions[h_name] then
            dev.eh:add_listener(
                "RegionTurnStartHeroismMissions",
                "RegionTurnStart",
                function(context)
                    local region = context:region() --:CA_REGION
                    return (not not heroism_missions[region:name()]) and (not land_mission:is_active()) and (not region:owning_faction():is_null_interface()) 
                    and region:owning_faction():subculture() ~= "vik_sub_cult_welsh"
                end,
                function(context)
                    local region = context:region() --:CA_REGION
                    local context = em:build_context_for_event(land_mission, region, dev.get_faction(h_name))
                    em:force_check_and_queue_event(land_mission, context)
                end,
                true)
            
        end
    end

    dev.eh:add_listener(
        "CharacterTurnStartHeroism",
        "CharacterTurnStart",
        function(context)
            local char = context:character() --:CA_CHAR
            if char:region():is_null_interface() then
                return false
            end
            return dev.is_char_normal_general(char) and char:faction():name() == "vik_fact_jorvik" and (not not HEROISM[char:region():owning_faction():name()])
        end,
        function(context)
            local char = context:character() --:CA_CHAR
            local heroism = HEROISM[char:region():owning_faction():name()]
            heroism:change_value(-1, "factor_bandits_heroism")
        end,
        true)
    dev.eh:add_listener(
        "RegionTurnStartBandits",
        "RegionTurnStart",
        function(context)
            local region = context:region() --:CA_REGION
            if region:owning_faction():is_null_interface() or (not region:is_province_capital()) then
                return false
            end
            return not not HEROISM[region:owning_faction():name()]
        end,
        function(context)
            local region = context:region() --:CA_REGION
            local heroism = HEROISM[region:owning_faction():name()]
            local rm = PettyKingdoms.RiotManager.get(region:name())
            if rm.riot_in_progress then
                heroism:change_value(-2, "factor_riots_heroism")
            end
        end,
        true)

    local heroism_champion_event = em:create_event("sw_heroism_champion", "incident", "standard")
    heroism_champion_event:add_callback(function(context)
        local heroism = HEROISM[context:faction():name()]
        heroism:change_value(3, "factor_champion_follower_heroism")
    end)

    dev.eh:add_listener(
        "CharacterCompletedBattlePolitics",
        "ShieldwallCharacterCompletedBattle",
        function(context)
            local char = context:character() --:CA_CHAR
            local pb = char:model():pending_battle()
            return (char:faction():is_human() and (not not HEROISM[char:faction():name()])) and
                (pb:attacker():command_queue_index() == char:command_queue_index() or pb:defender():command_queue_index() == char:command_queue_index())
        end,
        function(context)
            local char = context:character() --:CA_CHAR
            local heroism = HEROISM[char:faction():name()]
            local significance = PettyKingdoms.ForceTracking.get_last_battle_significance_for_faction(char:faction())
            local pb = char:model():pending_battle()
            local attacker_won = pb:attacker():won_battle()
            if char:won_battle() then
                local victory_type --:string
                if attacker_won then
                    victory_type = pb:attacker_battle_result()
                else
                    victory_type = pb:defender_battle_result()
                end
                if victory_type == "heroic_victory" then
                    heroism:change_value(10, "factor_heroic_victories_heroism")
                end
                if char:has_skill("vik_follower_siege_engineer_gwined") then
                    if char:military_force():unit_list():has_unit("wel_royal_uchelwr") then
                        local context_for_event = em:build_context_for_event(char:faction(), char, heroism_champion_event)
                        em:force_check_and_trigger_event_immediately(heroism_champion_event, context_for_event)
                    end
                elseif char:has_skill("vik_follower_siege_engineer_strat_clut") then
                    if char:military_force():unit_list():has_unit("wel_old_north_uchelwr") then
                        local context_for_event = em:build_context_for_event(char:faction(), char, heroism_champion_event)
                        em:force_check_and_trigger_event_immediately(heroism_champion_event, context_for_event)
                    end
                end
            else
                local defeat_type --:string
                if attacker_won then
                    defeat_type = pb:defender_battle_result()
                else
                    defeat_type = pb:attacker_battle_result()
                end
                if defeat_type == "valiant_defeat" then
                    heroism:change_value(1, "factor_valiant_defeats_heroism")
                else
                    heroism:change_value(-3, "factor_defeats_heroism")
                end
            end
        end,
        true)





    
end)

