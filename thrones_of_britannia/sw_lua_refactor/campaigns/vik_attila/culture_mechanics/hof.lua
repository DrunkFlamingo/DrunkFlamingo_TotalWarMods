local hof_key = "vik_hof"
local hof_dilemma = "sw_hof_"
local sc_key = "vik_sub_cult_viking_gael"

local events = dev.GameEvents

local cooldowns = {
    [1] = 40,
    [2] = 30,
    [3] = 25,
    [4] = 20,
    [5] = 18,
    [6] = 15,
    [7] = 12
} --:map<int, int>
 --after this its always 10. 

--v function(hof_count: int) --> int
local function get_cooldown(hof_count)
    return cooldowns[hof_count] or 10
end

--v function(region_list: CA_REGION_LIST) --> int
local function count_hofs(region_list)
    local count = 0
    for i = 0, region_list:num_items() - 1 do
        if region_list:item_at(i):building_superchain_exists(hof_key) then
            count = count + 1;
        end
    end
    return count
end

local hofs = {

}--:map<string, number>

dev.first_tick(function(context) 
    if dev.is_new_game() then
        local players = cm:get_human_factions()
        for i = 1, #players do hofs[players[i]] = 1 end
    end
    dev.eh:add_listener(
        "Hofs",
        "FactionTurnStart",
        function(context)
            return context:faction():is_human() and context:faction():subculture() == sc_key
        end,
        function(context)
          
            local faction = context:faction()
            local region_list = faction:region_list()
            if not context:faction():faction_leader():has_trait("shield_heathen_pagan") then
                cm:add_restricted_building_level_record_for_faction(faction:name(), hof_key)
                hofs[faction:name()] = 999
                return
            elseif hofs[faction:name()] == 999 then --they are pagan, unlock the building
                cm:remove_restricted_building_level_record_for_faction(faction:name(), hof_key)
            end
            local count = count_hofs(region_list)
            if count == 0 then
                return
            end
            local cooldown_current = hofs[faction:name()] or 0
            local target = get_cooldown(count)
            if cooldown_current > target then hofs[faction:name()] = (target - 3) elseif hofs[faction:name()] > 0 then
                hofs[faction:name()] = cooldown_current - 1
            end
        end,
        true
    )
    local hof_events = events:create_new_condition_group("HofBuildingEvents", function(context)
        local faction = context:region():owning_faction()
        return hofs[faction:name()] == 0 
    end)


    hof_events:set_number_allowed_in_queue(1)
    hof_events:add_callback(function(context)
        local faction = context:faction()
        local cd = get_cooldown(count_hofs(faction:region_list()))
        hofs[faction:name()] = cd 
    end)

    events:register_condition_group(hof_events, "RegionTurnStart")
    for i = 1, 4 do
        local event = events:create_event(hof_dilemma.. i .."_" , "dilemma", "concatenate_region")
        event:join_groups("ProvinceCapitals", "HofBuildingEvents")
    end
end)



dev.Save.attach_to_table(hofs, "hof_cd")