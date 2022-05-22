local faction_key = "vik_fact_northleode"
local global_cooldown = 0
local decrees = {
    [1] = {
        ["event"] = "sw_decree_northleode_eoferwic",
        ["duration"] = 6,
        ["gold_cost"] = -1000,
        ["currency"] = "influence",
        ["currency_cost"] = 0,
        ["cooldown"] = 10
    },
    [2] = {
        ["event"] = "sw_decree_northleode_tamworthige",
        ["duration"] = 6,
        ["gold_cost"] = -1500,
        ["currency"] = "influence",
        ["currency_cost"] = 0,
        ["cooldown"] = 10,
        ["callback"] = function(decree) --:DECREE
            --TODO confederations for northleode decree
            local faction = dev.get_faction(decree.owning_faction)
            dev.lock_confederation_for_faction(faction, false)
        end
    },
    [3] = {
        ["event"] = "sw_decree_northleode_dun_foither",
        ["duration"] = 6,
        ["gold_cost"] = -1200,
        ["currency"] = "influence",
        ["currency_cost"] = 0,
        ["cooldown"] = 10
    },
    [4] = {
        ["event"] = "sw_decree_northleode_bebbanburg",
        ["duration"] = 6,
        ["gold_cost"] = -750,
        ["currency"] = "influence",
        ["currency_cost"] = 0,
        ["cooldown"] = 10
    }
} --:map<int, {event: string, duration: number, gold_cost: number, currency: string, currency_cost: number, cooldown: number, is_dilemma: boolean?, callback: (function(decree: DECREE))?}>

local decree_conditions = {
    [1] = {
        {event = "RegionTurnStart", conditional = function(context) --:WHATEVER
            return context:region():name() == "vik_reg_eoferwic" and context:region():owning_faction():name() == faction_key
        end},
        {event = "RegionChangesOwnership", conditional = function(context) --:WHATEVER
            return  context:region():name() == "vik_reg_eoferwic" and context:region():owning_faction():name() == faction_key
        end}
    },
    [2] = {
        {event = "RegionTurnStart", conditional = function(context) --:WHATEVER
            return context:region():name() == "vik_reg_tamworthige" and context:region():owning_faction():name() == faction_key
        end},
        {event = "RegionChangesOwnership", conditional = function(context) --:WHATEVER
            return  context:region():name() == "vik_reg_tamworthige" and context:region():owning_faction():name() == faction_key
        end}
    },
    [3] = {
        {event = "RegionTurnStart", conditional = function(context) --:WHATEVER
            return context:region():name() == "vik_reg_dun_foither" and context:region():owning_faction():name() == faction_key
        end},
        {event = "RegionChangesOwnership", conditional = function(context) --:WHATEVER
            return  context:region():name() == "vik_reg_dun_foither" and context:region():owning_faction():name() == faction_key
        end}
    }
}--:map<int, vector<{event: string, conditional: (function(context: WHATEVER) --> (boolean))}>>

local decrees_can_relock = {
    [1] = {false, false},
    [2] = {false, false},
    [3] = {false, false},
    [4] = {}
} --:map<int, vector<boolean>>

dev.first_tick(function(context)

    if dev.is_new_game() then
        local faction_list = dev.faction_list()
        for i = 0, faction_list:num_items() - 1 do
            local faction = faction_list:item_at(i)
            if faction:subculture() == "vik_sub_cult_english" then
                dev.lock_confederation_for_faction(faction, true)
            end
        end
    end

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
        dev.turn_start(faction_key, function(context)
            local faction = context:faction() --:CA_FACTION
            if not faction:has_effect_bundle("sw_decree_northleode_tamworthige") then
                dev.lock_confederation_for_faction(faction, true)
            end
        end)
    end
end)

