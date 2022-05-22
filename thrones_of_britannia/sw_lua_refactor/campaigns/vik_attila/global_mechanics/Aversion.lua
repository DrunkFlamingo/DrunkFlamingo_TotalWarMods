local bundles = {
	["vik_sub_cult_anglo_viking"] = "zsw_diplomacy_all_gva",
	["vik_sub_cult_viking_gael"] = "zsw_diplomacy_all_vsk",
	["vik_sub_cult_english"] = "zsw_diplomacy_all_sax",
	["vik_sub_cult_irish"] = "zsw_diplomacy_all_iri",
	["vik_sub_cult_welsh"] = "zsw_diplomacy_all_welsh",
	["vik_sub_cult_scots"] = "zsw_diplomacy_all_scots",
	["vik_sub_cult_viking"] = "zsw_diplomacy_all_invaders",
}--:map<string, string>


dev.pre_first_tick(function(context)
    local local_faction = dev.get_faction(cm:get_local_faction(true))
    UIScript.effect_bundles.remove_exact_bundle(bundles[local_faction:subculture()])
    local faction_list = dev.faction_list()
    if dev.is_new_game() then
        for i = 0, faction_list:num_items() - 1 do
            local faction = faction_list:item_at(i)
            cm:apply_effect_bundle(bundles[faction:subculture()], faction:name(), 0)
        end
    end 
    dev.eh:add_listener(
        "FactionTurnStartDiplo",
        "FactionTurnStart",
        function(context)
            local faction = context:faction()
            return faction:name() ~= "rebels" and  (not faction:is_dead()) and (not faction:has_effect_bundle(bundles[faction:subculture()]))
        end,
        function(context)
            local faction = context:faction()
            cm:apply_effect_bundle(bundles[faction:subculture()], faction:name(), 0)
        end,
        true)

end)