local faction_key = "vik_fact_west_seaxe"
--v function(t: any)
local function log(t) dev.log(tostring(t), faction_key) end
local rivals = {
    {"vik_fact_gwined"},
    {"vik_fact_mide", "vik_fact_dyflin"},
    {"vik_fact_east_engle"},
    {"vik_fact_strat_clut", "vik_fact_northymbre"},
    {"vik_fact_circenn", "vik_fact_sudreyar"}
} --:vector<vector<string>>

local event_manager = dev.GameEvents

-------------------------------------------
----------Events: WestSeaxe!--------------
-------------------------------------------


--v function(turn: number)
local function EventsWestSeaxe(turn)

end

--v function(context: WHATEVER, turn: number)
local function EventsMissionsWestSeaxe(context, turn)


end

--v function(context: WHATEVER, turn: number)
local function EventsDilemmasWestSeaxe(context, turn)

end

--v function(wessex: CA_FACTION)
local function ai_wessex(wessex)

end


dev.first_tick(function(context)
    local wessex = dev.get_faction(faction_key)
    if not wessex:is_human() then
        ai_wessex(wessex)
        return
    end
    log("loaded faction script for "..faction_key)

    local wessex_starting_mission = event_manager:create_event("sw_start_wessex", "mission", "standard")
    wessex_starting_mission:set_unique(true)
    wessex_starting_mission:add_completion_condition("FactionDestroyed", function(context)
        return context:faction():name() == "vik_fact_jorvik", true
    end)
    wessex_starting_mission:add_mission_complete_callback(function(context)
        cm:set_saved_value("start_mission_done", true)
    end)



    if dev.is_new_game() then
        local context_for_event = event_manager:build_context_for_event(wessex)
        event_manager:force_check_and_trigger_event_immediately(wessex_starting_mission, context_for_event)
        for k = 1, #rivals do
            local r = cm:random_number(#rivals[k])
            local rival_to_create = rivals[k][r]
            log("Adding Rival: "..rival_to_create)
            PettyKingdoms.Rivals.new_rival(rival_to_create, 
            Gamedata.kingdoms.faction_kingdoms[rival_to_create],  Gamedata.kingdoms.kingdom_provinces(dev.get_faction(rival_to_create)),
            Gamedata.kingdoms.faction_nations[rival_to_create], Gamedata.kingdoms.nation_provinces(dev.get_faction(rival_to_create)))
        end
    end
    
    --AI events
    AIEvents.add_ai_gwined_mierce_events()

end)