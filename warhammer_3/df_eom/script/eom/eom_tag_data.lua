--- "sigmar"|"ulric"|"morr"|"taal"|"undead"
--- |"expansionist"|"secessionist"
---|"industrialist"|"naturalist"|
--- "impoverished"|"wealthy"
---|"diplomatic"|"aggressive"

local factions_to_tags = {
    ["wh_main_emp_empire"] = {"sigmar", "industrialist", "wealthy", "diplomatic"},
    ["wh_main_emp_averland"] = {"aggressive", "expansionist"},
    ["wh_main_emp_hochland"] = {"taal", "diplomatic", "impoverished"},
    ["wh_main_emp_middenland"] = {"ulric", "naturalist"},
    ["wh_main_emp_nordland"] = {"ulric", "impoverished", "naturalist", "aggressive"},
    ["wh_main_emp_ostermark"] = {"morr", "impoverished", "secessionist", "diplomatic"},
    ["wh_main_emp_stirland"] = {"sigmar", "wealthy", "diplomatic"},
    ["wh_main_emp_talabecland"] = {"taal", "naturalist", "wealthy", "aggressive"},
    ["wh_main_emp_wissenland"] = {"sigmar", "industrialist", "wealthy", "diplomatic"},
}