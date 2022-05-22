-------------------------------------------------------------------------------
--------------------------------- AI Personalities ---------------------------
-------------------------------------------------------------------------------
------------------------- Created by Craig: 23/03/2017 ------------------
------------------------- Last Updated: 08/03/2018 by Laura ------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- Assigns the specified personalities to the CAI factions at the start of a new campaign.
-- Additional factions can be added to the list using cm:force_change_cai_faction_personality("faction_key", "cai_personalities/key")

personalities_initialised = false --:boolean

--v function(context: WHATEVER)
function new_campaign_cai_personalities(context)
	if personalities_initialised == false then
	
		output("Setting CAI personalities");
		
		-- Work out a difficulty setting for the initial personalities to use.
		local difficulty = cm:model():difficulty_level();
		local difficulty_mod = "";
		if difficulty == 1 then -- Easy
			difficulty_mod = "_easy"
		elseif difficulty == 0 then -- Normal
			difficulty_mod = ""
		elseif difficulty == -1 then -- Hard
			difficulty_mod = "_hard"
		elseif difficulty == -2 then -- Very Hard
			difficulty_mod = "_very_hard"
		elseif difficulty == -3 then -- Legendary
			difficulty_mod = "_very_hard"
		end
		
		--Setup the CAI personalities
		cm:force_change_cai_faction_personality("vik_fact_west_seaxe", "vik_aggressive_settler_considerate"..difficulty_mod); -- Westsexa's starting personality
		cm:force_change_cai_faction_personality("vik_fact_mierce", "vik_aggressive_raider_settler_opportunist_long"..difficulty_mod); -- Miercna's starting personality
		cm:force_change_cai_faction_personality("vik_fact_gwined", "vik_aggressive_reliable_anti_english"..difficulty_mod); -- Gwined's starting personality
		cm:force_change_cai_faction_personality("vik_fact_strat_clut", "vik_aggressive_considerate"..difficulty_mod); -- Strat Clut's starting personality
		cm:force_change_cai_faction_personality("vik_fact_mide", "vik_diplomatic_reliable_long"..difficulty_mod); -- Midhe's starting personality
		cm:force_change_cai_faction_personality("vik_fact_circenn", "vik_defensive_reliable_anti_eastmen"..difficulty_mod); -- Scoan's starting personality
		cm:force_change_cai_faction_personality("vik_fact_dyflin", "vik_aggressive_sacker_melodramatic_short"..difficulty_mod); -- Dyflin's starting personality
		cm:force_change_cai_faction_personality("vik_fact_sudreyar", "vik_aggressive_reliable"..difficulty_mod); -- Sudreyar' starting personality
		cm:force_change_cai_faction_personality("vik_fact_northymbre", "vik_aggressive_raiding_unreliable"..difficulty_mod); -- Northymbra's starting personality
		cm:force_change_cai_faction_personality("vik_fact_east_engle", "vik_aggressive_raiding_opportunist"..difficulty_mod); -- East Angla's starting personality
		
		---------------------------------------------------------------------
		-- non-playables --
		
		-- -- VIKING SEA KINGS
		cm:force_change_cai_faction_personality("vik_fact_vedrafjordr", "vik_aggressive_sacker_greedy"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_veisafjordr", "vik_aggressive_greedy_settler"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_hlymrekr", "vik_aggressive_unreliable_greedy_anti_irish"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_myrrborg", "vik_aggressive_sacker_opportunist"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_gallgoidel", "vik_aggressive_short"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_orkneyar", "vik_aggressive_settler"..difficulty_mod); -- minor faction starting personalities
		
		-- -- IRISH
		cm:force_change_cai_faction_personality("vik_fact_aileach", "vik_aggressive_reliable"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_airgialla", "vik_aggressive_greedy_settler_short"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_ulaid", "vik_aggressive_long"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_brega", "vik_aggressive_greedy_long"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_breifne", "vik_aggressive_melodramatic"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_connacht", "vik_diplomatic_loyal_settler"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_osraige", "vik_diplomatic_long"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_laigin", "vik_aggressive_greedy"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_caisil", "vik_aggressive_anti_eastmen"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_tuadmuma", "vik_aggressive_considerate"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_desmuma", "vik_diplomatic_considerate"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_iarmuma", "vik_diplomatic"..difficulty_mod); -- minor faction starting personalities
		
		-- -- SCOTTISH
		cm:force_change_cai_faction_personality("vik_fact_fortriu", "vik_aggressive_raiding_coward"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_athfochla", "vik_aggressive_unreliable"..difficulty_mod); -- minor faction starting personalities
		
		-- -- GREAT VIKING ARMY
		cm:force_change_cai_faction_personality("vik_fact_holdrness", "vik_aggressive_loves_empires_coward"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_hylrborg", "vik_aggressive_unreliable_overconfident"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_hellirborg", "vik_aggressive_settler_considerate"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_djurby", "vik_aggressive_sacker_melodramatic_short_anti_english"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_ledeborg", "vik_aggressive_loyal_settler"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_steinnborg", "vik_aggressive_impulsive_short"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_heimiliborg", "vik_aggressive_raiding_opportunist"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_veidrborg", "vik_aggressive_greedy_sacker"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_bedeborg", "vik_aggressive_sacker_reliable"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_grantebru", "vik_aggressive"..difficulty_mod); -- minor faction starting personalities
		
		
		-- -- ENGLISH
		cm:force_change_cai_faction_personality("vik_fact_northleode", "vik_aggressive_raiding_anti_danelaw"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_westernas", "vik_diplomatic_loyal"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_westmoringas", "vik_aggressive_settler"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_cent", "vik_defensive_loves_empires_considerate"..difficulty_mod); -- minor faction starting personalities ##### VASSAL
		cm:force_change_cai_faction_personality("vik_fact_suth_seaxe", "vik_defensive_loves_empires_considerate"..difficulty_mod); -- minor faction starting personalities ##### VASSAL
		cm:force_change_cai_faction_personality("vik_fact_defena", "vik_defensive_loves_empires_considerate"..difficulty_mod); -- minor faction starting personalities ##### VASSAL
		
		-- -- WELSH
		cm:force_change_cai_faction_personality("vik_fact_powis", "vik_aggressive_reliable_hates_empires_welsh"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_seisilwig", "vik_defensive_long_welsh"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_brechinauc", "vik_defensive_unreliable_anti_english_welsh"..difficulty_mod); -- minor faction starting personalities
		cm:force_change_cai_faction_personality("vik_fact_gwent", "vik_defensive_anti_english"..difficulty_mod); -- minor faction starting personalities ##### VASSAL
		cm:force_change_cai_faction_personality("vik_fact_gliwissig", "vik_defensive_anti_english"..difficulty_mod); -- minor faction starting personalities ##### VASSAL
		cm:force_change_cai_faction_personality("vik_fact_dyfet", "vik_aggressive_loyal_settler"..difficulty_mod); -- minor faction starting personalities -- DEWET
		cm:force_change_cai_faction_personality("vik_fact_cerneu", "vik_defensive_anti_english"..difficulty_mod); -- minor faction starting personalities ##### VASSAL
		
		
		
		
		personalities_initialised = true;
	else
		dev.log("Already set startpos CAI personalities, so no need to do it again!");
	end
end
dev.first_tick(new_campaign_cai_personalities)
dev.Save.save_value("personalities_initialised", function() return personalities_initialised end, function(saved_copy) personalities_initialised = saved_copy end)
