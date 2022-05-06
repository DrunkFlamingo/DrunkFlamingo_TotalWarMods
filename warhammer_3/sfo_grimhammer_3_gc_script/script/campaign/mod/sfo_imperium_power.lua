---@param t string
local out = function(t)
    ModLog("SFO: "..tostring(t).." (sfo_imperium)")
end

---round num to the nearest multiple of num
---@param num number
---@param mult integer
---@return integer
local mround = function(num, mult)
    return (math.floor((num/mult)+0.5))*mult
end

--Uses custom effect bundles to construct benefits and penalties based on the size of each empire.

--if a subculture list is used, it must be exhaustive.
local subculture_groups = {
    all = {
        ["wh_dlc05_sc_wef_wood_elves"] = true,
        ["wh_main_sc_brt_bretonnia"] = true,
        ["wh_main_sc_nor_norsca"] = true,
        ["wh_main_sc_dwf_dwarfs"] = true,
        ["wh_main_sc_emp_empire"] = true,
        ["wh_main_sc_ksl_kislev"] = true,
        ["wh_main_sc_teb_teb"] = true,
        ["wh_main_sc_grn_greenskins"] = true,
        ["wh_main_sc_grn_savage_orcs"] = true,
        ["wh_main_sc_vmp_vampire_counts"] = true,
        ["wh2_dlc09_sc_tmb_tomb_kings"] = true,
        ["wh2_dlc11_sc_cst_vampire_coast"] = true,
        ["wh2_main_sc_def_dark_elves"] = true,
        ["wh2_main_sc_hef_high_elves"] = true,
        ["wh2_main_sc_lzd_lizardmen"] = true,
        ["wh2_main_sc_skv_skaven"] = true,
        ["wh3_main_sc_cth_cathay"] = true,
        ["wh3_main_sc_dae_daemons"] = true,
        ["wh3_main_sc_kho_khorne"] = true,
        ["wh3_main_sc_ksl_kislev"] = true,
        ["wh3_main_sc_nur_nurgle"] = true,
        ["wh3_main_sc_ogr_ogre_kingdoms"] = true,
        ["wh3_main_sc_sla_slaanesh"] = true,      
        ["wh3_main_sc_tze_tzeentch"] = true         
    },
    tk = {
        ["wh2_dlc09_sc_tmb_tomb_kings"] = true
    },
    def = {
        ["wh2_main_sc_def_dark_elves"] = true
    },
    grn = {
        ["wh_main_sc_grn_greenskins"] = true
    },
    brt = {
        ["wh_main_sc_brt_bretonnia"] = true
    },
    vmp_cst = {
        ["wh_main_sc_vmp_vampire_counts"] = true,
        ["wh2_dlc11_sc_cst_vampire_coast"] = true               
    },
    all_no_brt = {
        ["wh_dlc05_sc_wef_wood_elves"] = true,
        ["wh_main_sc_nor_norsca"] = true,
        ["wh_main_sc_dwf_dwarfs"] = true,
        ["wh_main_sc_emp_empire"] = true,
        ["wh_main_sc_ksl_kislev"] = true,
        ["wh_main_sc_teb_teb"] = true,
        ["wh_main_sc_grn_greenskins"] = true,
        ["wh_main_sc_grn_savage_orcs"] = true,
        ["wh_main_sc_vmp_vampire_counts"] = true,
        ["wh2_dlc09_sc_tmb_tomb_kings"] = true,
        ["wh2_dlc11_sc_cst_vampire_coast"] = true,
        ["wh2_main_sc_def_dark_elves"] = true,
        ["wh2_main_sc_hef_high_elves"] = true,
        ["wh2_main_sc_lzd_lizardmen"] = true,
        ["wh2_main_sc_skv_skaven"] = true
    },
    all_no_grn = {
        ["wh_dlc05_sc_wef_wood_elves"] = true,
        ["wh_main_sc_brt_bretonnia"] = true,
        ["wh_main_sc_nor_norsca"] = true,
        ["wh_main_sc_dwf_dwarfs"] = true,
        ["wh_main_sc_emp_empire"] = true,
        ["wh_main_sc_ksl_kislev"] = true,
        ["wh_main_sc_teb_teb"] = true,
        ["wh_main_sc_grn_savage_orcs"] = true,
        ["wh_main_sc_vmp_vampire_counts"] = true,
        ["wh2_dlc09_sc_tmb_tomb_kings"] = true,
        ["wh2_dlc11_sc_cst_vampire_coast"] = true,
        ["wh2_main_sc_def_dark_elves"] = true,
        ["wh2_main_sc_hef_high_elves"] = true,
        ["wh2_main_sc_lzd_lizardmen"] = true,
        ["wh2_main_sc_skv_skaven"] = true
    },
    all_no_tk = {
        ["wh_dlc05_sc_wef_wood_elves"] = true,
        ["wh_main_sc_brt_bretonnia"] = true,
        ["wh_main_sc_nor_norsca"] = true,
        ["wh_main_sc_dwf_dwarfs"] = true,
        ["wh_main_sc_emp_empire"] = true,
        ["wh_main_sc_ksl_kislev"] = true,
        ["wh_main_sc_teb_teb"] = true,
        ["wh_main_sc_grn_greenskins"] = true,
        ["wh_main_sc_grn_savage_orcs"] = true,
        ["wh_main_sc_vmp_vampire_counts"] = true,
        ["wh2_dlc11_sc_cst_vampire_coast"] = true,
        ["wh2_main_sc_def_dark_elves"] = true,
        ["wh2_main_sc_hef_high_elves"] = true,
        ["wh2_main_sc_lzd_lizardmen"] = true,
        ["wh2_main_sc_skv_skaven"] = true
    }
}

--if a faction is added to an effect which is not added to its subculture, it will recieve it. If the faction is explicitly set false, this will override the subculture setting to remove the bundle from a specific faction.
local faction_groups = {
    example = {
        ["wh_main_dwf_dwarfs"] = true, --even though dwarfs are not sc_emp_empire, this will override that to grant it.
        ["wh_main_emp_middenland"] = false -- even though Middenland is sc_emp_empire, this will override that to remove it.
    }
}

local effect_groups = {
    ["wh_imperium_0"] = {
        {key = "wh2_main_effect_slave_public_order_modifier", scope = "faction_to_province_own_unseen", min = 1, max = 5, value = -40, capitals_only = false, full_province_only = false, halving_value = 5, invert_halving = false, culture = subculture_groups.def},                        

        {key = "wh_main_effect_force_all_campaign_recruitment_cost_all", scope = "faction_to_force_own_unseen", min = 1, max = 5, value = -30, capitals_only = false, full_province_only = false, halving_value = 5, invert_halving = false, culture = subculture_groups.all_no_tk},                      

        {key = "wh_main_effect_building_construction_cost_mod", scope = "faction_to_region_own_unseen", min = 1, max = 5, value = -20, capitals_only = false, full_province_only = false, halving_value = 5, invert_halving = false, culture = subculture_groups.tk},
        {key = "wh_main_effect_unit_recruitment_points", scope = "faction_to_province_own_unseen", min = 1, max = 5, value = 2, capitals_only = false, full_province_only = false, halving_value = 5, invert_halving = false, culture = subculture_groups.tk},

        {key = "wh_main_effect_public_order_faction", scope = "faction_to_province_own_unseen", min = 1, max = 5, value = 2, capitals_only = false, full_province_only = false, halving_value = 5, invert_halving = false, culture = subculture_groups.all}
    },
    ["wh_imperium_1"] = {
        {key = "wh_main_effect_province_growth_other", scope = "faction_to_province_own_unseen", min = 6, max = 400, value = 1, capitals_only = false, full_province_only = false, halving_value = 1, invert_halving = true, culture = subculture_groups.all_no_grn},
        {key = "wh_main_effects_province_growth_faction", scope = "faction_to_province_own_unseen", min = 6, max = 400, value = 2, capitals_only = false, full_province_only = false, halving_value = 1, invert_halving = true, culture = subculture_groups.grn},

        {key = "wh_main_effect_force_all_campaign_movement_range", scope = "faction_to_force_own_unseen", min = 6, max = 400, value = 0.33, capitals_only = false, full_province_only = false, halving_value = 1, invert_halving = true, culture = subculture_groups.all},
        {key = "wh_main_effect_public_order_faction", scope = "faction_to_province_own_unseen", min = 6, max = 400, value = -0.05, capitals_only = false, full_province_only = false, halving_value = 1, invert_halving = true, culture = subculture_groups.all},
        {key = "wh_main_effect_public_order_faction_counter", scope = "faction_to_province_own_unseen", min = 100, max = 400, value = 0.025, capitals_only = false, full_province_only = false, halving_value = 1, invert_halving = true, culture = subculture_groups.all}
    },
}--:map<string, vector<{key: string, scope: string, min: int, max: int, value: int, full_province_only: boolean, capitals_only: boolean, halving_value: int, invert_halving: boolean, culture: map<string,boolean>?, faction: map<string,boolean>?}>>




--v function(value: int, base: int, halving_value: int, invert: boolean, offset: int) --> int
local function get_effect_value(value, base, halving_value, invert, offset)
    local retval --:int
    if not invert then
        retval = value
        local c_base = base - offset + 1
        while c_base - halving_value >= 0 do
            c_base = c_base - halving_value
            retval = mround(retval/2, 1)
        end
        return retval
    end
    local multiplier = math.ceil((base-offset)/halving_value)
    if base % halving_value == 0 then
        multiplier = multiplier + 1
    end
    local retval = mround(value*multiplier, 1)
    return retval
end


--v function(faction: CA_FACTION, capitals: int, settlements: int, full_provinces: int)
local function build_imperium_bundles(faction, capitals, settlements, full_provinces)
    for effect_bundle, effect_set in pairs(effect_groups) do
        if faction:has_effect_bundle(effect_bundle) then
            cm:remove_effect_bundle(effect_bundle, faction:name()) 
        end
        local new_bundle = cm:create_new_custom_effect_bundle(effect_bundle)
        local added_effects = false --:boolean
        for i = 1, #effect_set do
            local effect = effect_set[i]
            local culture_whitelist = effect.culture --# assume culture_whitelist: map<string,boolean>
            local faction_whitelist = effect.faction --# assume faction_whitelist: map<string, boolean>
            local is_valid_for_culture = (not culture_whitelist) or not not culture_whitelist[faction:subculture()]
            local is_valid_for_faction = (not faction_whitelist) or ((faction_whitelist[faction:name()] ~= false and is_valid_for_culture) or not not faction_whitelist[faction:name()]) 
            out("Checking effect: "..effect.key .."; is valid for culture: "..tostring(is_valid_for_culture).."; is valid for faction: "..tostring(is_valid_for_faction))
            if settlements >= effect.min and settlements <= effect.max and is_valid_for_culture and is_valid_for_faction then
                local base = settlements
                if effect.full_province_only then
                    base = full_provinces
                elseif effect.capitals_only then
                    base = capitals
                end
                local value = get_effect_value(effect.value, base, effect.halving_value, effect.invert_halving, effect.min)
                out("Base ("..base..") within bounds: ("..effect.min..","..effect.max..") and being added with value: "..value)
                if value ~= 0 then
                    new_bundle:add_effect(effect.key, effect.scope, value)
                    added_effects = true
                end
            end
        end
        if added_effects then
            cm:apply_custom_effect_bundle_to_faction(new_bundle, faction)
        end
    end
end

--v function(faction: CA_FACTION)
local function build_region_counts_and_bundles(faction)
    local region_list = faction:region_list()
    local c = 0
    local f = 0
    local s = 0
    for i = 0, region_list:num_items() - 1 do
        local region = region_list:item_at(i)
        s = s + 1 
        if region:is_province_capital() then
            c = c + 1
            if faction:holds_entire_province(region:province_name(), true) then
               f = f + 1 
            end
        end
    end
    out("Human faction "..faction:name().." has c:"..c.." f:"..f.." s:"..s)
    build_imperium_bundles(faction, c, s, f)
end

sfo_imperium_power = function() 
    if cm:is_new_game() then
        for j = 1, #cm:get_human_factions() do
            local faction = cm:get_faction(cm:get_human_factions()[j])
            out("Building Startpos Imperium Bundle for: "..faction:name())
            build_region_counts_and_bundles(faction)
        end
    end
    core:add_listener(
        "ImperiumEffects",
        "GarrisonOccupiedEvent",
        function(context)
            return context:garrison_residence():region():owning_faction():is_human()
        end,
        function(context)
            local faction = context:garrison_residence():region():owning_faction() --:CA_FACTION
            out("Human faction "..faction:name().." captured a settlement.")
            build_region_counts_and_bundles(faction)
        end,
        true)
    core:add_listener(
        "ImperiumEffects",
        "RegionFactionChangeEvent",
        function(context)
            return context:previous_faction():is_human()
        end,
        function(context)
            local faction = context:previous_faction() --:CA_FACTION
            out("human faction  "..faction:name().." lost a settlement")
            build_region_counts_and_bundles(faction)
        end,
        true)
    core:add_listener(
        "ImperiumEffects",
        "FactionJoinsConfederation",
        function(context)
            return context:confederation():is_human()
        end,
        function(context)
            local faction = context:confederation() --:CA_FACTION
            out("human faction  "..faction:name().." confederated an ally")
            build_region_counts_and_bundles(faction)
        end,
        true)

end

out("Script Loaded")