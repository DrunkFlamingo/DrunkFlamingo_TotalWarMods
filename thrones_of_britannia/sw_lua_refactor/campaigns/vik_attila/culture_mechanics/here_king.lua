local HK = {} --:map<string, {FACTION_RESOURCE, FACTION_RESOURCE}>
local hk_cap = 6
local here_king_factions = {
    ["vik_fact_east_engle"] = 3,
    ["vik_fact_northymbre"] = 4
} --:map<string, int>

local here_king_foreigner_manpower_factor = "foreigners_faction_leader" --:string

local hk_value_to_foreigners = {
    [1] = 0,
    [2] = 0,
    [3] = 80,
    [4] = 120,
    [5] = 240,
    [6] = 600
}--:map<int, int>

--v function(resource: FACTION_RESOURCE) --> string
local function value_converter_sax(resource)
    if resource.value <= 3 then
        return tostring(4-resource.value)
    else
        return "0"
    end
end

--v function(resource: FACTION_RESOURCE) --> string
local function value_converter_dan(resource)
    if resource.value >= 4 then
        return tostring(resource.value-3)
    else
        return "0"
    end
end

--v function(faction: string, quantity: int | boolean, cause: string)
local function mod_here_king(faction, quantity, cause)
    if not HK[faction] then
        return
    end
    local sax = HK[faction][1]
    local dan = HK[faction][2]
    local q = quantity if type(q) == "boolean" then q = (dan:get_factor(cause) * -1) end --# assume q: int
    local old_value = sax.value
    local new_value = old_value + q
    if not quantity then
        dev.log("Modifying Here King for ["..faction.."] by wiping out cause: ["..cause.."] which has quantity: ["..tostring(dan:get_factor(cause)).."] ", "HERE_KING")
    else
        dev.log("Modifying Here King for ["..faction.."] by modifying cause: ["..cause.."] by quantity: ["..q.."] ", "HERE_KING")
    end
    local old_factor = dan:get_factor(cause)
    local new_factor = old_factor + q
    dan:set_factor(cause, q)
    sax:set_factor(cause, -1*q)
    sax:set_new_value(new_value)
    dan:set_new_value(new_value)
end


--v function(player_faction: CA_FACTION)
local function here_king_turn(player_faction)
    if not HK[player_faction:name()] then
        return
    end
    local wars = 0;
	for i = 0, cm:model():world():faction_list():num_items() - 1 do
		local current_faction = cm:model():world():faction_list():item_at(i);
        if current_faction:subculture() ~= "vik_sub_cult_viking" and player_faction:name() ~= current_faction:name() then
			if player_faction:at_war_with(current_faction) then
				wars = wars + 1;
			end
		end
    end
    local treaties = 0;
	for i = 0, cm:model():world():faction_list():num_items() - 1 do
		local current_faction = cm:model():world():faction_list():item_at(i);
        if current_faction:subculture() == "vik_sub_cult_english" and player_faction:name() ~= current_faction:name() then
			if current_faction:allied_with(player_faction) or current_faction:is_vassal_of(current_faction) then
				treaties = treaties + 1;
			end
		end
    end
    mod_here_king(player_faction:name(), false, "culture_war")
    mod_here_king(player_faction:name(), false, "culture_peace")
    mod_here_king(player_faction:name(), dev.mround(dev.clamp(wars/2, 0, 2), 1), "culture_war")
    mod_here_king(player_faction:name(), dev.mround(dev.clamp(treaties/-2, -2, 0), 1), "culture_peace")
    dev.log("Here King English: "..tostring(HK[player_faction:name()][1].value), "HERE_KING")
    dev.log("Here King Army: "..tostring(HK[player_faction:name()][2].value), "HERE_KING")
end

dev.first_tick(function(context) 
    local humans = cm:get_human_factions()
    for i = 1, #humans do
        local h_name = humans[i]
        local current_human = dev.get_faction(h_name)
        if not not here_king_factions[h_name] then
            local hk_sax = PettyKingdoms.FactionResource.new(h_name, "vik_here_king_english", "faction_focus", here_king_factions[h_name], hk_cap, {}, value_converter_sax)
            local hk_dan = PettyKingdoms.FactionResource.new(h_name, "vik_here_king_army", "faction_focus", here_king_factions[h_name], hk_cap, {}, value_converter_dan)
            HK[h_name] = {hk_sax, hk_dan}
            if dev.is_new_game() and MANPOWER_FOREIGN[h_name] then
                MANPOWER_FOREIGN[h_name]:set_factor(here_king_foreigner_manpower_factor, hk_value_to_foreigners[here_king_factions[h_name]])
                MANPOWER_FOREIGN[h_name]:reapply()
            end
        end
       
    end

    dev.eh:add_listener("HereKingTurnStart", "FactionTurnStart", function(context) return not not HK[context:faction():name()] end, function(context) here_king_turn(context:faction()) end, true)


end)