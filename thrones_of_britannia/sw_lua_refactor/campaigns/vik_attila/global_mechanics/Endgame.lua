--we need to support two invasions.
local norse_invader_arrival = "sw_norse_invasion_arrives"
local norse_invader_hostile = "sw_norse_invasion_attacks"
local norse_location = "vik_reg_eoferwic"

local normans_warning = "sw_normans_invasion_prelude"
local normans_prelude_turn = 4
local norman_far_away_distance = 2000
local norman_far_away_event = "sw_normans_invasion_far_away"
local norman_region_prefix = "sw_normans_invasion_near_"
local norman_locations = { 
    "vik_reg_northwic",
    "vik_reg_lunden",
    "vik_reg_tintagol",
    "vik_reg_werham"
}--:vector<string>

local END_GAME_INVASIONS = {
    ["vik_fact_normaunds"] = {leader_army = "norman_royal", base_army = "norman_invader", spawns = {"en_southwest", "en_south", "en_southeast"}, delay = 6, size = 5, spawned = false},
    ["vik_fact_norse"] = {leader_army = "norse_royal", base_army = "norse_invader", spawns = {"en_northeast", "an_northeast"}, delay = 1, size = 3, spawned = false}
}--:map<string, {leader_army: string, base_army: string, spawns: vector<string>, delay: int, size: int, spawned: boolean}>
if dev.is_new_game() and CONST.__testcases.__test_endgame_invasions then
    for k, v in pairs(END_GAME_INVASIONS) do END_GAME_INVASIONS[k].delay = dev.mround(dev.clamp(v.delay-((v.delay*3)/4), 1, 5), 1) end
end
--the numbers are: min level, recharge rate, chance to add.
--when size is at min level or higher, takes math.floor((size - min level)/recharge rate) + 1 attempts using the chance to add. 
--1, 2, 60 in an army of 3 will try to add the unit twice at a 60% chance. 9, 1, 100 in an army of size 12 will add 4 units 100% of the time. 
local armies = {
    ["norman_invader"] = {
        ["nor_spearmen"] = {2,3,80},
        ["nor_levy_spearmen"] = {1,4,20},
        ["nor_mailed_spearmen"] = {2,3,15},
        ["nor_axe_levy"] = {2,3,30},
        ["nor_archers"] = {3,3,35},
        ["nor_flemish_crossbowmen"] = {5, 5, 25},
        ["nor_catapult"] = {7,15,30},
        ["nor_horsemen"] = {3,6,50},
        ["nor_cavalry"] = {10,2,30},
        ["nor_scout_cavalry"] = {3,4,15},
        ["nor_maine_warriors"] = {4,3,15},
        ["nor_swordsmen"] = {4,4,10}
    },
    ["norman_royal"] = {
      ["nor_spearmen"] = {3,3,50},
      ["nor_mailed_spearmen"] = {3,3,20},
      ["nor_archers"] = {3,3,30},
      ["nor_flemish_crossbowmen"] = {5, 5, 30},
      ["nor_catapult"] = {7,15,30},
      ["nor_horsemen"] = {3,6,35},
      ["nor_cavalry"] = {10,2,15},
      ["nor_scout_cavalry"] = {3,4,10},
      ["nor_maine_warriors"] = {4,3,15},
      ["nor_swordsmen"] = {4,4,10},
      --royal only
      ["nor_shield_wall"] = {3,3,35},
      ["nor_axemen"] = {3,3,35},
      ["nor_knights"] = {3,3,25},
      ["nor_foot_soldiers"] = {4,4,10},
    },
    ["norse_royal"] = {
      ["est_spearband"] = {2,3,50},
      ["est_spear_hirdmen"] = {2,3,30},
      ["est_axemen"] = {2,4,30},
      ["est_long_axes"] =  {10,10,25},
      ["est_mailed_axemen"] = {2,3,30},
      ["est_champions"] = {5,12,35},
      ["est_hunters"] = {3,4,15},
      ["est_archers"] = {3,4,35},
      ["vik_mailed_archers"] = {5, 5, 25},
      ["est_marauders"] = {8,8,20},
      ["est_shield_biters"] = {10,10,25},
      ["est_scouts"] = {5,5,15},
      ["est_hirdmen"] = {4,4,10},
      ["est_spear_guard"] = {4,4,10}
    },
    ["norse_invader"] = {
      ["est_spearband"] = {2,3,80},
      ["est_spear_hirdmen"] = {2,3,15},
      ["est_axemen"] = {2,3,30},
      ["est_long_axes"] =  {10,10,25},
      ["est_mailed_axemen"] = {2,3,30},
      ["est_champions"] = {10,10,25},
      ["est_hunters"] = {3,3,15},
      ["est_archers"] = {3,3,35},
      ["vik_mailed_archers"] = {10, 5, 25},
      ["est_marauders"] = {6,6,35},
      ["est_shield_biters"] = {10,10,25},
      ["est_scouts"] = {3,4,15},
      ["est_hirdmen"] = {4,4,10},
      ["est_spear_guard"] = {4,4,10}
    }
}--:map<string, map<string, {int, int, int}>>

local events = dev.GameEvents

--v function(t: any)
local function log(t)
    dev.log(tostring(t), "ENDGAME-INVADERS")
end

--spawn the army itself
--figure out if we have a human target player
--fire any necessary event.
--v function(faction_key: string, army_type: string, x: int, y: int)
local function create_invasion_force(faction_key, army_type, x, y)
    local force_key = dev.create_army(armies, 7 + END_GAME_INVASIONS[faction_key].size , army_type)
    local temp_region = cm:model():world():region_manager():region_list():item_at(0):name();
    dev.log("Spawning Invader!: \nForce key is: "..force_key .. "\nLocation is: "..temp_region.."("..x..","..y..")\nfaction_key:"..faction_key)
    cm:create_force(faction_key, force_key, temp_region, x, y, "sw_raiders_"..dev.invasion_number(), true)
    dev.spawn_blockers[x] =  dev.spawn_blockers[x] or {}
    dev.spawn_blockers[x][y] = cm:model():turn_number()
end

--v function(x: int, y: int, t_list: vector<string>, human_faction: CA_FACTION?) --> (int, number)
local function get_closest_target(x, y, t_list, human_faction)
    local dist = 1000000 --:number
    local rf = 0 --:int
    for r = 1, #t_list do
        local region = dev.get_region(t_list[r])
        local distance = dev.distance(x, y, region:settlement():logical_position_x(),  region:settlement():logical_position_y())
        --# assume human_faction: CA_FACTION
        if (not human_faction or (region:owning_faction():name() == human_faction:name() or region:owning_faction():is_vassal_of(human_faction))) and distance < dist  then
            dist = distance 
            rf = r
        end
    end
    return rf, dist
end


--v function(invading_faction: string, location_key: string)
local function spawn_invasion(invading_faction, location_key)
    dev.log("Creating invasion force for ["..invading_faction.."] from location ["..location_key.."]", "INV")
    local entry = END_GAME_INVASIONS[invading_faction]
    local spawns = {} --:vector<{int, int}>
    for s = 1, 8 do
        local x, y = Gamedata.spawn_locations.VikingRaiders[location_key]["x"..tostring(s)], Gamedata.spawn_locations.VikingRaiders[location_key]["y"..tostring(s)] 
        if dev.spawn_blockers[x] and dev.spawn_blockers[x][y] then
            --go round again
        else
            table.insert(spawns, {x, y})
        end
    end
    local royal_armies = -2 + entry.size 
    for i = 1, #spawns do
        local is_royal = i <= royal_armies
        if is_royal then
            create_invasion_force(invading_faction, entry.leader_army, spawns[i][1], spawns[i][2])
        else
            create_invasion_force(invading_faction, entry.base_army, spawns[i][1], spawns[i][2])
        end
    end
    cm:apply_effect_bundle("sw_invasion_faction", invading_faction, 20)
    END_GAME_INVASIONS[invading_faction].spawned = true
end


--v function(human_faction: CA_FACTION)
local function check_norman_invasion(human_faction)
    local entry = END_GAME_INVASIONS["vik_fact_normaunds"]
    if entry.spawned or #entry.spawns == 0 then
        return
    end
    END_GAME_INVASIONS["vik_fact_normaunds"].delay = entry.delay - 1
    log("Cooldown on vik_fact_normaunds endgame invasion is: "..tostring(END_GAME_INVASIONS["vik_fact_normaunds"].delay))
    if entry.delay <= normans_prelude_turn and not events:get_event(normans_warning):is_off_cooldown() then
        local event_context = events:build_context_for_event(normans_warning, human_faction)
        events:force_check_and_trigger_event_immediately(normans_warning, event_context)
    end
    if entry.delay <= 0 then
        local location_key = entry.spawns[cm:random_number(#entry.spawns)]
        spawn_invasion("vik_fact_normaunds", location_key)
        local x, y = Gamedata.spawn_locations.VikingRaiders[location_key]["x1"], Gamedata.spawn_locations.VikingRaiders[location_key]["y1"] 
        local rf, dist = get_closest_target(x, y, norman_locations, human_faction)
        if dist > norman_far_away_distance or (not norman_locations[rf]) then
            local event_context = events:build_context_for_event(norman_far_away_event, human_faction)
            events:force_check_and_trigger_event_immediately(norman_far_away_event, event_context)
        elseif norman_locations[rf] then
            local region = norman_locations[rf]
            local incident = norman_region_prefix .. string.gsub(region, "vik_reg_", "")
            local event_context = events:build_context_for_event(incident, human_faction)
            events:force_check_and_trigger_event_immediately(incident, event_context)
        end
    end
end

--v function(human_faction: CA_FACTION)
local function check_norse_invasion(human_faction)
    local entry = END_GAME_INVASIONS["vik_fact_norse"]
    if entry.spawned then
        return
    end
    END_GAME_INVASIONS["vik_fact_norse"].delay = entry.delay - 1
    log("Cooldown on vik_fact_norse endgame invasion is: "..tostring(END_GAME_INVASIONS["vik_fact_norse"].delay))
    if entry.delay <= 0 then
        local location_key = entry.spawns[cm:random_number(#entry.spawns)]
        spawn_invasion("vik_fact_norse", location_key)
        local jorvik_owner = dev.get_region(norse_location):owning_faction()
        if jorvik_owner:name() ~= "vik_fact_norse" and not dev.get_faction("vik_fact_norse"):at_war_with(jorvik_owner) then
            cm:force_declare_war("vik_fact_norse", jorvik_owner:name())
        end
        if human_faction:name() == jorvik_owner:name() then
            local event_context = events:build_context_for_event(norse_invader_hostile, human_faction)
            events:force_check_and_trigger_event_immediately(norse_invader_hostile, event_context)
        else
            local event_context = events:build_context_for_event(norse_invader_arrival, human_faction)
            events:force_check_and_trigger_event_immediately(norse_invader_arrival, event_context)
        end
    end
end
dev.first_tick(function(context) 
    events:create_event(norman_far_away_event, "incident", "standard"):set_cooldown(99)
    events:create_event(norse_invader_hostile, "incident", "standard"):set_cooldown(99)
    events:create_event(norse_invader_arrival, "incident", "standard"):set_cooldown(99)
    events:create_event(normans_warning, "incident", "standard"):set_cooldown(99)
    for i = 1, #norman_locations do
        local norman_arrival_event = norman_region_prefix .. string.gsub(norman_locations[i], "vik_reg_", "")
        events:create_event(norman_arrival_event, "incident", "standard"):set_cooldown(99)
    end
    for key, entry in pairs(END_GAME_INVASIONS) do
        local size = entry.size
        local difficulty = cm:model():difficulty_level()
        entry.size = size + difficulty*-1
    end

    dev.eh:add_listener(
        "EndGameInvasionsTurnStart",
        "KingdomTurnStart",
        function(context)
            local table = context:table_data()[context:faction():name()]
            return (table and table[2] == true) or (context:faction():is_human() and CONST.__testcases.__test_endgame_invasions)
        end,
        function(context)
            local faction = context:faction()
            log("Checking Endgame invasions for "..faction:name())
            if CONST.__testcases.__test_endgame_invasions then
                log("TEST VAR IS ACTIVE: CONST.__testcases.__test_endgame_invasions")
            end
            check_norman_invasion(faction)
            check_norse_invasion(faction)
        end,
        true)
    dev.eh:add_listener(
        "EndGameInvasionManagers",
        "FactionTurnStart",
        function(context)
            return not not END_GAME_INVASIONS[context:faction():name()]
        end,
        function(context)
            local faction = context:faction() --:CA_FACTION

            log("Its "..faction:name().."'s turn'")
            if faction:name() == "vik_fact_norse" then
                local owner = dev.get_region(norse_location):owning_faction()
                log("Jorvik is owned by: "..owner:name())
                if owner:name() ~= faction:name() then
                    dev.set_factions_hostile(faction:name(), owner:name())
                    if not faction:at_war_with(owner) then
                        log("Declaring war on owner!")
                        cm:force_declare_war(faction:name(), owner:name())
                    end
                end
            end
            if faction:name() == "vik_fact_normaunds" then
                local x = faction:faction_leader():logical_position_x() 
                local y = faction:faction_leader():logical_position_y()
                local list = {} --:vector<string>
                for i = 1, #norman_locations do
                    if not (dev.get_region(norman_locations[i]):owning_faction():name() == faction:name()) then
                        log(norman_locations[i].. " is not yet owned by the Normans")
                        table.insert(list, norman_locations[i])
                    end
                end
                local closest_target_i = get_closest_target(x, y, list)
                if list[closest_target_i] then
                    log("closest target was: "..list[closest_target_i])
                    local owner = dev.get_region(list[closest_target_i]):owning_faction()
                    if owner:name() ~= faction:name() then
                        log("closest target was owned by: "..owner:name())
                        dev.set_factions_hostile(faction:name(), owner:name())
                        if not faction:at_war_with(owner) then
                            log("Declaring war on owner!")
                            cm:force_declare_war(faction:name(), owner:name())
                        end 
                    end
                end
            end
            local num_wars = faction:factions_at_war_with():num_items() 
            if num_wars < 2 then
                for i = 0, faction:character_list():num_items() - 1 do
                    local char = faction:character_list():item_at(i)
                    if not char:region():is_null_interface() then
                        if char:region():owning_faction():name() ~= faction:name() and not (char:region():owning_faction():is_vassal_of(faction)) then
                            if not faction:at_war_with(char:region():owning_faction()) then
                                dev.set_factions_hostile(faction:name(), char:region():owning_faction():name())
                                cm:force_declare_war(faction:name(), char:region():owning_faction():name())
                            end
                        end
                    end
                end
            end
        end,
        true
    )
end)


dev.Save.attach_to_table(END_GAME_INVASIONS, "ENDGAME_INVASIONS")
