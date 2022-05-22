-------------------------------------------------------------------------------
-------------------- AUTOMATIC TRADE AND SHROUD REMOVAL------------------------
-------------------------------------------------------------------------------
-------------------- Created by Craig: 11/04/2017 -----------------------------
------ Modified Slightly by Drunk Flamingo for inclusion in Shieldwall---------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- This script turns off the shroud and sets up automatic trade agreements between every faction that is at peace and can trade.
-- The intention behind the trading is that it will take the micro/exploits out of trading, as well as make it feel like a more natural occurrence in the campaign.
-- By settings the global tarrifs to -100% in the difficulty modifiers table we can have full control over the potential max earnings from trade, regardless of income
-- This means there's a lot more land and naval trade available at all times for people to raid.
-- The shroud has been removed due to the increased visibility from trading, and because it doesn't make much sense for the factions not to know the lay of the land in this period.

--v function(t: any)
local function output(t)
    dev.log(tostring(t), "Shroud")
end

--v function(current_faction: CA_FACTION)
function FactionTurnStart_Trade(current_faction)
    if current_faction:is_null_interface() == false then
        if current_faction:has_home_region() == true then
            local faction_list = cm:model():world():faction_list();
            for i = 0, faction_list:num_items() - 1 do
                local second_faction = faction_list:item_at(i);
                if current_faction ~= second_faction then
                    if second_faction:unused_international_trade_route() == true then
                        --output("We found international trade routes");
                        if current_faction:is_trading_with(second_faction) == false then	
                            if current_faction:at_war_with(second_faction) == false then								
                                cm:force_make_trade_agreement(current_faction:name(), second_faction:name());
                            end
                        end
                    --else output("No international trade routes");
                    
                    end
                    
                end
            end
        end
    end
end

--v function()
function DisableShroud()
    local faction_list = cm:model():world():faction_list();
    for i = 0, faction_list:num_items() - 1 do
        local current_faction = faction_list:item_at(i);
        if current_faction:is_null_interface() == false then
            if current_faction:is_human() == true then
                local region_list = cm:model():world():region_manager():region_list();
                for i = 0, region_list:num_items() - 1 do
                    local region = region_list:item_at(i);
                   -- output("Making "..region:name() .. " visible.")
                    cm:make_region_seen_in_shroud(current_faction:name(), region:name());
                end 
            end
        end
    end
    local sea_regions = Gamedata.general.sea_regions
    for i = 1, #sea_regions do
      --  output("Making "..sea_regions[i] .. " visible.")
        cm:make_sea_region_seen_in_shroud(sea_regions[i]);
    end
end

--v function()
function Update_Fog()
    cm:make_neighbouring_regions_visible_in_shroud();
end

dev.post_first_tick(function(context)
    output("#### Adding Shroud Listeners ####")
    dev.eh:add_listener(
        "GarrisonOccupiedEvent_Shroud",
        "GarrisonOccupiedEvent",
        true,
        function(context) Update_Fog() end,
        true
    )
    dev.eh:add_listener(
        "FactionTurnStart_Shroud",
        "FactionTurnStart",
        true,
        function(context) Update_Fog() end,
        true
    )
    output("#### Adding Trade Listeners ####")
    dev.eh:add_listener(
        "FactionTurnStart_Trade",
        "FactionTurnStart",
        true,
        function(context) FactionTurnStart_Trade(context:faction()) end,
        true
    )
    if dev.is_new_game() then
        FactionTurnStart_Trade(cm:model():world():whose_turn_is_it())
    end
    Update_Fog()
    DisableShroud()
end)