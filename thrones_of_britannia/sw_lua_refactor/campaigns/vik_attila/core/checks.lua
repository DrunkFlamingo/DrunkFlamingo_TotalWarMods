--v function(t: any)
local function log(t)
    dev.log(tostring(t), "Check")
end

--HELPERS
--could be moved
--what is the distance between two points?
--v function(ax: number, ay: number, bx: number, by: number) --> number
local function distance_2D(ax, ay, bx, by)
    return (((bx - ax) ^ 2 + (by - ay) ^ 2) ^ 0.5);
end;

local viking_sc = {
	vik_sub_cult_viking_gael = true,
	vik_sub_cult_anglo_viking = true
} --:map<string, boolean>
local raiders = {
	vik_fact_wicing = true,
	vik_fact_finngaill = true,
	vik_fact_nordmann = true,
	vik_fact_dubgaill = true,
	vik_fact_haeden = true
} --:map<string, boolean>
--CHECKS

--v [NO_CHECK] function(ca_object: any) --> boolean
local function check_not_null(ca_object)
    if not ca_object.is_null_interface then
        log("Call to check not null provided an object without the is_null_interface method!")
    end
        
    return not ca_object:is_null_interface()
end

--v function(faction: CA_FACTION) --> boolean
local function check_is_faction_human(faction)
    return faction:is_human()
end

--v function(faction: CA_FACTION) --> boolean
local function check_is_faction_at_war_with_viking_faction(faction)
	local factions_at_war_with = faction:factions_at_war_with()
	for i = 0, factions_at_war_with:num_items() - 1 do
		local current_faction = factions_at_war_with:item_at(i)
		if viking_sc[current_faction:subculture()] then
			return true
		end
	end
	return false
end

--v function(faction: CA_FACTION) --> boolean
local function check_is_faction_viking_faction(faction)
    return not not viking_sc[faction:subculture()]
end

--v function(faction: CA_FACTION) --> boolean
local function check_is_faction_raider_faction(faction)

    return not not raiders[faction:subculture()]
end

--v function(region: CA_REGION) --> boolean
local function check_is_region_low_public_order(region)
    return (region:squalor() - region:sanitation() > 0) 
end

--v function(char: CA_CHAR) --> boolean
local function check_is_char_near_church(char)
    local church_superchains = {
        "vik_abbey",
        "vik_church",
        "vik_monastery",
        "vik_nunnaminster",
        "vik_school_ros",
        "vik_scoan_abbey"
       --[[ "vik_st_brigit",
        "vik_st_ciaran",
        "vik_st_columbe",
        "vik_st_cuthbert",
        "vik_st_dewi",
        "vik_st_edmund",
        "vik_st_patraic",
        "vik_st_ringan",
        "vik_st_swithun" 
        we check for these using string.find to save time--]] 
    }
    local char_faction_regions = char:faction():region_list()
    local x, y = char:logical_position_x(), char:logical_position_y()
    if char_faction_regions:is_empty() then
        return false
    else
        for i = 0, char_faction_regions:num_items() - 1 do
            local current_region = char_faction_regions:item_at(i)
            local superchain = current_region:settlement():slot_list():item_at(0):building():superchain()
            local xb, yb = current_region:settlement():logical_position_x(), current_region:settlement():logical_position_y()
            if string.find(superchain, "_st_") then
                return (distance_2D(x, y, xb, yb) < 200)
            else
                for j = 1, #church_superchains do
                    if church_superchains[j] == superchain then
                        return (distance_2D(x, y, xb, yb) < 200)
                    end
                end
            end
        end
    end
    return false
end


--v function(char: CA_CHAR) --> boolean
local function check_is_char_from_viking_faction(char)
    
    return not not viking_sc[char:faction():subculture()]
end

--v function(character: CA_CHAR) --> (boolean, string)
local function check_does_char_have_household_guard(character)
	local faction_to_follower_trait = {
		["vik_fact_circenn"] = "vik_follower_champion_circenn",
		["vik_fact_west_seaxe"] = "vik_follower_champion_west_seaxe",
		["vik_fact_mierce"] = "vik_follower_champion_mierce",
		["vik_fact_mide"]  = "vik_follower_champion_mide",
		["vik_fact_east_engle"]  = "vik_follower_champion_east_engle",
		["vik_fact_northymbre"]  = "vik_follower_champion_northymbre",
		["vik_fact_strat_clut"]  = "vik_follower_champion_strat_clut",
		["vik_fact_gwined"]  = "vik_follower_champion_gwined",
		["vik_fact_dyflin"]  = "vik_follower_champion_dyflin",
		["vik_fact_sudreyar"]  = "vik_follower_champion_sudreyar",
		["vik_fact_northleode"]  = "vik_follower_champion",
		["vik_fact_caisil"]  = "vik_follower_champion",
		["nil"] = "vik_follower_champion"
	} --:map<string, string>

	local faction_name = character:faction():name()
	local skill_key = faction_to_follower_trait[faction_name]
	if skill_key == nil then
		skill_key = faction_to_follower_trait["nil"]
    end
	return character:has_skill(skill_key), skill_key
end

--v function(character: CA_CHAR) --> (boolean, string)
local function check_does_char_have_bard(character)
	local faction_to_follower_trait = {
		["vik_fact_circenn"] = "vik_follower_bard_circenn",
		["vik_fact_west_seaxe"] = "vik_follower_bard_west_seaxe",
		["vik_fact_mierce"] = "vik_follower_bard_mierce",
		["vik_fact_mide"]  = "vik_follower_bard_mide",
		["vik_fact_strat_clut"]  = "vik_follower_bard_strat_clut",
		["vik_fact_gwined"]  = "vik_follower_bard_gwined",
		["vik_fact_northleode"]  = "vik_follower_bard",
		["vik_fact_caisil"]  = "vik_follower_bard",
		["nil"] = "vik_follower_bard"
	} --:map<string, string>

	local faction_name = character:faction():name()
	local skill_key = faction_to_follower_trait[faction_name]
	if skill_key == nil then
		skill_key = faction_to_follower_trait["nil"]
	end
	return character:has_skill(skill_key), skill_key
end

--v function(character: CA_CHAR) --> (boolean, string)
local function check_does_char_have_scribe(character)
    local faction_to_follower_trait = {
		["vik_fact_circenn"] = "vik_follower_scribe_circenn",
		["vik_fact_west_seaxe"] = "vik_follower_scribe_west_seaxe",
		["vik_fact_mierce"] = "vik_follower_scribe_mierce",
		["vik_fact_mide"]  = "vik_follower_scribe_mide",
		["vik_fact_east_engle"]  = "vik_follower_scribe_east_engle",
		["vik_fact_northymbre"]  = "vik_follower_scribe_northymbre",
		["vik_fact_strat_clut"]  = "vik_follower_scribe_strat_clut",
		["vik_fact_gwined"]  = "vik_follower_scribe_gwined",
		["vik_fact_northleode"]  = "vik_follower_scribe",
		["vik_fact_caisil"]  = "vik_follower_scribe",
		["nil"] = "vik_follower_scribe"
	} --:map<string, string>

	local faction_name = character:faction():name()
	local skill_key = faction_to_follower_trait[faction_name]
	if skill_key == nil then
		skill_key = faction_to_follower_trait["nil"]
	end
	
	return character:has_skill(skill_key), skill_key
end

--v function(character: CA_CHAR) --> (boolean, string)
local function check_does_char_have_skald(character)
    local faction_to_follower_trait = {
		["vik_fact_east_engle"]  = "vik_follower_bard_east_engle",
		["vik_fact_northymbre"]  = "vik_follower_bard_northymbre",
		["vik_fact_dyflin"]  = "vik_follower_bard_dyflin",
		["vik_fact_sudreyar"]  = "vik_follower_bard_sudreyar",
	} --:map<string, string>

	local faction_name = character:faction():name()
	local skill_key = faction_to_follower_trait[faction_name]
	if skill_key == nil then
		return false, nil
	end
	return character:has_skill(skill_key), skill_key
end

--v function(character: CA_CHAR) --> (boolean, string)
local function check_does_char_have_gothi(character)
    local faction_to_follower_trait = {
		["vik_fact_east_engle"]  = "vik_follower_quartermaster_east_engle",
		["vik_fact_northymbre"]  = "vik_follower_quartermaster_northymbre",
		["vik_fact_dyflin"]  = "vik_follower_scribe_dyflin",
		["vik_fact_sudreyar"]  = "vik_follower_scribe_sudreyar",
	} --:map<string, string>

	local faction_name = character:faction():name()
	local skill_key = faction_to_follower_trait[faction_name]
	if skill_key == nil then
		return false, nil
	end
	return character:has_skill(skill_key), skill_key
end

--v function(character: CA_CHAR) --> (boolean, string)
local function check_does_char_have_quartermaster(character)
	local faction_to_follower_trait = {
		["vik_fact_circenn"] = "vik_follower_quartermaster_circenn",
		["vik_fact_west_seaxe"] = "vik_follower_quartermaster_west_seaxe",
		["vik_fact_mierce"] = "vik_follower_quartermaster_mierce",
		["vik_fact_mide"]  = "vik_follower_quartermaster_mide",
		["vik_fact_strat_clut"]  = "vik_follower_quartermaster_strat_clut",
		["vik_fact_gwined"]  = "vik_follower_quartermaster_gwined",
		["vik_fact_dyflin"]  = "vik_follower_quartermaster_dyflin",
		["vik_fact_sudreyar"]  = "vik_follower_quartermaster_sudreyar",
		["vik_fact_northleode"]  = "vik_follower_quartermaster",
		["vik_fact_caisil"]  = "vik_follower_quartermaster",
		["nil"] = "vik_follower_quartermaster"
	} --:map<string, string>

	local faction_name = character:faction():name()
	local skill_key = faction_to_follower_trait[faction_name]
	if skill_key == nil then
		skill_key = faction_to_follower_trait["nil"]
	end
	return character:has_skill(skill_key), skill_key
end

--v function(character: CA_CHAR) --> (boolean, string)
local function check_does_char_have_viking_captain(character)
	local faction_to_follower_trait = {
		["vik_fact_sudreyar"]  = "vik_follower_siege_engineer_sudreyar",
	} --:map<string, string>

	local faction_name = character:faction():name()
	local skill_key = faction_to_follower_trait[faction_name]
	if skill_key == nil then
		return false, nil
	end
	return character:has_skill(skill_key), skill_key
end

--v function(character: CA_CHAR) --> (boolean, string)
local function check_does_char_have_select_fyrd_captain(character)
	local faction_to_follower_trait = {
		["vik_fact_west_seaxe"]  = "vik_follower_siege_engineer_west_seaxe",

	} --:map<string, string>

	local faction_name = character:faction():name()
	local skill_key = faction_to_follower_trait[faction_name]
	if skill_key == nil then
		return false, nil
	end
	return character:has_skill(skill_key), skill_key
end

--v function(character: CA_CHAR) --> (boolean, string)
local function check_does_char_have_marcher_veteran(character)
	local faction_to_follower_trait = {
		["vik_fact_mierce"]  = "vik_follower_siege_engineer_mierce",

	} --:map<string, string>

	local faction_name = character:faction():name()
	local skill_key = faction_to_follower_trait[faction_name]
	if skill_key == nil then
		return false, nil
	end
	return character:has_skill(skill_key), skill_key
end


--v function(character: CA_CHAR) --> (boolean, string)
local function check_does_char_have_henchmen(character)
	local faction_to_follower_trait = {
		["vik_fact_circenn"] = "vik_follower_pillager_circenn",
		["vik_fact_west_seaxe"] = "vik_follower_pillager_west_seaxe",
		["vik_fact_mierce"] = "vik_follower_pillager_mierce",
		["vik_fact_mide"]  = "vik_follower_pillager_mide",
		["vik_fact_east_engle"]  = "vik_follower_pillager_east_engle",
		["vik_fact_northymbre"]  = "vik_follower_pillager_northymbre",
		["vik_fact_strat_clut"]  = "vik_follower_pillager_strat_clut",
		["vik_fact_gwined"]  = "vik_follower_pillager_gwined",
		["vik_fact_dyflin"]  = "vik_follower_pillager_dyflin",
		["vik_fact_sudreyar"]  = "vik_follower_pillager_sudreyar",
		["vik_fact_northleode"]  = "vik_follower_pillager",
		["vik_fact_caisil"]  = "vik_follower_pillager",
		["nil"] = "vik_follower_pillager"
	} --:map<string, string>

	local faction_name = character:faction():name()
	local skill_key = faction_to_follower_trait[faction_name]
	if skill_key == nil then
		skill_key = faction_to_follower_trait["nil"]
	end
	return character:has_skill(skill_key), skill_key
end


--v function(character: CA_CHAR) --> (boolean, string)
local function check_does_char_have_smith(character)
    local faction_to_follower_trait = {
		["vik_fact_circenn"] = "vik_follower_forager_circenn",
		["vik_fact_west_seaxe"] = "vik_follower_forager_west_seaxe",
		["vik_fact_mierce"] = "vik_follower_forager_mierce",
		["vik_fact_mide"]  = "vik_follower_forager_mide",
		["vik_fact_east_engle"]  = "vik_follower_forager_east_engle",
		["vik_fact_northymbre"]  = "vik_follower_forager_northymbre",
		["vik_fact_strat_clut"]  = "vik_follower_forager_strat_clut",
		["vik_fact_gwined"]  = "vik_follower_forager_gwined",
		["vik_fact_dyflin"]  = "vik_follower_forager_dyflin",
		["vik_fact_sudreyar"]  = "vik_follower_forager_sudreyar",
		["vik_fact_northleode"]  = "vik_follower_forager_northleode",
		--["vik_fact_caisil"]  = "vik_follower_priest",
		["nil"] = "vik_follower_forager"
	} --:map<string, string>

	local faction_name = character:faction():name()
	local skill_key = faction_to_follower_trait[faction_name]
	if skill_key == nil then
		skill_key = faction_to_follower_trait["nil"]
	end
	return character:has_skill(skill_key), skill_key
end


--v function(character: CA_CHAR) --> (boolean, string)
local function check_does_char_have_priest(character)
    local faction_to_follower_trait = {
		["vik_fact_circenn"] = "vik_follower_priest_circenn",
		["vik_fact_west_seaxe"] = "vik_follower_priest_west_seaxe",
		["vik_fact_mierce"] = "vik_follower_priest_mierce",
		["vik_fact_mide"]  = "vik_follower_priest_mide",
		["vik_fact_east_engle"]  = "vik_follower_priest_east_engle",
		["vik_fact_northymbre"]  = "vik_follower_priest_northymbre",
		["vik_fact_strat_clut"]  = "vik_follower_priest_strat_clut",
		["vik_fact_gwined"]  = "vik_follower_priest_gwined",
		["vik_fact_dyflin"]  = "vik_follower_priest_dyflin",
		["vik_fact_sudreyar"]  = "vik_follower_priest_sudreyar",
		["vik_fact_northleode"]  = "vik_follower_priest",
		["vik_fact_caisil"]  = "vik_follower_priest",
		["nil"] = "vik_follower_priest"
	} --:map<string, string>

	local faction_name = character:faction():name()
	local skill_key = faction_to_follower_trait[faction_name]
	if skill_key == nil then
		skill_key = faction_to_follower_trait["nil"]
	end
	return character:has_skill(skill_key), skill_key
end

--v function(character: CA_CHAR) --> (boolean, string)
local function check_does_char_have_sailor(character)
    local faction_to_follower_trait = {
		["vik_fact_dyflin"]  = "vik_follower_siege_engineer_dyflin",
		["vik_fact_sudreyar"]  = "vik_follower_siege_engineer_sudreyar",
	} --:map<string, string>

	local faction_name = character:faction():name()
	local skill_key = faction_to_follower_trait[faction_name]
	if skill_key == nil then
		return false, nil
	end
	return character:has_skill(skill_key), skill_key
end

--v function(character: CA_CHAR) --> (boolean, string)
local function check_does_char_have_champion(character)
    local faction_to_follower_trait = {
		["vik_fact_strat_clut"]  = "vik_follower_siege_engineer_strat_clut",
		["vik_fact_gwined"]  = "vik_follower_siege_engineer_gwined",
	} --:map<string, string>

	local faction_name = character:faction():name()
	local skill_key = faction_to_follower_trait[faction_name]
	if skill_key == nil then
		return false, nil
	end
	return character:has_skill(skill_key), skill_key
end

--v function(faction: CA_FACTION) --> boolean
local function check_is_faction_player_ally(faction)
    local players = cm:get_human_factions()
    local result = false;
    for i,value in pairs(players) do
        if (result == false) and (dev.get_faction(value):allied_with(faction)==true) then
            result = true;
        end
    end
    
    return result;
end



return {
    not_null = check_not_null,
    --faction
    is_faction_human = check_is_faction_human,
	is_faction_viking_faction = check_is_faction_viking_faction,
	is_faction_raider_faction = check_is_faction_raider_faction,
	is_faction_player_ally = check_is_faction_player_ally,
	is_faction_at_war_with_viking_faction = check_is_faction_at_war_with_viking_faction,
    --region
    is_region_low_public_order = check_is_region_low_public_order,
    --characters
    is_char_from_viking_faction = check_is_char_from_viking_faction,
    is_char_near_church = check_is_char_near_church,
    does_char_have_household_guard = check_does_char_have_household_guard,
    does_char_have_champion = check_does_char_have_champion,
    does_char_have_scribe = check_does_char_have_scribe,
	does_char_have_henchmen = check_does_char_have_henchmen,
	does_char_have_quartermaster = check_does_char_have_quartermaster,
    does_char_have_bard  = check_does_char_have_bard,
	does_char_have_skald = check_does_char_have_skald,
    does_char_have_priest = check_does_char_have_priest,
    does_char_have_gothi = check_does_char_have_gothi,
	does_char_have_viking_captain = check_does_char_have_viking_captain,
	does_char_have_smith = check_does_char_have_smith,
	does_char_have_marcher_veteran = check_does_char_have_marcher_veteran,
	does_char_have_select_fryd_captain = check_does_char_have_select_fyrd_captain
}