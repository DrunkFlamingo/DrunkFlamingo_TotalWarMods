local BURGHAL_FACTIONS = {
    "vik_fact_west_seaxe",
    "vik_fact_mierce",
    "vik_fact_northleode"
}--:vector<string>

ENG_BURGHAL = {} --:map<string, FACTION_RESOURCE>


--v function(region_list: CA_REGION_LIST) --> (number, number)
local function calculate_burghal_value(region_list)
    local new_brughal = 0 --:number
	local new_total = 0 --:number
	local check_reg = {} --:map<CA_CQI, boolean>
	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i)
		if region:is_province_capital() then
			if region:has_governor() and (not check_reg[region:governor():command_queue_index()]) then
				new_total = new_total+ 1;
				check_reg[region:governor():command_queue_index()] = true
				if region:governor():loyalty() >= 5 then 
					 new_brughal = new_brughal + 1;
				end
			end
		end
    end
    return new_brughal, new_total
end

--v function(faction_name: string)
local function refresh_burghal(faction_name)
    local new_value, new_total = calculate_burghal_value(dev.get_faction(faction_name):region_list())
    ENG_BURGHAL[faction_name]:set_new_value(new_value, new_total)
end

dev.first_tick(function(context)
    --build objects
    for i = 1, #BURGHAL_FACTIONS do
        local faction_name = BURGHAL_FACTIONS[i]
        local faction_obj = dev.get_faction(faction_name)
        if faction_obj:is_human() then
            local resource = PettyKingdoms.FactionResource.new(faction_name, "vik_english_peasant", "capacity_fill", 0, 3, {},
            function(self) --:FACTION_RESOURCE
                if self.value >= self.cap_value then
                    return "positive"
                else
                    return "negative"
                end
            end)
            ENG_BURGHAL[faction_name] = resource
            refresh_burghal(faction_name)
        end
    end

    cm:add_listener(
        "FactionTurnStart_Burghal",
        "FactionTurnStart",
        function(context) return context:faction():is_human() == true and not not ENG_BURGHAL[context:faction():name()] end,
        function(context) refresh_burghal(context:faction():name()) end,
        true
    );
    
    cm:add_listener(
        "FactionLeaderSignsPeaceTreaty_Burghal",
        "FactionLeaderSignsPeaceTreaty",
        function(context) return (function() for key, _ in pairs(ENG_BURGHAL) do if dev.get_faction(key):is_human() then return true end end return false end)() end,
        function(context) 
            local humans = cm:get_human_factions()
            for i = 1, #humans do
                if ENG_BURGHAL[humans[i]] then
                    refresh_burghal(humans[i])
                end
            end
        end,
        true
    );
    
    cm:add_listener(
        "GovernorAssignedCharacterEvent_Burghal",
        "GovernorAssignedCharacterEvent",
        function(context) return (function() for key, _ in pairs(ENG_BURGHAL) do if dev.get_faction(key):is_human() then return true end end return false end)() end,
        function(context) 
            local humans = cm:get_human_factions()
            for i = 1, #humans do
                if ENG_BURGHAL[humans[i]] then
                    refresh_burghal(humans[i])
                end
            end
        end,
        true
    );
    
    cm:add_listener(
        "IncidentOccuredEvent_Burghal",
        "IncidentOccuredEvent",
        function(context) return not not ENG_BURGHAL[context:faction():name()] end,
        function(context)
            refresh_burghal(context:faction():name())
        end,
        true
    )
        
        
end)