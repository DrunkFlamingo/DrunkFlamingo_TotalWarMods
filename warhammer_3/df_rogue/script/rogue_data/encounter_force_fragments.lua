--fragments should be between 2 and 4 units.
return {
    ----template
    ["template_fragment_key"] = {
        internal_description = "this is the template entry for a fragment",
        mandatory_units = {
            {
                unit_key = "",
                quantity = 0,
                unit_upgradable_effect_keys = {} 
            },
        },
        fragment_members = {
            {"unit_key", "unit_key"},
            {}
        }
    },

    ----Slaanesh
    --core units
    ["sla_marauder_infantry"] = {
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
    ["sla_marauder_cavalry"] = {
        internal_description = "Varied Slaneshi Marauder Cavalry",
        mandatory_units = {

        },
        fragment_members = {
            {"wh3_main_sla_cav_hellstriders_0", "wh3_main_sla_cav_hellstriders_0", "wh3_main_sla_cav_hellstriders_1"},
            {"wh3_main_sla_cav_hellstriders_0", "wh3_main_sla_cav_hellstriders_0", "wh3_main_sla_cav_hellstriders_1"}
        }
    },
    ["sla_marauder_cultist"] = {
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
    ["kho_chaos_warriors"] = {
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
    ["kho_cultist_easy"] = {
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
}