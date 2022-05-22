-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	CAMPAIGN SCRIPT
--
--	First file that gets loaded by a scripted campaign.
--	This shouldn't need to be changed by per-campaign, except for the
--	require and callback commands at the bottom of the file
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

--v function(text: string)
local function failure_log(text)

	local pre = "ERROR:"
    local logText = tostring(text)
    local logTimeStamp = os.date("%d, %m %Y %X")
    local popLog = io.open("sheildwall_critical.txt","a")
    --# assume logTimeStamp: string
    popLog :write(pre..":  [".. logTimeStamp .. "]:  "..logText .. "  \n")
    popLog :flush()
    popLog :close()
end

-- change this to false to not load the script
local load_script = true;

if not load_script then
	out.ting("*** WARNING: Not loading script for campaign " .. campaign_start_file .. " as load_script variable is set to false! Edit lua file at " .. debug.getinfo(1).source .. " to change this back ***");
	return;
end;

-- force reloading of the lua script library
package.loaded["lua_scripts.Campaign_Script_Header"] = nil;
require "lua_scripts.Campaign_Script_Header";

-- name of the campaign, sourced from the name of the containing folder
campaign_name = get_folder_name_and_shortform();

-- name of the local faction, to be filled in later
local_faction = "";

-- include path to other scripts associated with this campaign
package.path = package.path .. ";data/campaigns/" .. campaign_name .. "/?.lua";
package.path = package.path .. ";data/campaigns/" .. campaign_name .. "/factions/?.lua";

-- create campaign manager
cm = campaign_manager:new(campaign_name);

-- require a file in the factions subfolder that matches the name of our local faction
--[[
-- moved this code inside the first tick callback 
cm:register_ui_created_callback(
	function()
		if (cm:model():is_multiplayer() == true) then
			local_faction = cm:get_local_faction();
			
			if not (local_faction == "") then
				output("Loading faction script for faction " .. local_faction);
				inc_tab();
				_G.script_env = getfenv(1);
				
				-- faction scripts loaded here
				if load_faction_script(local_faction) and load_faction_script(local_faction .. "_intro") then
					dec_tab();
					output("Faction scripts loaded");
				else
					dec_tab();
				end;
			end;
		end;
	end
);
]]-- 

cm:add_listener(
	"loading_screen_dismissed",
	"LoadingScreenDismissed",
	true,
	function()
		output("scripting.lua - LoadingScreenDismissed event has been received");
		local_faction = cm:get_local_faction();
		
		-- load up the faction file
		if not (local_faction == "") then
			output("Loading faction script for faction " .. local_faction);
			inc_tab();
			_G.script_env = getfenv(1);
			
			-- faction scripts loaded here
			if load_faction_script(local_faction) and load_faction_script(local_faction .. "_intro") then
				dec_tab();
				output("Faction scripts loaded");
			else
				dec_tab();
			end;
		end
		
		-- once that is loaded we can start the game for the factions
		if is_function(start_game_for_faction) then
			start_game_for_faction(true);		-- set to false to not show cutscene
		else
			script_error("start_game_for_faction() function is being called but hasn't been loaded - the script has gone wrong somewhere else, investigate!");
		end;
		
		start_game_all_factions();
	end,
	false
);


-- try and load a faction script
function load_faction_script(scriptname)
	local success, err_code = pcall(function() require(scriptname) end);
			
	if success then
		output(scriptname .. ".lua loaded");
	else
		script_error("ERROR: Tried to load faction script " .. scriptname .. " without success - either the script is not present or it is not valid. See error below");
		output("*************");
		output("Returned lua error is:");
		output(err_code);
		output("*************");
	end;
	
	return success;
end;



-------------------------------------------------------
--	function to call when the first tick occurs
-------------------------------------------------------
cm:register_first_tick_callback(
	function()
		if (cm:model():is_multiplayer() == true) then
			local_faction = cm:get_local_faction();
			
			if not (local_faction == "") then
				output("Loading faction script for faction " .. local_faction);
				inc_tab();
				_G.script_env = getfenv(1);
				
				-- faction scripts loaded here
				if load_faction_script(local_faction) and load_faction_script(local_faction .. "_intro") then
					dec_tab();
					output("Faction scripts loaded");
				else
					dec_tab();
				end;
			end;
			
			if is_function(start_game_for_faction) then
				start_game_for_faction(true);		-- set to false to not show cutscene
			else
				script_error("start_game_for_faction() function is being called but hasn't been loaded - the script has gone wrong somewhere else, investigate!");
			end;
			
			start_game_all_factions();
		end;
	end
);

-------------------------------------------------------
--	additional script files to load
-------------------------------------------------------
local ok, err = pcall(function()
require("shieldwall_scripted")
end) if not ok then
	failure_log("Critical Error")
	failure_log(tostring(err))
	failure_log(debug.trackback())
end