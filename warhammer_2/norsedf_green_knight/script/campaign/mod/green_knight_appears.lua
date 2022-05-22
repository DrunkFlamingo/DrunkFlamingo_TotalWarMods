local testing_mode = false --makes the chivalry chance 100% and forces logging on for this mod

--v function(t: any)
local function print(t)
    if __write_output_to_logfile or testing_mode then
        local logText = tostring(t)
        local logTimeStamp = os.date("%d, %m %Y %X")
        local popLog = io.open("warhammer_expanded_log.txt","a")
        --# assume logTimeStamp: string
        popLog :write("BRT:  [".. logTimeStamp .. "]:  "..logText .. "  \n")
        popLog :flush()
        popLog :close()
    end
end
core:add_listener(
    "PendingBattleGreenKnightGarrison",
    "ScriptEventPendingBattle",
    function(context)
        local bret_defender = false --:boolean
        local bret_attacker = false --:boolean
        local ok, err = pcall(function()
        print("checking pre battle for bret defender")
        if cm:pending_battle_cache_num_attackers() >= 1 then
			for i = 1, cm:pending_battle_cache_num_attackers() do
                local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
                if not (current_faction_name == "rebels") then
                    print("pre battle subculture ["..cm:get_faction(current_faction_name):subculture().."] faction ["..current_faction_name.."] ")
                    if cm:get_faction(current_faction_name):subculture() == "wh_main_sc_brt_bretonnia" then
                        bret_attacker = true;
                    end
                end
			end
		end		
		if cm:pending_battle_cache_num_defenders() >= 1 then
			for i = 1, cm:pending_battle_cache_num_defenders() do
                local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
                print("pre battle subculture ["..cm:get_faction(current_faction_name):subculture().."] faction ["..current_faction_name.."] ")
                if not (current_faction_name == "rebels") then
				    if cm:get_faction(current_faction_name):subculture() == "wh_main_sc_brt_bretonnia" then
                        bret_defender = true;
                    end
                end
			end
        end
        print("bret defender ["..tostring(bret_defender).."] bret attacker ["..tostring(bret_attacker).."] ")
        end)
        if not ok then 
            print(err) 
        end
        return bret_defender and (not bret_attacker)
    end,
    function(context)
        local ok, err = pcall(function()
        if cm:pending_battle_cache_num_defenders() >= 1 then
			for i = 1, cm:pending_battle_cache_num_defenders() do
                local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
                print("checking spawn for ["..current_faction_name.."] ")
                if cm:get_faction(current_faction_name):subculture() == "wh_main_sc_brt_bretonnia" and cm:model():military_force_for_command_queue_index(this_mf_cqi):is_armed_citizenry() then
                    print("is garrison")
                    if not cm:model():military_force_for_command_queue_index(this_mf_cqi):unit_list():has_unit("wh_dlc07_brt_cha_green_knight_0") then
                        print("doesn't have the green knight already")
                        local faction_chivalry = cm:get_faction(current_faction_name):total_food()
                        print("chivalry is ["..tostring(faction_chivalry).."] ")
                        if not cm:get_faction(current_faction_name):is_human() and cm:model():turn_number() > 5 then
                            faction_chivalry = (1800/(cm:get_faction(current_faction_name):region_list():num_items() + 00.1))
                        end
                        if (faction_chivalry > 0 and (cm:random_number(2000) < faction_chivalry)) or testing_mode then
                            print("applying green knight appearance!")
                            cm:apply_effect_bundle_to_force("norse_green_knight_appears", this_mf_cqi, 1)
                            break;
                        end
                    end
				end
			end
        end
    end) if not ok then print(err) end
    end, true)