local adaptive_difficulty = require("AdaptiveDifficultyData")


local function mround(num, mult)
    --round num to the nearest multiple of num
    return (math.floor((num/mult)+0.5))*mult
end

local function setup_mct()
    local loc_prefix = "mct_diff_"
    local mod = mct:register_mod("adaptive_difficulty")

    mod:set_title(loc_prefix.."mod_title", true)
    mod:set_description(loc_prefix.."mod_desc", true)
    mod:set_author("DrunkFlamingo")

    mod:add_new_section("0_a_global_settings", loc_prefix.."global_settings", true)

    local character_catchup = mod:add_new_option("character_catchup", "checkbox")
    character_catchup:set_text(loc_prefix.."character_catchup_title", true)
    character_catchup:set_tooltip_text(loc_prefix.."character_catchup_tt", true)
    character_catchup:set_default_value(adaptive_difficulty.enable_character_exp_bonus)

    local time_scale = mod:add_new_option("time_scale", "slider")
   
    time_scale:set_text(loc_prefix.."time_scale_title", true)
    time_scale:set_tooltip_text(loc_prefix.."time_scale_tt", true)
    time_scale:slider_set_min_max(5, 80)
    
    local turn_interval = mod:add_new_option("turn_interval", "slider")
    turn_interval:set_text(loc_prefix.."turn_interval_title", true)
    turn_interval:set_tooltip_text(loc_prefix.."turn_interval_tt", true)
    turn_interval:slider_set_min_max(1, 10)
    turn_interval:slider_set_step_size(1)
    turn_interval:set_default_value(adaptive_difficulty.turn_interval)

    time_scale:slider_set_step_size(adaptive_difficulty.turn_interval)
    time_scale:set_default_value(adaptive_difficulty.base_scaling_time)
    turn_interval:add_option_set_callback(function(option)
        local value = option:get_selected_setting()
        local time_scale_value = mround(time_scale:get_selected_setting(), value)
        time_scale:slider_set_step_size(value)
        time_scale:set_selected_setting(time_scale_value)
    end)

    mod:add_new_section("0_difficulty_selector_section", loc_prefix.."selector_section", true)
    local difficulty = mod:add_new_option("difficulty_selector", "slider")
    difficulty:set_text(loc_prefix.."difficulty_selector_title", true)
    difficulty:set_tooltip_text(loc_prefix.."difficulty_selector_tt", true)
    difficulty:slider_set_min_max(1, 5)
    difficulty:slider_set_step_size(1)
    difficulty:set_default_value(2)
    for i = 1, 5 do
        for effect_key, effect_info in pairs(adaptive_difficulty.bonus_effects) do
        
            local difficulty_info = effect_info.difficulty_values[i] 
            if difficulty_info then
                local sect_key = i.."_"..effect_key
                local section_loc = "If you see this I'm shit at scripting"
                --we can't assemble this string during campaign loadup without crashing the game.
                if __game_mode ~= __lib_type_campaign then
                    section_loc = effect.get_localised_string(loc_prefix.."difficulty_"..i)..": ".. effect.get_localised_string("effects_description_"..effect_key)
                elseif cm then
                    cm:add_first_tick_callback(function()
                        section_loc = effect.get_localised_string(loc_prefix.."difficulty_"..i)..": ".. effect.get_localised_string("effects_description_"..effect_key)
                        mod:get_section_by_key(sect_key):set_localised_text(section_loc)
                    end)
                end
                local section = mod:add_new_section(sect_key, section_loc)
                --main options
                local max = mod:add_new_option(sect_key.."_max", "slider")
                max:set_text(loc_prefix.."option_max_effect_title", true)
                max:set_tooltip_text(loc_prefix.."option_max_effect_tt", true)
                max:slider_set_min_max(difficulty_info.min_effect, 250)
                max:slider_set_step_size(1)
                max:set_default_value(difficulty_info.max_effect)

                local min = mod:add_new_option(sect_key.."_min", "slider")
                min:set_text(loc_prefix.."option_min_effect_title", true)
                min:set_tooltip_text(loc_prefix.."option_min_effect_tt", true)
                min:slider_set_min_max(-100, difficulty_info.max_effect)
                min:slider_set_step_size(1)
                min:set_default_value(difficulty_info.min_effect)

                local start = mod:add_new_option(sect_key.."_start", "slider")
                start:set_text(loc_prefix.."option_start_effect_title", true)
                start:set_tooltip_text(loc_prefix.."option_start_effect_tt", true)
                start:slider_set_min_max(difficulty_info.min_effect, difficulty_info.max_effect)
                start:slider_set_step_size(1)
                start:set_default_value(difficulty_info.start_effect)

                max:add_option_set_callback(function(option) 
                    local max_val = option:get_selected_setting()
                    local start_val = start:get_selected_setting()
                    if start_val > max_val then
                        start:set_selected_setting(max_val)
                    end
                    start:slider_set_min_max(min:get_selected_setting(), max_val)
                    min:slider_set_min_max(-100, max_val)
                end)
                min:add_option_set_callback(function(option) 
                    local min_val = option:get_selected_setting()
                    local start_val = start:get_selected_setting()
                    if start_val < min_val then
                        start:set_selected_setting(min_val)
                    end
                    start:slider_set_min_max(min_val, max:get_selected_setting())
                    max:slider_set_min_max(min_val, 250)
                end)
                section:set_visibility(i == difficulty:get_selected_setting())
            end
        end
    end


    difficulty:add_option_set_callback(function(option) 
        local val = option:get_selected_setting() 
        --# assume val: number
        for i = 1, 5 do
            for effect_key, effect_info in pairs(adaptive_difficulty.bonus_effects) do
                local difficulty_info = effect_info.difficulty_values[i] 
                if difficulty_info then
                    local sect_key = i.."_"..effect_key
                    local section = mod:get_section_by_key(sect_key)
                    section:set_visibility(i==val)           
                end
            end
        end
    end)
end

setup_mct()
