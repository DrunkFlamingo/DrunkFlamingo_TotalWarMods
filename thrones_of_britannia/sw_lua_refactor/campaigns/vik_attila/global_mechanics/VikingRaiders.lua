local dilemma_cd = 12 --how often can the player be asked about danegeld at most?
local raider_cd_base = 19 -- the formula for final cooldown is base minus clamp(2*region_intensity, 0, 9). 
local raider_cd_reduction_max = 12 -- how much can cooldown be reduced by intensity?
local cd_intensity_scale = 3 -- how much cooldown is lost per intensity level?
-- base - intensity*scale or max.

local vassal_boredom_time = 5 -- how long does it take for a vassal viking faction to betray you if bored?
local vassal_betrayal_chance = 8 -- how likely are rival GVA factions to purchase their loyalty?

--every level of intensity drops the cooldown on armies by the cd intensity scale to a max of the cd reduction max.
--also contributes to determining army size, along with campaign difficulty. 
local region_intensities = {
    ["vik_fact_finngaill"] = {2, 3, 2},
    ["vik_fact_nordmann"] = {2, 3, 4, 2},
    ["vik_fact_dubgaill"] = {2, 3, 3, 4},
    ["vik_fact_wicing"] =  {3, 3, 2},
    ["vik_fact_haeden"] =  {3, 4, 5}
}--:map<string, vector<int>>


--the numbers are: min level, recharge rate, chance to add.
--when size is at min level or higher, takes math.floor((size - min level)/recharge rate) + 1 attempts using the chance to add. 
--1, 2, 60 in an army of 3 will try to add the unit twice at a 60% chance. 9, 1, 100 in an army of size 12 will add 4 units 100% of the time. 
local armies = {
    ["raider_norse"] = {
        ["est_berserkers"] = {1, 15, 100},
        ["est_spear_hirdmen"] = {1, 2, 60},
        ["est_shield_biters"] = {4, 3, 30},
        ["vik_mailed_archers"] = {6, 3, 30},
        ["est_marauders"] = {2, 2, 35}
    },
    ["raider_dane"] = {
        ["dan_shield_biters"] = {1, 15, 100},
        ["dan_anglian_raiders"] = {1, 2, 80},
        ["dan_berserkers"] = {6, 3, 50},
        ["dan_ceorl_axemen"] = {2, 2, 35}
    },
    ["dane_royal"] = {

    },
    ["dane_invader"] = {

    }
}--:map<string, map<string, {int, int, int}>>

--these can be fired by an event call but have settings handled here.
local scripted_invasions = {
    ["earlygame_norse"] = {},
    ["midgame_dane"] = {},
    ["lategame_norse"] = {},
    ["lategame_norman"] = {}
}


local invaders = {
    ["vik_fact_dubgaill"] = {army = "raider_norse", spawns = {"sc_northwest", "sc_north" , "ir_northwest"}, cooldown = 9},
    ["vik_fact_finngaill"] = {army = "raider_norse", spawns = {"sc_northwest", "ir_south"}, cooldown = 12},
    ["vik_fact_wicing"] = {army = "raider_norse", spawns = {"en_southwest", "en_south", "en_southeast"}, cooldown = 1},
    ["vik_fact_nordmann"] = {army = "raider_norse", spawns = {"sc_east", "sc_north", "an_northeast"}, cooldown = 3},
    ["vik_fact_haeden"] = {army = "raider_dane", spawns = {"an_northeast", "en_northeast"}, cooldown = 10},
}--:map<string, {army: string, spawns: vector<string>, cooldown: int}>

--states: normal, vassal.
local active_raiders = {

}--:map<string, {state: number, target: string}>


local events = dev.GameEvents


--get the faction who is closest the spawn point. 
--v function(x: int, y: int, is_human: boolean) --> (string, number)
local function get_closest_faction_to_spawn_point(x, y, is_human)
    if is_human then
        local distance = nil --:number
        local faction = "" --:string
        local humans = cm:get_human_factions()
        for j = 1, #humans do 
            local region_list = dev.get_faction(humans[j]):region_list()
            for k = 0, region_list:num_items() - 1 do
                local region = region_list:item_at(k)
                local lx = region:settlement():logical_position_x() - x
                local ly = region:settlement():logical_position_y() - y
                local region_distance = ((lx * lx) + (ly * ly))
                if not distance or distance > region_distance then
                    distance = region_distance
                    faction = region:owning_faction():name()
                end
            end
        end
        return faction, distance
    else
        local distance = nil --:number
        local faction = "" --:string
        local humans = cm:get_human_factions()
        local region_list = dev.region_list()
        for k = 0, region_list:num_items() - 1 do
            local region = region_list:item_at(k)
            local lx = region:settlement():logical_position_x() - x
            local ly = region:settlement():logical_position_y() - y
            local region_distance = ((lx * lx) + (ly * ly))
            if not distance or distance > region_distance then
                distance = region_distance
                faction = region:owning_faction():name()
            end
        end
        return faction, distance

    end
end


--v function(location_key: string) --> (int, int)
local function get_spawn_position(location_key)
    dev.log("Finding a spawn position from: "..location_key)
    local spawn = cm:random_number(8)
    for i = 1, 8 do
        local s = spawn + i
        if s > 8 then 
            s = s - 8
        end

        local x, y = Gamedata.spawn_locations.VikingRaiders[location_key]["x"..tostring(s)], Gamedata.spawn_locations.VikingRaiders[location_key]["y"..tostring(s)] 
        if dev.spawn_blockers[x] and dev.spawn_blockers[x][y] then
            --go round again
        else
            return x, y
        end
    end
    return -1, -1 
end


--spawn the army itself
--figure out if we have a human target player
--fire any necessary event.
--v function(faction_key: string, location_key: string, x: int, y: int, intensity: int, should_fire_event: boolean)
local function create_invasion_force(faction_key, location_key, x, y, intensity, should_fire_event)
    dev.log("Creating invasion force for ["..faction_key.."] from location ["..location_key.."]", "RAIDER")
    local army_type = invaders[faction_key].army
    local force_vector = {} --:vector<string>
    local force_key = dev.create_army(armies, intensity, army_type)
    local temp_region = cm:model():world():region_manager():region_list():item_at(0):name();
    dev.log("Spawning Viking Raid!: \nForce key is: "..force_key .. "\nLocation is: "..temp_region.."("..x..","..y..")\nfaction_key:"..faction_key)
    cm:create_force(faction_key, force_key, temp_region, x, y, "sw_raiders_"..dev.invasion_number(), true)
    dev.spawn_blockers[x] =  dev.spawn_blockers[x] or {}
    dev.spawn_blockers[x][y] = cm:model():turn_number()
    local cd = raider_cd_base - dev.mround(dev.clamp(cd_intensity_scale*intensity, 0, raider_cd_reduction_max), 1)
    if cm:model():is_multiplayer() then
        cd = cd*2
    end
    invaders[faction_key].cooldown = cd
    if should_fire_event then
        local incident = "sw_viking_invasion_" .. faction_key .. string.sub(location_key, string.find(location_key, "_") + 1)
        dev.log("notifying players with incident: "..incident, "RAIDER")
        for i = 1, #cm:get_human_factions() do
            cm:trigger_incident(cm:get_human_factions()[i], incident, true)
        end
    end
end

--v function(faction_key: string)
local function invasions_turn_start(faction_key)
    local faction = dev.get_faction(faction_key)
    dev.log("Invader ["..faction_key.."] is off CD!", "RAIDER")
    local location_key = invaders[faction_key].spawns[cm:random_number(#invaders[faction_key].spawns)]
    local x, y = get_spawn_position(location_key)
    if x == -1 then
        dev.log("No valid spawn found!", "RAIDER")
        return
    end
    local turn_increment = math.ceil(cm:model():turn_number()/20)
    if not region_intensities[faction_key][turn_increment] then
        dev.log("No intensity value found at the current turn increment, aborting!")
        return
    end
    local intensity = turn_increment - cm:model():difficulty_level(); --DIFFICULTY VARS
    local closest_human, h = get_closest_faction_to_spawn_point(x, y, true)
    local closest_faction, f = get_closest_faction_to_spawn_point(x, y, false)
    local target = closest_faction
    dev.log("closest human to spawn was ["..closest_human..","..tostring(h).."]", "RAIDER")
    dev.log("closest faction to spawn was ["..closest_faction..","..tostring(f).."]", "RAIDER")
    if closest_faction == closest_human or dev.get_faction(closest_faction):is_vassal_of(dev.get_faction(closest_human)) or h*0.60 < f then
        --is this human on dilemma CD?
        if events:can_queue_dilemma() and (not (invaders[closest_human].cooldown > 0)) and dev.get_faction(closest_human):treasury() > 1100 then
            --queue dilemma
            --shield_invasion_danegeld	or _GVA
            local dilemma = "shield_invasion_danegeld"
            if dev.get_faction(closest_human):subculture() == "vik_sub_cult_anglo_viking" then
                dilemma = dilemma .. "_GVA"
            end
            dev.log("Firing danegeld dilemma for human player ["..closest_human.."]", "RAIDER")
            --queue responce of spawning army when dilemma is picked.
            dev.respond_to_dilemma(dilemma, function(context)
                if context:choice() == 1 then
                    create_invasion_force(faction_key, location_key, x, y, intensity, false)
                    active_raiders[faction_key] = {state = -1, target = closest_human}
                elseif context:choice() == 3 then
                    create_invasion_force(faction_key, location_key, x, y, intensity, false)
                    active_raiders[faction_key] = {state = vassal_boredom_time, target = closest_human}
                else
                    local cd = raider_cd_base - dev.mround(dev.clamp(cd_intensity_scale*intensity, 0, raider_cd_reduction_max), 1)
                    if cm:model():is_multiplayer() then
                        cd = cd*2
                    end
                    invaders[faction_key].cooldown = cd
                end
                invaders[closest_human].cooldown = dilemma_cd
            end)
            local event_context = events:build_context_for_event(dilemma, dev.get_faction(closest_human))
            events:force_check_and_queue_event(dilemma, event_context)
        else
            create_invasion_force(faction_key, location_key, x, y, intensity, true) --only show a message when the human's distance is less than 3x the distance to the target.
            active_raiders[faction_key] = {state = -1, target = closest_human}
        end
    else
        create_invasion_force(faction_key, location_key, x, y, intensity, (h < 3*f))
        active_raiders[faction_key] = {state = -1, target = closest_faction}
    end
end


dev.first_tick(function(context)
    --put humans in the persisted table to track dilemma cd
    local humans = cm:get_human_factions()
    for i = 1, #humans do
        if not invaders[humans[i]] then
            invaders[humans[i]] = {cooldown = dev.mround(dilemma_cd/4, 1), army = "", spawns = {}}
        end
    end

    local danegeld_basic = events:create_event("shield_invasion_danegeld", "dilemma", "standard")
    local danegeld_gva = events:create_event("shield_invasion_danegeld_GVA", "dilemma", "standard")

    dev.eh:add_listener(
        "VikingRaidersTurnStartCooldowns",
        "FactionTurnStart",
        function(context)
            return context:faction():is_human()
        end,
        function(context)
            local human_faction = context:faction() --:CA_FACTION
            dev.log("Danegeld Dilemma CD for ["..human_faction:name().."] is at ["..tostring(invaders[human_faction:name()].cooldown).."]", "RAIDER")
            if invaders[human_faction:name()].cooldown > 0 then
                invaders[human_faction:name()].cooldown  = invaders[human_faction:name()].cooldown  - 1;
            end
            for faction_key, info in pairs(invaders) do
                if dev.get_faction(faction_key):is_dead() then
                    if info.cooldown == 0 then
                        invasions_turn_start(faction_key)
                    elseif info.cooldown > 0 then
                        dev.log("Viking Raider Faction "..faction_key.." is at CD: "..tostring(info.cooldown), "RAIDER")
                        info.cooldown = info.cooldown - 1; --this will happen twice in MP games, so we double CD's on MP games.\
                    end
                end
            end
        end,
        true)

    dev.eh:add_listener(
        "VikingRaidersTurnStart",
        "FactionTurnStart",
        function(context)
            return not not invaders[context:faction():name()] and not not active_raiders[context:faction():name()]
        end,
        function(context)
            local vikings = context:faction() --:CA_FACTION
            local viking_leader = vikings:faction_leader()
            local target = dev.get_faction(active_raiders[vikings:name()].target)
            local state = active_raiders[vikings:name()].state
            dev.log("Active Viking Raid by ["..vikings:name().."] is starting its turn with target: ["..target:name().."] and state ["..tostring(state).."] ", "RAIDER")
            if target:is_dead() then
                dev.log("Target is dead! Long Live the Target")
                local settlement = dev.closest_settlement_to_char(viking_leader, true)
                state = -1
                target = dev.get_region(settlement):owning_faction()
                active_raiders[vikings:name()].target = target:name()
            end
            if state < 0 and not vikings:at_war_with(target) then
                dev.log("Forcing raid to DOW target", "RAIDER")
                cm:force_declare_war(vikings:name(), target:name())
            elseif target:is_human() and state > 0 then
                if not vikings:is_vassal_of(target) then
                    dev.log("Forcing raid to be Vassalized by target", "RAIDER")
                    cm:force_make_vassal(target:name(), vikings:name())
                end
                local is_at_war = false --:boolean
                dev.log("Checking if Raider Ally is at war", "RAIDER")
                for i = 0, target:factions_at_war_with():num_items() - 1 do
                    is_at_war = true 
                    if target:factions_at_war_with():item_at(i):subculture() == "vik_sub_cult_anglo_viking" then
                        if cm:random_number(100) < vassal_betrayal_chance then
                            --betrayed!
                            active_raiders[vikings:name()] = {state = -1, target = target:name()}
                            cm:force_declare_war(vikings:name(), target:name())
                            cm:trigger_incident(target:name(), "sw_viking_vassal_betrayal", true)
                        end
                    end
                end
                if not is_at_war then
                    active_raiders[vikings:name()].state = active_raiders[vikings:name()].state - 1
                    dev.log("Incrementing Raider Boredom", "RAIDER")
                    if state == 0 then
                        --time to betray!
                        active_raiders[vikings:name()] = {state = -1, target = target:name()}
                        cm:force_declare_war(vikings:name(), target:name())
                    end
                end
            end
        end,
        true)
end)

dev.Save.attach_to_table(invaders, "VIKING_RAIDERS")
dev.Save.attach_to_table(active_raiders, "VIKING_RAIDERS_2")
