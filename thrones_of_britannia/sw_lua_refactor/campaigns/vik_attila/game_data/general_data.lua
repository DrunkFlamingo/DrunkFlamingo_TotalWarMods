-------------------------------------------------------------------------------
---------------------------------- LISTS --------------------------------------
-------------------------------------------------------------------------------
------------------------- Created by Craig: 14/03/2017 ------------------------
------------------------- Last Updated: 21/08/2018 Craig ----------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

---------------------
--- FACTION LISTS ---
---------------------

FACTIONS_MAJOR = {
	"vik_fact_mierce",
	"vik_fact_west_seaxe",
	"vik_fact_sudreyar",
	"vik_fact_dyflin",
	"vik_fact_east_engle",
	"vik_fact_northymbre",
	"vik_fact_circenn",
	"vik_fact_mide",
	"vik_fact_strat_clut",
	"vik_fact_gwined",
}--:vector<string>

FACTIONS_MAJOR_SEPARATIST = {
	["vik_fact_mierce"] = "vik_fact_separatists_mierce",
	["vik_fact_west_seaxe"] = "vik_fact_separatists_west_seaxe",
	["vik_fact_sudreyar"] = "vik_fact_separatists_sudreyar",
	["vik_fact_dyflin"] = "vik_fact_separatists_dyflin",
	["vik_fact_east_engle"] = "vik_fact_separatists_east_engle",
	["vik_fact_northymbre"] = "vik_fact_separatists_northymbre",
	["vik_fact_circenn"] = "vik_fact_separatists_circenn",
	["vik_fact_mide"] = "vik_fact_separatists_mide",
	["vik_fact_strat_clut"] = "vik_fact_separatists_strat_clut",
	["vik_fact_gwined"] = "vik_fact_separatists_gwined"	
}--:map<string, string>

FACTIONS_INVADERS_IRELAND = {
	"vik_fact_dubgaill",
	"vik_fact_finngaill",
}--:vector<string>

FACTIONS_INVADERS_SOUTH = {
	"vik_fact_nordmann",
	"vik_fact_wicing",
}--:vector<string>

FACTIONS_WALES = {
	"vik_fact_gwined",
	"vik_fact_powis",
	"vik_fact_seisilwig",
	"vik_fact_dyfet",
	"vik_fact_gliwissig",
	"vik_fact_gwent",
	"vik_fact_cerneu",
	"vik_fact_brechinauc",
}--:vector<string>

FACTION_ANGLO_VIKING_MINOR = {
	"vik_fact_bedeborg",
	"vik_fact_djurby",
	"vik_fact_grantebru",
	"vik_fact_heimiliborg",
	"vik_fact_hellirborg",
	"vik_fact_hylrborg",
	"vik_fact_ledeborg",
	"vik_fact_steinnborg",
	"vik_fact_veidrborg",
}--:vector<string>

--------------------
--- LAND REGIONS ---
--------------------

REGIONS_MAJOR_SETTLEMENTS = {
	"vik_reg_aberffro",
	"vik_reg_aberteifi",
	"vik_reg_achadh_bo",
	"vik_reg_aethelingaeg",
	"vik_reg_airchardan",
	"vik_reg_ard_macha",
	"vik_reg_bebbanburg",
	"vik_reg_bornais",
	"vik_reg_cair_gwent",
	"vik_reg_caisil",
	"vik_reg_cantwaraburg",
	"vik_reg_carleol",
	"vik_reg_casteltoun",
	"vik_reg_cathair_commain",
	"vik_reg_cetretha",
	"vik_reg_ceaster",
	"vik_reg_cippanhamm",
	"vik_reg_cluain_mac_nois",
	"vik_reg_colneceaster",
	"vik_reg_corcach",
	"vik_reg_dinefwr",
	"vik_reg_doreceaster",
	"vik_reg_druim_da_ethiar",
	"vik_reg_dun_att",
	"vik_reg_dun_cailden",
	"vik_reg_dun_foither",
	"vik_reg_blascona",
	"vik_reg_dun_patraic",
	"vik_reg_dun_sebuirgi",
	"vik_reg_dyflin",
	"vik_reg_eidenburg",
	"vik_reg_eoferwic",
	"vik_reg_exanceaster",
	"vik_reg_gleawceaster",
	"vik_reg_grantabrycg",
	"vik_reg_grianan_aileach",
	"vik_reg_guvan",
	"vik_reg_northhamtun",
	"vik_reg_haestingas",
	"vik_reg_hlymrekr",
	"vik_reg_inis_faithlenn",
	"vik_reg_ioua",
	"vik_reg_loidis",
	"vik_reg_lindcylne",
	"vik_reg_lunden",
	"vik_reg_mameceaster",
	"vik_reg_mathrafal",
	"vik_reg_nas",
	"vik_reg_northwic",
	"vik_reg_rath_cruachan",
	"vik_reg_rendlesham",
	"vik_reg_scoan",
	"vik_reg_seolesigge",
	"vik_reg_snotingaham",
	"vik_reg_steanford",
	"vik_reg_tamworthige",
	"vik_reg_tintagol",
	"vik_reg_tor_in_duine",
	"vik_reg_vedrafjordr",
	"vik_reg_veisafjordr",
	"vik_reg_waerincwicum",
	"vik_reg_werham",
	"vik_reg_wintanceaster",
}--:vector<string>

REGIONS_DYFLINN_AND_CASTELTOUN = {
	"vik_reg_dyflin",
	"vik_reg_casteltoun",
}--:vector<string>

REGIONS_CORNWALAS = {
	"vik_reg_bodmine",
	"vik_reg_sancte_germanes",
	"vik_reg_sancte_ye",
	"vik_reg_tintagol",
}--:vector<string>

REGION_PROVINCE_PECSAETAN = {
	"vik_reg_mameceaster",
	"vik_reg_otergimele",
	"vik_reg_lonceaster",
}--:vector<string>

REGIONS_NORTHUMBRIA = {
	"vik_reg_beoferlic",
	"vik_reg_eoferwic",
	"vik_reg_loidis",
	"vik_reg_mameceaster",
	"vik_reg_otergimele",
	"vik_reg_lonceaster",
	"vik_reg_hripum",
	"vik_reg_cetretha",
	"vik_reg_dunholm",
	"vik_reg_gyruum",
	"vik_reg_dacor",
	"vik_reg_cherchebi",
	"vik_reg_doneceaster",
	"vik_reg_alclyt",
	"vik_reg_heslerton",
	"vik_reg_poclintun",
	"vik_reg_hagustaldes",
	"vik_reg_bebbanburg",
	"vik_reg_carleol",
	"vik_reg_mailros",
	"vik_reg_dynbaer",
	"vik_reg_eidenburg",
	"vik_reg_aebburcurnig",
	"vik_reg_coldingaham",
	"vik_reg_rucestr",
}--:vector<string>

REGION_WALES_CITIES = {
	"vik_reg_aberffro",
	"vik_reg_mathrafal",
	"vik_reg_aberteifi",
	"vik_reg_dinefwr",
	"vik_reg_cair_gwent",
}--:vector<string>

REGIONS_SCOAN_AND_VASSALS = {
	"vik_reg_scoan",
}--:vector<string>

REGIONS_ISLES = {
	"vik_reg_bornais",
	"vik_reg_dun_beccan",
	"vik_reg_stornochway",
	"vik_reg_ioua",
	"vik_reg_aporcrosan",
}--:vector<string>

REGIONS_BREGA = {
	"vik_reg_dyflin",
	"vik_reg_na_seciri",
	"vik_reg_loch_gabhair",
	"vik_reg_linns",
	"vik_reg_cnodba",
}--:vector<string>

REGIONS_IRISH_LONGPHORTS = {
	"vik_reg_dyflin",
	"vik_reg_vedrafjordr",
	"vik_reg_veisafjordr",
	"vik_reg_corcach",
	"vik_reg_hlymrekr",
}--:vector<string>

REGIONS_WELSH_PORTS = {
	"vik_reg_lann_ildut",
	"vik_reg_menevia",
	"vik_reg_aberteifi",
	"vik_reg_aberffro",
	"vik_reg_dugannu",
}--:vector<string>

REGIONS_IRISH_PORTS = {
	"vik_reg_dyflin",
	"vik_reg_linns",
	"vik_reg_cairlinn",
	"vik_reg_dun_patraic",
	"vik_reg_latharna",
	"vik_reg_dun_sebuirgi",
	"vik_reg_dun_na_ngall",
	"vik_reg_cell_alaid",
	"vik_reg_hlymrekr",
	"vik_reg_inis_faithlenn",
	"vik_reg_corcach",
	"vik_reg_ard_mor",
	"vik_reg_vedrafjordr",
	"vik_reg_veisafjordr",
	"vik_reg_an_tinbhear_mor",
}--:vector<string>

REGIONS_ENGLISH_PORTS = {
	"vik_reg_otergimele",
	"vik_reg_tintagol",
	"vik_reg_exanceaster",
	"vik_reg_werham",
	"vik_reg_suthhamtun",
	"vik_reg_seolesigge",
	"vik_reg_haestingas",
	"vik_reg_dofere",
	"vik_reg_rofeceaster",
	"vik_reg_lunden",
	"vik_reg_maeldune",
	"vik_reg_gipeswic",
	"vik_reg_domuc",
	"vik_reg_earmutha",
	"vik_reg_drayton",
	"vik_reg_eoferwic",
	"vik_reg_gyruum",
	"vik_reg_bebbanburg",
}--:vector<string>

REGIONS_SCOTTISH_PORTS = {
	"vik_reg_dynbaer",
	"vik_reg_eidenburg",
	"vik_reg_sreth_belin",
	"vik_reg_cenn_rigmonid",
	"vik_reg_dun_foither",
	"vik_reg_abberdeon",
	"vik_reg_tor_in_duine",
	"vik_reg_torfness",
	"vik_reg_thursa",
	"vik_reg_blascona",
	"vik_reg_dun_beccan",
	"vik_reg_stornochway",
	"vik_reg_bornais",
	"vik_reg_ioua",
	"vik_reg_cell_daltain",
	"vik_reg_dun_aberte",
	"vik_reg_alt_clut",
	"vik_reg_din_prys",
}--:vector<string>

REGIONS_MAINLAND_PORTS = {
	"vik_reg_lann_ildut",
	"vik_reg_menevia",
	"vik_reg_aberteifi",
	"vik_reg_aberffro",
	"vik_reg_dugannu",
	"vik_reg_dynbaer",
	"vik_reg_eidenburg",
	"vik_reg_sreth_belin",
	"vik_reg_cenn_rigmonid",
	"vik_reg_dun_foither",
	"vik_reg_abberdeon",
	"vik_reg_tor_in_duine",
	"vik_reg_torfness",
	"vik_reg_thursa",
	"vik_reg_blascona",
	"vik_reg_dun_beccan",
	"vik_reg_stornochway",
	"vik_reg_bornais",
	"vik_reg_ioua",
	"vik_reg_cell_daltain",
	"vik_reg_dun_aberte",
	"vik_reg_alt_clut",
	"vik_reg_din_prys",
	"vik_reg_otergimele",
	"vik_reg_tintagol",
	"vik_reg_exanceaster",
	"vik_reg_werham",
	"vik_reg_suthhamtun",
	"vik_reg_seolesigge",
	"vik_reg_haestingas",
	"vik_reg_dofere",
	"vik_reg_rofeceaster",
	"vik_reg_lunden",
	"vik_reg_maeldune",
	"vik_reg_gipeswic",
	"vik_reg_domuc",
	"vik_reg_earmutha",
	"vik_reg_drayton",
	"vik_reg_eoferwic",
	"vik_reg_gyruum",
	"vik_reg_bebbanburg",
}--:vector<string>

REGIONS_EAST_MIERCNA_1 = {
	"vik_reg_dor",
	"vik_reg_wyrcesuuyrthe",
	"vik_reg_deoraby",
	"vik_reg_snotingaham",
	"vik_reg_ligeraceaster",
	"vik_reg_rocheberie",
	"vik_reg_steanford",
	"vik_reg_northhamtun",
	"vik_reg_buccingahamm",
	"vik_reg_bedanford",
	"vik_reg_steanford",
	"vik_reg_huntandun",
	"vik_reg_elig",
	"vik_reg_grantabrycg",
	"vik_reg_herutford",
}--:vector<string>

REGIONS_TREATY_DYFLIN = {
	"vik_reg_dun_sebuirgi",
	"vik_reg_coinnire",
	"vik_reg_latharna",
	"vik_reg_moige_bile",
	"vik_reg_dun_patraic",
	"vik_reg_cairlinn",
	"vik_reg_linns",
	"vik_reg_cnodba",
	"vik_reg_na_sceiri",
	"vik_reg_loch_gabhair",
	"vik_reg_dyflin",
	"vik_reg_nas",
	"vik_reg_gleann_da_loch",
	"vik_reg_an_tinbhear_mor",
	"vik_reg_cluain_mor",
	"vik_reg_ferna",
	"vik_reg_veisafjordr",
	"vik_reg_ros",
	"vik_reg_cell_maic_aeda",
	"vik_reg_vedrafjordr",
}--:vector<string>

REGIONS_IRELAND = {
	"vik_reg_clocher",
	"vik_reg_ard_macha",
	"vik_reg_cluain_eoais",
	"vik_reg_rath_luraig",
	"vik_reg_ard_sratha",
	"vik_reg_dun_na_ngall",
	"vik_reg_grianan_aileach",
	"vik_reg_ardach",
	"vik_reg_cell_mor",
	"vik_reg_druim_da_ethiar",
	"vik_reg_balla",
	"vik_reg_cell_alaid",
	"vik_reg_loch_raich",
	"vik_reg_rath_cruachan",
	"vik_reg_tuaim",
	"vik_reg_cenannas",
	"vik_reg_cluain_iraird",
	"vik_reg_cluain_mac_nois",
	"vik_reg_cathair_commain",
	"vik_reg_inis_cathaigh",
	"vik_reg_cell_cainning",
	"vik_reg_saigher",
	"vik_reg_caisil",
	"vik_reg_imblech_ibair",
	"vik_reg_lis_mor",
	"vik_reg_ard_fert",
	"vik_reg_druim_collachair",
	"vik_reg_inis_faithlenn",
	"vik_reg_cathair_domnaill",
	"vik_reg_ros_ailithir",
	"vik_reg_dun_sebuirgi",
	"vik_reg_coinnire",
	"vik_reg_latharna",
	"vik_reg_moige_bile",
	"vik_reg_dun_patraic",
	"vik_reg_cairlinn",
	"vik_reg_linns",
	"vik_reg_cnodba",
	"vik_reg_na_seciri",
	"vik_reg_loch_gabhair",
	"vik_reg_dyflin",
	"vik_reg_nas",
	"vik_reg_gleann_da_loch",
	"vik_reg_an_tinbhear_mor",
	"vik_reg_cluain_mor",
	"vik_reg_ferna",
	"vik_reg_veisafjordr",
	"vik_reg_ros",
	"vik_reg_cell_maic_aeda",
	"vik_reg_vedrafjordr",
	"vik_reg_tuam_greine",
	"vik_reg_achadh_bo",
	"vik_reg_hlymrekr",
	"vik_reg_corcach",
	"vik_reg_cluain",
	"vik_reg_ard_mor",

}--:vector<string>

REGIONS_TREATY_MIDHE = {
	"vik_reg_clocher",
	"vik_reg_ard_macha",
	"vik_reg_cluain_eoais",
	"vik_reg_rath_luraig",
	"vik_reg_ard_sratha",
	"vik_reg_dun_na_ngall",
	"vik_reg_grianan_aileach",
	"vik_reg_ardach",
	"vik_reg_cell_mor",
	"vik_reg_druim_da_ethiar",
	"vik_reg_balla",
	"vik_reg_cell_alaid",
	"vik_reg_loch_raich",
	"vik_reg_rath_cruachan",
	"vik_reg_tuaim",
	"vik_reg_cenannas",
	"vik_reg_cluain_iraird",
	"vik_reg_cluain_mac_nois",
	"vik_reg_cathair_commain",
	"vik_reg_inis_cathaigh",
	"vik_reg_cell_cainning",
	"vik_reg_saigher",
	"vik_reg_caisil",
	"vik_reg_imblech_ibair",
	"vik_reg_lis_mor",
	"vik_reg_ard_fert",
	"vik_reg_druim_collachair",
	"vik_reg_inis_faithlenn",
	"vik_reg_cathair_domnaill",
	"vik_reg_ros_ailithir",
}--:vector<string>

REGIONS_IRISH_SEA_PORTS = {
	"vik_reg_cell_alaid",
	"vik_reg_aberteifi",
	"vik_reg_dugannu",
	"vik_reg_otergimele",
	"vik_reg_din_prys",
	"vik_reg_alt_clut",
	"vik_reg_dun_aberte",
	"vik_reg_cell_daltain",
	"vik_reg_dun_sebuirgi",
	"vik_reg_latharna",
	"vik_reg_dun_patraic",
	"vik_reg_cairlinn",
	"vik_reg_linns",
	"vik_reg_dyflin",
	"vik_reg_an_tinbhear_mor",
	"vik_reg_veisafjordr",
	"vik_reg_casteltoun",
	"vik_reg_aberffro",
}--:vector<string>

REGIONS_INVASIONS_REGIONS_1 = {
	"vik_reg_ard_mor",
	"vik_reg_exanceaster",
	"vik_reg_werham",
}--:vector<string>

REGIONS_INVASIONS_REGIONS_2 = {
	"vik_reg_tintagol",
	"vik_reg_lann_ildut",
	"vik_reg_menevia",
}--:vector<string>

REGIONS_INVASIONS_REGIONS_3 = {
	"vik_reg_cell_alaid",
	"vik_reg_dun_na_ngall",
}--:vector<string>

REGIONS_INVASIONS_REGIONS_4 = {
	"vik_reg_lann_ildut",
	"vik_reg_menevia",
	"vik_reg_aberteifi",
}--:vector<string>

REGIONS_INVASIONS_REGIONS_5 = {
	"vik_reg_exanceaster",
	"vik_reg_werham",
	"vik_reg_seolesigge",
	"vik_reg_haestingas",
}--:vector<string>

REGIONS_INVASIONS_REGIONS_6 = {
	"vik_reg_tintagol",
	"vik_reg_exanceaster",
}--:vector<string>

REGIONS_INVASIONS_REGIONS_7 = {
	"vik_reg_cenn_rigmonid",
	"vik_reg_torfness",
	"vik_reg_thursa",
	"vik_reg_bornais",
}--:vector<string>

REGIONS_INVASIONS_REGIONS_8 = {
	"vik_reg_eidenburg",
	"vik_reg_dynbaer",
	"vik_reg_bebbanburg",
	"vik_reg_gyruum",
}--:vector<string>

REGIONS_INVASIONS_REGIONS_9 = {
	"vik_reg_drayton",
	"vik_reg_earmutha",
	"vik_reg_domuc",
}--:vector<string>

REGIONS_INVASIONS_REGIONS_10 = {
	"vik_reg_haestingas",
	"vik_reg_seolesigge",
}--:vector<string>

REGIONS_INVASIONS_REGIONS_11 = {
	"vik_reg_cenn_rigmonid",
	"vik_reg_torfness",
	"vik_reg_drayton",
	"vik_reg_earmutha",
}--:vector<string>

REGIONS_ANGLO_SAXON_CAPITALS = {
	"vik_reg_wintanceaster",
	"vik_reg_tamworthige",
	"vik_reg_cantwaraburg",
	"vik_reg_lunden",
}--:vector<string>

REGIONS_ENGLAND_CAPITALS = {
	"vik_reg_wintanceaster",
	"vik_reg_tamworthige",
	"vik_reg_cantwaraburg",
	"vik_reg_lunden",
	"vik_reg_eoferwic",
	"vik_reg_northwic",
}--:vector<string>

REGIONS_DANELAW_CAPITALS = {
	"vik_reg_eoferwic",
	"vik_reg_northwic",
}--:vector<string>

REGIONS_ALBA = {
	"vik_reg_abberdeon",
	"vik_reg_brechin",
	"vik_reg_dun_eachainn",
	"vik_reg_dun_foither",
	"vik_reg_rinnin",
	"vik_reg_cenn_rigmonid",
	"vik_reg_scoan",
	"vik_reg_sconnin",
	"vik_reg_dun_blann",
	"vik_reg_dun_cailden",
	"vik_reg_dun_duirn",
	"vik_reg_dun_nechtain",
	"vik_reg_airchardan",
	"vik_reg_tor_in_duine",
	"vik_reg_ros_cuissine",
	"vik_reg_dear",
	"vik_reg_forais",
	"vik_reg_inber_nise",
	"vik_reg_ros_maircind",
	"vik_reg_torfness",
}--:vector<string>

REGIONS_SCOTLAND = {
	"vik_reg_abberdeon",
	"vik_reg_brechin",
	"vik_reg_dun_eachainn",
	"vik_reg_dun_foither",
	"vik_reg_rinnin",
	"vik_reg_cenn_rigmonid",
	"vik_reg_scoan",
	"vik_reg_sconnin",
	"vik_reg_dun_blann",
	"vik_reg_dun_cailden",
	"vik_reg_dun_duirn",
	"vik_reg_dun_nechtain",
	"vik_reg_airchardan",
	"vik_reg_tor_in_duine",
	"vik_reg_ros_cuissine",
	"vik_reg_dear",
	"vik_reg_forais",
	"vik_reg_inber_nise",
	"vik_reg_ros_maircind",
	"vik_reg_torfness",
	"vik_reg_dun_att",
	"vik_reg_dun_ollaig",
	"vik_reg_cell_daltain",
	"vik_reg_dun_aberte",
	"vik_reg_hwitan_aerne",
	"vik_reg_alt_clut",
	"vik_reg_dun_domnaill",
	"vik_reg_din_prys",
	"vik_reg_guvan",
	"vik_reg_sreth_belin",
	"vik_reg_mailros",
	"vik_reg_coldingaham",
	"vik_reg_aebburcurnig",
	"vik_reg_eidenburg",
	"vik_reg_dynbaer",
	"vik_reg_aporcrosan",
	"vik_reg_dun_beccan",
	"vik_reg_ioua",
	"vik_reg_latharn",
	"vik_reg_thursa",
	"vik_reg_bornais",
	"vik_reg_stornochway",
	"vik_reg_blascona",
}--:vector<string>

REGIONS_DEWET = {
	"vik_reg_menevia",
	"vik_reg_haverfordia",
	"vik_reg_cair_mirddin",
}--:vector<string>

REGIONS_ANGLO_SAXON = {
	"vik_reg_aebburcurnig",
	"vik_reg_eidenburg",
	"vik_reg_dynbaer",
	"vik_reg_coldingaham",
	"vik_reg_mailros",
	"vik_reg_bebbanburg",
	"vik_reg_rucestr",
	"vik_reg_gyruum",
	"vik_reg_hagustaldes",
	"vik_reg_carleol",
	"vik_reg_dacor",
	"vik_reg_cherchebi",
	"vik_reg_lonceaster",
	"vik_reg_otergimele",
	"vik_reg_mameceaster",
	"vik_reg_ceaster",
	"vik_reg_stoc",
	"vik_reg_scrobbesburg",
	"vik_reg_staefford",
	"vik_reg_licetfelda",
	"vik_reg_tamworthige",
	"vik_reg_brug",
	"vik_reg_waerincwicum",
	"vik_reg_wigracestre",
	"vik_reg_hereford",
	"vik_reg_gleawceaster",
	"vik_reg_eofesham",
	"vik_reg_cirenceaster",
	"vik_reg_oxnaforda",
	"vik_reg_doreceaster",
	"vik_reg_cippanhamm",
	"vik_reg_bathanceaster",
	"vik_reg_cissanbyrig",
	"vik_reg_axanbrycg",
	"vik_reg_ethandun",
	"vik_reg_basengas",
	"vik_reg_basengas",
	"vik_reg_ebbesham",
	"vik_reg_rofeceaster",
	"vik_reg_glastingburi",
	"vik_reg_wiltun",
	"vik_reg_wintanceaster",
	"vik_reg_waecet",
	"vik_reg_aethelingaeg",
	"vik_reg_scireburnan",
	"vik_reg_sceaftesburg",
	"vik_reg_werham",
	"vik_reg_brideport",
	"vik_reg_cridiatune",
	"vik_reg_exanceaster",
	"vik_reg_totanes",
	"vik_reg_liwtune",
	"vik_reg_suthhamtun",
	"vik_reg_porteceaster",
	"vik_reg_wiht",
	"vik_reg_seolesigge",
	"vik_reg_middeherst",
	"vik_reg_staeningum",
	"vik_reg_laewe",
	"vik_reg_pefenesea",
	"vik_reg_haestingas",
	"vik_reg_stutfall",
	"vik_reg_dofere",
	"vik_reg_cantwaraburg",
	"vik_reg_tanet",
}--:vector<string>

REGIONS_LOCHLANN = {
	"vik_reg_blascona",
	"vik_reg_latharn",
	"vik_reg_thursa",
	"vik_reg_aporcrosan",
	"vik_reg_bornais",
	"vik_reg_dun_beccan",
	"vik_reg_ioua",
	"vik_reg_stornochway",
	"vik_reg_dun_att",
	"vik_reg_dun_ollaig",
	"vik_reg_cell_daltain",
	"vik_reg_dun_aberte",
	"vik_reg_inis_patraic",
	"vik_reg_casteltoun",
}--:vector<string>

REGIONS_EAST_DANELAW_MINORS = {
	"vik_reg_steanford",
	"vik_reg_huntandun",
	"vik_reg_elig",
	"vik_reg_grantabrycg",
	"vik_reg_herutford",
	"vik_reg_sancte_albanes",
}--:vector<string>

REGIONS_NORTHYMBRE_ALIVE = {
	"vik_reg_eoferwic",
	"vik_reg_northwic",
}

REGIONS_NORTHYMBRE_DEAD = {
	"vik_reg_eoferwic",
	"vik_reg_loidis",
	"vik_reg_cetretha",
	"vik_reg_northwic",
}

REGIONS_PORTS = {
	"vik_reg_abberdeon",
	"vik_reg_aberffro",
	"vik_reg_aberteifi",
	"vik_reg_alt_clut",
	"vik_reg_an_tinbhear_mor",
	"vik_reg_ard_mor",
	"vik_reg_bebbanburg",
	"vik_reg_blascona",
	"vik_reg_bornais",
	"vik_reg_cairlinn",
	"vik_reg_casteltoun",
	"vik_reg_cell_alaid",
	"vik_reg_cell_daltain",
	"vik_reg_cenn_rigmonid",
	"vik_reg_corcach",
	"vik_reg_din_prys",
	"vik_reg_dofere",
	"vik_reg_drayton",
	"vik_reg_dugannu",
	"vik_reg_dun_aberte",
	"vik_reg_dun_beccan",
	"vik_reg_dun_foither",
	"vik_reg_dun_na_ngall",
	"vik_reg_dun_patraic",
	"vik_reg_dun_sebuirgi",
	"vik_reg_dyflin",
	"vik_reg_dynbaer",
	"vik_reg_earmutha",
	"vik_reg_eidenburg",
	"vik_reg_eoferwic",
	"vik_reg_exanceaster",
	"vik_reg_gipeswic",
	"vik_reg_gyruum",
	"vik_reg_haestingas",
	"vik_reg_hlymrekr",
	"vik_reg_inis_faithlenn",
	"vik_reg_ioua",
	"vik_reg_lann_ildut",
	"vik_reg_latharna",
	"vik_reg_linns",
	"vik_reg_lunden",
	"vik_reg_maeldune",
	"vik_reg_menevia",
	"vik_reg_otergimele",
	"vik_reg_rofeceaster",
	"vik_reg_seolesigge",
	"vik_reg_sreth_belin",
	"vik_reg_stornochway",
	"vik_reg_suthhamtun",
	"vik_reg_thursa",
	"vik_reg_tintagol",
	"vik_reg_tor_in_duine",
	"vik_reg_torfness",
	"vik_reg_vedrafjordr",
	"vik_reg_veisafjordr",
	"vik_reg_werham",
}

REGIONS_CIRCENN = {
	"vik_reg_scoan",
	"vik_reg_brechin",
	"vik_reg_sconnin",
	"vik_reg_cenn_rigmonid",
	"vik_reg_dun_eachainn",
}

REGIONS_MIDE = {
	"vik_reg_cluain_mac_nois",
	"vik_reg_ardach",
	"vik_reg_cluain_iraird",
	"vik_reg_cenannas",
}

REGIONS_WALES = {
	"vik_reg_aberffro",
	"vik_reg_cair_segeint",
	"vik_reg_dugannu",
	"vik_reg_rudglann",
	"vik_reg_lann_afan",
	"vik_reg_lann_idloes",
	"vik_reg_mathrafal",
	"vik_reg_oswaldestroe",
	"vik_reg_aberteifi",
	"vik_reg_lann_dewi",
	"vik_reg_lann_padarn",
	"vik_reg_cair_mirddin",
	"vik_reg_dinefwr",
	"vik_reg_haverfordia",
	"vik_reg_menevia",
	"vik_reg_cair_gwent",
	"vik_reg_dinas_powis",
	"vik_reg_lann_cors",
	"vik_reg_lann_ildut",
	"vik_reg_nedd",
}

REGIONS_OLD_NORTH = {
	"vik_reg_alt_clut",
	"vik_reg_dun_domnaill",
	"vik_reg_guvan",
	"vik_reg_sreth_belin",
	"vik_reg_carleol",
	"vik_reg_cherchebi",
	"vik_reg_dacor",
	"vik_reg_din_prys",
	"vik_reg_hwitan_aerne",
	"vik_reg_bebbanburg",
	"vik_reg_coldingaham",
	"vik_reg_mailros",
	"vik_reg_rucestr",
	"vik_reg_aebburcurnig",
	"vik_reg_dynbaer",
	"vik_reg_eidenburg",
}

REGIONS_CERNEU = {
	"vik_reg_bodmine",
	"vik_reg_sancte_germanes",
	"vik_reg_sancte_ye",
	"vik_reg_tintagol",
}

-------------------
--- SEA REGIONS ---
-------------------

local SEA_REGIONS = {
	"vik_sea_dofere_sund",
	"vik_sea_engle_sae",
	"vik_sea_engle_sund",
	"vik_sea_lake",
	"vik_sea_linne_forthin",
	"vik_sea_linne_moreb",
	"vik_sea_loch_eochaid",
	"vik_sea_maerse_sae",
	"vik_sea_mare_incognita",
	"vik_sea_muir_britton",
	"vik_sea_muir_deiscert",
	"vik_sea_muir_domon",
	"vik_sea_muir_eirenn",
	"vik_sea_muir_norc",
	"vik_sea_muir_sinna",
	"vik_sea_muir_tuaiscert",
	"vik_sea_northsae",
	"vik_sea_seaxe_sae",
	"vik_sea_solentan",
	"vik_sea_sruth_tuaiscert",
	"vik_sea_suthsae",
}--:vector<string>

------------------------
--- RESOURCE REGIONS ---
------------------------

REGIONS_CLOTH = {
	"vik_reg_basengas",
	"vik_reg_wigracestre",
	"vik_reg_scrobbesburg",
	"vik_reg_hagustaldes",
	"vik_reg_dun_na_ngall",
	"vik_reg_aelmham",
	"vik_reg_cluain",
	"vik_reg_guldeford",
	"vik_reg_na_seciri",
	"vik_reg_poclintun",
	"vik_reg_rath_luraig",
	"vik_reg_wigingamere",
}--:vector<string>

REGIONS_POTTERY = {
	"vik_reg_brideport",
	"vik_reg_ebbesham",
	"vik_reg_gipeswic",
	"vik_reg_buccingahamm",
	"vik_reg_lude",
	"vik_reg_dun_aberte",
	"vik_reg_cathair_domnaill",
	"vik_reg_cluain_eoais",
	"vik_reg_coinnire",
	"vik_reg_flichesburg",
	"vik_reg_forais",
	"vik_reg_staefford",
	"vik_reg_wiltun",
}--:vector<string>

REGIONS_TIN = {
	"vik_reg_bodmine",
	"vik_reg_liwtune",
}--:vector<string>

REGIONS_WOOD = {
	"vik_reg_lann_ildut",
	"vik_reg_din_prys",
	"vik_reg_alt_clut",
	"vik_reg_laewe",
	"vik_reg_hereford",
	"vik_reg_dun_duirn",
	"vik_reg_loch_raich",
	"vik_reg_brechin",
	"vik_reg_cairlinn",
	"vik_reg_cridiatune",
	"vik_reg_gleann_da_loch",
	"vik_reg_rucestr",
	"vik_reg_stoc",
}--:vector<string>

REGIONS_IRON = {
	"vik_reg_waecet",
	"vik_reg_huntandun",
	"vik_reg_bedanford",
	"vik_reg_hereford",
	"vik_reg_dor",
	"vik_reg_cell_daltain",
	"vik_reg_cell_mor",
	"vik_reg_cluain_mor",
	"vik_reg_ard_fert",
	"vik_reg_ligeraceaster",
	"vik_reg_alclyt",
	"vik_reg_inber_nise",
	"vik_reg_lis_mor",
	"vik_reg_loch_gabhair",
	"vik_reg_abberdeon",
	"vik_reg_pefenesea",
	"vik_reg_stutfall",
}--:vector<string>

REGIONS_LEAD = {
	"vik_reg_cissanbyrig",
	"vik_reg_llanbadarn",
	"vik_reg_rhuddlan",
	"vik_reg_hripum",
	"vik_reg_dacor",
	"vik_reg_thursa",
	"vik_reg_dun_beccan",
	"vik_reg_cell_alaid",
	"vik_reg_sceaftesburg",
	"vik_reg_cirenceaster",
	"vik_reg_dinas_powis",
	"vik_reg_earmutha",
	"vik_reg_deoraby",
	"vik_reg_scrobbesburg",
}--:vector<string>

REGIONS_FURS = {
	"vik_reg_lonceaster",
	"vik_reg_dun_nechtain",
	"vik_reg_dun_ollaig",
	"vik_reg_bathanceaster",
	"vik_reg_middhyrsrt",
	"vik_reg_coldingaham",
	"vik_reg_deoraby",
	"vik_reg_herutford",
}--:vector<string>

REGIONS_SALT = {
	"vik_reg_maeldune",
	"vik_reg_dynbaer",
	"vik_reg_stornochway",
	"vik_reg_linns",
	"vik_reg_tuaim",
	"vik_reg_drayton",
	"vik_reg_porteceaster",
	"vik_reg_tilaburg",
}--:vector<string>


return {
	sea_regions = SEA_REGIONS,
	regions = {
		east_mercia = REGIONS_EAST_MIERCNA_1,
		northumbria = REGIONS_NORTHUMBRIA,
		anglo_saxon = REGIONS_ANGLO_SAXON,
		danelaw = REGIONS_EAST_DANELAW_MINORS
	},
	port_regions = {
		ireland_ports = REGIONS_IRISH_PORTS,
		scotland_ports = REGIONS_SCOTTISH_PORTS
	}
}