
local mct = get_mct()
local loc_prefix = "mct_df_gnoblar_snacks_"
local mod = mct:register_mod("df_gnoblar_snacks")
mod:set_title(loc_prefix.."mod_title", true)
mod:set_author("Drunk Flamingo")
mod:set_description(loc_prefix.."mod_desc", true)

local enable = mod:add_new_option("a_enable", "checkbox")
enable:set_default_value(true)
enable:set_text(loc_prefix.."a_enable_txt", true)
enable:set_tooltip_text(loc_prefix.."a_enable_tt", true)

local meat_value = mod:add_new_option()


local meat_value = mod:add_new_option("b_meat_value", "slider")
meat_value:set_text(loc_prefix.."b_meat_value_txt", true)
meat_value:set_tooltip_text(loc_prefix.."b_meat_value_tt", true)
meat_value:slider_set_min_max(0, 20)
meat_value:set_default_value(10)
meat_value:slider_set_step_size(1)




enable:add_option_set_callback(
    function(option) 
        local val = option:get_selected_setting() 
        local meat_setting = option:get_mod():get_option_by_key("b_meat_value")
        meat_setting:set_uic_visibility(val)
    end
)