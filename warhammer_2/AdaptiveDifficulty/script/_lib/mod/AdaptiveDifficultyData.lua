--this is in a seperate script in _lib to help with MCT integration


--# type global DIFFICULTY_VALUES = map<number, {
--#         max_effect: number, min_effect: number,  start_effect: number,  
--#         num_regions_required: number?,
--#         per_victory_value: number?, per_loss_value: number?,
--#         per_rebellion_defeated_value: number?,
--#         per_turn_value: number?
--#     }>

--# type global BONUS_EFFECTS = map<string, { 
--#     difficulty_values: DIFFICULTY_VALUES,
--#     effect_scope: string,
--#     subculture_whitelist: string?,
--#     faction_whitelist: string?
--#}>

--# type global ADAPTIVE_DIFFICULTY = {
--# testing_mode: boolean,
--# effect_bundle: string,
--# base_scaling_time: int,
--# turn_interval: int, 
--# minimum_significant_strenth_ratio: number,
--# enable_character_exp_bonus: boolean,
--# character_exp_turn_interval: int,
--# character_exp_first_turn: int,
--# bonus_effects:BONUS_EFFECTS
--#}

local adaptive_difficulty = {
    testing_mode = false,
    effect_bundle = "adaptive_difficulty_bonuses",
    base_scaling_time = 40, 
    -- on turn value = 1 it takes base_scaling_time turns to go from max_effect to min_effect. per_thing_values are measured in turns, with each turn being worth (max-min)/base_scaling_time
    turn_interval = 5,  
    -- applies per_turn gains every X turns instead. Doesn't change #s, updates them less often. Will bug out if base_scaling_time/turn_interval isn't an integer. 
    minimum_significant_strenth_ratio = 0.9,
    enable_character_exp_bonus = true,
    character_exp_turn_interval = 10,
    character_exp_first_turn = 20,
    bonus_effects = {
        ["wh_main_effect_force_all_campaign_upkeep"] = {
            difficulty_values = {
                [1] = {max_effect = 0, min_effect = -10, num_regions_required = 4, start_effect = 0, per_victory_value = -5, per_loss_value = 40, per_turn_value = -1},
                [2] = {max_effect = 0, min_effect = -15, num_regions_required = 3, start_effect = 0, per_victory_value = -5, per_loss_value = 30, per_turn_value = -1},
                [3] = {max_effect = 0, min_effect = -20, num_regions_required = 2, start_effect = 0, per_victory_value = -5, per_loss_value = 20, per_turn_value = -1},
                [4] = {max_effect = -5, min_effect = -30, num_regions_required = 2, start_effect = -10, per_victory_value = -7, per_loss_value = 15, per_turn_value = -1},
                [5] = {max_effect = -10, min_effect = -30, num_regions_required = 0, start_effect = -15, per_victory_value = -15, per_loss_value = 15, per_turn_value = -1}
            },
            effect_scope = "faction_to_force_own"
        },
        ["wh_main_effect_force_all_campaign_recruitment_cost_all"] = {
            difficulty_values = {
                [2] = {max_effect = -15, min_effect = -30,  start_effect = -15, per_victory_value = -5, per_loss_value = 40, per_turn_value = -2},
                [3] = {max_effect = -25, min_effect = -50,  start_effect = -35, per_victory_value = -5, per_loss_value = 30, per_turn_value = -2},
                [4] = {max_effect = -35, min_effect = -70,  start_effect = -70, per_victory_value = -7, per_loss_value = 20, per_turn_value = -2},
                [5] = {max_effect = -40, min_effect = -80,  start_effect = -80, per_victory_value = -15, per_loss_value = 20, per_turn_value = -2}
            },
            effect_scope = "faction_to_force_own"
        },
        ["wh_dlc05_effect_building_army_xp_gain"] = {
            difficulty_values = {
                [1] = {max_effect = 1, min_effect = 0, start_effect = 0, per_victory_value = 50, per_turn_value = -10},
                [2] = {max_effect = 2, min_effect = 0, start_effect = 0, per_victory_value = 50, per_turn_value = -10},
                [3] = {max_effect = 3, min_effect = 0, start_effect = 0, per_victory_value = 50, per_turn_value = -10},
                [4] = {max_effect = 5, min_effect = 1, start_effect = 1, per_victory_value = 50, per_turn_value = -10},
                [5] = {max_effect = 6, min_effect = 1, start_effect = 1, per_victory_value = 50, per_turn_value = -10}
            },
            effect_scope = "faction_to_force_own"
        },
        ["wh_main_effect_hordebuilding_growth_core"] = {
            difficulty_values = {
                [1] = {max_effect = 8, min_effect = 0, start_effect = 8, per_victory_value = 10, per_loss_value = -40, per_turn_value = -2},
                [2] = {max_effect = 10, min_effect = 5, start_effect = 10, per_victory_value = 10, per_loss_value = -30, per_turn_value = -2},
                [3] = {max_effect = 12, min_effect = 5, start_effect = 12, per_victory_value = 20, per_loss_value = -20, per_turn_value = -2},
                [4] = {max_effect = 15, min_effect = 7, start_effect = 15, per_victory_value = 40, per_loss_value = -20, per_turn_value = -2},
                [5] = {max_effect = 20, min_effect = 9, start_effect = 20, per_victory_value = 40, per_loss_value = -20, per_turn_value = -2}
            },
            effect_scope = "faction_to_force_own"
        },
        ["wh_main_effect_growth_all"] = {
            difficulty_values = {
                [1] = {max_effect = 40, min_effect = 0, start_effect = 0, per_turn_value = 1},
                [2] = {max_effect = 60, min_effect = 20, start_effect = 20, per_turn_value = 1},
                [3] = {max_effect = 90, min_effect = 30, start_effect = 30, per_turn_value = 1},
                [4] = {max_effect = 120, min_effect = 40, start_effect = 40, per_turn_value = 1},
                [5] = {max_effect = 180, min_effect = 60, start_effect = 60, per_turn_value = 1}
            },
            effect_scope = "faction_to_province_own"
        }
    } 
}--:ADAPTIVE_DIFFICULTY


return adaptive_difficulty