local rival = {} --# assume rival: RIVAL
local instances = {} --:map<string, RIVAL>
local rivals_to_create = {}--:map<string, boolean>
dev.Save.attach_to_table(rivals_to_create, "RIVALS_LIST")


local secondary_factions = {
    ["vik_fact_gwined"] = true,
    ["vik_fact_strat_clut"] = true,
    ["vik_fact_dyflin"] = true,
    ["vik_fact_norse"] = true,
    ["vik_fact_sudreyar"] = true,
    ["vik_fact_circenn"] = true,
    ["vik_fact_normaunds"] = true,
    ["vik_fact_mide"] = true,
    ["vik_fact_mierce"] = true,
    ["vik_fact_west_seaxe"] = true,
    ["vik_fact_east_engle"] = true,
    ["vik_fact_northymbre"] = true,
    ["vik_fact_aileach"] = true,
    ["vik_fact_dene"] = true,
    ["vik_fact_northleode"] = true,
    ["vik_fact_orkneyar"] = true,
    ["vik_fact_ulaid"] = true,
} --:map<string, boolean>



--v function(players: vector<string>, character: CA_CHAR) --> boolean
local function CheckIfPlayerIsNearFaction(players, character)
    local result = false;
    if character:faction():is_human() then
        return true
    end
    local radius = 20;
    for i,value in ipairs(players) do
        local player_force_list = dev.get_faction(value):military_force_list();
        local j = 0;
        while (result == false) and (j < player_force_list:num_items()) do
            local player_character = player_force_list:item_at(j):general_character();
            local distance = dev.distance(character:logical_position_x(), character:logical_position_y(), player_character:logical_position_x(), player_character:logical_position_y());
            result = (distance < radius);
            j = j + 1;
        end
    end
    return result;
end



--v function(faction_key: string, kingdom: string, region_list: vector<string>, nation: string, region_list_national:vector<string>) --> RIVAL
function rival.new(faction_key, kingdom, region_list, nation, region_list_national)
    local self = {}
    setmetatable(self, {
        __index = rival
    })--# assume self: RIVAL

    self.faction_name = faction_key
    self.my_regions = {} --:map<string, true>
    self.nation_regions = {} --:map<string, true>
    self.kingdom_level = 0
    for i = 1, #region_list do
        self.my_regions[region_list[i]] = true
    end
    for i = 1, #region_list_national do
        self.nation_regions[region_list_national[i]] = true
    end
    rivals_to_create[faction_key] = true
    return self

end

--v function(self: RIVAL, t: any)
function rival.log(self, t)
    dev.log(tostring(t), "RIVAL")
end


--v function(self: RIVAL, is_defender: boolean)
function rival.autowin(self, is_defender)
    self:log("Rival: "..self.faction_name.." is autowinning a battle!")
    if not is_defender then
        cm:win_next_autoresolve_battle(self.faction_name);
        cm:modify_next_autoresolve_battle(1, 0, 1, 20, true);
    else
        cm:win_next_autoresolve_battle(self.faction_name);
        cm:modify_next_autoresolve_battle(0, 1, 20, 1, true);
    end

end



--v function(self: RIVAL, faction: CA_FACTION) --> boolean
function rival.is_other_rival(self, faction)
    return not not instances[faction:name()]
end

--v function(self: RIVAL, context: WHATEVER) --> (boolean, boolean)
function rival.get_battle_info(self, context) 
    self:log("Rival "..self.faction_name.." is getting info about a battle!")
    local attacking_faction = context:pending_battle():attacker():faction() --:CA_FACTION
    local defending_faction = context:pending_battle():defender():faction() --:CA_FACTION
    local location = context:pending_battle():attacker():region() --:CA_REGION
    local attacker_territory = false --:boolean
    local defender_territory = false --:boolean
    if not location:is_null_interface() then
         attacker_territory = (self.faction_name == attacking_faction:name()) --be the attacker
          and (
              (self.kingdom_level == 0 and self.my_regions[location:name()])  --be either a petty kingdom inside your major kingdom
            or (self.kingdom_level > 0 and self.nation_regions[location:name()]) --or a major kingdom inside your nation
        )   
        defender_territory = (self.faction_name == defending_faction:name()) --be the defender
        and (
            (self.kingdom_level == 0 and self.my_regions[location:name()])  --be either a petty kingdom inside your major kingdom
          or (self.kingdom_level > 0 and self.nation_regions[location:name()]) --or a major kingdom inside your nation
      )   
    end
    local attacker_is_major = self:is_other_rival(attacking_faction) 
	local defender_is_major = self:is_other_rival(defending_faction) 
	local attacker_is_secondary = PettyKingdoms.VassalTracking.is_faction_vassal(defending_faction:name()) or attacking_faction:is_human() or secondary_factions[attacking_faction:name()] or dev.Check.is_faction_player_ally(attacking_faction)
    local defender_is_secondary = PettyKingdoms.VassalTracking.is_faction_vassal(defending_faction:name()) or defending_faction:is_human() or secondary_factions[defending_faction:name()] or dev.Check.is_faction_player_ally(attacking_faction)
    if CONST.__write_output_to_logfile then
        --v function(t: any)
        local function MELOG(t) self:log(t) end
        MELOG("\n#### BATTLE ####\n"..attacking_faction:name().." v "..defending_faction:name());
        do
            local print = MELOG
            local a_mf = context:pending_battle():defender():military_force() --:CA_FORCE
            local b_mf = context:pending_battle():attacker():military_force() --:CA_FORCE
            local vec = {b_mf, a_mf} --:vector<CA_FORCE>
            local name = "attacker"
            print("Outputting battle info for crash debug")
            --v function(t: string)
            local function print(t) MELOG("\t"..t) end
            print("is seige?: "..tostring(context:pending_battle():seige_battle()))
            print("is night battle?: "..tostring(context:pending_battle():night_battle()))
            print("is naval battle?: "..tostring(context:pending_battle():naval_battle()))
            print("has contested garrison?: "..tostring(context:pending_battle():seige_battle()))
            for i = 1, 2 do
                print(name.." info:")
                --v function(t: string)
                local function print(t) MELOG("\t\t"..t) end
                
                local current_mf = vec[i]
                print("faction ".. current_mf:faction():name())
                if current_mf:has_general() then
                    print(name.." has general")
                    local gen = current_mf:general_character()
                    do
                        --v function(t: string)
                        local function print(t) MELOG("\t\t\t"..t) end
                        print("rank ".. tostring(gen:rank()))
                        print("is faction leader?" .. tostring(gen:is_faction_leader()))
                        if gen:region():is_null_interface() then
                            print("region null interface -- at sea")
                        else
                            print("region ".. gen:region():name())
                        end
                    end
                end
                print("Unit list: ")
                --v function(t: string)
                local function print(t) MELOG("\t\t"..t) end
                for j = 0, current_mf:unit_list():num_items() - 1 do
                    print(current_mf:unit_list():item_at(j):unit_key())
                end
                name = "defender"
            end
        end


    end
    --abort if players are nearby
    if CheckIfPlayerIsNearFaction(cm:get_human_factions(), context:pending_battle():attacker()) then
        return false, false
    end
    --abort if the defender is secondary.
    if defender_is_secondary then
        return false, false
    end
    --if both are major, we're in our territory, but we're attacking, abort
    if attacker_territory and defender_is_major then
        return false, false
    --if we're in attacker territory and they aren't major, win.
    elseif attacker_territory then
        return true, false
    --if they're in defender territory and attacker is major, defender wins win.
    elseif defender_territory and not attacker_is_major then
        return false, true
    end
    --if its not your territory, but you are the attacker
    if (not defender_territory) and (not attacker_territory) and (self.faction_name == attacking_faction:name()) then
        --if we're attacking a protected faction, abort
        if defender_is_secondary then
            return false, false
        else
            --otherwise, give a win to attackers
            return true, false
        end
    --if its not your territory, but you are the defender
    elseif (not defender_territory) and (not attacker_territory) and self.faction_name == defending_faction:name() then
        --if we're defending a protected faction, abort
        if attacker_is_secondary then
            return false, false
        else
            --otherwise, give a win to defenders
            return false, true
        end
    end
    return false, false
end



--v function(faction_key: string, kingdom: string, region_list: vector<string>, nation: string, region_list_national:vector<string>) --> RIVAL
local function make_rival_faction(faction_key, kingdom, region_list, nation, region_list_national)
    if (not is_string(faction_key)) or (not is_string(kingdom)) or (not is_string(nation)) then
        return nil
    end
    local new_rival = rival.new(faction_key, kingdom, region_list, nation, region_list_national)
    instances[faction_key] = new_rival
    new_rival:log("Created rival! "..faction_key.. " with kingdom  "..kingdom)
    return new_rival
end

--v function(key: string) --> boolean
local function is_rival(key)
    return not not instances[key]
end

dev.first_tick(function(context)
    dev.log("Rivals module adding listeners", "RIVAL")
    for rival_to_create, value in pairs(rivals_to_create) do
        make_rival_faction(rival_to_create, 
        Gamedata.kingdoms.faction_kingdoms[rival_to_create],  Gamedata.kingdoms.kingdom_provinces(dev.get_faction(rival_to_create)),
        Gamedata.kingdoms.faction_nations[rival_to_create], Gamedata.kingdoms.nation_provinces(dev.get_faction(rival_to_create)))
    end
    dev.eh:add_listener(
        "GuarenteedEmpiresCore",
        "PendingBattle",
        function(context)
            return is_rival(context:pending_battle():attacker():faction():name())
        end,
        function(context)
            local attacking_faction = context:pending_battle():attacker():faction() --:CA_FACTION
            local defending_faction = context:pending_battle():defender():faction() --:CA_FACTION
            local attacker_rival = instances[attacking_faction:name()]
            local buff_attacker, buff_defender = attacker_rival:get_battle_info(context)
            if buff_attacker then
                attacker_rival:autowin(false)
            end
        end,
        true)
    dev.eh:add_listener(
        "GuarenteedEmpiresCore",
        "PendingBattle",
        function(context)
            return is_rival(context:pending_battle():defender():faction():name())
        end,
        function(context)
            local attacking_faction = context:pending_battle():attacker():faction() --:CA_FACTION
            local defending_faction = context:pending_battle():defender():faction() --:CA_FACTION
            local defender_rival = instances[defending_faction:name()]
            local buff_attacker, buff_defender = defender_rival:get_battle_info(context)
            if buff_defender then
                defender_rival:autowin(true)
            end
        end,
        true)
        dev.eh:add_listener(
            "GuarenteedEmpiresCore",
            "PendingBattle",
            function(context)
                return CONST.__utilities.__human_autowins_every_battle
            end,
            function(context)
                dev.log("Human autowins battles constant is active: autowinning a battle!", "__human_autowins_every_battle")
                local attacking_faction = context:pending_battle():attacker():faction() --:CA_FACTION
                local defending_faction = context:pending_battle():defender():faction() --:CA_FACTION
                local defender_rival = instances[defending_faction:name()]
                if attacking_faction:is_human() then
                    cm:win_next_autoresolve_battle(attacking_faction:name());
                    cm:modify_next_autoresolve_battle(1, 0, 1, 20, true);
                else
                    cm:win_next_autoresolve_battle(defending_faction:name());
                    cm:modify_next_autoresolve_battle(0, 1, 20, 1, true);
                end
            end,
            true)
        if CONST.__utilities.__human_autowins_every_battle then
            local h = dev.get_faction(cm:get_local_faction(true))
            if not h:model():pending_battle():is_null_interface() then
                local pb = h:model():pending_battle() 
                dev.log("Human autowins battles constant is active: we loaded game into a pending battle!", "__human_autowins_every_battle")
                if pb:attacker():faction():is_human() then
                    dev.log("Human autowins battles constant is active: autowinning an attacker battle!", "__human_autowins_every_battle")
                    cm:win_next_autoresolve_battle(h:name());
                    cm:modify_next_autoresolve_battle(1, 0, 1, 20, true);
                elseif pb:defender():faction():is_human() then
                    dev.log("Human autowins battles constant is active: autowinning a defender battle!", "__human_autowins_every_battle")
                    cm:win_next_autoresolve_battle(h:name());
                    cm:modify_next_autoresolve_battle(0, 1, 20, 1, true);
                end
            end
        end
end)

dev.eh:add_listener(
    "CharacterCompletedBattle",
    "CharacterCompletedBattle",
    function(context)
        return true
    end,
    function(context)
        local char = context:character()
        dev.log("Faction: "..char:faction():name().." won battle: ["..tostring(context:character():won_battle()).."]!", "PB")
    end,
    true
)


return {
    is_rival = is_rival,
    new_rival = make_rival_faction
}