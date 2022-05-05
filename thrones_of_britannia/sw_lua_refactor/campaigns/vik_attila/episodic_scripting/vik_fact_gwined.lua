
local faction_key = "vik_fact_gwined"
--v function(t: any)
local function log(t) dev.log(tostring(t), faction_key) end

local event_manager = dev.GameEvents

local rivals = {
    {"vik_fact_mierce"},
    {"vik_fact_mide", "vik_fact_dyflin"},
    {"vik_fact_east_engle", "vik_fact_west_seaxe"},
    {"vik_fact_northymbre"},
    {"vik_fact_northleode", "vik_fact_strat_clut"},
    {"vik_fact_circenn", "vik_fact_sudreyar"}
} --:vector<vector<string>>

--v function(t: any)
local function log(t) dev.log(tostring(t), "NARR") end






dev.first_tick(function(context)
    local gwined = dev.get_faction(faction_key)
    local mierce = dev.get_faction("vik_fact_mierce")
    local bandits = dev.get_faction("vik_fact_jorvik")
    local djurby = dev.get_faction("vik_fact_djurby")
    local ledeborg = dev.get_faction("vik_fact_ledeborg")
    local seisilwig = dev.get_faction("vik_fact_seisilwig")
    local powis = dev.get_faction("vik_fact_powis")
    local brechinauc = dev.get_faction("vik_fact_brechinauc")
    local dewet = dev.get_faction("vik_fact_dyfet")
    local heroism = PettyKingdoms.FactionResource.get("vik_heroism", gwined)
    if not gwined:is_human() then
        return
    end
    log("loaded faction script for "..faction_key)

    local gwined_starting_mission = event_manager:create_event("sw_start_gwined", "mission", "standard")
    gwined_starting_mission:set_unique(true)
    gwined_starting_mission:add_completion_condition("FactionDestroyed", function(context)
        return context:faction():name() == "vik_fact_jorvik", true
    end)
    gwined_starting_mission:add_mission_complete_callback(function(context)
        heroism:change_value(3, "factor_missions_heroism")
        cm:set_saved_value("start_mission_done", true)
    end)


    local GwinedEventGroup = event_manager:create_new_condition_group("GwinedFactionNarrativeGroup")
    GwinedEventGroup:add_queue_time_condition(function(context)
        return context:faction():name() == faction_key
    end)
    event_manager:register_condition_group(GwinedEventGroup, "FactionTurnStart")

    --help powis or not?
    local gwined_powis_choice = event_manager:create_event("sw_gwined_avenge_rhodri", "dilemma", "standard")
    gwined_powis_choice:set_unique(true)
    gwined_powis_choice:add_queue_time_condition(function(context)
        local welsh_not_yet_at_war = (not mierce:at_war_with(seisilwig))
        and (not mierce:at_war_with(gwined)) and (not mierce:at_war_with(powis))
        and (not gwined:at_war_with(seisilwig)) and (gwined:allied_with(powis))
        local turn = (dev.turn() >= 3 and dev.turn() <= 7) or gwined_starting_mission:mission():was_successful()
        return welsh_not_yet_at_war and turn
    end)
    gwined_powis_choice:add_callback(function(context)
        if context:choice() == 0 then
            heroism:change_value(5, "factor_dilemmas_heroism")
        else
            cm:force_break_alliance(faction_key, "vik_fact_powis")
        end

    end)
    gwined_powis_choice:join_groups("GwinedFactionNarrativeGroup")

    --does Seisilwig help?
    local SeisilwigDecision = event_manager:create_new_condition_group("GwinedSeisilwigDecision", function(context)
        local turn = (dev.turn() >= (gwined_powis_choice:last_turn_occured() + 5))
        local not_at_war = not (gwined:at_war_with(seisilwig) or gwined:at_war_with(powis))
        return gwined_powis_choice:has_occured() and not_at_war and turn and dev.chance(50)
    end)
    SeisilwigDecision:set_unique(true)
    event_manager:register_condition_group(SeisilwigDecision)
    --no, they powergrab
    local seisilwig_powergrab = event_manager:create_event("sw_gwined_seisilwig_powergrab", "incident", "standard")
    seisilwig_powergrab:add_callback(function(context)
        dev.lock_war_declaration_for_faction(seisilwig, false)
        dev.set_factions_hostile(seisilwig:name(), brechinauc:name())
        cm:force_declare_war(seisilwig:name(), brechinauc:name())
    end)
    seisilwig_powergrab:join_groups("GwinedFactionNarrativeGroup", "GwinedSeisilwigDecision")

    --yes, they do.
    local seisilwig_helps = event_manager:create_event("sw_gwined_seisilwig_helps", "incident", "standard")
    seisilwig_helps:add_callback(function(context)
        dev.lock_war_declaration_for_faction(seisilwig, false)
    end)
    seisilwig_helps:join_groups("GwinedFactionNarrativeGroup", "GwinedSeisilwigDecision")

    --seisilwig betrays Powis
    local seisilwig_betrayal = event_manager:create_event("sw_gwined_seisilwig_betrays", "incident", "standard")
    seisilwig_betrayal:set_unique(true)
    seisilwig_betrayal:add_queue_time_condition(function(context)
        if not seisilwig_helps:has_occured() or powis:is_dead() then
            return false
        end
        local turns_since_helped = dev.turn() - seisilwig_helps:last_turn_occured() 
        local time_window = (turns_since_helped >= 6) and (turns_since_helped < 12)
        return time_window and dev.chance(25)
    end)
    seisilwig_betrayal:add_callback(function(context)
        cm:force_make_peace(seisilwig:name(), mierce:name())
        dev.reset_faction_diplomatic_stance(seisilwig:name(), mierce:name())
        cm:force_declare_war(seisilwig:name(), powis:name())
        dev.set_factions_hostile(seisilwig:name(), powis:name())
    end)
    seisilwig_betrayal:join_groups("GwinedFactionNarrativeGroup")
    
    --seisilwig will move onto fighting Dewet after Brechinauc if they invade neighbours.
    if (not seisilwig:is_dead()) and ((not brechinauc:is_dead()) or (not dewet:is_dead())) then
        dev.turn_start(seisilwig:name(), function(context)
            if seisilwig_powergrab:has_occured() and dev.turn() >= (seisilwig_powergrab:last_turn_occured() + 4) then
                if brechinauc:is_dead() or (not seisilwig:at_war_with(brechinauc)) then
                    if (not dewet:is_dead()) and (not dewet:allied_with(seisilwig)) and (not dewet:is_vassal_of(seisilwig)) then
                        cm:force_declare_war(seisilwig:name(), dewet:name())
                        dev.set_factions_hostile(seisilwig:name(), dewet:name())
                    end
                end
            elseif seisilwig_helps:has_occured() and (not seisilwig_betrayal:has_occured()) and dev.turn() < 20 then
                if powis:at_war_with(mierce) and (not seisilwig:at_war_with(mierce)) then
                    cm:force_declare_war(seisilwig:name(), mierce:name())
                    dev.set_factions_hostile(seisilwig:name(), mierce:name())
                end
            end
        end)
    end
    --powis will declare war if gwined or seisilwig help them
    if (not powis:is_dead()) and (not mierce:is_dead()) then
        dev.turn_start("vik_fact_powis", function(context)
            if not mierce:is_dead() and dev.turn() < 20 then
                if gwined_powis_choice:has_occured() and (dev.turn() >= 9) then
                    dev.lock_war_declaration_for_faction(powis, false)
                    dev.lock_war_declaration_for_faction(mierce, false)
                    if (not powis:at_war_with(mierce)) then
                        if gwined_powis_choice:choice() == 0 then
                            dev.set_factions_hostile(powis:name(), mierce:name())
                            cm:force_declare_war(powis:name(), mierce:name())
                        elseif seisilwig_helps:has_occured() and (dev.turn() >= 9) then
                            dev.set_factions_hostile(powis:name(), mierce:name())
                            cm:force_declare_war(powis:name(), mierce:name())
                        end
                    end
                end
            end
        end)
    end


    if dev.is_new_game() then
        --fire starting mission
        local context_for_event = event_manager:build_context_for_event(gwined)
        event_manager:force_check_and_trigger_event_immediately(gwined_starting_mission, context_for_event)
        --declare on bandits and spawn them near us.
        cm:force_declare_war("vik_fact_jorvik", faction_key)
        log("Spawning bandit for Gwined")
        spawn_bandits_for_region(dev.get_region("vik_reg_aberffro"), gwined, true)
        if cm:model():difficulty_level() < 0 then
            spawn_bandits_for_region(dev.get_region("vik_reg_rudglann"), gwined, true)
        end
        --lock war declarations for the plot

        dev.lock_war_declaration_for_faction(seisilwig, true)
        dev.lock_war_declaration_for_faction(mierce, true)
        dev.lock_war_declaration_for_faction(powis, true)
        
        --delete the bandits that are not in our regions
        local character_list = bandits:character_list()

        for i = 0, character_list:num_items()- 1 do
            local character = character_list:item_at(i)
            if character:has_military_force() and character:region():owning_faction():name() ~= faction_key then
                cm:kill_character(dev.lookup(character), true, true) 
            end
        end
        --add rivals
        for k = 1, #rivals do
            local r = cm:random_number(#rivals[k])
            local rival_to_create = rivals[k][r]
            log("Adding Rival: "..rival_to_create)
            PettyKingdoms.Rivals.new_rival(rival_to_create, 
            Gamedata.kingdoms.faction_kingdoms[rival_to_create],  Gamedata.kingdoms.kingdom_provinces(dev.get_faction(rival_to_create)),
            Gamedata.kingdoms.faction_nations[rival_to_create], Gamedata.kingdoms.nation_provinces(dev.get_faction(rival_to_create)))
        end
        --add units to Seisilwig so they're more of a challenge
        if seisilwig:has_faction_leader() then
            local leader = seisilwig:faction_leader()
            cm:grant_unit(dev.lookup(leader), "wel_royal_uchelwr")
            cm:grant_unit(dev.lookup(leader), "wel_royal_spearmen")
            cm:grant_unit(dev.lookup(leader), "wel_royal_spearmen")
        end
    end


end)