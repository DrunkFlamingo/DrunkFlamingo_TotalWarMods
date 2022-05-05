-------------------------------------------------------------------------------
------------------------------- SEASONAL WEATHER ------------------------------
-------------------------------------------------------------------------------
------------------------- Created by AmericanCaesar: 05JUN20 ------------------
------------------------- Last Updated:                  ----------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- Seasonal weather effects apply to your faction during the campaign
-- Bad weather can start on turn 10 and have one bad weather per year thereafter

--v function(t: any)
local function log(t)
    dev.log(tostring(t), "SEASONS")
end

local SEASON_INFO = {
    last_bad_weather_turn = -3,
    last_season_change_turn = 0,
    faction_to_last_season = {},
    faction_to_bad_weather = {}
} --:{last_bad_weather_turn: int, last_season_change_turn: int, faction_to_last_season: map<string, int>, faction_to_bad_weather: map<string, boolean>}

local BAD_WEATHER_CHANCE = 10 --:int
local SEASONAL_WEATHER_DURATION = 4 --:int
local SEASONAL_WEATHER_DELAY = 9 --:int

-- The duration for each weather bundle to be applied for
local events = dev.GameEvents




--v function(faction: CA_FACTION, season_bundle: string, is_new_game: boolean)
local function apply_season_bundle_to_faction(faction, season_bundle, is_new_game)
    local region_list = dev.region_list(faction)
    local duration = SEASONAL_WEATHER_DURATION
    if is_new_game then
        duration = SEASONAL_WEATHER_DURATION - 2
    end
    for i = 0, region_list:num_items() - 1 do
        local current_region = region_list:item_at(i)
        -- Weather gets applied to all factions

        if current_region:is_province_capital() then
            cm:apply_effect_bundle_to_region(season_bundle, current_region:name(), duration);
        end
    end
end


--v function(season: int, is_bad: boolean) --> string
function get_season_bundle(season, is_bad)
    -- All of the weather bundles that can occur:
	    -- shield_season_winter
	    -- shield_season_winter_bitter
	    -- shield_season_summer
	    -- shield_season_summer_drought
	    -- shield_season_harvest
	    -- shield_season_harvest_cold
	    -- shield_season_spring
        -- shield_season_spring_flood

    local season_to_weather_bundles = {
        [3] = "shield_season_winter",
        [1] = "shield_season_summer",
        [2] = "shield_season_harvest",
        [0] = "shield_season_spring",
    } --:map<int, string>
    local weather_bundle = season_to_weather_bundles[season]
    local season_to_bad_weather = {
        [3] = "_bitter",
        [1] = "_drought",
        [2] = "_cold",
        [0] = "_flood",
    } --:map<int, string>

    if is_bad == true then
        weather_bundle = weather_bundle .. season_to_bad_weather[season]
    end
    return weather_bundle
end


--v function(current_faction: CA_FACTION, turn: int, season: int)
local function SeasonalWeather(current_faction, turn, season)
    log("Applying Seasonal Weather to "..current_faction:name().." on turn "..tostring(turn).." for season "..tostring(season))
    -- Do we roll a bad season?
    local is_bad = false;
    --if we've already rolled a bad weather, and it has not yet been 3 turns since then.
    if SEASON_INFO.last_bad_weather_turn + SEASONAL_WEATHER_DELAY < turn  then 
        if dev.chance(BAD_WEATHER_CHANCE) then 
            SEASON_INFO.last_bad_weather_turn = turn;
            SEASON_INFO.faction_to_bad_weather[current_faction:name()] = true
			is_bad = true
        end
    end
    
    local weather_bundle = get_season_bundle(season, is_bad)
    apply_season_bundle_to_faction(current_faction, weather_bundle, turn == 1)
    SEASON_INFO.faction_to_last_season[current_faction:name()] = season
    SEASON_INFO.last_season_change_turn = turn
    if is_bad and current_faction:is_human() then
        local context = events:build_context_for_event(weather_bundle, current_faction)
        events:force_check_and_queue_event(weather_bundle, context)
    end
end


dev.first_tick(function(context) --once the game is created...

    --set up any essential data
    events:create_event("shield_season_winter_bitter", "incident", "standard") --repeat this command for each incident
    events:create_event("shield_season_summer_drought", "incident", "standard")
    events:create_event("shield_season_harvest_cold", "incident", "standard")
    events:create_event("shield_season_spring_flood", "incident", "standard")

    --do anything that happens on new game
    if dev.is_new_game() then
        local season = cm:model():season()
        log("Current season is ".. tostring(season))
        local players = cm:get_human_factions()
        for i = 1, #players do
            SeasonalWeather(dev.get_faction(players[i]), dev.turn(), season)
        end
    end
    --set up listeners to do things going forward.
    dev.eh:add_listener( --add a listener
        "SeasonalWeather",
        "FactionTurnStart",
        true,
        function(context)
            local faction = context:faction() --:CA_FACTION
            local turn = dev.turn()
            local season = cm:model():season();

            
            -- Did the season change? then change the weather
            local last_season = SEASON_INFO.faction_to_last_season[faction:name()] or -99
            if faction:is_human() then
                log("Current season is ".. tostring(season) .. " last season stored is "..last_season)
            end
            if season ~= last_season then
                --clear bad weather status
                SEASON_INFO.faction_to_bad_weather[faction:name()] = nil
                --apply new season
                SeasonalWeather(faction, turn, season);
            end 
        end,
        true)
    dev.eh:add_listener(
        "SeasonalWeather",
        "RegionChangesOwnership",
        function(context)
           return context:region():is_province_capital() and (not context:region():owning_faction():is_null_interface())
        end,
        function(context)
            local turn = dev.turn()
            local region = context:region() --:CA_REGION
            local faction = region:owning_faction()
            local last_season = SEASON_INFO.faction_to_last_season[faction:name()] 
            --if we applied a 3 turn bundle originally on turn 1, it should expire start of turn 4. 
            local duration_reduction = turn - SEASON_INFO.last_season_change_turn
            if duration_reduction >= 4 then
                return
            end
            --duration_reduction = turns since applied
            local is_bad = not not SEASON_INFO.faction_to_bad_weather[faction:name()] --not not converts nil to false
            local bundle = get_season_bundle(last_season, is_bad)
            cm:apply_effect_bundle_to_region(bundle, region:name(), SEASONAL_WEATHER_DURATION - 1 - duration_reduction)
        end,
        true)
    
end)




------------------------------------------------
---------------- Saving/Loading ----------------
------------------------------------------------
dev.Save.persist_table(SEASON_INFO, "SEASON_INFO", function(t) SEASON_INFO = t end)

