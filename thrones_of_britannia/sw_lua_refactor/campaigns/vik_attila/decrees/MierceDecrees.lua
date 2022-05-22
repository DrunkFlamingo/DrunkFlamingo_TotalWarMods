local faction_key = "vik_fact_mierce"
local global_cooldown = 0
local decrees = {
    [1] = {
        ["event"] = "sw_decree_mierce_warriors",
        ["duration"] = 6,
        ["gold_cost"] = 0,
        ["currency"] = "fyrd",
        ["currency_cost"] = -1,
        ["cooldown"] = 3
    },
    [2] = {
        ["event"] = "sw_decree_mierce_lords",
        ["duration"] = 6,
        ["gold_cost"] = 0,
        ["currency"] = "fyrd",
        ["currency_cost"] = -1,
        ["cooldown"] = 3
    },
    [3] = {
        ["event"] = "sw_decree_mierce_church",
        ["duration"] = 6,
        ["gold_cost"] = 0,
        ["currency"] = "fyrd",
        ["currency_cost"] = -1,
        ["cooldown"] = 3
    },
    [4] = {
        ["event"] = "sw_decree_mierce_pay_hoards",
        ["duration"] = 0,
        ["gold_cost"] = -3000,
        ["currency"] = "fyrd",
        ["currency_cost"] = 1,
        ["cooldown"] = 0
    }
} --:map<int, {event: string, duration: number, gold_cost: number, currency: string, currency_cost: number, cooldown: number, is_dilemma: boolean?, callback: (function(decree: DECREE))?}>

local decree_conditions = {

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

