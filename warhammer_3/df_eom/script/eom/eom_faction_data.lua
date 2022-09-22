---@class EOM_DATA_FACTION
local default_entry = {
    key = "wh_main_emp_empire",
    --- which factions can be selected to feud with this faction?
    potential_rivals = {}, ---@type string[]
    --- what is the fealty value at the start of the game?
    base_fealty = 0, ---@type integer
    --- can this faction lead a civil war?
    can_lead_civil_war = false, ---@type boolean
    --- when this faction runs out of Fealty, should they always trigger a civil war instead of rebelling on their own?
    always_triggers_civil_war = false, ---@type boolean
    --- what state does this faction start in.
    starting_state = "normal" ---@type EOM_FACTION_STATE
} 

local faction_data = {
    ["wh_main_emp_empire"] = {
        key = "wh_main_emp_empire",
        potential_rivals = {"wh_main_emp_middenland", "wh_main_emp_talabecland", "wh_main_emp_averland"},
        can_lead_civil_war = true,
        always_triggers_civil_war = true,
        starting_state = "emperor"
    },
    ["wh_main_emp_averland"] = {
        key = "wh_main_emp_averland",
        potential_rivals = {"wh_main_emp_stirland", "wh_main_emp_wissenland"},
        base_fealty = 4,
        can_lead_civil_war = true,
        always_triggers_civil_war = false,
        starting_state = "normal"
    },
    ["wh_main_emp_hochland"] = {
        key = "wh_main_emp_hochland",
        potential_rivals = {"wh_main_emp_talabecland", "wh_main_emp_ostland"},
        base_fealty = 4,
        can_lead_civil_war = false,
        always_triggers_civil_war = false,
        starting_state = "normal"
    },
    ["wh_main_emp_middenland"] = {
        key = "wh_main_emp_middenland",
        potential_rivals = {"wh_main_emp_talabecland", "wh_main_emp_wissenland", "wh_main_emp_empire"},
        base_fealty = 2,
        can_lead_civil_war = false,
        always_triggers_civil_war = false,
        starting_state = "normal"
    },
    ["wh_main_emp_nordland"] = {
        key = "wh_main_emp_nordland",
        potential_rivals = {"wh_main_emp_ostland", "wh_main_emp_hochland", "wh_main_emp_empire"},
        base_fealty = 3,
        can_lead_civil_war = false,
        always_triggers_civil_war = false,
        starting_state = "normal"
    },
    ["wh_main_emp_ostermark"] = {
        key = "wh_main_emp_ostermark",
        potential_rivals = {"wh_main_emp_ostland", "wh_main_emp_talabecland"},
        base_fealty = 3,
        can_lead_civil_war = false,
        always_triggers_civil_war = false,
        starting_state = "normal"
    },
    ["wh_main_emp_ostland"] = {
        key = "wh_main_emp_ostland",
        potential_rivals = {"wh_main_emp_stirland", "wh_main_emp_averland"},
        base_fealty = 5,
        can_lead_civil_war = false,
        always_triggers_civil_war = false,
        starting_state = "normal"
    },
    ["wh_main_emp_stirland"] = {
        key = "wh_main_emp_stirland",
        potential_rivals = {"wh_main_emp_nordland", "wh_main_emp_wissenland"},
        base_fealty = 5,
        can_lead_civil_war = false,
        always_triggers_civil_war = false,
        starting_state = "normal"
    },
    ["wh_main_emp_talabecland"] = {
        key = "wh_main_emp_talabecland",
        potential_rivals = {"wh_main_emp_middenland", "wh_main_emp_wissenland"},
        base_fealty = 4,
        can_lead_civil_war = true,
        always_triggers_civil_war = false,
        starting_state = "normal"
    },
    ["wh_main_emp_wissenland"] = {
        key = "wh_main_emp_wissenland",
        potential_rivals = {"wh_main_emp_middenland", "wh_main_emp_talabecland", "wh_main_emp_averland"},
        base_fealty = 7,
        can_lead_civil_war = true,
        always_triggers_civil_war = true,
        starting_state = "normal"
    }
} ---@type table<string, EOM_DATA_FACTION>


for field_name, default_data in pairs(default_entry) do
    for faction_key, faction_data in pairs(faction_data) do
        if faction_data[field_name] == nil then
            faction_data[field_name] = default_data
        end
    end
end

return faction_data