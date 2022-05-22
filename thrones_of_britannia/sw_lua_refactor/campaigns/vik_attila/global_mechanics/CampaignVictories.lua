--manages forming kingdoms.
--how does this crap work in Coop? Don't ask me. I'm not entirely sure why coop games don't just have normal victory conditions.
--gonna leave it broken for MP campaigns for now.


--v function(t: any)
local function log(t)
    dev.log(tostring(t), "VICT")
end

local victory_incidents = {
    ["vik_vc_conquest_1"] = "vik_incident_short_victory_conquest",
    ["vik_vc_fame_1"] = "vik_incident_short_victory_fame",
    ["vik_vc_fame_2"] = "vik_incident_long_victory_fame",
    ["vik_vc_conquest_2"] = "vik_incident_long_victory_conquest"
} --:map<string, string>

local final_victory_events = {
    ["vik_vc_fame_2"] = "vik_incident_invasion_end_1_fame",
    ["vik_vc_conquest_2"] = "vik_incident_invasion_end_1_conquest"
} --:map<string, string>

local victory_cutscenes = {
    ["vik_vc_conquest_1"] = "vik_victory_domination_short",
    ["vik_vc_fame_1"] = "vik_victory_fame_short",
    ["vik_vc_fame_2"] = "vik_victory_fame_long",
    ["vik_vc_conquest_2"] = "vik_victory_domination_long",
    ["vik_vc_kingdom_2"] = "vik_victory_kingdom_long",
    ["vik_vc_kingdom_1"] = "vik_victory_kingdom_short",
    ["vik_vc_invasion"] = "vik_victory_ultimate"
} --:map<string, string>

local victories = {

} --:map<string, {bool, bool, string, string}>
dev.Save.attach_to_table(victories, "victory_cnd")


--v function(faction: CA_FACTION, kingdom: string, long_victory: boolean, no_message:boolean?)
function KingdomSetFounderFaction(faction, kingdom, long_victory, no_message)
    log("Setting Kingdom: campaign_localised_strings_string_vik_fact_kingdom_"..kingdom)
    cm:set_faction_name_override(faction:name(), "campaign_localised_strings_string_vik_fact_kingdom_"..kingdom);
	local founder = "ai";
    local faction_string = string.gsub(faction:name(), "vik_fact_", "")
	--Remove old effect bundles for player and apply new effect bundles
	if faction:is_human() then
        founder = "player";
        if kingdom == Gamedata.kingdoms.faction_nations[faction:name()] then
            if faction:has_effect_bundle("vik_kingdom_"..Gamedata.kingdoms.faction_kingdoms[faction:name()].."_"..faction_string) then
                cm:remove_effect_bundle("vik_kingdom_"..Gamedata.kingdoms.faction_kingdoms[faction:name()].."_"..faction_string, faction:name())
            end
            cm:apply_effect_bundle("vik_kingdom_"..kingdom.."_"..faction_string, faction:name(), 0)
        else
            if faction:has_effect_bundle("vik_faction_trait_"..faction_string) then
                cm:remove_effect_bundle("vik_faction_trait_"..faction_string, faction:name())
            end
            cm:apply_effect_bundle("vik_kingdom_"..kingdom.."_"..faction_string, faction:name(), 0)
        end
	end
	
    --Fire the incident

	local incident = "vik_incident_kingdom_formed_"..kingdom.."_"..founder;
	if long_victory == true then
		incident = "vik_incident_kingdom_formed_"..kingdom.."_player_long_victory";
    end
    dev.eh:trigger_event("FactionFormsKingdom", faction, kingdom)
    if not no_message then
        cm:trigger_incident(faction:name(), incident, true)
    end
end

--v function(faction: CA_FACTION, mission: string)
local function apply_victory_mission(faction, mission)
    if not not string.find(mission, "_1") then
        log("Applying Short Victory Reward")
        --short victory
        if mission == "vik_vc_kingdom_1" then
            log("Setting Kingdom Founder")
            KingdomSetFounderFaction(faction, Gamedata.kingdoms.faction_kingdoms[faction:name()], false)
            victories[faction:name()][3] = Gamedata.kingdoms.faction_kingdoms[faction:name()]
        end
        if victories[faction:name()][1] == false and victory_cutscenes[mission] then
            log("Firing Cutscene")
            cm:register_instant_movie(victory_cutscenes[mission])
            log("Unlocking Victory Tech")
            cm:unlock_technology(faction:name(), "vik_mil_cap_1")
            victories[faction:name()][1] = true
            if victory_incidents[mission] then
                log("Triggering Victory Incident")
                cm:trigger_incident(faction:name(), victory_incidents[mission], true)
            end
        end
    elseif not not string.find(mission, "_2") then
        log("Applying Short Victory Reward")
        --long victory
        if mission == "vik_vc_kingdom_2" then
            log("Setting Kingdom Founder")
            KingdomSetFounderFaction(faction, Gamedata.kingdoms.faction_nations[faction:name()], true, not victories[faction:name()][2])
            victories[faction:name()][3] = Gamedata.kingdoms.faction_nations[faction:name()]
        end
        if victories[faction:name()][2] == false then
            victories[faction:name()][2] = true
            log("Firing Cutscene")
            cm:register_instant_movie(victory_cutscenes[mission])
            if final_victory_events[mission] then
                log("Triggering Victory Incident")
                cm:trigger_incident(faction:name(), final_victory_events[mission], true)
            end
        elseif victory_incidents[mission] then
            log("Triggering Victory Incident")
            cm:trigger_incident(faction:name(), victory_incidents[mission], true)
        end
    elseif mission == "vik_vc_invasion" then
        log("Firing Endgame Cutscene")
        cm:register_instant_movie("vik_victory_ultimate"); 
    end
end


dev.first_tick(function(context) 
    log("Initializing Victories")
    if cm:is_multiplayer() == false then
        if dev.is_new_game() or (victories[cm:get_local_faction(true)] == nil) then
            victories[cm:get_local_faction(true)] = {false, false, "", ""}
        end
        local faction = dev.get_faction(cm:get_local_faction(true))
        if victories[cm:get_local_faction(true)] then
            --set names after loading
            if victories[cm:get_local_faction(true)][3] ~= "" and Gamedata.kingdoms.faction_kingdoms[faction:name()] then
                KingdomSetFounderFaction(faction, Gamedata.kingdoms.faction_kingdoms[faction:name()], false, true)
            end
            if victories[cm:get_local_faction(true)][4] ~= "" then
                KingdomSetFounderFaction(faction,Gamedata.kingdoms.faction_nations[faction:name()], false, true)
            end 
        end
        if (victories[cm:get_local_faction(true)][1] == false) then
            cm:lock_technology(cm:get_local_faction(true), "vik_mil_cap_1")
        end
        
        dev.eh:add_listener(
			"MissionSucceeded_Victory",
			"MissionSucceeded",
            function(context)
               return (not not string.find(context:mission():mission_record_key(), "vik_vc_")) and (not not Gamedata.kingdoms.faction_kingdoms[context:faction():name()])
            end,
            function(context) 
                log("Succeeded Victory Mission: "..context:mission():mission_record_key())
                local mission = context:mission():mission_record_key() --:string
                local faction = context:faction() --:CA_FACTION
                apply_victory_mission(faction, mission)
            end,
			true
        );
        dev.eh:add_listener(
            "KingdomTurnStartGenerator",
            "FactionTurnStart",
            function(context)
                return not not victories[context:faction():name()]
            end,
            function(context)
                local faction = context:faction()
                log("Kingdom: "..faction:name().." starting their turn: "..tostring(cm:model():turn_number()))
                dev.eh:trigger_event("KingdomTurnStart", faction, victories)
            end,
            true)
        --[[
        dev.eh:add_listener(
            "AIKingdomTurnStart",
            "FactionTurnStart",
            function(context)
                return not context:faction():is_human() and PettyKingdoms.Rivals.is_rival(context:faction():name())
            end,
            function(context)
                local faction = context:faction()
                local kingdom_controlled = false --:boolean
                local nation_controlled = false --:boolean
                local can_be_kingdom = true --:boolean
                local can_be_nation = true --:boolean
                if Gamedata.kingdoms.faction_kingdoms[faction:name()] == Gamedata.kingdoms.faction_kingdoms[cm:get_local_faction()] then
                    can_be_kingdom = false
                end
                if Gamedata.kingdoms.faction_nations[faction:name()] == Gamedata.kingdoms.faction_nations[cm:get_local_faction()] then
                    can_be_nation = false
                end
                if can_be_kingdom then
                    local provs = Gamedata.kingdoms.kingdom_provinces(faction)
                    for p = 1, #provs do
                        local regions = Gamedata.regions.get_regions_in_regions_province(provs[p])
                        for r = 1, #regions do
                            local region = dev.get_region(regions[r])
                            if region:owning_faction():name() == faction:name() then
                                kingdom_controlled = true
                            else
                                kingdom_controlled = false
                                break;
                            end
                        end
                        if kingdom_controlled == false then
                            break
                        end
                    end
                end
                if can_be_nation then
                    local provs = Gamedata.kingdoms.nation_provinces(faction)
                    for p = 1, #provs do
                        local regions = Gamedata.regions.get_regions_in_regions_province(provs[p])
                        for r = 1, #regions do
                            local region = dev.get_region(regions[r])
                            if region:owning_faction():name() == faction:name() then
                                nation_controlled = true
                            else
                                nation_controlled = false
                                break;
                            end
                        end
                        if nation_controlled == false then
                            break
                        end
                    end
                end
                if can_be_kingdom and kingdom_controlled then
                    KingdomSetFounderFaction(faction, Gamedata.kingdoms.faction_kingdoms[faction:name()], false)
                elseif can_be_nation and nation_controlled then
                    KingdomSetFounderFaction(faction, Gamedata.kingdoms.faction_nations[faction:name()], false)
                end
            end,
            true
        )--]]
    end
end )


