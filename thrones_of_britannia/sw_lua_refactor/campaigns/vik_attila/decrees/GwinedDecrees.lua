local faction_key = "vik_fact_gwined"
local global_cooldown = 0
local decrees = {
    [1] = {
        ["event"] = "sw_decree_gwined_song_of_mead",
        ["duration"] = 12,
        ["gold_cost"] = -1250,
        ["currency"] = "heroism",
        ["currency_cost"] = -15,
        ["cooldown"] = 32,
        ["callback"] = function(decree) --:DECREE
            local owner = dev.get_faction(decree.owning_faction)
            for i = 0, owner:region_list():num_items() - 1 do
                local region = owner:region_list():item_at(i)
                if region:is_province_capital() then
                    local rm = PettyKingdoms.RiotManager.get(region:name())
                    if rm.riot_in_progress then
                        rm:end_riot(region)
                    end
                end
            end
        end
    },
    [2] = {
        ["event"] = "sw_decree_gwined_song_of_horses",
        ["duration"] = 12,
        ["gold_cost"] = -1500,
        ["currency"] = "heroism",
        ["currency_cost"] = -20,
        ["cooldown"] = 32
    },
    [3] = {
        ["event"] = "sw_decree_gwined_song_of_pendragon",
        ["duration"] = 12,
        ["gold_cost"] = -1750,
        ["currency"] = "heroism",
        ["currency_cost"] = -20,
        ["cooldown"] = 32
    },
    [4] = {
        ["event"] = "sw_decree_gwined_song_of_thousand_sons",
        ["duration"] = 12,
        ["gold_cost"] = -1000,
        ["currency"] = "heroism",
        ["currency_cost"] = -15,
        ["cooldown"] = 32

    }
} --:map<int, {event: string, duration: number, gold_cost: number, currency: string, currency_cost: number, cooldown: number, is_dilemma: boolean?, callback: (function(decree: DECREE))?}>

local decree_conditions = {
    [2] = {
        {event = "FactionTurnStart", conditional = function(context) --:WHATEVER
            return context:faction():name() == faction_key and context:faction():has_technology("vik_mil_cavalry_1")
        end}
    }
}--:map<int, vector<{event: string, conditional: (function(context: WHATEVER) --> (boolean))}>>

local decrees_can_relock = {
    [1] = {false},
    [2] = {false},
    [3] = {false},
    [4] = {false}
} --:map<int, vector<boolean>>

dev.first_tick(function(context)
    if dev.get_faction(faction_key):is_human() then
        PettyKingdoms.Decree.add_faction_handler(faction_key, global_cooldown)
        for i = 1, 4 do
            local decree_info = decrees[i]
            local entry = PettyKingdoms.Decree.add_decree(faction_key, i, decree_info.event,  decree_info.duration,  decree_info.cooldown, decree_info.gold_cost, decree_info.currency,  decree_info.currency_cost,  not not  decree_info.is_dilemma)
            if decree_info.callback then
                entry.callback = decree_info.callback
            end
            local unlock = decree_conditions[i]
            if unlock then
                local can_relock = decrees_can_relock[i]
                for j = 1, #unlock do
                    local condition = unlock[j]
                    entry:add_unlock_condition(condition.event, condition.conditional, not not can_relock[j])
                end
            else
                entry.is_locked = false;
            end
        end
    end
end)

