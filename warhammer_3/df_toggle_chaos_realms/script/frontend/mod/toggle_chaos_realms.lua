---@param t any
local out = function(t)
  ModLog("DRUNKFLAMINGO: "..tostring(t).." (toggle realms)")
end


local mct 
if get_mct then
  mct = get_mct()
end

local set_narrative_enabled = function(enable)
  out("Front end set narrative enabled: "..tostring(enable))
  core:svr_save_bool("sbool_enabled_chaos_realms", enable)
end


local get_registered_narrative_preference = function (ignore_mct)
  if mct and not ignore_mct then
    local settings = mct:get_mod_by_key("toggle_chaos_realms")
    return settings:get_option_by_key("a_enable"):get_selected_setting()
  end
  if not core:svr_load_registry_bool("rbool_chaos_realm_preference_set") then
    return true
  end 
  return core:svr_load_registry_bool("rbool_enabled_chaos_realms") 
end


local function get_or_create_toggle_box_sp(uic_grand_campaign)
  -- :root:campaign_select_new:right_holder:tab_settings:settings_holder:settings_holder:listview:list_clip:list_box
  local campaign_options = find_uicomponent(uic_grand_campaign, "right_holder", "tab_settings", "settings_holder", "settings_holder", "listview", "list_clip", "list_box")
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
        return context.string == "campaign_select_new"
    end,
    function (context)
      local uic_grand_campaign = find_uicomponent("campaign_select_new");
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
  "ChaosRealmsHideinIE",
  "ComponentLClickUp",
  function(context) return find_uicomponent("campaign_select_new") and uicomponent_descended_from(UIComponent(context.component), "tab_campaign") end,
  function(context)			
    local uic_grand_campaign = find_uicomponent("campaign_select_new");
    local campaign_options = find_uicomponent(uic_grand_campaign, "right_holder", "tab_settings", "settings_holder", "settings_holder", "listview", "list_clip", "list_box")
    local existing_checkbox = find_uicomponent(campaign_options, "checkbox_chaos_realms")
    if existing_checkbox then
      out("Found the checkbox state on campaign selected")
      core:get_tm():real_callback(function()
        -- :root:campaign_select_new:side_panel_holder:side_holder:button_list
        local campaign_button_list = find_uicomponent(uic_grand_campaign, "side_panel_holder", "side_holder", "button_list")
        local campaign_id = campaign_button_list:GetContextObjectId("CcoCampaignStartInfo")
        local enable = campaign_id == "wh3_main_chaos__0_0"
        out("existing_checkbox visibility " ..tostring(existing_checkbox:Visible()).. "new visibility " .. tostring(enable))
        existing_checkbox:SetVisible(enable)
      end, 100, "ChaosRealmToggleHideCallback")
      
    else
      out("Campaign is beign selected but we couldn't find any checkbox for the realms toggle")
    end
  end,
  true
);

core:add_listener(
  "start_campaign_button_listener",
  "ComponentLClickUp",
  function(context) return context.string == "button_start_campaign" and uicomponent_descended_from(UIComponent(context.component), "campaign_select_new") end,
  function(context)			
    local uic_grand_campaign = find_uicomponent("campaign_select_new");
    local campaign_options = find_uicomponent(uic_grand_campaign, "right_holder", "tab_settings", "settings_holder", "settings_holder", "listview", "list_clip", "list_box")
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

if mct then
  
  local mod_settings = mct:register_mod("toggle_chaos_realms")
  local loc_prefix = "mct_df_toggle_realms_"
  mod_settings:set_title(loc_prefix.."mod_title", true)
  mod_settings:set_author("Drunk Flamingo")
  mod_settings:set_description(loc_prefix.."mod_desc", true)

  local enable = mod_settings:add_new_option("a_enable", "checkbox")
  enable:set_default_value(get_registered_narrative_preference(true))
  enable:set_text(loc_prefix.."a_enable_txt", true)
  enable:set_tooltip_text(loc_prefix.."a_enable_tt", true)
  --when this toggle gets changed, also change the in menu toggle to match
  enable:add_option_set_callback(function (option)
    local val = option:get_selected_setting() 
    set_narrative_enabled(val)
    local uic_grand_campaign = find_uicomponent("campaign_select_new");
    if uic_grand_campaign then
      local campaign_options = find_uicomponent(uic_grand_campaign, "right_holder", "tab_settings", "settings_holder", "settings_holder", "listview", "list_clip", "list_box")
      local existing_checkbox = find_uicomponent(campaign_options, "checkbox_chaos_realms")
      if existing_checkbox then
        if val then
          existing_checkbox:SetState("selected")
        else
          existing_checkbox:SetState("active")
        end
      end
    end
  end)
  core:add_listener(
    "MctPanelOpened_ToggleChaosRealms",
    "MctPanelOpened",
    true,
    function (context)
      local uic_grand_campaign = find_uicomponent("campaign_select_new");
      local campaign_options = find_uicomponent(uic_grand_campaign, "right_holder", "tab_settings", "settings_holder", "settings_holder", "listview", "list_clip", "list_box")
      local existing_checkbox = find_uicomponent(campaign_options, "checkbox_chaos_realms")
      if existing_checkbox then
        out("Found the checkbox state on campaign starting")
        out("existing_checkbox state " ..existing_checkbox:CurrentState())
        local is_enabled = not not string.find(existing_checkbox:CurrentState(), "selected")
        enable:set_selected_setting(is_enabled)
      elseif uic_grand_campaign then
        out("MCT panel opened but we couldn't find any checkbox for the realms toggle despite UIC grand campaign existing!")
      end
    end,
    true)
end