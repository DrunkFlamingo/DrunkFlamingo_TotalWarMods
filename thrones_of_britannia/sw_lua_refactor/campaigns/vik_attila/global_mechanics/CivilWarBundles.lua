local faction_civil_wars = {
    ["vik_fact_mierce"] = "vik_fact_separatists_mierce",
	["vik_fact_west_seaxe"] = "vik_fact_separatists_west_seaxe",
	["vik_fact_sudreyar"] = "vik_fact_separatists_sudreyar",
	["vik_fact_dyflin"] = "vik_fact_separatists_dyflin",
	["vik_fact_east_engle"] = "vik_fact_separatists_east_engle",
	["vik_fact_northymbre"] = "vik_fact_separatists_northymbre",
	["vik_fact_circenn"] = "vik_fact_separatists_circenn",
	["vik_fact_mide"] = "vik_fact_separatists_mide",
	["vik_fact_strat_clut"] = "vik_fact_separatists_strat_clut",
	["vik_fact_gwined"] = "vik_fact_separatists_gwined"	,
    ["vik_fact_northleode"] = "vik_fact_separatists_english"
} --:map<string, string>

local civil_war_bundle = "vik_civil_war_effects"


dev.first_tick(function(context)
    dev.eh:add_listener(
        "FactionTurnStartCivilWar",
        "FactionTurnStart",
        function(context) return not not faction_civil_wars[context:faction():name()] end,
        function(context)
            local faction = context:faction() --:CA_FACTION
            if faction:has_effect_bundle(civil_war_bundle) then
                local faction_to_check = faction_civil_wars[faction:name()]
                if faction_to_check then
                    if dev.get_faction(faction_to_check):is_dead() then
                        cm:remove_effect_bundle(civil_war_bundle, faction:name())
                    end
                end
            end
        end,
        true)
    for faction_key, civil_war_faction_key in pairs(faction_civil_wars) do
        dev.eh:add_listener(
            "FactionDestroyedCivilWar",
            "FactionDestroyed",
            function(context) return context:faction():name() == civil_war_faction_key end,
            function(context)
                local faction = dev.get_faction(faction_key)
                if faction:has_effect_bundle(civil_war_bundle) then
                    cm:remove_effect_bundle(civil_war_bundle, faction_key)
                end
            end,
            true)
    end
end)