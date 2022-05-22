local faction_key = "vik_fact_northleode"
local wicing_key = "vik_fact_wicing"
local jorvik_key = "vik_fact_northymbre"

local event_manager = dev.GameEvents

local westmoringas_event_turn = 14
local strat_clut_event_turn = 3
local betrayal_event_turn = 25


--v function(t: any)
local function log(t) dev.log(tostring(t), "NARR") end


local rivals = {
    {"vik_fact_northymbre"},
    {"vik_fact_mide", "vik_fact_dyflin"},
    {"vik_fact_east_engle", "vik_fact_west_seaxe"},
    {"vik_fact_mierce"},
    {"vik_fact_circenn"},
    {"vik_fact_strat_clut"}
} --:vector<vector<string>>
local spawns = {
    ["vik_reg_doneceaster"] = {560,351},
    ["vik_reg_beoferlic"] = {638,386}
} --:map<string, {int, int}>
local armies = {
    ["vik_reg_doneceaster"] = {
        ["dan_mailed_swordsmen"] = {1, 15, 100},
        ["dan_anglian_raiders"] = {1, 2, 60},
        ["est_shield_biters"] = {4, 3, 30},
        ["dan_spearmen"] = {6, 3, 30},
        ["dan_ceorl_archers"] = {2, 2, 35}
    },
    ["vik_reg_beoferlic"] = {
        ["dan_northumbrian_thegns"] = {1, 15, 100},
        ["dan_spearmen"] = {1, 2, 80},
        ["dan_berserkers"] = {6, 3, 50},
        ["dan_anglian_raiders"] = {2, 2, 35}
    }
}--:map<string, map<string, {int, int, int}>>



-------------------------------------------
----------Events: Northleode!--------------
-------------------------------------------

--v function(northleode: CA_FACTION)
function ai_northleode_start(northleode)
    local leader = northleode:faction_leader()
    cm:grant_unit(dev.lookup(leader), "eng_thegns")
    cm:grant_unit(dev.lookup(leader), "eng_thegns")
    cm:grant_unit(dev.lookup(leader), "eng_north_champion")
end


dev.first_tick(function(context)
    local northleode = dev.get_faction(faction_key)
    local wicing = dev.get_faction(wicing_key)
    local jorvik = dev.get_faction(jorvik_key)
    if not northleode:is_human() then
        if dev.is_new_game() then
            ai_northleode_start(northleode)
        end
        return
    end
    log("loaded faction script for "..faction_key)

    local northleode_opening_event = event_manager:create_event("sw_start_northleode", "mission", "standard")
    northleode_opening_event:add_completion_condition("FactionDestroyed", function(context)
        return context:faction():name() == wicing_key, true
    end)

    if dev.is_new_game() then
        --apply starting bundle
        cm:apply_effect_bundle("sw_northleode_king_of_nothing", "vik_fact_northleode", 0)
        --fire starting mission
        local context_for_event = event_manager:build_context_for_event(northleode, wicing)
        event_manager:force_check_and_trigger_event_immediately(northleode_opening_event, context_for_event)
        --add rival factions
        for k = 1, #rivals do
            local r = cm:random_number(#rivals[k])
            local rival_to_create = rivals[k][r]
            log("Adding Rival: "..rival_to_create)
            PettyKingdoms.Rivals.new_rival(rival_to_create, 
            Gamedata.kingdoms.faction_kingdoms[rival_to_create],  Gamedata.kingdoms.kingdom_provinces(dev.get_faction(rival_to_create)),
            Gamedata.kingdoms.faction_nations[rival_to_create], Gamedata.kingdoms.nation_provinces(dev.get_faction(rival_to_create)))
        end
        --prevent this from happening too early
        if not jorvik:is_human() then
            cm:force_diplomacy("vik_fact_westmoringas", "vik_fact_northymbre", "war", false, false)
            cm:force_diplomacy("vik_fact_northymbre", "vik_fact_westmoringas", "war", false, false)
        end
    end

    --this group covers all the events which happen while Northleode is a vassal of Jorvik.
    local faction_narrative_group = event_manager:create_new_condition_group("NorthleodeFactionEvents") 
    faction_narrative_group:add_queue_time_condition(function(context)
        local faction = context:faction() --:CA_FACTION
        return faction:name() == faction_key and faction:is_vassal_of(jorvik)
    end)
    event_manager:register_condition_group(faction_narrative_group, "FactionTurnStart")

    --the dilemma to defend fellow saxons against Strat Clut.
    local strat_clut_dilemma = event_manager:create_event("sw_northleode_help_against_strat_clut", "dilemma", "standard")
    strat_clut_dilemma:set_unique(true)
    strat_clut_dilemma:add_queue_time_condition(function(context)
        local turn = dev.turn()
        if dev.get_faction("vik_fact_strat_clut"):at_war_with(dev.get_faction("vik_fact_westernas")) then
            return true
        elseif turn >= strat_clut_event_turn and (not dev.get_faction("vik_fact_westernas"):is_dead()) then
            log("forcing war between strat clut and westernas")
            cm:force_declare_war("vik_fact_strat_clut", "vik_fact_westernas")
            return false
        end
        return false
    end)
    strat_clut_dilemma:add_callback(function(context)
        if context:choice() == 0 then
            log("forcing war between jorvik and strat clut")
			cm:force_declare_war("vik_fact_northymbre", "vik_fact_strat_clut")
		end
    end)
    strat_clut_dilemma:join_group("NorthleodeFactionEvents")

    --the dilemma to defend westernas against your master.
    local westernas_dilemma = event_manager:create_event("sw_northleode_help_against_jorvik", "dilemma", "standard")
    westernas_dilemma:set_unique(true)
    westernas_dilemma:add_queue_time_condition(function(context)
        local turn = dev.turn()
        if turn >= westmoringas_event_turn then
            cm:force_diplomacy("vik_fact_westmoringas", "vik_fact_northymbre", "war", true, true)
            cm:force_diplomacy("vik_fact_northymbre", "vik_fact_westmoringas", "war", true, true)
            return true
        else
            return false
        end
    end)
    westernas_dilemma:add_callback(function(context)
        if context:choice() == 0 then
            log("forcing war between northleode and jorvik")
			cm:force_declare_war("vik_fact_northleode", "vik_fact_northymbre")
            log("forcing war between jorvik and westmoringas")
            cm:force_declare_war("vik_fact_northymbre", "vik_fact_westmoringas")
		else
			cm:force_declare_war("vik_fact_northymbre", "vik_fact_westmoringas")
		end
    end)
    westernas_dilemma:join_group("NorthleodeFactionEvents")

    --the dilemma to betray your vassal with Mierce.
    local mierce_betrayal = event_manager:create_event("sw_northleode_betrayal_mierce", "dilemma", "standard")
    mierce_betrayal:set_unique(true)
    mierce_betrayal:add_queue_time_condition(function(context)
        local turn = dev.turn()
        if turn >= betrayal_event_turn then
            local alive = not dev.get_faction("vik_fact_mierce"):is_dead()
            local not_at_war = not dev.get_faction("vik_fact_northleode"):at_war_with(dev.get_faction("vik_fact_mierce"))
            local not_allied = dev.get_faction("vik_fact_northymbre"):allied_with(dev.get_faction("vik_fact_mierce"))
            return (alive) and (not_at_war) and (not_allied) and dev.chance(40)
        else
            return false
        end
    end)
    mierce_betrayal:add_callback(function(context)
        local choice = context:choice()
        if choice == 0 then
            log("forcing a war between northleode and jorvik")
			cm:force_declare_war("vik_fact_northleode", "vik_fact_northymbre")
			if (not dev.get_faction("vik_fact_mierce"):at_war_with(dev.get_faction("vik_fact_northymbre"))) then
                log("forcing a war between mierce and jorvik")
				cm:force_declare_war("vik_fact_mierce", "vik_fact_northymbre")
			end
		end
    end)
    mierce_betrayal:join_group("NorthleodeFactionEvents")
    --the dilemma to betray your vassal with East Engle.
    local east_engle_betrayal = event_manager:create_event("sw_northleode_betrayal_east_engle", "dilemma", "standard")
    east_engle_betrayal:set_unique(true)
    east_engle_betrayal:add_queue_time_condition(function(context)
        local turn = dev.turn()
        if turn >= betrayal_event_turn then
            local alive = not dev.get_faction("vik_fact_east_engle"):is_dead()
            local not_at_war = not dev.get_faction("vik_fact_northleode"):at_war_with(dev.get_faction("vik_fact_east_engle"))
            local not_allied = dev.get_faction("vik_fact_northymbre"):allied_with(dev.get_faction("vik_fact_east_engle"))
            return (alive) and (not_at_war) and (not_allied) and dev.chance(40)
        else
            return false
        end
    end)
    east_engle_betrayal:add_callback(function(context)
        local choice = context:choice()
        if choice == 0 then
            log("forcing a war between northleode and jorvik")
            cm:force_declare_war("vik_fact_northleode", "vik_fact_northymbre")
            if (not dev.get_faction("vik_fact_east_engle"):at_war_with(dev.get_faction("vik_fact_northymbre"))) then
                log("forcing a war between east engle and jorvik")
                cm:force_declare_war("vik_fact_east_engle", "vik_fact_northymbre")
            end
        end
    end)
    east_engle_betrayal:join_group("NorthleodeFactionEvents")

    --check at the start of turn if Northleode is still Jorvik's vassal
    if northleode:is_vassal_of(jorvik) then
        dev.turn_start(faction_key, function(context)
            if northleode:is_vassal_of(jorvik) then
                log("Northleode is still a vassal!")
            elseif northleode:has_effect_bundle("sw_northleode_king_of_nothing") then
                log("northleode is no longer a vassal")
                cm:remove_effect_bundle("sw_northleode_king_of_nothing", faction_key)
            end
        end)
        dev.eh:add_listener(
            "NorthleodeEventsDiplomatic",
            "FactionVassalRebelled",
            function(context)
                return context:faction():name() == faction_key
            end,
            function(context)
                log("northleode is no longer a vassal")
                cm:remove_effect_bundle("sw_northleode_king_of_nothing", faction_key)
            end,
            false
        )
    end

    --AI events
    AIEvents.add_ai_gwined_mierce_events()

end)