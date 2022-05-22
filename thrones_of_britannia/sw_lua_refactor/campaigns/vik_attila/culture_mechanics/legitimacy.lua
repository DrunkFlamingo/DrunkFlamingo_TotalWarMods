local LEGITIMACY = {} --:map<string, FACTION_RESOURCE>
local legitimacy_factions = {
    ["vik_fact_circenn"] = 15,
    ["vik_fact_mide"] = 7
} --:map<string, int>
local legitimacy_max = 30

--v function(resource: FACTION_RESOURCE) --> string
local function value_converter(resource)
    return tostring(math.floor(resource.value/6))
end
	
dev.first_tick(function(context) 
    dev.log("#### Adding Welsh Mechanics Listeners ####", "HERO")
    local humans = cm:get_human_factions()
    for i = 1, #humans do
        local h_name = humans[i]
        if legitimacy_factions[h_name] then
            local legitimacy = PettyKingdoms.FactionResource.new(h_name, "vik_legitimacy", "resource_bar", legitimacy_factions[h_name], legitimacy_max, {}, value_converter)
            LEGITIMACY[h_name] = legitimacy
        end
    end
end)

