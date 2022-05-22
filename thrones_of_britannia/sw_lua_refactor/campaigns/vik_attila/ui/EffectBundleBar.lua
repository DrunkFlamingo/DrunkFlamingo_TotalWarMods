local eb_roots = {} --:map<string, boolean>
local ebs = {} --:map<string, boolean>

--v function() --> CA_UIC
local function get_global_effects_list()
    local uic = dev.get_uic(cm:ui_root(), "layout", "top_center_holder", "resources_bar", "global_effect_list")
    if uic then
        return uic
    else
        return nil
    end
end

local function apply_changes_to_bundle_display()
    local display = get_global_effects_list()
    if display then
        for i = 0, display:ChildCount() - 1 do
            local bundle = UIComponent(display:Find(i))
            if ebs[bundle:Id()] then
                bundle:SetVisible(false)
            end
            local bundle_root = string.gsub(bundle:Id(), "_%d%d?", "")
            if eb_roots[bundle_root] then
                bundle:SetVisible(false)
            end
        end
    end
end




dev.eh:add_listener(
    "BundlesPanelClosedCampaign",
    "PanelClosedCampaign",
    true,
    function(context)
        apply_changes_to_bundle_display()
    end,
    true)


--v [NO_CHECK] function()
local function hook_into_cm()
    cm.apply_effect_bundle = function(cm, bundle, faction, timer)
        cm.game_interface:apply_effect_bundle(bundle, faction, timer)
        apply_changes_to_bundle_display()
        dev.log("Applied "..bundle.." to "..faction.." for ".. timer, "bundle")
    end
    local old_effect_remove = cm.remove_effect_bundle
    cm.remove_effect_bundle = function(cm, bundle, faction)
        cm.game_interface:remove_effect_bundle(bundle, faction)
        apply_changes_to_bundle_display()
        dev.log("removed "..bundle.." from "..faction, "bundle")
    end
end

hook_into_cm()

dev.first_tick(function(context)
    apply_changes_to_bundle_display()
    dev.eh:add_listener(
    "BundlesFactionTurnStart",
    "FactionTurnStart",
    true,
    function(context)
        dev.callback(function()
            apply_changes_to_bundle_display()
        end, 0.1)
    end,
    true)
end)

--v function(root: string)
local function remove_effect_bundles_with_root(root)
    eb_roots[root] = true
end
--v function(key:string)
local function remove_exact_bundle(key)
    ebs[key] = true
end

return {
    remove_effect_bundles_with_root = remove_effect_bundles_with_root,
    remove_exact_bundle = remove_exact_bundle
}