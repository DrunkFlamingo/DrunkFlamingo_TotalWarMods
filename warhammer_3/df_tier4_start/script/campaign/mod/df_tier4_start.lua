local out = function(t)
    ModLog("DRUNKFLAMINGO: "..tostring(t).." (T4 Start)")
end



cm:add_first_tick_callback_new(function ()
    local region_list = cm:model():world():region_manager():region_list()
    out("its a new game, doing our thing")
    for i = 0, region_list:num_items() - 1 do
        local region = region_list:item_at(i)
        if not region:is_abandoned() then
            cm:instantly_set_settlement_primary_slot_level(region:settlement(), 4)
            local slot_list = region:settlement():slot_list()
            if slot_list:num_items() > 1 then
                for j = 1, slot_list:num_items() - 1 do
                    local slot = slot_list:item_at(j)
                    if slot:has_building() then
                        local building_key = slot:building():name()
                        local upgrade_key = building_key
                        while #cm:get_building_level_upgrades(upgrade_key) > 0 do
                            upgrade_key = cm:get_building_level_upgrades(upgrade_key)[1]
                        end
                        cm:instantly_upgrade_building_in_region(slot, upgrade_key)
                    end
                end
            end
        end
    end
    local faction_list = cm:model():world():faction_list()
    for i = 0, faction_list:num_items() - 1 do
        local faction = faction_list:item_at(i) 
        local quantity = get_factions_bonus_value(faction, "start_tfour_extra_money") or 0
        cm:treasury_mod(faction:name(), quantity)
    end
end)