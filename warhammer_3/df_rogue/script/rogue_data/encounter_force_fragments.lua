--fragments should be between 2 and 4 units.


local mandatory_unit_entry = {unit_key = "", quantity = 0, unit_upgradable_effect_keys = {}} ---@class ROGUE_MANDATORY_UNIT_DATA

---@class ROGUE_FORCE_FRAGMENT_DATA
template_fragment_key = {
    id = template_fragment_key,
    internal_description = "this is the template entry for a fragment",
    mandatory_units = {
        {
            unit_key = "",
            quantity = 0,
            unit_upgradable_effect_keys = {} 
        },
    }, ---@class ROGUE_MANDATORY_UNIT_DATA[]
    fragment_members = {
        {"unit_key", "unit_key"},
        {}
    } ---@type string[][]
}


return {


    ----Slaanesh
    --core units
{
        id = "sla_marauder_infantry",
        internal_description = "Varied Slaneshi Marauder Infantry",
        mandatory_units = {
            {
                unit_key = "wh3_main_sla_inf_marauders_0",
                quantity = 1,
                unit_upgradable_effect_keys = {} 
            },
            {
                unit_key = "wh3_main_sla_inf_marauders_1",
                quantity = 1,
                unit_upgradable_effect_keys = {} 
            },
        },
        fragment_members = {
            {"wh3_main_sla_inf_marauders_0", "wh3_main_sla_inf_marauders_1", "wh3_main_sla_inf_marauders_2"},
            {"wh3_main_sla_inf_marauders_0", "wh3_main_sla_inf_marauders_1", "wh3_main_sla_inf_marauders_2"}
        }
    },
    {
        id = "sla_marauder_cavalry",
        internal_description = "Varied Slaneshi Marauder Cavalry",
        mandatory_units = {

        },
        fragment_members = {
            {"wh3_main_sla_cav_hellstriders_0", "wh3_main_sla_cav_hellstriders_0", "wh3_main_sla_cav_hellstriders_1"},
            {"wh3_main_sla_cav_hellstriders_0", "wh3_main_sla_cav_hellstriders_0", "wh3_main_sla_cav_hellstriders_1"}
        }
    },
    {
        id = "sla_marauder_cultist",
        internal_description = "A cultist with only basic abilities and no mount, supported by two marauder units",
        mandatory_units = {
            {
                unit_key = "wh3_main_sla_cha_cultist_0",
                quantity = 1,
                unit_upgradable_effect_keys = {} 
                --TODO add cultist effects
            }
        },
        fragment_members = {
            {"wh3_main_sla_inf_marauders_2", "wh3_main_sla_inf_marauders_1"},
            {"wh3_main_sla_inf_marauders_2", "wh3_main_sla_inf_marauders_1"}
        }
    },
    ----Khorne
    --core units
    {
        id = "kho_chaos_warriors",
        internal_description = "Varied Khorne Chaos Warriors",
        mandatory_units = {

        },
        fragment_members = {
            {"wh3_main_kho_inf_chaos_warriors_0", "wh3_main_kho_inf_chaos_warriors_1", "wh3_main_kho_inf_chaos_warriors_2"},
            {"wh3_main_kho_inf_chaos_warriors_0", "wh3_main_kho_inf_chaos_warriors_1", "wh3_main_kho_inf_chaos_warriors_2"},
            {"wh3_main_kho_inf_chaos_warriors_0", "wh3_main_kho_inf_chaos_warriors_1", "wh3_main_kho_inf_chaos_warriors_2"},
            {"wh3_main_kho_inf_chaos_warriors_0", "wh3_main_kho_inf_chaos_warriors_1", "wh3_main_kho_inf_chaos_warriors_2"}
        }
    },
    --characters
    {   
        id = "kho_cultist_easy",
        internal_description = "A cultist with only basic abilities and no mount",
        mandatory_units = {
            {
                unit_key = "wh3_main_kho_cha_cultist_0",
                quantity = 1,
                unit_upgradable_effect_keys = {} 
                --TODO add cultist effects
            }
        },
        fragment_members = {

        }
    }
}---@type ROGUE_FORCE_FRAGMENT_DATA[]