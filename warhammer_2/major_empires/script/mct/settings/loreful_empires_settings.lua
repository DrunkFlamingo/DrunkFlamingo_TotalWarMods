local loc_prefix = "mct_loreful_empires_"
local loreful_empires = mct:register_mod("loreful_empires")
loreful_empires:set_title(loc_prefix.."mod_title", true)
loreful_empires:set_author("Drunk Flamingo")
loreful_empires:set_description(loc_prefix.."mod_desc", true)

local enable = loreful_empires:add_new_option("a_enable", "checkbox")
enable:set_default_value(true)
enable:set_text(loc_prefix.."a_enable_txt", true)
enable:set_tooltip_text(loc_prefix.."a_enable_tt", true)

loreful_empires:add_new_section("z_advanced_options", loc_prefix.."advanced_options", true)

local autoconfed = loreful_empires:add_new_option("a_autoconfed", "checkbox")
autoconfed:set_default_value(false)
autoconfed:set_text(loc_prefix.."a_autoconfed_txt", true)
autoconfed:set_tooltip_text(loc_prefix.."a_autoconfed_tt", true)

local confed_cd = loreful_empires:add_new_option("b_confed_cd", "slider")
confed_cd:set_text(loc_prefix.."b_confed_cd_txt", true)
confed_cd:set_tooltip_text(loc_prefix.."b_confed_cd_tt", true)
confed_cd:slider_set_min_max(1, 25)
confed_cd:set_default_value(10)
confed_cd:slider_set_step_size(1)

local defensive_restriction = loreful_empires:add_new_option("c_defensive_restriction", "checkbox")
defensive_restriction:set_default_value(false)
defensive_restriction:set_text(loc_prefix.."c_defensive_restriction_txt", true)
defensive_restriction:set_tooltip_text(loc_prefix.."c_defensive_restriction_tt", true)

local leader_restriction = loreful_empires:add_new_option("d_leader_restriction", "checkbox")
leader_restriction:set_default_value(false)
leader_restriction:set_text(loc_prefix.."d_leader_restriction_txt", true)
leader_restriction:set_tooltip_text(loc_prefix.."d_leader_restriction_tt", true)

local enable_for_allies = loreful_empires:add_new_option("e_enable_for_allies", "checkbox")
enable_for_allies:set_default_value(false)
enable_for_allies:set_text(loc_prefix.."e_enable_for_allies_txt", true)
enable_for_allies:set_tooltip_text(loc_prefix.."e_enable_for_allies_tt", true)

local secondary_factions = loreful_empires:add_new_option("f_secondary_factions", "dropdown")
secondary_factions:set_text(loc_prefix.."f_secondary_factions_txt", true)
secondary_factions:set_tooltip_text(loc_prefix.."f_secondary_factions_tt", true)
secondary_factions:add_dropdown_value("secondary_factions_on", "Enabled (Recommended)", "This mod will not impact battles involving secondary factions.", true)
secondary_factions:add_dropdown_value("secondary_factions_off", "Disabled", "This mod will not protect secondary factions.")
secondary_factions:add_dropdown_value("secondary_factions_major", "Treat as major", "This mod will add the secondary factions list to the major factions list.")

local options_list = {
    "a_autoconfed",
    "b_confed_cd",
    "c_defensive_restriction",
    "d_leader_restriction",
    "e_enable_for_allies",
    "f_secondary_factions"
} --:vector<string>

enable:add_option_set_callback(
    function(option) 
        local val = option:get_selected_setting() 
        --# assume val: boolean
        local options = options_list

        for i = 1, #options do
            local option_obj = option:get_mod():get_option_by_key(options[i])
            option_obj:set_uic_visibility(val)
        end
        --option:get_mod():set_section_visibility("respec_options", val)
    end
)