local casualties_tech = "vik_mil_melee_4a"
local casualties_replenishment_rate_max = 30
local casualties_replenishment_rate_min = 5
local factor = "manpower_tech"
dev.first_tick(function(context)
    dev.eh:add_listener(
        "CharacterCasualtiesCachedTech",
        "CharacterCasualtiesCached",
        function(context)
            return context:character():faction():is_human() and context:character():faction():has_technology(casualties_tech) 
            and (not context:character():region():is_null_interface()) and (not context:character():region():owning_faction():is_null_interface())
            and context:character():faction():name() == context:character():region():owning_faction():name()
        end,
        function(context)
            local faction = context:faction()
            local noble_manpower = PettyKingdoms.FactionResource.get("sw_pop_noble", faction)
            local serf_manpower = PettyKingdoms.FactionResource.get("sw_pop_serf", faction)
            local nobles_rec_handler = UIScript.recruitment_handler.get_handler_for_faction_resource("sw_pop_noble") or {unit_costs = {}}
            local serf_rec_handler = UIScript.recruitment_handler.get_handler_for_faction_resource("sw_pop_serf") or {unit_costs = {}}
            local noble_list = nobles_rec_handler.unit_costs
            local serf_list = serf_rec_handler.unit_costs 
            local casualties = context:table_data() --:map<string, number>
            for unit_key, casualties_perc in pairs(casualties) do
                if noble_list[unit_key] then
                    local recovered_prop = cm:random_number(casualties_replenishment_rate_min, casualties_replenishment_rate_max)/100 * casualties_perc/100 * -1
                    local recovered = dev.mround(noble_list[unit_key]*recovered_prop, 1)
                    noble_manpower:change_value(recovered, factor)
                end
                if serf_list[unit_key] then
                    local recovered_prop = cm:random_number(casualties_replenishment_rate_min, casualties_replenishment_rate_max)/100 * casualties_perc/100 * -1
                    local recovered = dev.mround(serf_list[unit_key]*recovered_prop, 1)
                    serf_manpower:change_value(recovered, factor)
                end
            end
        end,
        false
    )


end)