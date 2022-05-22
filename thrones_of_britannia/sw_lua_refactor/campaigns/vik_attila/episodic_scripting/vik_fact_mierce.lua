local faction_key = "vik_fact_mierce"
--v function(t: any)
local function log(t) dev.log(tostring(t), faction_key) end
local rivals = {
    {"vik_fact_gwined"},
    {"vik_fact_mide", "vik_fact_dyflin"},
    {"vik_fact_east_engle", "vik_fact_west_seaxe"},
    {"vik_fact_northymbre"},
    {"vik_fact_northleode", "vik_fact_strat_clut"},
    {"vik_fact_circenn", "vik_fact_sudreyar"}
} --:vector<vector<string>>

local event_manager = dev.GameEvents

-------------------------------------------
----------Events: Mierce!--------------
-------------------------------------------


--v function(turn: number)
local function EventsMierce(turn)

end

--v function(context: WHATEVER, turn: number)
local function EventsMissionsMierce(context, turn)


end

--v function(context: WHATEVER, turn: number)
local function EventsDilemmasMierce(context, turn)

end

--v function(mierce: CA_FACTION)
function ai_mierce_start(mierce)
    local leader = mierce:faction_leader()
    cm:grant_unit(dev.lookup(leader), "eng_thegns")
    cm:grant_unit(dev.lookup(leader), "eng_thegns")
    cm:grant_unit(dev.lookup(leader), "eng_earls_spearmen")
    cm:transfer_region_to_faction("vik_reg_rocheberie", mierce:name())
end



dev.first_tick(function(context)
    local mierce = dev.get_faction(faction_key)
    local djurby = dev.get_faction("vik_fact_djurby")
    local ledeborg = dev.get_faction("vik_fact_ledeborg")
    local seisilwig = dev.get_faction("vik_fact_seisilwig")
    local powis = dev.get_faction("vik_fact_powis")
    local gwined = dev.get_faction("vik_fact_gwined")
    if not mierce:is_human() then
        ai_mierce_start(mierce)
        return
    end
    log("loaded faction script for "..faction_key)

    local mierce_starting_mission = event_manager:create_event("sw_start_mierce", "mission", "standard")
    mierce_starting_mission:set_unique(true)
    mierce_starting_mission:add_completion_condition("ShieldwallCharacterCompletedBattle", function(context)
        local mission_context = mierce_starting_mission:mission():context()
        local char = context:character() --:CA_CHAR
        if char:faction():name() == mission_context:faction():name() and char:won_battle() then
            local pb = char:model():pending_battle()
            local attacker_won = pb:attacker():won_battle()
            if attacker_won then
                for i = 1, cm:pending_battle_cache_num_defenders() do
                    local char_cqi, force_cqi, faction_key = cm:pending_battle_cache_get_defender(i)
                    if faction_key == mission_context:other_faction():name() and PettyKingdoms.ForceTracking.was_char_cqi_a_faction_leader_in_last_battle(char_cqi) then
                        return true, true
                    end
                end
            else
                for i = 1, cm:pending_battle_cache_num_attackers() do
                    local char_cqi, force_cqi, faction_key = cm:pending_battle_cache_get_attacker(i)
                    if faction_key == mission_context:other_faction():name() and PettyKingdoms.ForceTracking.was_char_cqi_a_faction_leader_in_last_battle(char_cqi) then
                        return true, true
                    end
                end
            end
        end
        return false, true
    end)
    mierce_starting_mission:add_completion_condition("FactionDestroyed", function(context)
        return context:faction():name() == "vik_fact_ledeborg", true
    end)
    mierce_starting_mission:add_mission_complete_callback(function(context)
        cm:set_saved_value("start_mission_done", true)
    end)

    local MierceEventsGroup = event_manager:create_new_condition_group("MierceFactionNarrativeTurnStart")
    MierceEventsGroup:add_queue_time_condition(function(context)
        return context:faction():name() == faction_key
    end)
    event_manager:register_condition_group(MierceEventsGroup, "FactionTurnStart")

    --sir oswald
    local mr_bones_oswald_bones = event_manager:create_event("sw_mierce_oswald_bones", "mission", "standard")
    mr_bones_oswald_bones:add_queue_time_condition(function(context)
        local jorvik = dev.get_region("vik_reg_eoferwic")
        if jorvik:owning_faction():is_null_interface() then
            return false
        end
        return mierce:factions_at_war_with():is_empty() or mierce:at_war_with(jorvik:owning_faction())
    end)
    mr_bones_oswald_bones:set_unique(true)
    mr_bones_oswald_bones:add_completion_condition("CharacterPerformsOccupationDecisionOccupy", function(context)
        return context:character():region():name() == "vik_reg_eoferwic" and context:character():faction():name() == mierce:name(), true
    end)
    mr_bones_oswald_bones:add_completion_condition("CharacterPerformsOccupationDecisionSack", function(context)
        return context:character():region():name() == "vik_reg_eoferwic" and context:character():faction():name() == mierce:name(), true
    end)
    mr_bones_oswald_bones:add_mission_complete_callback(function(context)
        local character = mierce:faction_leader()
        if character:is_null_interface() then
            log("Mierce completed the mission to sack Jorvik while their faction leader is dead. How the fuck does that happen.")
            return
        end
        dev.add_trait(character, "vik_item_silver_reliquary", true)
    end)
    mr_bones_oswald_bones:join_groups("MierceFactionNarrativeTurnStart")


    --wales
    local WelshDecision = event_manager:create_new_condition_group("MierceWelshDecision", function(context)
        local djurby_dealt_with = djurby:is_dead() or (not mierce:at_war_with(djurby))
        local ledeborg_dealt_with = ledeborg:is_dead() or (not mierce:at_war_with(ledeborg))
        local welsh_alive = (not seisilwig:is_dead()) 
        and (not gwined:is_dead()) and (not powis:is_dead())
        local welsh_not_yet_at_war = (not mierce:at_war_with(seisilwig))
        and (not mierce:at_war_with(gwined)) and (not mierce:at_war_with(powis))

        local turn = dev.turn() >= 15
        if cm:model():difficulty_level() < -1 then
            djurby_dealt_with = true
            ledeborg_dealt_with = true
        end
        return djurby_dealt_with and ledeborg_dealt_with and turn and welsh_alive and welsh_not_yet_at_war and dev.chance(50)
    end)
    WelshDecision:set_unique(true)
    WelshDecision:set_number_allowed_in_queue(1)
    event_manager:register_condition_group(WelshDecision)

    local welsh_event_infighting = event_manager:create_event("sw_mierce_welsh_infighting", "incident", "standard")
    welsh_event_infighting:add_callback(function(context)
        dev.lock_war_declaration_for_faction(gwined, false)
        dev.lock_war_declaration_for_faction(seisilwig, false)
        dev.lock_war_declaration_for_faction(powis, false)
        dev.set_factions_hostile("vik_fact_gwined", "vik_fact_powis")
        dev.set_factions_hostile("vik_fact_gwined", "vik_fact_seisilwig")
        dev.set_factions_hostile("vik_fact_seisilwig", "vik_fact_powis")    
    end)
    welsh_event_infighting:join_groups("MierceFactionNarrativeTurnStart", "MierceWelshDecision")
    
    local welsh_event_invasion = event_manager:create_event("sw_mierce_welsh_invasion", "incident", "standard")
    welsh_event_invasion:add_callback(function(context)
        dev.lock_war_declaration_for_faction(powis, false)
        dev.set_factions_hostile("vik_fact_gwined", faction_key)
        dev.set_factions_hostile("vik_fact_powis", faction_key)
        dev.set_factions_hostile("vik_fact_seisilwig", faction_key)  
    end)
    welsh_event_invasion:join_groups("MierceFactionNarrativeTurnStart", "MierceWelshDecision")

    local welsh_event_early_war = event_manager:create_event("sw_mierce_welsh_war", "incident", "standard")
    welsh_event_early_war:add_queue_time_condition(function(context)
        if welsh_event_invasion:has_occured() then
            local delay =  8 + cm:model():difficulty_level()
            local turn = welsh_event_invasion:last_turn_occured() + delay <= dev.turn()
            return turn
        elseif (not welsh_event_infighting:has_occured()) and (mierce:at_war_with(powis) or mierce:at_war_with(gwined) or mierce:at_war_with(seisilwig)) then
            local already_at_war_with_all_three = mierce:at_war_with(powis) and mierce:at_war_with(gwined) and mierce:at_war_with(seisilwig) 
            local turn = 15 <= dev.turn()
            return turn and not already_at_war_with_all_three
        end
        return false
    end)
    welsh_event_early_war:add_callback(function(context)
        dev.lock_war_declaration_for_faction(gwined, false)
        dev.lock_war_declaration_for_faction(seisilwig, false)
        dev.lock_war_declaration_for_faction(powis, false)
        if mierce:at_war_with(seisilwig) == false then
            cm:force_declare_war("vik_fact_seisilwig", faction_key)
        end
        if mierce:at_war_with(powis) == false then
            cm:force_declare_war("vik_fact_powis", faction_key)
        end
        if mierce:at_war_with(gwined) == false then
            cm:force_declare_war("vik_fact_gwined", faction_key)
        end
    end)
    welsh_event_early_war:set_unique(true)
    welsh_event_early_war:join_groups("MierceFactionNarrativeTurnStart")

    local welsh_event_late_war = event_manager:create_event("sw_mierce_welsh_gwined", "incident", "standard")
    welsh_event_late_war:add_queue_time_condition(function(context)
        if not welsh_event_infighting:has_occured() then
            return false
        end
        local turn = 40 <= dev.turn()

        local seisilwig_dealt_with = seisilwig:is_dead() or (not gwined:at_war_with(seisilwig))
        local powis_dealt_with = seisilwig:is_dead() or (not gwined:at_war_with(seisilwig))
        return turn and seisilwig_dealt_with and powis_dealt_with
    end)
    welsh_event_late_war:add_callback(function(context)
        dev.set_factions_hostile("vik_fact_gwined", faction_key)
        cm:force_diplomacy(faction_key, "vik_fact_gwined", "war", true, true)
        if mierce:at_war_with(gwined) == false then
            cm:force_declare_war("vik_fact_gwined", faction_key)
        end
    end)
    welsh_event_late_war:set_unique(true)
    welsh_event_late_war:join_groups("MierceFactionNarrativeTurnStart")


    local MiercePostBattleGroup = event_manager:create_new_condition_group("MierceFactionNarrativePostBattle")
    MiercePostBattleGroup:add_queue_time_condition(function(context)
        return context:character():faction():name() == faction_key and context:character():won_battle()
    end)
    event_manager:register_condition_group(MiercePostBattleGroup, "ShieldwallCharacterCompletedBattle")

    local djurby_regions = {
        "vik_reg_deoraby",
        "vik_reg_wyrcesuuyrthe"
    }--:vector<string>
    local djurby_capitulates_dilemma = event_manager:create_event("sw_mierce_djurby_capitulates", "dilemma", "standard")
    djurby_capitulates_dilemma:set_unique(true)
    djurby_capitulates_dilemma:add_queue_time_condition(function(context)
        local start_mission_done = mierce_starting_mission:mission():was_successful()
        local we_are_attacker = cm:pending_battle_cache_get_attacker_faction_name(1) == faction_key
        local djurby_defeated = false
        local djurby_forces 
        if we_are_attacker then
            for i = 1, cm:pending_battle_cache_num_defenders() do
                local char_cqi, force_cqi, faction_key = cm:pending_battle_cache_get_defender(i)
                if faction_key == "vik_fact_djurby" then
                    djurby_defeated = true
                end
            end
        else
            for i = 1, cm:pending_battle_cache_num_attackers() do
                local char_cqi, force_cqi, faction_key = cm:pending_battle_cache_get_attacker(i)
                if faction_key == "vik_fact_djurby" then
                    djurby_defeated = true
                end
            end
        end
        if djurby_defeated then
            local was_significant = PettyKingdoms.ForceTracking.get_last_battle_significance_for_faction(djurby) >= 75
            return start_mission_done and was_significant
        end    
        return false
    end)    
    djurby_capitulates_dilemma:add_callback(function(context)
        if context:choice() == 0 then
            local regions = {} --:map<string, boolean>
            for i = 1, #djurby_regions do
                local region = dev.get_region(djurby_regions[i])
                regions[region:name()] = true
                if region:owning_faction():name() == faction_key then
                    cm:transfer_region_to_faction(region:name(), djurby:name())
                end
            end
            for i = 1, djurby:region_list():num_items() - 1 do
                local region = djurby:region_list():item_at(i)
                if not regions[region:name()] then
                    cm:transfer_region_to_faction(region:name(), faction_key)
                end
            end
            cm:force_make_vassal(faction_key, "vik_fact_djurby")
        else

        end
    end)
    djurby_capitulates_dilemma:join_groups("MierceFactionNarrativePostBattle")

    if dev.is_new_game() then
        local context_for_event = event_manager:build_context_for_event(mierce, ledeborg)
        event_manager:force_check_and_trigger_event_immediately(mierce_starting_mission, context_for_event)
        dev.lock_war_declaration_for_faction(gwined, true)
        dev.lock_war_declaration_for_faction(seisilwig, true)
        dev.lock_war_declaration_for_faction(powis, true)
        for k = 1, #rivals do
            local r = cm:random_number(#rivals[k])
            local rival_to_create = rivals[k][r]
            log("Adding Rival: "..rival_to_create)
            PettyKingdoms.Rivals.new_rival(rival_to_create, 
            Gamedata.kingdoms.faction_kingdoms[rival_to_create],  Gamedata.kingdoms.kingdom_provinces(dev.get_faction(rival_to_create)),
            Gamedata.kingdoms.faction_nations[rival_to_create], Gamedata.kingdoms.nation_provinces(dev.get_faction(rival_to_create)))
        end
    end



end)