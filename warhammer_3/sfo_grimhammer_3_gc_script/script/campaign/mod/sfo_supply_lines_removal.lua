function upkeep_penalty_condition(faction)
	local culture = faction:culture();
	
	return faction:is_human() and faction:is_allowed_to_capture_territory() and culture ~= "wh_main_brt_bretonnia" and culture ~= "wh2_dlc09_tmb_tomb_kings";
end;

-- loop through the player's armys and apply
function apply_upkeep_penalty(faction)
	local difficulty = cm:model():combined_difficulty_level();
	
	local effect_bundle = cm:create_new_custom_effect_bundle("wh3_main_bundle_force_additional_army_upkeep");
	effect_bundle:set_duration(0);
	local upkeep_value = 0 -- easy

		if difficulty == 0 then
			upkeep_value = 0 -- normal
		elseif difficulty == -1 then
			upkeep_value = 0 -- hard
		elseif difficulty == -2 then
			upkeep_value = 0 -- very hard
		elseif difficulty == -3 then
			upkeep_value = 0 -- legendary
		end;
	
	if cm:model():campaign_name_key() == "wh3_main_chaos" then
		if difficulty == 0 then
			upkeep_value = 0 -- normal
		elseif difficulty == -1 then
			upkeep_value = 0 -- hard
		elseif difficulty == -2 then
			upkeep_value = 0 -- very hard
		elseif difficulty == -3 then
			upkeep_value = 0 -- legendary
		end;
	end;
	
	effect_bundle:add_effect("wh_main_effect_force_all_campaign_upkeep_hidden", "force_to_force_own_factionwide", upkeep_value);
	common.set_context_value("supply_lines_upkeep_value", upkeep_value)

	local mf_list = faction:military_force_list();
	local army_list = {};
	
	-- clone the military force list, excluding any garrisons and black arks
	for i = 0, mf_list:num_items() - 1 do
		local current_mf = mf_list:item_at(i);
		
		if not current_mf:is_armed_citizenry() and current_mf:has_general() and not current_mf:is_set_piece_battle_army() then
			local character = current_mf:general_character();
			local force_type = current_mf:force_type():key();
			
			if not character:character_subtype("wh2_main_def_black_ark") and force_type ~= "DISCIPLE_ARMY" and force_type ~= "OGRE_CAMP" and force_type ~= "CARAVAN" then
				table.insert(army_list, current_mf);
			end;
		end;
	end;
	
	-- if there is more than one army, apply the effect bundle to the second army onwards
	if #army_list > 1000 then
		for i = 1000, #army_list do
			local current_mf = army_list[i];
			
			if not current_mf:has_effect_bundle(effect_bundle:key()) then
				cm:apply_custom_effect_bundle_to_characters_force(effect_bundle, army_list[i]:general_character());
			end;
		end;
	end;
end;