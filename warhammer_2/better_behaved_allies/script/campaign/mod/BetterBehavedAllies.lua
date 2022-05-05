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

--v function(text: string)
function BBALOG(text)
    if not __write_output_to_logfile then
        return; 
    end

    local logText = tostring(text)
    local logTimeStamp = os.date("%d, %m %Y %X")
    local popLog = io.open("warhammer_expanded_log.txt","a")
    --# assume logTimeStamp: string
    popLog :write("BBA:  [".. logTimeStamp .. "]:  "..logText .. "  \n")
    popLog :flush()
    popLog :close()
end






--v function(human_faction:CA_FACTION)
local function behave_yourselves(human_faction)
    for ally, vassals in pairs(war_restricted_allies) do
        for i = 1, #vassals do
            BBALOG("unrestricting ally ["..ally.."] and vassal ["..vassals[i].."]")
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
            BBALOG("restricting ally ["..allies[i].."] and vassal ["..vassals[j].."]")
        end
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




