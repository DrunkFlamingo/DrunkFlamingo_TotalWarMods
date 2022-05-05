local nations = {
    ["vik_fact_circenn"] = "scotland",
    ["vik_fact_west_seaxe"] = "england",
    ["vik_fact_mierce"] = "england",
    ["vik_fact_mide"]  = "ireland",
    ["vik_fact_east_engle"]  = "north_sea_empire",
    ["vik_fact_northymbre"]  = "north_sea_empire",
    ["vik_fact_strat_clut"]  = "old_north",
    ["vik_fact_gwined"]  = "wales",
    ["vik_fact_dyflin"]  = "norse_gaelic_sea",
    ["vik_fact_sudreyar"]  = "norse_gaelic_sea",
    ["vik_fact_northleode"]  = "england"
} --:map<string, string>

local formable_kingdoms = {
    ["vik_fact_circenn"] = "alba",
    ["vik_fact_west_seaxe"] = "anglo_saxon",
    ["vik_fact_mierce"] = "anglo_saxon",
    ["vik_fact_mide"]  = "temhair",
    ["vik_fact_east_engle"]  = "danelaw",
    ["vik_fact_northymbre"]  = "danelaw",
    ["vik_fact_strat_clut"]  = "prydein",
    ["vik_fact_gwined"]  = "prydein",
    ["vik_fact_dyflin"]  = "irish_vikings",
    ["vik_fact_sudreyar"]  = "lochlann",
    ["vik_fact_northleode"]  = "anglo_saxon"
} --:map<string, string>



local kingdoms_borders = {
    ["vik_fact_circenn_1"] = {{" vik_prov_circenn","vik_prov_monadh","vik_prov_aurmoreb","vik_prov_athfochla","vik_prov_airer_goidel","vik_prov_cait","vik_prov_iarmoreb","vik_prov_loden","vik_prov_strat_clut"}, false},
    ["vik_fact_west_seaxe_1"] = {{}, false},
    ["vik_fact_mierce_1"] = {{
        "vik_prov_staeffordscir",
        "vik_prov_hamtunscir",
        "vik_prov_middel_seaxe",
        "vik_prov_north_mierce",
        "vik_prov_gwined",
    }, false},
    ["vik_fact_mide_1"]  = {{"vik_prov_mide"}, false},
    ["vik_fact_east_engle_1"]  = {{
        "vik_prov_norfolc",
    }, false},
    ["vik_fact_northymbre_1"]  = {{
        "vik_prov_east_thryding", "vik_prov_north_thryding", "vik_prov_west_thryding",
    }, false},
    ["vik_fact_strat_clut_1"]  = {{
        "vik_prov_strat_clut",
        "vik_prov_cumbraland",
        "vik_prov_beornice",
        "vik_prov_loden",
        "vik_prov_north_thryding",
    }, false},
    ["vik_fact_gwined_1"]  = {{
        "vik_prov_gwined",
        "vik_prov_powis",
        "vik_prov_ceredigeaun",
        "vik_prov_dyfet",
        "vik_prov_morcanhuc",
    }, false},
    ["vik_fact_dyflin_1"]  = {{
        "vik_reg_dyflin",
        "vik_reg_na_seciri",
        "vik_reg_loch_gabhair",
        "vik_reg_linns",
        "vik_reg_cnodba",
    }, true},
    ["vik_fact_sudreyar_1"]  = {{}, false},
    ["vik_fact_northleode_1"]  = {{
        "vik_prov_loden",
        "vik_prov_beornice", 
        "vik_prov_north_thryding", 
        "vik_prov_east_thryding",
        "vik_prov_west_thryding"
    }, false},
    ["vik_fact_circenn_2"] = {{" vik_prov_circenn","vik_prov_monadh","vik_prov_aurmoreb","vik_prov_athfochla","vik_prov_airer_goidel","vik_prov_cait","vik_prov_iarmoreb","vik_prov_loden","vik_prov_strat_clut","vik_prov_druim_alban", "vik_prov_sudreyar", "vik_prov_aileach", "vik_prov_dal_naraidi", "vik_prov_east_thryding", "vik_prov_agmundrenesse"}, false},
    ["vik_fact_west_seaxe_2"] = {{
        "vik_prov_hamtunscir",		
        "vik_prov_staeffordscir",	
        "vik_prov_middel_seaxe",
        "vik_prov_north_mierce",
        "vik_prov_norfolc",
        "vik_prov_east_thryding",
        "vik_prov_beornice",
    }, false},
    ["vik_fact_mierce_2"] = {{
        "vik_prov_staeffordscir",
        "vik_prov_hamtunscir",
        "vik_prov_middel_seaxe",
        "vik_prov_north_mierce",
        "vik_prov_gwined",
        "vik_prov_norfolc",
        "vik_prov_east_thryding",
        "vik_prov_beornice",
    }, false},
    ["vik_fact_mide_2"]  = {{"vik_prov_aileach","vik_prov_airgialla","vik_prov_brega","vik_prov_breifne","vik_prov_connacht","vik_prov_corcaigh","vik_prov_dal_fiatach",
    "vik_prov_dal_naraidi","vik_prov_hlymrekr","vik_prov_iarmuma","vik_prov_laigen","vik_prov_mide","vik_prov_muma","vik_prov_osraige",
    "vik_prov_tuadmuma","vik_prov_vedrafjordr","vik_prov_veisafjordr",}, false},
    ["vik_fact_east_engle_2"]  = {{
        "vik_prov_norfolc",
        "vik_prov_east_thryding",
    }, false},
    ["vik_fact_northymbre_2"]  = {{"vik_prov_east_thryding", "vik_prov_north_thryding", "vik_prov_west_thryding", "vik_prov_beornice", "vik_prov_norfolc",}, false},
    ["vik_fact_strat_clut_2"]  = {{
        "vik_prov_strat_clut",
        "vik_prov_cumbraland",
        "vik_prov_beornice",
        "vik_prov_loden",
        "vik_prov_north_thryding",
        "vik_prov_gwined",
        "vik_prov_powis",
        "vik_prov_ceredigeaun",
        "vik_prov_dyfet",
        "vik_prov_morcanhuc",
        "vik_prov_kerneu",
    }, false},
    ["vik_fact_gwined_2"]  = {{
        "vik_prov_gwined",
        "vik_prov_powis",
        "vik_prov_ceredigeaun",
        "vik_prov_dyfet",
        "vik_prov_morcanhuc",
        "vik_prov_strat_clut",
        "vik_prov_cumbraland",
        "vik_prov_beornice",
        "vik_prov_loden",
        "vik_prov_kerneu"
    }, false},
    ["vik_fact_dyflin_2"]  = {{ "vik_reg_dyflin",
    "vik_reg_vedrafjordr",
    "vik_reg_veisafjordr",
    "vik_reg_corcach",
    "vik_reg_hlymrekr",
    "vik_reg_na_seciri",
    "vik_reg_loch_gabhair",
    "vik_reg_linns",
    "vik_reg_cnodba",
    "vik_reg_casteltoun"
}, true},
    ["vik_fact_sudreyar_2"]  = {{}, false},
    ["vik_fact_northleode_2"]  = {
        {"vik_prov_loden", "vik_prov_beornice", "vik_prov_north_thryding", "vik_prov_east_thryding", "vik_prov_west_thryding", "vik_prov_strat_clut", "vik_prov_monadh"}, false}
}--:map<string, {vector<string>, boolean}>

local kingdom_vassal_requirements = {
    ["vik_fact_east_engle_1"] = 9,
    ["vik_fact_northymbre_1"] = 9,
    ["vik_fact_east_engle_2"] = 14,
    ["vik_fact_northymbre_2"] = 14
}

local kingdom_sea_region_requirements = {
    ["vik_fact_dyflin_1"]  = 15,
    ["vik_fact_sudreyar_1"]  = 15,
    ["vik_fact_sudreyar_2"]  = 30,
    ["vik_fact_dyflin_2"]  = 30
}--:map<string, int>

--v function(faction: CA_FACTION)-->vector<string>
local function kingdom_provinces(faction) 
    if not formable_kingdoms[faction:name()] then
        return {}
    end
    if kingdoms_borders[faction:name().."_1"][2] == true then
        return Gamedata.regions.region_list_to_province_list(kingdoms_borders[faction:name().."_1"][1])
    end
    return kingdoms_borders[faction:name().."_1"][1]
end

--v function(faction: CA_FACTION)-->vector<string>
local function nation_provinces(faction) 
    if not formable_kingdoms[faction:name()] then
        return {}
    end
    if kingdoms_borders[faction:name().."_2"][2] == true then
        return Gamedata.regions.region_list_to_province_list(kingdoms_borders[faction:name().."_2"][1])
    end
    return kingdoms_borders[faction:name().."_2"][1] 
end

--v function(region: string, faction_key: string, level: int?) --> boolean
local function is_region_in_kingdom(region, faction_key, level)
    local faction = dev.get_faction(faction_key)
    if not formable_kingdoms[faction:name()] then
        return false
    end
    if not level then
        level = 1
    end
    --# assume level: int
    local list = kingdoms_borders[faction:name().."_"..level][1] 
    if kingdoms_borders[faction:name().."_"..level][2] == true then
        list = Gamedata.regions.region_list_to_province_list(kingdoms_borders[faction:name().."_"..level][1])
    end
    for i = 1, #list do
        if list[i] == region then
            return true
        end
    end
    return false
end

return {
    kingdom_provinces = kingdom_provinces,
    nation_provinces = nation_provinces,
    is_region_in_kingdom = is_region_in_kingdom,
    faction_nations = nations,
    faction_kingdoms = formable_kingdoms
}