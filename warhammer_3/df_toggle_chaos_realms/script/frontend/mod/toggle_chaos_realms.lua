---@param t string
local out = function(t)
  ModLog("DRUNKFLAMINGO: "..tostring(t).." (toggle realms)")
end

--:root:sp_grand_campaign:centre_docker:lord_details_panel:lord_info:tab_settings:options:campaign:label_tx

local set_narrative_enabled = function(enable)
  out("Front end set narrative enabled: "..tostring(enable))
  core:svr_save_bool("sbool_enabled_chaos_realms", enable)
end


local get_registered_narrative_preference = function ()
  if not core:svr_load_registry_bool("rbool_chaos_realm_preference_set") then
    return true
  end 
  return core:svr_load_registry_bool("rbool_enabled_chaos_realms") 
end


local function get_or_create_toggle_box_sp(uic_grand_campaign)
  local campaign_options = find_uicomponent(uic_grand_campaign, "centre_docker", "lord_details_panel", "lord_info", "tab_settings", "options", "campaign")
  local existing_checkbox = find_uicomponent(campaign_options, "checkbox_chaos_realms")
  if is_uicomponent(existing_checkbox) then
    return existing_checkbox
  else
    out("No existing chaos realms checkbox found, creating one")
    local text_label = find_uicomponent(campaign_options, "label_tx")
    local chaos_realm_label = UIComponent(text_label:CopyComponent("label_tx_chaos_realms"))
    chaos_realm_label:SetStateText(common.get_localised_string("fe_chaos_realm_header"), "fe_chaos_realm_header")
    chaos_realm_label:SetTooltipText("", true)
    out("Set the header")

    local chaos_realm_checkbox = UIComponent(campaign_options:CreateComponent("checkbox_chaos_realms", "ui/templates/df/sp_campaign_settings_checkbox_w_clickable_label"))
    if chaos_realm_checkbox then
      chaos_realm_checkbox:SetVisible(true)
      local saved_preference = get_registered_narrative_preference()
      if saved_preference then
        out("Saved preference: Realms on")
        chaos_realm_checkbox:SetState("selected")
      elseif saved_preference == false then
        out("Saved preference: Realms Off")
        chaos_realm_checkbox:SetState("active")
      else
        out("No saved preference: New user; realms defaulting to on!")
      end
      return chaos_realm_checkbox
    else
      out("Failed to create the chaos realm checkbox!")
    end
  end
end


local function get_or_create_toggle_box_mp(uic_grand_campaign)
  local options_list = find_uicomponent(uic_grand_campaign, "ready_parent", "center_holder", "settings_parent", "settings_list")
  local existing_checkbox = find_uicomponent(options_list, "checkbox_chaos_realms")
  if existing_checkbox then
    return existing_checkbox
  else 
    out("No existing chaos realms checkbox found, creating one")
    local chaos_realm_checkbox = UIComponent(options_list:CreateComponent("checkbox_chaos_realms", "ui/templates/df/mp_lobby_setup_checkbox_w_label"))
    chaos_realm_checkbox:SetVisible(true)
    return chaos_realm_checkbox
  end
end

local function start_mp_lobby_update_callbacks()

  local tm = core:get_tm()
  tm:repeat_real_callback(function ()
    local uic_grand_campaign = find_uicomponent("mp_grand_campaign");
    local options_list = find_uicomponent(uic_grand_campaign, "ready_parent", "center_holder", "settings_parent", "settings_list")
    local existing_checkbox = find_uicomponent(options_list, "checkbox_chaos_realms")
    if not existing_checkbox then
      out("the repeat callback couldn't find the checkbox anymore and is ending")
      tm:remove_real_callback("MPUpdateCheckBox")
      return
    end
    local front_end_root = common.get_context_value("FrontendRoot")
    local campaign_key = front_end_root:Call("CampaignLobbyContext.CampaignStartInfoContext.Key")
    local has_tol_context = front_end_root:Call("CampaignLobbyContext.CampaignStartInfoContext.TimeOfLegendsCampaignRecordContext")
    if campaign_key ~= "wh3_main_chaos" or (not not has_tol_context) then
      out("This campaign isn't the chaos one, deleting the checkbox and ending the repeat callback")
      existing_checkbox:Destroy()
      tm:remove_real_callback("MPUpdateCheckBox")
      return
    end
    local is_host = front_end_root:Call("CampaignLobbyContext.LocalPlayerSlotContext.IsHost")
    if is_host then
      existing_checkbox:SetVisible(true)
    else
      existing_checkbox:SetVisible(false)
    end
  end, 500, "MPUpdateCheckBox")
end



core:add_listener(
    "ChaosRealmsToggle",
    "FrontendScreenTransition",
    function (context)
        return context.string == "sp_grand_campaign"
    end,
    function (context)
      local uic_grand_campaign = find_uicomponent("sp_grand_campaign");
			if not uic_grand_campaign then
				out("ERROR: couldn't find uic_grand_campaign, how can this be?");
				return false
			end
      local ok, err = pcall(function()
        get_or_create_toggle_box_sp(uic_grand_campaign)
      end) 
      if not ok then
        out("Failed to do the thing")
        out(err)
      end
    end,
    true
)

core:add_listener(
    "ChaosRealmsToggle",
    "FrontendScreenTransition",
    function (context)
        return context.string == "mp_grand_campaign"
    end,
    function (context)
      local uic_grand_campaign = find_uicomponent("mp_grand_campaign");
			if not uic_grand_campaign then
				out("ERROR: couldn't find uic_grand_campaign, how can this be?");
				return false
			end
      local ok, err = pcall(function()
        local front_end_root = common.get_context_value("FrontendRoot")

        local is_resumed = front_end_root:Call("CampaignLobbyContext.IsResumed")
        out("MP Grand Campaign has opened! Is resumed == "..tostring(is_resumed))
        if is_resumed then
          out("Not creating the tickbox for this MP lobby: the campaign is resumed!")
        else
          get_or_create_toggle_box_mp(uic_grand_campaign)
          start_mp_lobby_update_callbacks()
        end
      end) 
      if not ok then
        out("Failed to do the thing")
        out(err)
      end
    end,
    true
)


core:add_listener(
  "start_campaign_button_listener",
  "ComponentLClickUp",
  function(context) return context.string == "button_start_campaign" and uicomponent_descended_from(UIComponent(context.component), "sp_grand_campaign") end,
  function(context)			
    local uic_grand_campaign = find_uicomponent("sp_grand_campaign");
    local campaign_options = find_uicomponent(uic_grand_campaign, "centre_docker", "lord_details_panel", "lord_info", "tab_settings", "options", "campaign")
    local existing_checkbox = find_uicomponent(campaign_options, "checkbox_chaos_realms")
    if existing_checkbox then
      out("Found the checkbox state on campaign starting")
      out("existing_checkbox state " ..existing_checkbox:CurrentState())
      local enable = not not string.find(existing_checkbox:CurrentState(), "selected")
      set_narrative_enabled(enable)
    else
      out("Campaign is starting but we couldn't find any checkbox for the realms toggle")
    end
  end,
  true
);

core:add_listener(
  "ready_button_listener",
  "ComponentLClickUp",
  function(context) return context.string == "button_ready" and uicomponent_descended_from(UIComponent(context.component), "mp_grand_campaign") end,
  function(context)			
    local uic_grand_campaign = find_uicomponent("mp_grand_campaign");
    local options_list = find_uicomponent(uic_grand_campaign, "ready_parent", "center_holder", "settings_parent", "settings_list")
    local existing_checkbox = find_uicomponent(options_list, "checkbox_chaos_realms")
    if existing_checkbox then
      out("Found the checkbox state on campaign starting")
      out("existing_checkbox state " ..existing_checkbox:CurrentState())
      local enable = not not string.find(existing_checkbox:CurrentState(), "selected")
      set_narrative_enabled(enable)
    else
      out("Local player is ready but we couldn't find any checkbox for the realms toggle")
      out("The game is hopefully either being resumed or not a chaos realms campaign")
    end
  end,
  true
);

--TODO coop multiplayer
--[[[ui] <450.5s>   root > mp_grand_campaign > ready_parent > center_holder > settings_parent > settings_list > checkbox_load_lord
[ui] <450.5s>   root > mp_grand_campaign > ready_parent > center_holder > settings_parent > settings_list > checkbox_load_lord > dy_label

]]