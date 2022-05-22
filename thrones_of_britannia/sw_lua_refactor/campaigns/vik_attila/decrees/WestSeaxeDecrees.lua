local faction_key = "vik_fact_west_seaxe"
local global_cooldown = 0
local decrees = {
    [1] = {
        ["event"] = "sw_decree_wessex_ad_hoc_levy",
        ["duration"] = 6,
        ["gold_cost"] = -1500,
        ["currency"] = "influence",
        ["currency_cost"] = -1,
        ["cooldown"] = 20,
        ["callback"] = function(decree) --:DECREE
            local owner = dev.get_faction(decree.owning_faction)
            for i = 0, owner:character_list():num_items() - 1 do
                local char = owner:character_list():item_at(i)
                if dev.is_char_normal_general(char) then
                    cm:replenish_action_points(dev.lookup(char))
                end
            end
        end
    },
    [2] = {
        ["event"] = "sw_decree_wessex_fyrd",
        ["duration"] = 6,
        ["gold_cost"] = -1200,
        ["currency"] = "influence",
        ["currency_cost"] = -1,
        ["cooldown"] = 20
    },
    [3] = {
        ["event"] = "sw_decree_wessex_scholarship",
        ["duration"] = 6,
        ["gold_cost"] = -1000,
        ["currency"] = "influence",
        ["currency_cost"] = -1,
        ["cooldown"] = 20
    },
    [4] = {
        ["event"] = "sw_decree_wessex_witan",
        ["duration"] = 6,
        ["gold_cost"] = -250,
        ["currency"] = "influence",
        ["currency_cost"] = -2,
        ["cooldown"] = 20,
        ["callback"] = function(decree) --:DECREE
            decree.handler.zero_cost_turns = 10
        end
    }
} --:map<int, {event: string, duration: number, gold_cost: number, currency: string, currency_cost: number, cooldown: number, is_dilemma: boolean?, callback: (function(decree: DECREE))?}>

local decree_conditions = {
    [1] = {
        {event = "FactionTurnStart", conditional = function(context) --:WHATEVER
            return context:faction():name() == faction_key and  cm:model():season() < 2
        end}
    },
    [2] = {
        {event = "FactionTurnStart", conditional = function(context) --:WHATEVER
                return context:faction():name() == faction_key and cm:model():season() < 2
        end}
    },
    [3] = {
        {event = "RegionTurnStart", conditional = function(context) --:WHATEVER
            return context:region():owning_faction():name() == faction_key and context:region():building_exists("vik_court_school_3")
        end}
    },
    [4] = {
        {event = "FactionTurnStart", conditional = function(context) --:WHATEVER
            return context:faction():name() == faction_key and not context:faction():has_effect_bundle("vik_english_peasant_negative")
        end}
    }
}--:map<int, vector<{event: string, conditional: (function(context: WHATEVER) --> (boolean))}>>

local decrees_can_relock = {
    [1] = {true},
    [2] = {true},
    [3] = {false},
    [4] = {true}
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

