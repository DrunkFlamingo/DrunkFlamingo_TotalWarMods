local out = function (t)
    ModLog("DrunkFlamingo: " .. t.."(df_better_behaved_allies.lua)")
end


war_restricted_allies = {} --:map<string, vector<string>>


cm:add_saving_game_callback(
    function(context)
        cm:save_named_value("betterbehavedallies", war_restricted_allies, context)
    end
)

cm:add_loading_game_callback(
    function(context)
        war_restricted_allies = cm:load_named_value("betterbehavedallies", {}, context)
    end
)








--v function(human_faction:CA_FACTION)
local function behave_yourselves(human_faction)
    for ally, vassals in pairs(war_restricted_allies) do
        for i = 1, #vassals do
            out("unrestricting ally ["..ally.."] and vassal ["..vassals[i].."]")
            cm:force_diplomacy("faction:"..ally, "faction:"..vassals[i], "war", true, true, false)
        end
    end
    war_restricted_allies = {}
    local vassals = {} --:vector<string>
    local allies = {} --:vector<string>
    local factions_met = human_faction:factions_met()
    for i = 0, factions_met:num_items() - 1 do
        local current = factions_met:item_at(i)
        if human_faction:allied_with(current) then
            if not current:is_dead() then
                table.insert(allies, current:name())
            end
        end
        if current:is_vassal_of(human_faction) then
            if not current:is_dead() then
                table.insert(vassals, current:name())
            end
        end
    end
    for i = 1, #allies do
        war_restricted_allies[allies[i]] = vassals
        for j = 1, #vassals do
            cm:force_diplomacy("faction:"..allies[i], "faction:"..vassals[j], "war", false, false, false)
            out("restricting ally ["..allies[i].."] and vassal ["..vassals[j].."]")
        end
    end
end

function df_better_behaved_allies()
    local humans = cm:get_human_factions()
    for i = 1, #humans do
        local current = cm:get_faction(humans[i])
        if current and current:is_factions_turn() then
            behave_yourselves(current)
        end
    end
    core:add_listener(
        "BetterBehavedAlliesCore",
        "FactionTurnStart",
        function(context)
            return context:faction():is_human()
        end,
        function(context)
            behave_yourselves(context:faction())
        end,
        true)
end


--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update
--update




