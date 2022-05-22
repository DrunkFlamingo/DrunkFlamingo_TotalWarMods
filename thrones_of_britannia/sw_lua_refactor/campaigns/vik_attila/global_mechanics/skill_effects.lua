--v function(t: any)
local function log(t) dev.log(tostring(t), "SKILLS") end
--household guard is handled by other mechanics.

local event_manager = dev.GameEvents
local check = dev.Check




local skill_events_post_battle = {
    {
        key = "sw_heroism_bard", 
        checks = {check.does_char_have_bard},
        levels = {1}, 
        condition = function(context) --:WHATEVER
            return context:character():faction():is_human() and dev.chance(50) and not not PettyKingdoms.FactionResource.get("vik_heroism", context:character():faction())
        end, 
        callback = function(context) --:WHATEVER
            PettyKingdoms.FactionResource.get("vik_heroism", context:character():faction()):change_value(2, "factor_follower_events_heroism")  
        end,
        cooldown = 3
    },
    {
        key = "sw_heroism_bard_2", 
        checks = {check.does_char_have_bard},
        levels = {1}, 
        condition = function(context) --:WHATEVER
            return context:character():faction():is_human() and dev.chance(30) and not not PettyKingdoms.FactionResource.get("vik_heroism", context:character():faction())
        end, 
        callback = function(context) --:WHATEVER
            PettyKingdoms.FactionResource.get("vik_heroism", context:character():faction()):change_value(3, "factor_follower_events_heroism")  
        end,
        cooldown = 3
    },
    {
        key = "sw_heroism_bard_3", 
        checks = {check.does_char_have_bard},
        levels = {1}, 
        condition = function(context) --:WHATEVER
            return context:character():faction():is_human() and dev.chance(20) and not not PettyKingdoms.FactionResource.get("vik_heroism", context:character():faction())
        end, 
        callback = function(context) --:WHATEVER
            PettyKingdoms.FactionResource.get("vik_heroism", context:character():faction()):change_value(5, "factor_follower_events_heroism") 
        end,
        cooldown = 3
    },
    {
        key = "sw_fame_bard", 
        checks = {check.does_char_have_bard},
        levels = {1}, 
        condition = function(context) --:WHATEVER
            return context:character():faction():is_human() and dev.chance(50)
        end, 
        callback = function(context) --:WHATEVER
            local character = context:character() --:CA_CHAR
            local pol_char = PettyKingdoms.CharacterPolitics.get(character:command_queue_index())
            pol_char:increase_personal_fame()
        end,
        cooldown = 3
    }
}--:vector<{key: string, checks: vector<(function(CA_CHAR) --> (boolean, string))>, levels:vector<int>, condition: function(context: WHATEVER) --> boolean, callback: function(context: WHATEVER), cooldown: int?}>

local character_retreats = {} --:map<CA_CQI, int>
dev.Save.attach_to_table(character_retreats, "skils_character_retreats")
local skill_events_post_retreat = {
    {
        key = "sw_bard_retreat", 
        checks = {check.does_char_have_bard},
        levels = {1}, 
        condition = function(context) --:WHATEVER
            local character = context:character()--:CA_CHAR
            if not character_retreats[character:command_queue_index()] then
                character_retreats[character:command_queue_index()] = 0 
                return false
            end
            character_retreats[character:command_queue_index()] = character_retreats[character:command_queue_index()] + 1
            return dev.chance(character_retreats[character:command_queue_index()] * 10)
        end, 
        callback = function(context) --:WHATEVER
    
        end,
        cooldown = 250
    },
    {
        
        key = "sw_skald_retreat", 
        checks = {check.does_char_have_skald},
        levels = {1}, 
        condition = function(context) --:WHATEVER
            local character = context:character()--:CA_CHAR
            if not character_retreats[character:command_queue_index()] then
                character_retreats[character:command_queue_index()] = 0 
                return false
            end
            character_retreats[character:command_queue_index()] = character_retreats[character:command_queue_index()] + 1
            return dev.chance(character_retreats[character:command_queue_index()] * 10)
        end, 
        callback = function(context) --:WHATEVER
    
        end,
        cooldown = 250
    }
}--:vector<{key: string, checks: vector<(function(CA_CHAR) --> (boolean, string))>, levels:vector<int>, condition: function(context: WHATEVER) --> boolean, callback: function(context: WHATEVER), cooldown: int?}>



local skill_events_character_turn_start = {
    {
        key = "sw_drill_marcher", 
        checks = {check.does_char_have_henchmen},
        levels = {1}, 
        condition = function(context) --:WHATEVER
            local character = context:character() --:CA_CHAR
            local region = character:region() --:CA_REGION
            local force = character:military_force()
            if region:is_null_interface() or force:is_null_interface() then
                return false
            end
            local character_is_encamped = force:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP" 
            local has_fyrd = force:unit_list():has_unit("eng_fyrd_spearmen") or force:unit_list():has_unit("eng_fyrd_archers")
            local character_faction_has_techs = character:faction():has_technology("vik_mil_melee_2a") or character:faction():has_technology("vik_mil_missile_4")
            return character_is_encamped and has_fyrd and character_faction_has_techs 
        end, 
        callback = function(context) --:WHATEVER

        end,
        cooldown = 9
    },
    {
        key = "sw_drill_select_fyrd", 
        checks = {check.does_char_have_henchmen},
        levels = {1}, 
        condition = function(context) --:WHATEVER
            local character = context:character() --:CA_CHAR
            local region = character:region() --:CA_REGION
            local force = character:military_force()
            if region:is_null_interface() or force:is_null_interface() then
                return false
            end
            local character_is_encamped = force:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP" 
            local has_fyrd = force:unit_list():has_unit("eng_fyrd_spearmen") or force:unit_list():has_unit("eng_fyrd_archers")
            local character_faction_has_techs = character:faction():has_technology("vik_mil_melee_2a") or character:faction():has_technology("vik_mil_missile_4")
            return character_is_encamped and has_fyrd and character_faction_has_techs 
        end, 
        callback = function(context) --:WHATEVER

        end,
        cooldown = 9
    },
    {
        key = "sw_renown_captain_recruited", 
        checks = {check.does_char_have_viking_captain},
        levels = {1}, 
        condition = function(context) --:WHATEVER
            local char = context:character() --:CA_CHAR
            return (not char:region():is_null_interface()) and FOREIGN_WARRIORS.provinces_with_foreigners[char:region():name()]
        end, 
        callback = function(context) --:WHATEVER

        end,
        cooldown = 10
    },
    {
        key = "sw_renown_sailors_recruited", 
        checks = {check.does_char_have_viking_captain},
        levels = {1}, 
        condition = function(context) --:WHATEVER
            local char = context:character() --:CA_CHAR
            return (not char:region():is_null_interface()) and FOREIGN_WARRIORS.provinces_with_foreigners[char:region():name()]
        end, 
        callback = function(context) --:WHATEVER

        end,
        cooldown = 10
    },
    {
        key = "sw_renown_vikings_recruited", 
        checks = {check.does_char_have_viking_captain},
        levels = {1}, 
        condition = function(context) --:WHATEVER
            local char = context:character() --:CA_CHAR
            return (not char:region():is_null_interface()) and FOREIGN_WARRIORS.provinces_with_foreigners[char:region():name()]
        end, 
        callback = function(context) --:WHATEVER

        end,
        cooldown = 10
    },
    {
        key = "sw_skills_henchmen_1", 
        checks = {check.does_char_have_henchmen},
        levels = {1}, 
        condition = function(context) --:WHATEVER
            local character = context:character() --:CA_CHAR
            local region = character:region() --:CA_REGION
            local force = character:military_force()
            if region:is_null_interface() or force:is_null_interface() then
                return false
            end
            local character_is_raiding = force:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" and region:owning_faction():name() ~= character:faction():name()
            local has_slaves = not not  PettyKingdoms.FactionResource.get("vik_dyflin_slaves", character:faction())
            return character_is_raiding and has_slaves 
        end, 
        callback = function(context) --:WHATEVER
            local character = context:character() --:CA_CHAR
            local region = character:region() --:CA_REGION
            if region:is_null_interface() then
                return --this happens when using the testing variable sometimes since the result of the condition is ignored.
            end
            local slaves =  PettyKingdoms.FactionResource.get("vik_dyflin_slaves", character:faction())
            slaves:change_value(100) 
            --TODO Slaves factors
        end,
        cooldown = 3
    },
    {
        key = "sw_skills_henchmen_2", 
        checks = {check.does_char_have_henchmen},
        levels = {1}, 
        condition = function(context) --:WHATEVER
            local character = context:character() --:CA_CHAR
            local region = character:region() --:CA_REGION
            local force = character:military_force()
            if region:is_null_interface() or force:is_null_interface() then
                return false
            end
            local character_is_raiding = force:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" and region:owning_faction():name() ~= character:faction():name()
            return character_is_raiding 
        end, 
        callback = function(context) --:WHATEVER

        end,
        cooldown = 3
    },
    {
        key = "sw_skills_henchmen_3", 
        checks = {check.does_char_have_henchmen},
        levels = {1}, 
        condition = function(context) --:WHATEVER
            local character = context:character() --:CA_CHAR
            local region = character:region() --:CA_REGION
            local force = character:military_force()
            if region:is_null_interface() or force:is_null_interface() then
                return false
            end
            local character_is_raiding = force:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" and region:owning_faction():name() ~= character:faction():name()
            local is_irish = character:faction():subculture() == "vik_sub_cult_irish"
            return character_is_raiding and is_irish and region:building_superchain_exists("vik_pasture")
        end, 
        callback = function(context) --:WHATEVER

        end,
        cooldown = 3
    },
    {
        key = "sw_skills_henchmen_4", 
        checks = {check.does_char_have_henchmen},
        levels = {1}, 
        condition = function(context) --:WHATEVER
            local character = context:character() --:CA_CHAR
            local region = character:region() --:CA_REGION
            local force = character:military_force()
            if region:is_null_interface() or force:is_null_interface() then
                return false
            end
            local mp_region = PettyKingdoms.RegionManpower.get(region:name())
            local character_is_raiding = force:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" and region:owning_faction():name() ~= character:faction():name()
            local not_trait = not character:has_trait("shield_faithful_friend_of_the_church")
            return character_is_raiding and not_trait and (mp_region.monk_pop and mp_region.monk_pop > 0)
        end, 
        callback = function(context) --:WHATEVER
            local character = context:character() --:CA_CHAR
            local region = character:region() --:CA_REGION
            if region:is_null_interface() then
                return --this happens when using the testing variable sometimes since the result of the condition is ignored.
            end
            local loss = dev.clamp(PettyKingdoms.RegionManpower.get(region:name()).monk_pop * -1, -40, 0)
            PettyKingdoms.RegionManpower.get(region:name()):mod_monks(dev.mround(loss, 1), true, "monk_riots")
        end,
        cooldown = 3
    }
}--:vector<{key: string, checks: vector<(function(CA_CHAR) --> (boolean, string))>, levels:vector<int>, condition: function(context: WHATEVER) --> boolean, callback: function(context: WHATEVER), cooldown: int?}>



 


--v function(char: CA_CHAR, required_skill_checks: vector<(function(CA_CHAR) --> (boolean, string))>,required_not_skills: vector<(function(CA_CHAR) --> (boolean, string))>?) --> boolean
function has_required_skills(char, required_skill_checks, required_not_skills)
    local retval = true --:boolean
    for i = 1, #required_skill_checks do
        if required_skill_checks[i](char) == false then
            retval = false
        end
    end
    if required_not_skills then
        --# assume required_not_skills: vector<(function(CA_CHAR) --> boolean)>
        for i = 1, #required_not_skills do
            if required_not_skills[i](char) then
                retval = false
            end
        end
    end
    --log("Skill Effect Check on ["..tostring(char:command_queue_index()).."] for "..name.." resulted in: "..tostring(retval))
    return retval
end

--v function(name: string, required_skill_checks: vector<(function(CA_CHAR) --> (boolean, string))>, callback: function(context: WHATEVER), required_not_skills: vector<(function(CA_CHAR) --> (boolean, string))>?)
local function add_skill_effect_callback(name, required_skill_checks, callback, required_not_skills) 
    dev.eh:add_listener(
        "SkillEffectsCharTurnStart",
        "CharacterTurnStart",
        function(context) 
            local char = context:character() --:CA_CHAR
            if not char:faction():is_human() then return false end
            return has_required_skills(char, required_skill_checks, required_not_skills)
        end,
        function(context)
            callback(context)
        end,
        true)

end

----------------------------
--Henchmen Rewards Raiding--
----------------------------
--TODO henchmen rewards
dev.first_tick(function(context) 
    



end)





--on turn start, if we have a blacksmith and we don't have a blacksmith item yet, give us a dilemma to get one.




local blessings = {} --:map<string, {string, int, int, string?}>
dev.Save.attach_to_table(blessings, "skills_blessings")
--v function(char: CA_CHAR, bundle: string, turn_to_apply: int, last_bundle: int, region: string?)
local function set_blessing_entry(char, bundle, turn_to_apply, last_bundle, region)
    blessings[tostring(char:command_queue_index())] = {bundle, turn_to_apply, last_bundle, region}
end


local gothi_bundle = "sw_gothi_"
local priest_bundle = "sw_priest_"
local gov_suffix = "_gov"
local num_bundles = 3
local change_turns = 9

--v function(prefix: string, entry: {string, int, int, string?}) --> (string, int)
local function get_next_bundle(prefix, entry)
    local last_a = entry[3]
    local new_a = cm:random_number(num_bundles) 
    if new_a == last_a then new_a = new_a + 1 end if new_a > num_bundles then new_a = 1 end
    return prefix..new_a, new_a
end




----------------------------
--Bard Rewards Postbattle--
----------------------------

local character_event_last_happened = {} --:map<CA_CQI, number>
dev.Save.attach_to_table(character_event_last_happened, "skills_character_event_last_happened")

dev.first_tick(function(context) 

    local PostBattleSkillEvents = event_manager:create_new_condition_group("SkillEventsPostBattle")
    PostBattleSkillEvents:set_number_allowed_in_queue(1)
    event_manager:register_condition_group(PostBattleSkillEvents, "ShieldwallCharacterCompletedBattle")

    for i = 1, #skill_events_post_battle do
        local event_info = skill_events_post_battle[i]
        local event = event_manager:create_event(event_info.key, "incident", "standard")
        if CONST.__testcases.__test_skill_events then
            event:set_cooldown(#skill_events_post_battle)
        end
        event:add_queue_time_condition(function(context)
            local character = context:character() --:CA_CHAR
            local pol_char = PettyKingdoms.CharacterPolitics.get(character:command_queue_index())
            local passed_checks = true
            local last = character_event_last_happened[character:command_queue_index()] or 0
            if (not CONST.__testcases.__test_skill_events) and (dev.turn() <= last + (event_info.cooldown or 0)) then
                return false
            end
            if not character:won_battle() then
                return false
            end
            for j = 1, #event_info.checks do 
                local passed, skill_key = event_info.checks[j](character)
                if (not passed) or pol_char:get_skill_points(skill_key) < event_info.levels[j] then 
                    passed_checks = false
                end
            end
            if CONST.__testcases.__test_skill_events then
                local cond = event_info.condition(context)
                log("Skill events test: ["..event_info.key.."] passed checks: ["..tostring(passed_checks).."], condition returned ["..tostring(cond).."]")
                return true
            end
            return passed_checks and event_info.condition(context)
        end)
        event:add_callback(function(context)
            local character = context:character() --:CA_CHAR
            character_event_last_happened[character:command_queue_index()] = dev.turn()
            event_info.callback(context)
        end)
        event:join_groups("SkillEventsPostBattle")
    end

    local RetreatSkillEvents = event_manager:create_new_condition_group("SkillEventsRetreat")
    RetreatSkillEvents:set_number_allowed_in_queue(1)
    event_manager:register_condition_group(RetreatSkillEvents, "CharacterRetreatedFromBattle")
    for i = 1, #skill_events_post_retreat do
        local event_info = skill_events_post_retreat[i]
        local event = event_manager:create_event(event_info.key, "incident", "standard")

        event:set_cooldown(event_info.cooldown or 0)
        
        event:add_queue_time_condition(function(context)
            local character = context:character() --:CA_CHAR
            local pol_char = PettyKingdoms.CharacterPolitics.get(character:command_queue_index())
            local last = character_event_last_happened[character:command_queue_index()] or 0
            local passed_checks = true
            for j = 1, #event_info.checks do 
                local passed, skill_key = event_info.checks[j](character)
                log("SkillEventsRetreat check for event ["..event_info.key.."] number ["..j.."] returned ["..tostring(passed).."] and ["..tostring(skill_key).."] ")
                if (not passed) or pol_char:get_skill_points(skill_key) < event_info.levels[j] then 
                    passed_checks = false
                end
            end
            if CONST.__testcases.__test_skill_events then
                local cond = event_info.condition(context)
                log("Skill events test: ["..event_info.key.."] passed checks: ["..tostring(passed_checks).."], condition returned ["..tostring(cond).."]")
                return true
            end
            return passed_checks and event_info.condition(context)
        end)
        event:add_callback(function(context)
            local character = context:character() --:CA_CHAR
            character_event_last_happened[character:command_queue_index()] = dev.turn()
            event_info.callback(context)
        end)
        event:join_groups("SkillEventsRetreat")
    end


    local TurnStartSkillEvents = event_manager:create_new_condition_group("SkillEventsTurnstart")
    TurnStartSkillEvents:set_number_allowed_in_queue(1)
    event_manager:register_condition_group(TurnStartSkillEvents, "CharacterTurnStart")
    for i = 1, #skill_events_character_turn_start do
        local event_info = skill_events_character_turn_start[i]
        local event = event_manager:create_event(event_info.key, "incident", "standard")
        if CONST.__testcases.__test_skill_events then
            event:set_cooldown(#skill_events_character_turn_start)
        end
        event:add_queue_time_condition(function(context)
            local character = context:character() --:CA_CHAR
            local pol_char = PettyKingdoms.CharacterPolitics.get(character:command_queue_index())
            local last = character_event_last_happened[character:command_queue_index()] or 0
            local passed_checks = true
            if (not CONST.__testcases.__test_skill_events) and (dev.turn() <= last + (event_info.cooldown or 0)) then
                return false
            end
            for j = 1, #event_info.checks do 
                local passed, skill_key = event_info.checks[j](character)
                if (not passed) or pol_char:get_skill_points(skill_key) < event_info.levels[j] then 
                    passed_checks = false
                end
            end
            if CONST.__testcases.__test_skill_events then
                local cond = event_info.condition(context)
                log("Skill events test: ["..event_info.key.."] passed checks: ["..tostring(passed_checks).."], condition returned ["..tostring(cond).."]")
                return true
            end
            return passed_checks and event_info.condition(context)
        end)
        event:add_callback(function(context)
            local character = context:character() --:CA_CHAR
            character_event_last_happened[character:command_queue_index()] = dev.turn()
            event_info.callback(context)
        end)
        event:join_groups("SkillEventsTurnstart")
    end



    ------------------------------
    --Gothi and Priest Blessings--
    ------------------------------


    add_skill_effect_callback(gothi_bundle, {dev.Check.does_char_have_gothi}, function(context)
        local char = context:character() --:CA_CHAR
        local turn = cm:model():turn_number()
        local entry = blessings[tostring(char:command_queue_index())] or {"", 0, 0}
        local should_check_gov = not not entry[4]
        --if we have an unexpired bundle on a governor, delete it.
        if entry[2] > turn and should_check_gov then
            local region = dev.get_region(entry[4])
            if (not region:has_governor()) or region:governor():command_queue_index() ~= char:command_queue_index() then
                cm:remove_effect_bundle_from_region(entry[1], entry[4])
                entry[4] = nil
                entry[2] = turn
            end
        end
        --if we don't have a bundle out, put one out!
        if entry[2] <= turn then
            local bundle, bnum = get_next_bundle(gothi_bundle, entry)
            local pols_char = PettyKingdoms.CharacterPolitics.get(char:command_queue_index())
            local region = nil --:string
            if not pols_char then
                --# assume pols_char:WHATEVER
                pols_char = {last_governorship = "vik_gov_province_"}
            end
            local governorship = string.gsub(pols_char.last_governorship, "vik_gov_province_", "vik_prov_")
            local gov_region = Gamedata.regions.get_capital_with_province_key(governorship)
            if gov_region then
                region = gov_region:name()
                bundle = bundle .. gov_suffix
                cm:apply_effect_bundle_to_region(bundle, region, change_turns)
            elseif char:has_military_force() then
                cm:apply_effect_bundle_to_characters_force(bundle, char:command_queue_index(), 0, true)
            end
            set_blessing_entry(char, bundle, turn + change_turns, bnum)
        end
    end, {dev.Check.does_char_have_priest})
    add_skill_effect_callback(priest_bundle, {dev.Check.does_char_have_priest}, function(context)
        local char = context:character() --:CA_CHAR
        local turn = cm:model():turn_number()
        local entry = blessings[tostring(char:command_queue_index())] or {"", 0, 0}
        local should_check_gov = not not entry[4]
        --if we have an unexpired bundle on a governor, delete it.
        if entry[2] > turn and should_check_gov then
            local region = dev.get_region(entry[4])
            if (not region:has_governor()) or region:governor():command_queue_index() ~= char:command_queue_index() then
                cm:remove_effect_bundle_from_region(entry[1], entry[4])
                entry[4] = nil
                entry[2] = turn
            end
        end
        --if we don't have a bundle out, put one out!
        if entry[2] <= turn then
            local bundle, bnum = get_next_bundle(priest_bundle, entry)
            local pols_char = PettyKingdoms.CharacterPolitics.get(char:command_queue_index())
            local region = nil --:string
            if not pols_char then
                --# assume pols_char:WHATEVER
                pols_char = {last_governorship = "vik_gov_province_"}
            end
            local governorship = string.gsub(pols_char.last_governorship, "vik_gov_province_", "vik_prov_")
            local gov_region = Gamedata.regions.get_capital_with_province_key(governorship)
            if gov_region then
                region = gov_region:name()
                bundle = bundle .. gov_suffix
                cm:apply_effect_bundle_to_region(bundle, region, change_turns)
            else
                cm:apply_effect_bundle_to_characters_force(bundle, char:command_queue_index(), change_turns, true)
            end
            set_blessing_entry(char, bundle, turn + change_turns, bnum)
        end
    end, {dev.Check.does_char_have_gothi})

end)

