
local event_manager = dev.GameEvents

--v function(t: any)
local function log(t) dev.log(tostring(t), "NARR") end


local function add_danelaw_geopolitics()



end




local function add_ai_gwined_mierce_events()
    local mierce = dev.get_faction("vik_fact_mierce")
    local djurby = dev.get_faction("vik_fact_djurby")
    local ledeborg = dev.get_faction("vik_fact_ledeborg")
    local seisilwig = dev.get_faction("vik_fact_seisilwig")
    local powis = dev.get_faction("vik_fact_powis")
    local gwined = dev.get_faction("vik_fact_gwined")

    if gwined:is_human() or mierce:is_human() or seisilwig:is_human() then
        log("WARNING: Called for AI GwinedvsMierce events, but Gwined, Mierce or Seisilwig are human! This is almost definitely a mistake")
        return
    end
    
    if dev.is_new_game() then
        dev.lock_war_declaration_for_faction(gwined, true)
    end

    local WelshDecision = event_manager:create_new_condition_group("AIWelshDecision", function(context)
        local djurby_dealt_with = djurby:is_dead() or (not mierce:at_war_with(djurby)) or dev.chance(50)
        local ledeborg_dealt_with = ledeborg:is_dead() or (not mierce:at_war_with(ledeborg)) or dev.chance(50)
        local welsh_alive = (not seisilwig:is_dead()) 
        and (not gwined:is_dead()) and (not powis:is_dead())
        local welsh_not_yet_at_war = (not mierce:at_war_with(seisilwig))
        and (not mierce:at_war_with(gwined)) --we don't care if they're already fighting Powis.
        local welsh_not_yet_at_civil_war = (not gwined:at_war_with(gwined))
        and (not gwined:at_war_with(powis)) and (not gwined:at_war_with(powis))
        local turn = dev.turn() >= 8
        return djurby_dealt_with and ledeborg_dealt_with and turn and welsh_alive and welsh_not_yet_at_war and welsh_not_yet_at_civil_war and dev.chance(40)
    end)
    WelshDecision:set_unique(true)
    event_manager:register_condition_group(WelshDecision, "FactionTurnStart")

    local ai_event_infighting = event_manager:create_event("sw_ai_welsh_infighting", "incident", "standard")
    ai_event_infighting:add_callback(function(context)
        dev.lock_war_declaration_for_faction(gwined, false)
        dev.set_factions_hostile(seisilwig:name(), gwined:name())
        cm:force_declare_war(seisilwig:name(), gwined:name())
    end)
    ai_event_infighting:join_groups("AIWelshDecision")
    local ai_event_invasion = event_manager:create_event("sw_ai_welsh_invade_mierce", "incident", "standard")
    ai_event_infighting:add_callback(function(context)
        dev.lock_war_declaration_for_faction(gwined, false)
        if mierce:at_war_with(seisilwig) == false then
            cm:force_declare_war(seisilwig:name(), mierce:name())
        end
        if mierce:at_war_with(powis) == false then
            cm:force_declare_war(powis:name(), mierce:name())
        end
        if mierce:at_war_with(gwined) == false then
            cm:force_declare_war(gwined:name(), mierce:name())
        end
    end)
    ai_event_invasion:join_groups("AIWelshDecision")

end











return {
    add_ai_gwined_mierce_events = add_ai_gwined_mierce_events
}