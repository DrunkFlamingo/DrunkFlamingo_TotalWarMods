
--While this script has been modified, it was originally written for RomeII by Mitch. 

isLogAllowed = true
LElogVerbosity = 2 --:number


function LELOGRESET()
    if not __write_output_to_logfile then
        return
    end
    
    local logTimeStamp = os.date("%d, %m %Y %X")
    --# assume logTimeStamp: string
    
    local popLog = io.open("loreful_empires_log.txt","w+")
    popLog :write("NEW LOG ["..logTimeStamp.."] \n")
    popLog :flush()
    popLog :close()
end

--v function(text: string)
function LELOG(text)
	ftext = "LESCRIPT"

    if not __write_output_to_logfile then
      return
    end

  local logText = tostring(text)
  local logContext = tostring(ftext)
  local logTimeStamp = os.date("%d, %m %Y %X")
  local popLog = io.open("loreful_empires_log.txt","a")
  --# assume logTimeStamp: string
  popLog :write("LE:  "..logText .. "    : [" .. logContext .. "] : [".. logTimeStamp .. "]\n")
  popLog :flush()
  popLog :close()
end

--v function(msg: string)
function LE_ERROR(msg)
	local ast_line = "********************"
	
	-- do output
	print(ast_line)
	print("SCRIPT ERROR, timestamp " .. get_timestamp())
	print(msg)
	print("")
	print(debug.traceback("", 2))
	print(ast_line)
	-- assert(false, msg .. "\n" .. debug.traceback())
	
	-- logfile output
		local file = io.open("loreful_empires_log.txt", "a")
		
		if file then
			file:write(ast_line .. "\n")
			file:write("SCRIPT ERROR, timestamp " .. get_timestamp() .. "\n")
			file:write(msg .. "\n")
			file:write("\n")
			file:write(debug.traceback("", 2) .. "\n")
			file:write(ast_line .. "\n")
			file:close()
		end
end
LELOGRESET()

--v function() --> vector<CA_FACTION>
local function GetPlayerFactions()
	local player_factions = {}
	local faction_list = cm:model():world():faction_list()
	for i = 0, faction_list:num_items() - 1 do
		local curr_faction = faction_list:item_at(i)
		if (curr_faction:is_human() == true) then
			table.insert(player_factions, curr_faction)
		end
	end
	return player_factions
end

--v function(ax: number, ay: number, bx: number, by: number) --> number
local function distance_2D(ax, ay, bx, by)
	return (((bx - ax) ^ 2 + (by - ay) ^ 2) ^ 0.5)
end

--v function(players: vector<CA_FACTION>, force: CA_MILITARY_FORCE) --> boolean
local function CheckIfPlayerIsNearFaction(players, force)
	local result = false
	local force_general = force:general_character()
	local radius = 20
	for i,value in ipairs(players) do
		local player_force_list = value:military_force_list()
		local j = 0
		while (result == false) and (j < player_force_list:num_items()) do
			local player_character = player_force_list:item_at(j):general_character()
			local distance = distance_2D(force_general:logical_position_x(), force_general:logical_position_y(), player_character:logical_position_x(), player_character:logical_position_y())
			result = (distance < radius)
			j = j + 1
		end
	end
	return result
end


--v function(players: vector<CA_FACTION>, faction: CA_FACTION) --> boolean
local function CheckIfFactionIsPlayersAlly(players, faction)
	local result = false
	for i,value in pairs(players) do
		if (result == false) and (value:allied_with(faction)==true) then
			result = true
		end
	end
	
	return result
end
	



local loreful_empires_manager = {} --# assume loreful_empires_manager: LOREFUL_EMPIRES_MANAGER

--v function(starting_majors: vector<string>, starting_secondaries: vector<string>) --> LOREFUL_EMPIRES_MANAGER
function loreful_empires_manager.new(starting_majors, starting_secondaries)
	local self = {}
	setmetatable(self, {
		__index = loreful_empires_manager
	}) --# assume self: LOREFUL_EMPIRES_MANAGER
	self._majorFactions = {} --:map<string, boolean>
	for i = 1, #starting_majors do
		self._majorFactions[starting_majors[i]] = true
	end
	self._secondaryFactions = {} --:map<string, boolean>
	for i = 1, #starting_secondaries do
		self._secondaryFactions[starting_secondaries[i]] = true
	end
	self._enabled = true --:boolean
	self._defensiveBattlesOnly = false --:boolean
	self._factionLeadersOnly = false --:boolean
	self._secondaryProtection = true --:boolean
	self._nearbyPlayerRestriction = true--:boolean
	self._enableScriptForAllies = false--:boolean
	self._autoconfed_enabled = false --:boolean
	self._autoconfed_list = {} --:map<string, boolean>
	self._autoconfed_cooldown = 9 --:number


	_G.lem = self
	return self
end


--v function(self: LOREFUL_EMPIRES_MANAGER) --> vector<string>
function loreful_empires_manager.get_major_list(self)
	local list = {} --:vector<string>
	for key, value in pairs(self._majorFactions) do
		table.insert(list, key)
	end
	return list
end

--v function(self: LOREFUL_EMPIRES_MANAGER) --> vector<string>
function loreful_empires_manager.get_secondary_list(self)
	local list = {} --:vector<string>
	for key, value in pairs(self._secondaryFactions) do
		table.insert(list, key)
	end
	return list
end

--v function(self: LOREFUL_EMPIRES_MANAGER, faction: string) --> boolean
function loreful_empires_manager.is_faction_major(self, faction)
	return not not self._majorFactions[faction]
end

--v function(self: LOREFUL_EMPIRES_MANAGER, faction: string) --> boolean
function loreful_empires_manager.is_faction_secondary(self, faction)
	return not not self._secondaryFactions[faction]
end


--v function(self: LOREFUL_EMPIRES_MANAGER) --> boolean
function loreful_empires_manager.defensive_battles_only(self)
	return self._defensiveBattlesOnly
end

--v function(self: LOREFUL_EMPIRES_MANAGER) --> boolean
function loreful_empires_manager.enable_script_for_allies(self)
	return self._enableScriptForAllies
end

--v function(self: LOREFUL_EMPIRES_MANAGER) --> boolean
function loreful_empires_manager.nearby_player_restriction(self)
	return self._nearbyPlayerRestriction
end

--v function(self: LOREFUL_EMPIRES_MANAGER) --> boolean
function loreful_empires_manager.autoconfederate_enabled(self)
	return self._autoconfed_enabled
end

--v function(self: LOREFUL_EMPIRES_MANAGER) --> boolean
function loreful_empires_manager.protect_secondary(self)
	return self._secondaryProtection
end

--v function(self: LOREFUL_EMPIRES_MANAGER) --> number
function loreful_empires_manager.autoconfed_cooldown(self)
	return self._autoconfed_cooldown
end

--v function(self: LOREFUL_EMPIRES_MANAGER) --> boolean
function loreful_empires_manager.faction_leaders_only(self)
	return self._factionLeadersOnly
end


--v function(self: LOREFUL_EMPIRES_MANAGER, context: WHATEVER)
function loreful_empires_manager.influence_battle(self, context)
	if self._enabled == false then
		return 
	end
	local pb = context:pending_battle() --:CA_PENDING_BATTLE
	local attacking_faction = pb:attacker():faction() --:CA_FACTION
	local defending_faction = pb:defender():faction() --:CA_FACTION
	local attacker_is_major = self:is_faction_major(attacking_faction:name())
	local defender_is_major = self:is_faction_major(defending_faction:name())
	local attacker_is_secondary = self:is_faction_secondary(attacking_faction:name())
	local defender_is_secondary = self:is_faction_secondary(defending_faction:name())
	local attacker_is_leader = pb:attacker():is_faction_leader()
	local defender_is_leader = pb:defender():is_faction_leader()
	local player_factions = GetPlayerFactions()
	LELOG("Battle Influencer:\n#### BATTLE ####\n"..attacking_faction:name().." v "..defending_faction:name())

	if attacking_faction:is_human() == false and defending_faction:is_human() == false then
		if (defender_is_secondary == false and attacker_is_secondary == false) or self:protect_secondary() == false then 
			if attacker_is_major == true and defender_is_major == false then
				if (not self:faction_leaders_only()) or attacker_is_leader == true then
					LELOG("Battle Influencer:Major Attacker v Minor Defender")

					if self:defensive_battles_only() == false then
						--If the minor faction is the player's military ally, we don't give bonuses to the major faction
						local ally_involved = CheckIfFactionIsPlayersAlly(player_factions, defending_faction)
						
						if self:enable_script_for_allies() == true then
							ally_involved = false
						else
							LELOG("Battle Influencer:Ally Involved: "..tostring(ally_involved))
						end

						if ally_involved == false then
							--If any of the player's armies/navies is close to the battle, the major faction won't receive the bonuses
							local player_nearby = false
							if self:nearby_player_restriction() == true then
								player_nearby = CheckIfPlayerIsNearFaction(player_factions, context:pending_battle():defender():military_force())
							end
							LELOG("Battle Influencer:Player Nearby: "..tostring(player_nearby))

							if player_nearby == false then
								--Arguments: attacker win chance, defender win chance, attacker losses modifier, defender losses modifier
								LELOG("Battle Influencer:Modified autoresolve for "..context:pending_battle():attacker():faction():name())
								cm:win_next_autoresolve_battle(context:pending_battle():attacker():faction():name())
								cm:modify_next_autoresolve_battle(1, 0, 1, 20, true)
							end
						end
					else
						LELOG("Battle Influencer:No autoresolve modification because the script is disabled for offensive battles.")
					end
				else
					LELOG("Battle Influencer:Major Faction is not being led by their FL, and the tweaker is set!")
				end
			elseif attacker_is_major == false and defender_is_major == true then
				if (not self:faction_leaders_only()) or defender_is_leader == true then
					LELOG("Battle Influencer:Minor Attacker v Major Defender")

					--If the minor faction is the player's military ally, we don't give bonuses to the major faction
					local ally_involved = CheckIfFactionIsPlayersAlly(player_factions, defending_faction)
						
					if self:enable_script_for_allies() == true then
						ally_involved = false
					else
						LELOG("Battle Influencer:Ally Involved: "..tostring(ally_involved))
					end

					if ally_involved == false then
						--If any of the player's forces is close to the battle, the major faction won't receive the bonuses
						local player_nearby = false
						if self:nearby_player_restriction() == true then
							player_nearby = CheckIfPlayerIsNearFaction(player_factions, context:pending_battle():attacker():military_force())
						end
						LELOG("Battle Influencer:Player Nearby: "..tostring(player_nearby))

						if player_nearby == false then
							LELOG("Battle Influencer:Modified autoresolve for "..context:pending_battle():defender():faction():name())
							cm:win_next_autoresolve_battle(context:pending_battle():defender():faction():name())
							cm:modify_next_autoresolve_battle(0, 1, 20, 1, true)
						end
					end
				else
					LELOG("Battle Influencer:Major Faction is not being led by their FL, and the tweaker is set!")
				end
			elseif attacker_is_major == true and defender_is_major == true then
				if self:faction_leaders_only() and defender_is_leader == false then
					LELOG("Battle Influencer:Major Attacker v Major Defender; Defender failed leadership requirement")
					if self:defensive_battles_only() == false then
						--If the minor faction is the player's military ally, we don't give bonuses to the major faction
						local ally_involved = CheckIfFactionIsPlayersAlly(player_factions, defending_faction)
						
						if self:enable_script_for_allies() == true then
							ally_involved = false
						else
							LELOG("Battle Influencer:Ally Involved: "..tostring(ally_involved))
						end

						if ally_involved == false then
							--If any of the player's armies/navies is close to the battle, the major faction won't receive the bonuses
							local player_nearby = false
							if self:nearby_player_restriction() == true then
								player_nearby = CheckIfPlayerIsNearFaction(player_factions, context:pending_battle():defender():military_force())
							end
							LELOG("Battle Influencer:Player Nearby: "..tostring(player_nearby))

							if player_nearby == false then
								--Arguments: attacker win chance, defender win chance, attacker losses modifier, defender losses modifier
								LELOG("Battle Influencer:Modified autoresolve for "..context:pending_battle():attacker():faction():name())
								cm:win_next_autoresolve_battle(context:pending_battle():attacker():faction():name())
								cm:modify_next_autoresolve_battle(1, 0, 1, 20, true)
							end
						end
					else
						LELOG("Battle Influencer:No autoresolve modification because the script is disabled for offensive battles.")
					end
				elseif self:faction_leaders_only() and attacker_is_leader == false then
					LELOG("Battle Influencer:Major Attacker v Major Defender; Attacker failed leadership requirement")
					
					--If the minor faction is the player's military ally, we don't give bonuses to the major faction
					local ally_involved = CheckIfFactionIsPlayersAlly(player_factions, defending_faction)
						
					if self:enable_script_for_allies() == true then
						ally_involved = false
					else
						LELOG("Battle Influencer:Ally Involved: "..tostring(ally_involved))
					end

					if ally_involved == false then
						--If any of the player's forces is close to the battle, the major faction won't receive the bonuses
						local player_nearby = false
						if self:nearby_player_restriction() == true then
							player_nearby = CheckIfPlayerIsNearFaction(player_factions, context:pending_battle():attacker():military_force())
						end
						LELOG("Battle Influencer:Player Nearby: "..tostring(player_nearby))

						if player_nearby == false then
							LELOG("Battle Influencer:Modified autoresolve for "..context:pending_battle():defender():faction():name())
							cm:win_next_autoresolve_battle(context:pending_battle():defender():faction():name())
							cm:modify_next_autoresolve_battle(0, 1, 20, 1, true)
						end
					end
				else
					LELOG("Battle Influencer:Major Attacker v Major Defender")
				end
			elseif attacker_is_major == false and defender_is_major == false then
				LELOG("Battle Influencer:Minor Attacker v Minor Defender\nNo autoresolve modification")
			end
		else 
			LELOG("Battle Influencer:Secondary Involved \nNo autoresolve modification")
		end
	end
end

--v function(self: LOREFUL_EMPIRES_MANAGER)
function loreful_empires_manager.activate(self)
	core:add_listener(
		"GuarenteedEmpires",
		"PendingBattle",
		true,
		function(context) self:influence_battle(context) end,
		true)
	LELOG("listener init")
	core:trigger_event("LorefulEmpiresActivated")
end


events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function(context)
	if LElogVerbosity < 2 then 
		return
	end
	if context:character():model():pending_battle():has_defender() and context:character():model():pending_battle():defender():cqi() == context:character():cqi() then
		-- The character is the Defender
		local result = context:character():model():pending_battle():defender_battle_result()

		if result == "close_victory" or result == "decisive_victory" or result == "heroic_victory" or result == "pyrrhic_victory" then
			LELOG("Battle Influencer:-- Result --\n"..context:character():faction():name().." Won! ("..result..")")
		end
	elseif context:character():model():pending_battle():has_attacker() and context:character():model():pending_battle():attacker():cqi() == context:character():cqi() then
		-- The character is the Attacker
		local result = context:character():model():pending_battle():attacker_battle_result()

		if result == "close_victory" or result == "decisive_victory" or result == "heroic_victory" or result == "pyrrhic_victory" then
			LELOG("Battle Influencer:-- Result --\n"..context:character():faction():name().." Won! ("..result..")")
		end
	end
end


--autocongeal feature
--need to also enable the feature flag
--v function(self: LOREFUL_EMPIRES_MANAGER, allowed_sc: map<string, boolean>)
function loreful_empires_manager.activate_autoconfed_with_list(self, allowed_sc)
	core:add_listener(
		"AutoconfedFactionTurnStart",
		"FactionTurnStart",
		function(context)
			local not_rebels = (not (context:faction():name() == "rebels"))
			local not_human = (not context:faction():is_human())
			local landed = (context:faction():has_home_region())
			local allowed = (not not allowed_sc[context:faction():subculture()])
			LELOG("Autoconfed: faction turn start ["..context:faction():name().."], checks ["..tostring(not_rebels).."] ["..tostring(not_human).."] ["..tostring(landed).."] ["..tostring(allowed).."]")
			return (not_human and not_rebels and landed and allowed)
		end,
		function(context)
			local our_faction = context:faction() --:CA_FACTION
			local sv = cm:get_saved_value("le_autoconfed_"..our_faction:name())
			if not not sv then
				if sv > 0 then
					sv = sv - 1
					cm:set_saved_value("le_autoconfed_"..our_faction:name(), sv)
					LELOG("Autoconfed: Faction ["..our_faction:name().."] is on cooldown for ["..tostring(sv).."] more turns")
					return
				else
					LELOG("Autoconfed: Faction ["..our_faction:name().."] is being checked.")
				end
			else
				LELOG("Autoconfed: Faction ["..our_faction:name().."] is being checked.")
			end
			local faction_map = {} --:map<CA_FACTION, boolean>
			-- first, check our adjacent regions for a list of factions. 
			local region_list = context:faction():region_list() --:CA_REGION_LIST
			for i = 0, region_list:num_items() - 1 do
				local region = region_list:item_at(i)
				local adj_list = region:adjacent_region_list()
				for j = 0, adj_list:num_items() - 1 do
					local adj = adj_list:item_at(j)
					if region:owning_faction():name() ~= adj:owning_faction():name() then
						if (region:owning_faction():subculture() == adj:owning_faction():subculture()) then
							if not (adj:owning_faction():is_human()) then
								faction_map[adj:owning_faction()] = true 
							end
						end
					end
				end
			end

			--can we take any of these fuckers?
			for current_faction, _ in pairs(faction_map) do
				if (our_faction:diplomatic_standing_with(current_faction:name()) >= 50) and self:autoconfederate_enabled() == true then
					if self:is_faction_major(our_faction:name()) and (not (self:is_faction_major(current_faction:name()) or self:is_faction_secondary(current_faction:name()))) then
						cm:force_confederation(our_faction:name(), current_faction:name())
						cm:set_saved_value("le_autoconfed_"..our_faction:name(), self:autoconfed_cooldown())
						LELOG("Autoconfed: Confederating ["..our_faction:name().."] and ["..current_faction:name().."]")
					end
				end
			end
		end, true)
end



--API


--v function(self: LOREFUL_EMPIRES_MANAGER, faction_key: string)
function loreful_empires_manager.remove_faction_from_major(self, faction_key)
	if not is_string(faction_key) then
		LE_ERROR("API USAGE ERROR: faction key must be a string!")
		script_error("LOREFUL EMPIRES API: Incorrect argument Type: Use the logging pack to see more details!")
		return
	end
	self._majorFactions[faction_key] = nil
end

--v function(self: LOREFUL_EMPIRES_MANAGER, faction_key: string)
function loreful_empires_manager.remove_faction_from_secondary(self, faction_key)
	if not is_string(faction_key) then
		LE_ERROR("API USAGE ERROR: faction key must be a string!")
		script_error("LOREFUL EMPIRES API: Incorrect argument Type: Use the logging pack to see more details!")
		return
	end
	self._secondaryFactions[faction_key] = nil
end

--v function(self: LOREFUL_EMPIRES_MANAGER, faction_key: string)
function loreful_empires_manager.add_faction_to_major(self, faction_key)
	if not is_string(faction_key) then
		LE_ERROR("API USAGE ERROR: faction key must be a string!")
		script_error("LOREFUL EMPIRES API: Incorrect argument Type: Use the logging pack to see more details!")
		return
	end
	if self:is_faction_secondary(faction_key) then
		LELOG("API: faction being added to major is currently secondary, removing it.")
		self:remove_faction_from_secondary(faction_key)
	end
	self._majorFactions[faction_key] = true
	LELOG("API: Added ["..faction_key.."] to the major list! ")
end

--v function(self: LOREFUL_EMPIRES_MANAGER, faction_key: string)
function loreful_empires_manager.add_faction_to_secondary(self, faction_key)
	if not is_string(faction_key) then
		LE_ERROR("API USAGE ERROR: faction key must be a string!")
		script_error("LOREFUL EMPIRES API: Incorrect argument Type: Use the logging pack to see more details!")
		return
	end
	if self:is_faction_major(faction_key) then
		LELOG("API: faction being added to secondary is currently major, removing it.")
		self:remove_faction_from_major(faction_key)
	end
	self._secondaryFactions[faction_key] = true
	LELOG("API: Added ["..faction_key.."] to the secondary list!")
end

--v function(self: LOREFUL_EMPIRES_MANAGER, option: boolean)
function loreful_empires_manager.set_defensive_battles_only(self, option)
	if not is_boolean(option) then
		LE_ERROR("API USAGE ERROR: option must be a boolean!")
		script_error("LOREFUL EMPIRES API: Incorrect argument Type: Use the logging pack to see more details!")
		return
	end
	self._defensiveBattlesOnly = option
	LELOG("API: Set Defensive battles only to ["..tostring(option).."]")
end

--v function(self: LOREFUL_EMPIRES_MANAGER, option: boolean)
function loreful_empires_manager.set_enable_script_for_allies(self, option)
	if not is_boolean(option) then
		LE_ERROR("API USAGE ERROR: option must be a boolean!")
		script_error("LOREFUL EMPIRES API: Incorrect argument Type: Use the logging pack to see more details!")
		return
	end
	self._enableScriptForAllies = option
	LELOG("API: Set Enable Script For Allies to ["..tostring(option).."]")
end


--v function(self: LOREFUL_EMPIRES_MANAGER, option: boolean)
function loreful_empires_manager.set_nearby_player_restriction(self, option)
	if not is_boolean(option) then
		LE_ERROR("API USAGE ERROR: option must be a boolean!")
		script_error("LOREFUL EMPIRES API: Incorrect argument Type: Use the logging pack to see more details!")
		return
	end
	self._nearbyPlayerRestriction = option
	LELOG("API: Set nearby player restriction to ["..tostring(option).."]")
end
	
--v function(self: LOREFUL_EMPIRES_MANAGER, option: boolean)
function loreful_empires_manager.set_enable_autoconfederate(self, option)
	if not is_boolean(option) then
		LE_ERROR("API USAGE ERROR: option must be a boolean!")
		script_error("LOREFUL EMPIRES API: Incorrect argument Type: Use the logging pack to see more details!")
		return
	end
	self._autoconfed_enabled = option
	LELOG("API: Set autoconfederation to ["..tostring(option).."]")
end

--v function(self: LOREFUL_EMPIRES_MANAGER, option: boolean)
function loreful_empires_manager.set_protect_secondary_factions(self, option)
	if not is_boolean(option) then
		LE_ERROR("API USAGE ERROR: option must be a boolean!")
		script_error("LOREFUL EMPIRES API: Incorrect argument Type: Use the logging pack to see more details!")
		return
	end
	self._secondaryProtection = option
	LELOG("API: Set secondary faction protection to ["..tostring(option).."]")
end

--v function(self: LOREFUL_EMPIRES_MANAGER, option: boolean)
function loreful_empires_manager.set_faction_leaders_only(self, option)
	if not is_boolean(option) then
		LE_ERROR("API USAGE ERROR: option must be a boolean!")
		script_error("LOREFUL EMPIRES API: Incorrect argument Type: Use the logging pack to see more details!")
		return
	end
	self._factionLeadersOnly = option
	LELOG("API: Set faction leader only to ["..tostring(option).."]")
end

--v function(self: LOREFUL_EMPIRES_MANAGER, option: number)
function loreful_empires_manager.set_autoconfed_cooldown(self, option)
	if not is_number(option) then
		LE_ERROR("API USAGE ERROR: cooldown must be a number!")
		script_error("LOREFUL EMPIRES API: Incorrect argument Type: Use the logging pack to see more details!")
		return
	end
	self._autoconfed_cooldown = option
	LELOG("API: Set autoconfederate cooldown to ["..tostring(option).."]")
end

--v function(settings_table: map<string, WHATEVER>, lem: LOREFUL_EMPIRES_MANAGER)
local function apply_loreful_empires_mct_settings(settings_table, lem)
	-- Enable Mod
	core:remove_listener("AutoconfedFactionTurnStart")
	core:remove_listener("GuarenteedEmpires")
	if settings_table.a_enable then
		lem._enabled = true 
		lem:activate()
	else
		lem._enabled = false 
		return
	end
	-- Major AI Auto-confederate
	if settings_table.a_autoconfed then
		lem:set_enable_autoconfederate(true)
		local list = {
			wh_main_sc_brt_bretonnia = true,
			wh_main_sc_dwf_dwarfs = true,
			wh_main_sc_emp_empire = true,
			wh2_main_sc_def_dark_elves = true,
			wh2_main_sc_hef_high_elves = true,
			wh2_main_sc_lzd_lizardmen = true
		}--:map<string, boolean>
	
		lem:activate_autoconfed_with_list(list)
	else
		lem:set_enable_autoconfederate(false)
		core:remove_listener("AutoconfedFactionTurnStart")
	end
	-- Auto-confederate Cooldown
	lem:set_autoconfed_cooldown(settings_table.b_confed_cd - 1)
	-- Defensive Battles Only
	lem:set_defensive_battles_only(settings_table.c_defensive_restriction)
	-- Faction Leaders only
	lem:set_faction_leaders_only(settings_table.d_leader_restriction)
	-- Ignore allies
	lem:set_enable_script_for_allies(settings_table.e_enable_for_allies)
	-- Makes this mod ignore battles where a player's ally is involved.
	if settings_table.f_secondary_factions == "secondary_factions_on" then
		lem:set_protect_secondary_factions(true)
	elseif settings_table.f_secondary_factions == "secondary_factions_off" then
		lem:set_protect_secondary_factions(false)
	elseif settings_table.f_secondary_factions == "secondary_factions_major" then
		lem:set_protect_secondary_factions(false)
		local secondaries = lem:get_secondary_list()
		for i = 1, #secondaries do
			lem:add_faction_to_major(secondaries[i])
		end
	end
end

function wec_loreful_empires()
	cm:set_saved_value("df_guaranteed_empires_port", true)
	
	out("Battle Influencer is running")
	

	--factions on this list gain an advantage when fighting against factions not on this list
	local major_factions = {
		--bretonnians
		"wh_main_brt_bretonnia",
		"wh_main_brt_carcassonne",
		"wh2_dlc14_brt_chevaliers_de_lyonesse",
		--dwarfs
		"wh_main_dwf_dwarfs",
		"wh_main_dwf_karak_izor",
		--empire
		"wh_main_emp_empire",
		"wh_main_emp_middenland",
		"wh2_dlc13_emp_golden_order",
		--greenskins
		"wh_main_grn_crooked_moon",
		"wh_main_grn_greenskins",
        "wh_main_grn_orcs_of_the_bloody_hand",
        "wh2_dlc15_grn_broken_axe",
		-- vampire counts
		"wh_main_vmp_schwartzhafen",
		"wh_main_vmp_vampire_counts",
		--skaven
		"wh2_dlc09_skv_clan_rictus",
		"wh2_main_skv_clan_mors",
		"wh2_main_skv_clan_pestilens",
		"wh2_main_skv_clan_skyre",
        "wh2_main_skv_clan_eshin",
        "wh2_main_skv_clan_moulder",
		--tomb kings
		"wh2_dlc09_tmb_exiles_of_nehek",
		"wh2_dlc09_tmb_followers_of_nagash",
		"wh2_dlc09_tmb_khemri",
		"wh2_dlc09_tmb_lybaras",
		--dark elves
		"wh2_main_def_naggarond",
		"wh2_main_def_har_ganeth",
		"wh2_main_def_cult_of_pleasure",
		"wh2_main_def_hag_graef",
		--high elves
		"wh2_main_hef_order_of_loremasters",
		"wh2_main_hef_eataine",
		"wh2_main_hef_nagarythe",
        "wh2_main_hef_avelorn",
        "wh2_main_hef_yvresse",        
		--lizardmen
		"wh2_main_lzd_last_defenders",
		"wh2_main_lzd_hexoatl",
		"wh2_dlc12_lzd_cult_of_sotek",
		--norsca
		"wh_dlc08_nor_wintertooth"
		}
		
		--these factions do not get an advantage but can never have an advantage granted against them.
		local secondary_factions = {
		--kislev
		"wh_main_ksl_kislev",
		--dwarves
		"wh_main_dwf_karak_kadrin",
		"wh2_main_dwf_karak_zorn",
		"wh_main_dwf_kraka_drak",
		"wh_main_dwf_barak_varr",
        "wh_main_dwf_karak_azul",
        "wh2_dlc17_dwf_thorek_ironbrow",
		--empire
		"wh_main_emp_averland",
		"wh_main_emp_marienburg",
		"wh_main_emp_cult_of_ulric",
		"wh_main_emp_cult_of_sigmar",
		"wh2_dlc13_emp_the_huntmarshals_expedition",
		--greenskins
		"wh_main_grn_red_eye",
		"wh_main_grn_red_fangs",
		"wh_main_grn_necksnappers_waaagh",
		"wh_main_grn_orcs_of_the_bloody_hand_waaagh",
		"wh_main_grn_red_eye_waaagh",
		"wh_main_grn_red_fangs_waaagh",
		"wh_main_grn_greenskins_waaagh",
		"wh_main_grn_skullsmasherz_waaagh",
		"wh_main_grn_scabby_eye_waaagh",
		"wh_main_grn_teef_snatchaz_waaagh",
		"wh_main_grn_crooked_moon_waaagh",
		"wh_main_grn_broken_nose_waaagh",
		"wh_main_grn_black_venom_waaagh",
        "wh_main_grn_bloody_spearz_waaagh",
        "wh2_dlc15_grn_bonerattlaz",
        "wh2_dlc16_grn_creeping_death",
		--teb
		"wh_main_teb_border_princes",
		"wh_main_teb_estalia",
		"wh_main_teb_tilea",
		"wh2_main_emp_new_world_colonies",
		"wh2_main_emp_sudenburg",
		"wh_main_teb_bilbali",
		"wh_main_teb_lichtenburg_confederacy",
		"wh_main_teb_magritta",
		"wh_main_teb_tobaro",
		--dark elves
		"wh2_main_def_scourge_of_khaine",
		"wh2_main_def_karond_kar",
        "wh2_dlc11_def_the_blessed_dread",
        "wh2_twa03_def_rakarth",
        --beastmen
        "wh_dlc03_bst_beastmen",
        "wh_dlc05_bst_morghur_herd",
        "wh2_dlc17_bst_malagor",
        "wh2_dlc17_bst_taurox",
		--wood elves
		"wh_dlc05_wef_torgovann",
		"wh_dlc05_wef_wood_elves",
		"wh_dlc05_wef_wydrioth",
        "wh_dlc05_wef_argwylon",        
        "wh2_main_wef_bowmen_of_oreon",
        "wh2_dlc13_wef_laurelorn_forest",        
        "wh2_dlc16_wef_sisters_of_twilight",
        "wh2_dlc16_wef_drycha",        
		--high elves
		"wh2_main_hef_caledor",
		"wh2_main_hef_chrace",
        "wh2_main_hef_tiranoc",
        "wh2_dlc15_hef_imrik",
		--lizardmen
		"wh2_main_lzd_xlanhuapec",
		"wh2_main_lzd_itza",
        "wh2_dlc13_lzd_spirits_of_the_jungle",
        "wh2_dlc16_lzd_wardens_of_the_living_pools",
        "wh2_dlc17_lzd_oxyotl",
		--norsca
		"wh2_main_nor_skeggi",
		"wh_dlc08_nor_norsca",
		--skaven		
		-- vampire counts
        "wh_main_vmp_mousillon",
        "wh2_dlc16_vmp_lahmian_sisterhood",
		-- pirates!
		"wh2_dlc11_cst_pirates_of_sartosa",
		"wh2_dlc11_cst_noctilus",
		"wh2_dlc11_cst_vampire_coast",
		"wh2_dlc11_cst_the_drowned",
		--chaos
		"wh_main_chs_chaos"
		}
	
	local lem = loreful_empires_manager.new(major_factions, secondary_factions)
		--mcm integration
	local mcm = _G.mcm
	local mct = core:get_static_object("mod_configuration_tool")
	if mct then
		local loreful_empires_mod = mct:get_mod_by_key("loreful_empires")
		local settings_table = loreful_empires_mod:get_settings() 
		apply_loreful_empires_mct_settings(settings_table, lem)
		core:add_listener(
			"loreful_empires_MctFinalized",
			"MctFinalized",
			true,
			function(context)
				local mct = get_mct()
				local loreful_empires_mod = mct:get_mod_by_key("loreful_empires")
				local settings_table = loreful_empires_mod:get_settings() 
	
				apply_loreful_empires_mct_settings(settings_table, lem)
			end,
			true
		)
	else
		lem:activate()
		if not not mcm then
			local settings = mcm:register_mod("loreful_empires", "Loreful Empires", "Major faction autoresolve bonuses for lore factions")
			local enable = settings:add_tweaker("enable_mod", "Enable Mod", "Enables or disables autoresolve influencing for this mod.")
			enable:add_option("enabled", "Enable", "Enable this mod.")
			enable:add_option("disabled", "Disable", "Disable this mod."):add_callback(function(context) 
				lem._enabled = false
			end)
			local autoconfed = settings:add_tweaker("confed", "Major AI Auto-confederate", "When enabled, major factions will confederate any minor factions they have a high enough relationship with automatically.")
			autoconfed:add_option("disabled", "Disable", "Do not turn on this feature")
			autoconfed:add_option("enabled", "Enable", "Turn on this feature"):add_callback(function(context)
				lem:set_enable_autoconfederate(true)
				local list = {
					wh_main_sc_brt_bretonnia = true,
					wh_main_sc_dwf_dwarfs = true,
					wh_main_sc_emp_empire = true,
					wh2_main_sc_def_dark_elves = true,
					wh2_main_sc_hef_high_elves = true,
					wh2_main_sc_lzd_lizardmen = true
				}--:map<string, boolean>

				lem:activate_autoconfed_with_list(list)
			end)
			settings:add_variable("confed_cd", 1, 25, 10, 1, "Auto-confederate Cooldown", "The period of time between each confederation that can be automatically triggered for a faction"):add_callback(function(context)
				lem:set_autoconfed_cooldown(settings:get_variable_with_key("confed_cd"):current_value() - 1)
			end)
			local defensive_restriction = settings:add_tweaker("defensive_restriction", "Defensive Battles Only", "Makes the mod only support defensive battles.")
			defensive_restriction:add_option("defensive_restriction_off", "All battles", "This mod will impact offensive battles.")
			defensive_restriction:add_option("defensive_restriction_on", "Defensive Battles", "Disable this mod for attackers."):add_callback(function(context) 
				lem:set_defensive_battles_only(true)
			end)
			local leader_restriction = settings:add_tweaker("leader_restriction", "Faction Leaders only", "Makes this mod only influence when a legendary lord is involved.")
			leader_restriction:add_option("leader_restriction_off", "All Characters", "This mod will impact battles for any character.")
			leader_restriction:add_option("leader_restriction_on", "Faction Leaders Only", "Disable this mod for non-faction leaders."):add_callback(function(context) 
				lem:set_faction_leaders_only(true)
			end)
			local enable_for_allies = settings:add_tweaker("allies", "Ignore allies", "Makes this mod ignore battles where a player's ally is involved")
			enable_for_allies:add_option("allies_off", "Ignore Allies", "This mod will not impact battles which involve one of your allies.")
			enable_for_allies:add_option("allies_on", "Function for Allies", "This mod will impact battles regardless of alliance to a player."):add_callback(function(context) 
				lem:set_enable_script_for_allies(true)
			end)
			local secondary_factions = settings:add_tweaker("secondary_factions", "Secondary Factions", "Secondary factions are factions who are not given bonuses to their expansion, but who are important to lore and are thus protected from their enemies being given bonuses.")
			secondary_factions:add_option("secondary_factions_on", "Enabled (Recommended)", "This mod will not impact battles involving secondary factions")
			secondary_factions:add_option("secondary_factions_off", "Disabled", "This mod will not protect secondary factions"):add_callback(function(context) 
				lem:set_protect_secondary_factions(false)
			end)
			secondary_factions:add_option("secondary_factions_major", "Treat as major", "This mod will add the secondary factions list to the major factions list"):add_callback(function(context)
				lem:set_protect_secondary_factions(false)
				local secondaries = lem:get_secondary_list()
				for i = 1, #secondaries do
					lem:add_faction_to_major(secondaries[i])
				end
			end)
		end
	end
end