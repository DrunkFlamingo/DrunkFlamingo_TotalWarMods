--v function(text: any)
local function log(text)
    dev.log(tostring(text), "CultUI")
end

--v function() --> CA_UIC
local function get_culture_mechanics_bar()
    local culture_mechanics = find_uicomponent(cm:ui_root(), "culture_mechanics");
    if not culture_mechanics then
        log("Could not acquire the culture mechanics UIC")
    end
    return culture_mechanics
end

--v function(faction_name: string, effect_bundle: string, numeric_value: int, breakdown_factors: map<string, int>, alternate_uic: vector<string>?)
local function set_population_value(faction_name, effect_bundle, numeric_value, breakdown_factors, alternate_uic)
    log("Set Population Value called for ["..faction_name.."] with bundle ["..effect_bundle.."] and UI: ["..numeric_value.."]")
    local uic = get_culture_mechanics_bar()
    local mechanic_root = string.gsub(effect_bundle, "_%d", "")
    if alternate_uic then --# assume alternate_uic: vector<string>!
        uic = dev.uic_from_vec(cm:ui_root(), alternate_uic)
    end
    if not not uic then
        cm:apply_effect_bundle(effect_bundle, faction_name, 0)
        uic:InterfaceFunction("set_culture_mechanics_data", effect_bundle, faction_name, numeric_value)
        for factor, quantity in pairs(breakdown_factors) do
            uic:InterfaceFunction("add_culture_mechanics_breakdown_factor", factor, quantity, mechanic_root, faction_name)
        end
    end
end

--v function(faction_name: string, effect_bundle: string, current_value: int, maximum_value: int)
local function set_capacity_value(faction_name, effect_bundle, current_value, maximum_value)
    log("Set Capacity Value called for ["..faction_name.."] with bundle ["..effect_bundle.."] and UI: ["..current_value.."/"..maximum_value.."] ")
    local uic = get_culture_mechanics_bar()
    if not not uic then
        cm:apply_effect_bundle(effect_bundle, faction_name, 0)
        uic:InterfaceFunction("set_culture_mechanics_data", effect_bundle, faction_name, current_value, maximum_value);
    end
end

--v function(faction_name: string, effect_bundle: string, current_value: int, max_value: int, breakdown_factors: map<string, int>)
local function set_resource_bar_value(faction_name, effect_bundle, current_value, max_value, breakdown_factors)
    local uic = get_culture_mechanics_bar()
    local mechanic_root = string.gsub(effect_bundle, "_%d", "")
    if not not uic then
        for breakdown_factor, factor_value in pairs(breakdown_factors) do
            uic:InterfaceFunction("add_culture_mechanics_breakdown_factor", breakdown_factor, factor_value, mechanic_root, faction_name);
        end
        cm:apply_effect_bundle(effect_bundle, faction_name, 0)
        uic:InterfaceFunction("set_culture_mechanics_data", effect_bundle, faction_name, current_value, max_value);
    end
end

--v function(faction_name: string, effect_bundle: string, current_value: int, max_value: int, breakdown_factors: map<string, int>)
local function set_faction_focus_bar_value(faction_name, effect_bundle, current_value, max_value, breakdown_factors)
    local uic = get_culture_mechanics_bar()
    local mechanic_root = string.gsub(effect_bundle, "_%d", "")
    if not not uic then
        for breakdown_factor, factor_value in pairs(breakdown_factors) do
            uic:InterfaceFunction("add_culture_mechanics_breakdown_factor", breakdown_factor, factor_value, mechanic_root, faction_name);
        end
        uic:InterfaceFunction("set_culture_mechanics_data", effect_bundle, faction_name, current_value, max_value);
    end
end



return {
    population = set_population_value,
    capacity_fill = set_capacity_value,
    resource_bar = set_resource_bar_value,
    faction_focus = set_faction_focus_bar_value
}