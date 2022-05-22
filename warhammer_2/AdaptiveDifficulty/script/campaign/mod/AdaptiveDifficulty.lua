-- notes
--[[
Idea: AI Cheats should be adaptive
    Current cheats can feel frustrating because the AI rebounds instantly from defeats. 
    However, current cheats are also insufficient to make the game truly challenging for many people.
    Solution: make AI cheats reactive to the gameplay circumstances through scripting.

#:
    Settlement Growth: wh_main_effect_growth_all - flat
        Currently 20/40/60/100/125
        New behaviour: start slow enough that the AI does not have instant access to T5s, then accelerate by the midgame.

    Horde Growth: wh_main_effect_hordebuilding_growth_core flat
        Currently 5/6/7/8/9
        New behaviour: Start very high to get the faction off the ground, decay over time. Decay instantly if defeated by a human to prevent their growth feeling inevitable.
        Victories against the player reward the horde restore some growth, it still decays over time.

    Building Cost: wh_main_effect_building_construction_cost_mod percentage
        Currently 0/-50/-60/-70/-80
        No Changes. 
    
    Recruitment Cost: wh_main_effect_force_all_campaign_recruitment_cost_all percentage
        Currently 0/-30/-50/-60/-70
        Takes a dent whenever you beat their armies for a moment. Essentially the armies the AI builds before it fights the player are highly discounted, but the armies to replace defeated ones are not.

    Upkeep Cost: wh_main_effect_force_all_campaign_upkeep
        Currently 0/0/-10/-15/-20
        Starts lower than Vanilla but rises over time to quite a bit higher. This results in the AI having larger armies.
        This is, except on Legendary, disabled for small factions in order to prevent them from maintaining overly powerful stacks while sitting in their only settlement.
        When the player defeats the AI, the AI loses part of its discount. It recovers over time. 
        This is designed to make the initial challenge of fighting a faction harder without making it as tedious or grindy to eliminate factions in the lategame. 
    Character Replenishment: wh2_main_effect_replenishment_characters percentage
        Currently 10/10/12/14/16

    Force Replenishment: wh_main_effect_force_all_campaign_replenishment_rate percentage
        Currently 3/4/5/7/9

Impl:
    cm:get_difficulty() returns 1-5
    1 is easy, 5 is legendary.

    ,
    

--]]

--utilities
local util = df_util
--v function(t: any)
local function log(t)
    util.log(tostring(t), "Difficulty")
end

local adaptive_difficulty = require("AdaptiveDifficultyData")

--script

--# assume global class AI_BONUS_HANDLER
local ai_bonus_handler = {} --# assume ai_bonus_handler: AI_BONUS_HANDLER
local faction_to_ai_bonus_handler = {} --:map<string, AI_BONUS_HANDLER>

--v function(faction: CA_FACTION, difficulty: int) --> AI_BONUS_HANDLER
function ai_bonus_handler.new(faction, difficulty)
    local self = {}
    setmetatable(self, {
        __index = ai_bonus_handler
    })--# assume self: AI_BONUS_HANDLER

    self.faction = faction
    self.bundle = cm:create_new_custom_effect_bundle(adaptive_difficulty.effect_bundle)
    self.effects = {} --:map<string, number>
    self.saved_values = {} --:map<string, number>
    self.supress_effects = {} --:map<string, boolean>
    self.difficulty = difficulty

    faction_to_ai_bonus_handler[faction:name()] = self
    return self
end

--v function(self: AI_BONUS_HANDLER)
function ai_bonus_handler.apply_effects(self)
    --reset bundle
    self.bundle = nil
    cm:remove_effect_bundle("adaptive_difficulty_bonuses", self.faction:name())
    self.bundle = cm:create_new_custom_effect_bundle(adaptive_difficulty.effect_bundle)
    --loop through intended effects, add them to the bundle, and set their values.
    for effect_key, effect_value_unrounded in pairs(self.effects) do
        local effect_scope = adaptive_difficulty.bonus_effects[effect_key].effect_scope
        if effect_scope then
            if self.supress_effects[effect_key] then
                log("Effect "..effect_key.." is supressed for "..self.faction:name().." right now.")
            else
                local rounded_value = util.mround(effect_value_unrounded, 1)
                self.bundle:add_effect(effect_key, effect_scope, rounded_value)
            end
        else
            log("No scope specified for effect_key "..effect_key.." so it cannot be assigned")
        end
    end
    cm:apply_custom_effect_bundle_to_faction(self.bundle, self.faction)
end

--v function(self: AI_BONUS_HANDLER, bonus_effect_key: string, difficulty_values: DIFFICULTY_VALUES)
function ai_bonus_handler.check_effect_supressors(self, bonus_effect_key, difficulty_values)
    local bonus_info = difficulty_values[self.difficulty]
    local num_regions = bonus_info.num_regions_required
    if num_regions then
        --# assume num_regions: number
        local region_count = self.faction:region_list():num_items()
        if self.faction:is_allowed_to_capture_territory() and region_count < num_regions then
            self.supress_effects[bonus_effect_key] = true
        end
    end
end

--v function(self: AI_BONUS_HANDLER)
function ai_bonus_handler.check_all_effects_for_supressors(self)
    local bonus_effects = adaptive_difficulty.bonus_effects
    for key, value in pairs(self.effects) do
        if bonus_effects[key] then
            self:check_effect_supressors(key, bonus_effects[key].difficulty_values)
        end
    end
end

--v function(self: AI_BONUS_HANDLER)
function ai_bonus_handler.set_to_start_values(self)
    --set upkeep
    for bonus_effect_key, bonus_data in pairs(adaptive_difficulty.bonus_effects) do
        --see if we should care about this bonus key as this faction
        if ((bonus_data.subculture_whitelist == nil) or (bonus_data.subculture_whitelist == self.faction:subculture())) 
        and ((bonus_data.faction_whitelist == nil) or (bonus_data.faction_whitelist == self.faction:name())) then
            local bonus_info = bonus_data.difficulty_values[self.difficulty]
            if not bonus_info then
                log("\t["..bonus_effect_key.."] doesn't apply to this difficulty")
            else
                self.effects[bonus_effect_key] = bonus_info.start_effect
                self:check_effect_supressors(bonus_effect_key, bonus_data.difficulty_values)
            end
        end
    end
    self:apply_effects()
end

--adjust the AI's bonuses on turn start_effect.
--v function(self: AI_BONUS_HANDLER)
function ai_bonus_handler.turn_start(self)
    log("Turn started for "..self.faction:name()..".")
    --for each bonus
    for bonus_effect_key, bonus_data in pairs(adaptive_difficulty.bonus_effects) do
        --get the settings for our difficulty
        local bonus_info = bonus_data.difficulty_values[self.difficulty]
        if not bonus_info then
            log("\t["..bonus_effect_key.."] doesn't apply to this difficulty")
        elseif bonus_info.per_turn_value ~= 0 then
            local current_value = self.effects[bonus_effect_key]
            if current_value == nil then
                log("Warning, current value was nil for effect ["..bonus_effect_key.."!")
                current_value = 0
            end
            local scale_size = bonus_info.max_effect - bonus_info.min_effect
            local change_per_turn = (scale_size / adaptive_difficulty.base_scaling_time) * (bonus_info.per_turn_value or 0)
            local changes_per_turn_interval = change_per_turn * adaptive_difficulty.turn_interval
            local new_value = util.clamp(current_value + changes_per_turn_interval, bonus_info.min_effect, bonus_info.max_effect)
            log("\t["..bonus_effect_key.."] changed from "..current_value.." to "..new_value..".")
            self.effects[bonus_effect_key] = new_value
            --see if we need to supress the effect
            self:check_effect_supressors(bonus_effect_key, bonus_data.difficulty_values)
        end
    end
    self:apply_effects()
end

--a player character was defeated in battle by the AI. 
--Respond by boosting the AI's cheats to put more pressure on the player.
--v function(self: AI_BONUS_HANDLER)
function ai_bonus_handler.won_battle_against_player(self)

    for bonus_effect_key, bonus_data in pairs(adaptive_difficulty.bonus_effects) do
        --get the settings for our difficulty
        local bonus_info = bonus_data.difficulty_values[self.difficulty]
        if not bonus_info then
            log("\t["..bonus_effect_key.."] doesn't apply to this difficulty")
        elseif bonus_info.per_victory_value ~= 0 then
            local current_value = self.effects[bonus_effect_key]
            local scale_size = bonus_info.max_effect - bonus_info.min_effect
            local change_value = (scale_size / adaptive_difficulty.base_scaling_time) * (bonus_info.per_victory_value or 0)
            local new_value = util.clamp(current_value + change_value, bonus_info.min_effect, bonus_info.max_effect)
            log(self.faction:name().." won a battle against the player")
            log("\t["..bonus_effect_key.."] changed from "..current_value.." to "..new_value..".")
            self.effects[bonus_effect_key] = new_value
            self:check_effect_supressors(bonus_effect_key, bonus_data.difficulty_values)
        end
    end

    self:apply_effects()
end


--a player character has defeated the AI in battle.
--Respond by reducing the AI's cheats for a time. 
--v function(self: AI_BONUS_HANDLER)
function ai_bonus_handler.lost_battle_to_player(self)

    for bonus_effect_key, bonus_data in pairs(adaptive_difficulty.bonus_effects) do
        --get the settings for our difficulty
        local bonus_info = bonus_data.difficulty_values[self.difficulty]
        if not bonus_info then
            log("\t["..bonus_effect_key.."] doesn't apply to this difficulty")
        elseif bonus_info.per_loss_value ~= 0 then
            local current_value = self.effects[bonus_effect_key]
            local scale_size = bonus_info.max_effect - bonus_info.min_effect
            local change_value = (scale_size / adaptive_difficulty.base_scaling_time) * (bonus_info.per_loss_value or 0)
            local new_value = util.clamp(current_value + change_value, bonus_info.min_effect, bonus_info.max_effect)
            log("\t["..bonus_effect_key.."] changed from "..current_value.." to "..new_value..".")
            self.effects[bonus_effect_key] = new_value
            self:check_effect_supressors(bonus_effect_key, bonus_data.difficulty_values)
        end
    end
    self:apply_effects()
end

--the difficulty level has changed
--respond by adjusting the difficulty bonuses
--v function(self: AI_BONUS_HANDLER)
function ai_bonus_handler.difficulty_changed(self)
    local old_difficulty = self.difficulty
    self.difficulty = cm:get_difficulty()
    log("Changing difficulty values from "..old_difficulty.." to "..self.difficulty)
    for bonus_effect_key, bonus_data in pairs(adaptive_difficulty.bonus_effects) do
        local bonus_info = bonus_data.difficulty_values[self.difficulty]
        local old_info = bonus_data.difficulty_values[old_difficulty]
        if not bonus_info then
            log("\t["..bonus_effect_key.."] doesn't apply to the new difficulty")
            self.effects[bonus_effect_key] = 0
        elseif not old_info then
            log("\t["..bonus_effect_key.."] did not apply to the old difficulty")
            self.effects[bonus_effect_key] = bonus_info.start_effect
        else
            local old_scale =  old_info.max_effect - old_info.min_effect 
            local old_value = (self.effects[bonus_effect_key] or old_info.start_effect) --
            local proportion = (old_value- old_info.min_effect)/old_scale -- 
            local scale_size = bonus_info.max_effect - bonus_info.min_effect --20
            local new_value = bonus_info.min_effect + (scale_size*proportion)  -- -20 + 20*.8 = -4
            self.effects[bonus_effect_key] = new_value
            log("\t["..bonus_effect_key.."] shifted from "..tostring(old_value).." to "..tostring(new_value))
        end
        self:check_effect_supressors(bonus_effect_key, bonus_data.difficulty_values)
    end
end


--v function()
local function apply_mct()
    local mct = core:get_static_object("mod_configuration_tool")
    if mct then
        core:add_listener(
            "obr_MctInitialized",
            "MctInitialized",
            true,
            function(context)
                local mod = mct:get_mod_by_key("adaptive_difficulty") 
                log("Checking MCT settings to import")
                --global settings
                local character_catchup = mod:get_option_by_key("character_catchup")
                local time_scale = mod:get_option_by_key("time_scale")
                local turn_interval = mod:get_option_by_key("turn_interval")
                adaptive_difficulty.enable_character_exp_bonus = character_catchup:get_finalized_setting()
                adaptive_difficulty.base_scaling_time = time_scale:get_finalized_setting()
                adaptive_difficulty.turn_interval = turn_interval:get_finalized_setting()
                character_catchup:set_read_only()
                time_scale:set_read_only()
                turn_interval:set_read_only()
                --effect settings
                for i = 1, 5 do
                    for effect_key, bonus_info in pairs(adaptive_difficulty.bonus_effects) do
                        local difficulty_info = bonus_info.difficulty_values[i]
                        if difficulty_info then
                            local key_prefix = i.."_"..effect_key
                            local max_option = mod:get_option_by_key(key_prefix.."_max")
                            local max = max_option:get_finalized_setting() --:number
                            local min_option = mod:get_option_by_key(key_prefix.."_min")
                            local min = min_option:get_finalized_setting()--:number
                            local start_option = mod:get_option_by_key(key_prefix.."_start")
                            local start = start_option:get_finalized_setting() --:number
                            if difficulty_info.max_effect ~= max then
                                difficulty_info.max_effect = max
                                log("\tImported new max_effect for key "..key_prefix)
                            end
                            if difficulty_info.min_effect ~= min then
                                difficulty_info.min_effect = min
                                log("\tImported new min_effect for key "..key_prefix)
                            end
                            if difficulty_info.start_effect ~= start then
                                difficulty_info.start_effect = start
                                log("\tImported new start_effect for key "..key_prefix)
                            end
                            max_option:set_read_only()
                            min_option:set_read_only()
                            start_option:set_read_only()
                        end
                    end
                end
            end,
            true)
    end
end

--v function()
local function init()
    log("Init")
    apply_mct()
    local ok, err = pcall(function()
        if adaptive_difficulty.testing_mode then
            log("TESTING MODE IS ACTIVE: the script will see all humans as AI and all AI as humans")
        else
            log("Normal Mode")
        end
        local loaded_effects_cache = {} --:map<string, map<string, number>>
        local highest_human_rank = 0

        cm:add_loading_game_callback(function(context)
            highest_human_rank = cm:load_named_value("highest_human_rank", 0, context)
            loaded_effects_cache = cm:load_named_value("ai_bonus_handler_save", {}, context)
            log("Loaded effects cache")
        end)
        cm:add_saving_game_callback(function(context)
            local new_cache = {} --:map<string, map<string, number>>
            for faction_key, handler in pairs(faction_to_ai_bonus_handler) do
                local saved_effects = {} --:map<string, number>
                for key, value in pairs(handler.effects) do
                    saved_effects[key] = util.mround(value, 1)
                end
                new_cache[faction_key] = saved_effects
            end
            cm:save_named_value("highest_human_rank", highest_human_rank, context)
            cm:save_named_value("ai_bonus_handler_save", new_cache, context)
            log("Saved effects Cache")
        end)

        cm:add_first_tick_callback(function()
            local difficulty = cm:get_difficulty()
            local faction_list = cm:model():world():faction_list()
            log("Game is starting with a difficulty value of "..difficulty)
            for i = 0, faction_list:num_items() - 1 do
                local current_faction = faction_list:item_at(i)
                if current_faction:is_human() == adaptive_difficulty.testing_mode then --will only create for AI in normal mode, will only create for human in testing mode.
                    local new_handler = ai_bonus_handler.new(current_faction, difficulty)
                    local loaded_values = loaded_effects_cache[current_faction:name()]
                    if loaded_values then
                        if adaptive_difficulty.testing_mode then
                            log("\tLoaded effects for "..current_faction:name())
                            for k, v in pairs(loaded_values) do
                                log("\t\tLoaded ["..k.."] at value ["..tostring(v).."]")
                            end
                        end
                        new_handler.effects = loaded_values
                        new_handler:check_all_effects_for_supressors()
                        new_handler:apply_effects()
                    else
                        new_handler:set_to_start_values()
                    end
                end
            end

            core:add_listener(
                "FactionTurnStart_AdaptiveDifficulty",
                "FactionTurnStart",
                function(context)
                    return (context:faction():is_human() == adaptive_difficulty.testing_mode) and (cm:model():turn_number() % adaptive_difficulty.turn_interval) == 0 
                end,
                function(context)
                    local faction = context:faction() --:CA_FACTION
                    local handler = faction_to_ai_bonus_handler[faction:name()]
                    if faction:name() == "rebels" then
                        return 
                    end
                    if not handler then
                        log("No handler for "..faction:name())
                        ai_bonus_handler.new(faction, difficulty):set_to_start_values()
                    end
                    handler:turn_start()
                end,
                true)
            core:add_listener(
                "CharacterCompletedBattle_AdaptiveDifficulty",
                "CharacterCompletedBattle",
                function(context)
                    return context:character():faction():is_human() == not adaptive_difficulty.testing_mode
                end,
                function(context)
                    log("Human Character Completed Battle")
                    local character = context:character() --:CA_CHAR
                    local pb = context:pending_battle()
                    local attacker_value = cm:pending_battle_cache_attacker_value();
                    local defender_value = cm:pending_battle_cache_defender_value();
                    local attacker_result = cm:model():pending_battle():attacker_battle_result();
                    local defender_result = cm:model():pending_battle():defender_battle_result();
                    local attacker_won = (attacker_result == "heroic_victory") or (attacker_result == "decisive_victory") or (attacker_result == "close_victory") or (attacker_result == "pyrrhic_victory");
                    local defender_won = (defender_result == "heroic_victory") or (defender_result == "decisive_victory") or (defender_result == "close_victory") or (defender_result == "pyrrhic_victory");
                    --human won
                    if character:won_battle() then
                        if attacker_won then
                            log("\tHuman attacker victory, ratio was: "..tostring(attacker_value/defender_value))
                        else
                            log("\tHuman defender victory, ratio was: "..tostring(defender_value/attacker_value))
                        end
                        --check that the battle was challenging enough for the player
                        if (attacker_won and ((attacker_value/defender_value) > adaptive_difficulty.minimum_significant_strenth_ratio)) or (defender_won and ((defender_value/attacker_value) > adaptive_difficulty.minimum_significant_strenth_ratio)) then
                            local enemies = cm:pending_battle_cache_get_enemies_of_char(character)
                            local factions = {} --:map<string, bool>
                            for i = 1, #enemies do
                                local current_faction = enemies[i]:faction()
                                if current_faction:name() == "rebels" then
                                    --skip 
                                elseif current_faction:is_human() == adaptive_difficulty.testing_mode then --in MP games this might happen
                                    factions[current_faction:name()] = true 
                                end
                            end 
                            for faction_name, _ in pairs(factions) do
                                local handler = faction_to_ai_bonus_handler[faction_name]
                                log("Human beat "..faction_name.." in battle, adjusting their bonuses")
                                handler:lost_battle_to_player()
                            end
                        else
                            log("Human beat an AI in battle but the AI's army wasn't large enough to be significant.")
                        end
                    else --human lost
                        local enemies = cm:pending_battle_cache_get_enemies_of_char(character)
                        local factions = {} --:map<string, bool>
                        for i = 1, #enemies do
                            local current_faction = enemies[i]:faction()
                            if current_faction:name() == "rebels" then
                                --skip 
                            elseif current_faction:is_human() == adaptive_difficulty.testing_mode then --in MP games this might happen
                                factions[current_faction:name()] = true 
                            end
                        end 
                        for faction_name, _ in pairs(factions) do
                            local handler = faction_to_ai_bonus_handler[faction_name]
                            log(faction_name.." beat human in battle, adjusting their bonuses")
                            handler:won_battle_against_player()
                        end
                    end
                end,
                true)

            core:add_listener(
                "CharacterTurnStart_AdaptiveDifficulty",
                "CharacterTurnStart",
                function(context)
                    local turn = cm:model():turn_number()
                    return ((turn%adaptive_difficulty.character_exp_turn_interval) == 0) and (turn >= adaptive_difficulty.character_exp_first_turn)
                end,
                function(context)
                    local character = context:character() --:CA_CHAR
                    local faction = character:faction() 
                    if faction:is_human() == adaptive_difficulty.testing_mode then
                        if character:rank() < highest_human_rank then
                            cm:add_agent_experience(cm:char_lookup_str(character), 1, true)
                        end
                    else
                        if character:rank() > highest_human_rank then
                            highest_human_rank = character:rank()
                        end
                    end
                end,
                true)
            core:add_listener(
                "NominalDifficultyLevelChangedEvent_AdaptiveDifficulty",
                "NominalDifficultyLevelChangedEvent",
                true,
                function(context)
                    local faction_list = cm:model():world():faction_list()
                    log("Difficulty level changed")
                    for i = 0, faction_list:num_items() - 1 do
                        local current_faction = faction_list:item_at(i)
                        local handler = faction_to_ai_bonus_handler[current_faction:name()]
                        if handler then
                            handler:difficulty_changed()
                        end
                    end
                end,
                true)
            log("Listeners added successfully")
        end)
    end)
end

init()