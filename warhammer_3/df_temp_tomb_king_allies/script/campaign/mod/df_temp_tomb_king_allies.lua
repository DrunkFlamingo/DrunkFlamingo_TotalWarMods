
local out = function (t)
    ModLog("DrunkFlamingo: "..tostring(t).." (temp tomb king ally fix)")
end

local faction_effects_to_grant = {}
local unit_cap_effect_partial_match = "effect_unit_cap"

function apply_apply_unit_cap_bundle(effects_to_grant, owner)
    local bundle = cm:create_new_custom_effect_bundle("df_grant_outpost_owner_unit_cap_effects")
    bundle:set_duration(0)
    for effect_key, value in pairs(effects_to_grant) do
        bundle:add_effect(effect_key, "faction_to_faction_own", value)
    end
    cm:apply_custom_effect_bundle_to_faction(bundle, owner)
end


---check all buildings in the region with an outpost for unit capacity effects
---then apply those effects to a faction scope custom effect bundle.
---@param region_with_outpost REGION_SCRIPT_INTERFACE
---@param owner FACTION_SCRIPT_INTERFACE
function grant_outpost_owner_unit_cap_effects(region_with_outpost, owner)
    out("grant_outpost_owner_unit_cap_effects: "..region_with_outpost:name() .. " " .. owner:name())
    local effects_to_grant = faction_effects_to_grant[owner:name()]
    local slot_list = region_with_outpost:slot_list()
    for i = 0, slot_list:num_items() - 1 do
        local slot = slot_list:item_at(i)
        if slot:has_building() then
            local building = slot:building()
            out("Checking effects for building: "..building:name())
            local building_effects = building:effects()
            for j = 0, building_effects:num_items() - 1 do
                local effect = building_effects:item_at(j)
                if not not string.find(effect:key(), unit_cap_effect_partial_match) then
                   effects_to_grant[effect:key()] = (effects_to_grant[effect:key()] or 0) + effect:value() 
                   out("grant_outpost_owner_unit_cap_effects: "..effect:key().." "..effect:value())
                end
            end
        end
    end
end

---@param faction FACTION_SCRIPT_INTERFACE
function check_faction_outposts(faction)
    out("Checking faction ally outposts for faction: "..faction:name())
    faction_effects_to_grant[faction:name()] = {}
    local faction_allies = faction:factions_allied_with()
    out("They have "..faction_allies:num_items().." allies")
    local n = 0
    for i = 0, faction_allies:num_items() - 1 do
        local faction_interaction_id = faction:name().."."..faction_allies:item_at(i):name()
        out("Trying to find the interaction: "..faction_interaction_id)
        local settlement_key = common.get_context_value("CcoCampaignFactionInteraction", faction_interaction_id, "AlliedBuildingsContext.AlliedSettlementContext.RegionRecordKey")
        if settlement_key ~= nil then
            out("Found an outpost at "..settlement_key.." for faction "..faction:name().." and ally "..faction_allies:item_at(i):name())
            n = n + 1
            grant_outpost_owner_unit_cap_effects(cm:get_region(settlement_key), faction)
        end
    end
    out("Found "..n.." outposts for faction "..faction:name())
    apply_apply_unit_cap_bundle(faction_effects_to_grant[faction:name()], faction)
end

cm:add_first_tick_callback(function()
    ---on region turn start, check if there are any foreign slots for the current region.
    ---check if they are using the outpost slot template, then call grant_outpost_owner_unit_cap_effects()
    core:add_listener(
        "TombKingAllyShit",
        "FactionTurnStart",
        function (context)
            return not (context:faction():name() == "rebels")
        end,
        function (context)
            local ok, err = pcall(function ()
                check_faction_outposts(context:faction())
            end)
            if not ok then
                out("Error in check_faction_outposts: "..err)
            end
        end,
        true
    )
    local ok, err = pcall(function ()
        local humans = cm:get_human_factions()
        for i = 1, #humans do
            local human_faction = cm:get_faction(humans[i])
            check_faction_outposts(human_faction)
        end
    end)
    if not ok then
        out("Error in check_faction_outposts: "..err)
    end

    out("Added TK ally outpost checker")
end)