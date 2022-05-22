local building_storage_effects = {
    vik_granary_1 = 40,
    vik_granary_2 = 80,
    vik_souterrain_1 = 50,
    vik_souterrain_2 = 75,
    vik_souterrain_3 = 100,
    vik_warehouse_1 = 25,
    vik_warehouse_2 = 50,
    vik_warehouse_3 = 75,
    vik_fogou_1 = 50,
    vik_fogou_2 = 75,
    vik_fogou_3 = 100
}--: map<string, number>


local fs = PettyKingdoms.FoodStorage
for building, quantity in pairs(building_storage_effects) do
    fs.add_food_storage_effect_to_building(building, quantity)
end

local faction_food_storage_startpos = {
    ["vik_fact_west_seaxe"] = 86
}--:map<string, number>


dev.post_first_tick(function(context)
    local humans = cm:get_human_factions()
    if dev.is_new_game() then
        for i = 1, #humans do
            local fsm = PettyKingdoms.FoodStorage.get(humans[i])
            fsm:set_food_in_storage(faction_food_storage_startpos[humans[i]] or 0) 
            fsm:update_food_storage()
        end
    end
end)