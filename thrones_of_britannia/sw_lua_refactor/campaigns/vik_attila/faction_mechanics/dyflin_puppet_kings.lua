local faction_key = "vik_fact_dyflin"
local bundle_key = "sw_fe_dylin_3_campaign_"
dev.first_tick(function(context)
    dev.eh:add_listener(
        "FactionTurnStartDyflin",
        "FactionTurnStart",
        function(context)
            return context:faction():name() == faction_key
        end,
        function(context)
            local vassal_list = PettyKingdoms.VassalTracking.get_faction_vassals(faction_key)
            local level = dev.mround(dev.clamp(#vassal_list, 0, 5), 1)
            local last_bundle = cm:get_saved_value(bundle_key..faction_key)
            local new_bundle = bundle_key..tostring(level)
            if new_bundle ~= last_bundle then
                if last_bundle and dev.get_faction(faction_key):has_effect_bundle(last_bundle) then
                    cm:remove_effect_bundle(last_bundle, faction_key)
                end
                cm:set_saved_value(bundle_key..faction_key, new_bundle)
                cm:apply_effect_bundle(new_bundle, faction_key, 0)
            end
        end,
        true
    )

end)