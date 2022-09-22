
---@param t string|any
local out = function(t)
  ModLog("DRUNKFLAMINGO: "..tostring(t).." (tabletopcaps)")
end

local out_if = function(statement, message)
  if statement then 
    out(message)
  end
end

local ttc_error = function()
  script_error("DRUNKFLAMINGO TableTopCaps Error, see log")
end

---fills the localisation with the provided strings
---@param loc string
---@param ... string
---@return string
local  fill_loc = function(loc, ...)
  local output = loc
  for i = 1, #arg do
      local f = i - 1
      local gsub_text = f..f..f..f
      output = string.gsub(output, gsub_text, arg[i])
  end
  return output
end


local problematic_characters = {".", "-"}
local function escape_string(s)
  local ret = s
  for i = 1, #problematic_characters do
    local search = "%"..problematic_characters[i]
    local replace = "%%%"..problematic_characters[i]
    ret = string.gsub(ret, search, replace)
  end
  return ret
end

local function add_table_to_table(t, to_add, log_name)
  for i = 1, #to_add do
      t[#t+1] = to_add[i]
  end
  if log_name then
    out("Added "..tostring(#to_add).." items to "..log_name)
  end
end


local function repeat_callback_with_timespan(callback, interval, timespan, name_for_removal)
  local name =  name_for_removal or ("ttc_temp_callback_"..core:get_unique_counter())
  cm:repeat_real_callback(callback, interval, name)
  cm:real_callback(function()
    cm:remove_real_callback(name)
  end, timespan, name)
end

---@class tabletopcaps
local mod = {} 

mod.ui_settings = {}
--mod.version = 0 
-- :root:units_panel:main_units_panel:recruitment_docker:recruitment_options:recruitment_listbox
mod.ui_settings.path_to_recruitment_sources = {
  [1] = {"units_panel", "main_units_panel", "recruitment_docker", "recruitment_options", 
    "recruitment_listbox", "recruitment_pool_list", "list_clip", "list_box"},
  [2] = {"units_panel", "main_units_panel", "recruitment_docker", "recruitment_options",
     "recruitment_listbox"}
}
mod.ui_settings.path_from_source_to_unit_list = {"unit_list", "listview", "list_clip", "list_box"}
mod.ui_settings.path_to_mercenary_unit_list = {
  {"units_panel", "main_units_panel", "recruitment_docker", "recruitment_options", "mercenary_display",
   "listview", "list_clip", "list_box"}
}
mod.ui_settings.path_to_allied_unit_list = {
  {"units_panel", "main_units_panel", "recruitment_docker", "recruitment_options", "allied_recuitment_display", "recruitment_holder", "unit_list", 
  "listview", "list_clip", "allied_unit_list"}
}


mod.ui_settings.path_to_mercenary_cap = {"units_panel", "main_units_panel", "recruitment_docker", "recruitment_options", "mercenary_display","frame", "mercenary_cap_holder", "tx_merc_count"}

mod.ui_settings.groups_to_pips = {
  ["core"] = {[1] = "ui/custom/recruitment_controls/common_units.png"},
  ["special"] = {
    [1] = "ui/custom/recruitment_controls/special_units_1.png",
    [2] = "ui/custom/recruitment_controls/special_units_2.png",
    [3] = "ui/custom/recruitment_controls/special_units_3.png"
  },
  ["rare"] = {
    [1] = "ui/custom/recruitment_controls/rare_units_1.png",
    [2] = "ui/custom/recruitment_controls/rare_units_2.png",
    [3] = "ui/custom/recruitment_controls/rare_units_3.png"
  }
}
mod.ui_settings.ttc_meter_prefix = "ttc_points_"

-- :root:units_panel:main_units_panel:recruitment_docker:recruitment_options:allied_recuitment_display:recruitment_holder:unit_list:listview:list_clip:allied_unit_list
-- :root:units_panel:main_units_panel:recruitment_docker:recruitment_options:mercenary_display:frame:listview:list_clip:list_box


---Who to check for what special rules
mod.subculture_potential_special_rule_bonus_values = {} ---@type table<string, string[]>
mod.faction_potential_special_rule_bonus_values = {} ---@type table<string, string[]>
mod.subtype_potential_special_rule_bonus_values = {} ---@type table<string, string[]>

-- bonus values used for controlling dynamic budgets
mod.budget_bonus_values = {
  ["ttc_capacity_rare"] = "rare",
  ["ttc_capacity_special"] = "special"
} ---@type table<string, string>

-- values used for offsetting dynamic budgets according to MCT settings
mod.budget_offsets = {
  ["ttc_capacity_rare"] = 0,
  ["ttc_capacity_special"] = 0
} ---@type table<string, integer>

-- bonus values used for overwriting the groups on a unit for special rules
mod.special_rule_bonus_value_prefix = "ttc_special_rule_"
mod.special_rule_group_override_suffixes = {
  ["_to_core"] = "core",
  ["_to_special"] = "special",
  ["_to_rare"] = "rare"
}
mod.special_rule_weight_override_suffix = "_weight"
mod.special_rules_override_group_values = {
  [1] = "core",
  [2] = "special",
  [3] = "rare"
}

mod.mercenaries_in_queue = {}

mod.card_listeners_active = {

}---@type table<UIC_Address, boolean>

mod.selected_character = 0

---@alias unit_selection_entry {index: integer, context_id: string|integer, main_unit_key: string}
mod.unit_selection = {} ---@type unit_selection_entry[]

---refresh the picture of which units we have selected.
mod.update_unit_selection = function()
  mod.unit_selection = {}
  local armyList = find_uicomponent_from_table(core:get_ui_root(), {"units_panel", "main_units_panel", "units"})
  out("Updating unit selection:")
  if not not armyList then
      for i = 0, armyList:ChildCount() - 1 do	
          local unitCard = UIComponent(armyList:Find(i))
          if unitCard:CurrentState() == "queued" then
              --do nothing
          elseif unitCard:CurrentState() == "selected" or unitCard:CurrentState() == "selected_hover" then
              local unitContextId = unitCard:GetContextObjectId("CcoCampaignUnit")
              local campaignUnitContext = cco("CcoCampaignUnit", unitContextId)
              if not campaignUnitContext then
                out("Could not acquire the CCO Campaign Unit for unit " .. unitCard:Id())
              else
                local unitRecordContext = campaignUnitContext:Call("UnitRecordContext")
                local main_unit_key = unitRecordContext:Call("Key")
                table.insert(mod.unit_selection, {index = tostring(i), context_id = unitContextId, main_unit_key = main_unit_key})
              end
          end
      end
      out("Updated unit selection with # of units: " .. tostring(#mod.unit_selection))
  end
end

---Count the number of units of the given type in the unit selection.
---@param unit_key string
---@return integer
mod.count_unit_in_selection = function(unit_key)
  local count = 0
  for i = 1, #mod.unit_selection do
    if mod.unit_selection[i].main_unit_key == unit_key then
      count = count + 1
    end
  end
  return count
end

--c_print(tostring(core:get_static_object("tabletopcaps").is_recruit_panel_open()))
---mercenary_display
---@return boolean
mod.is_merc_panel_open = function()
  -- :root:units_panel:main_units_panel:recruitment_docker:recruitment_options:mercenary_display
  local merc_display = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel",
   "recruitment_docker", "recruitment_options", "mercenary_display")
  return is_uicomponent(merc_display) and merc_display:Visible(true)
end


---@return boolean
mod.is_recruit_panel_open = function()
  -- :root:units_panel:main_units_panel:recruitment_docker:recruitment_options:recruitment_listbox
  local recruit_display = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel",
   "recruitment_docker", "recruitment_options", "recruitment_listbox")
  return is_uicomponent(recruit_display) and recruit_display:Visible(true)
end

---units_panel
---@return boolean
mod.is_units_panel_open = function()
  return cm:get_campaign_ui_manager():is_panel_open("units_panel")
end

---allied_recuitment_display
---@return boolean
mod.is_allied_recruitment_panel_open = function()
  -- :root:units_panel:main_units_panel:recruitment_docker:recruitment_options:allied_recuitment_display
  local allied_recuitment_display = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel",
   "recruitment_docker", "recruitment_options", "allied_recuitment_display")
  return is_uicomponent(allied_recuitment_display) and allied_recuitment_display:Visible(true)
end

---@return boolean
mod.is_exchange_panel_open = function()
  local unit_exchange = find_uicomponent(core:get_ui_root(), "unit_exchange")
  return is_uicomponent(unit_exchange) and unit_exchange:Visible(true)
end

---The spell browser doesn't work properly.
---@return boolean
mod.is_spell_browser_open = function()
  local browser = find_uicomponent("spell_browser")
  return is_uicomponent(browser) and browser:Visible(true)
end

---the upgrades docker also does not count as a panel AFAIK
mod.is_warband_upgrade_panel_open = function()
  -- :root:units_panel:main_units_panel:warband_upgrades_docker:warband_upgrades
  local warband_upgrades = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel",
   "warband_upgrades_docker", "warband_upgrades")
  return is_uicomponent(warband_upgrades) and warband_upgrades:Visible(true)
end

mod.last_panel_open = ""
mod.get_current_panel = function ()
  if mod.is_exchange_panel_open() then
    return "unit_exchange"
  elseif mod.is_merc_panel_open() then
    return "mercenary_recruitment"
  elseif mod.is_warband_upgrade_panel_open() then
    return "warband_upgrades"
  elseif mod.is_allied_recruitment_panel_open() then
    return "allied_recruitment"
  elseif mod.is_recruit_panel_open() then
    return "units_recruitment"
  else
    return ""
  end
end

---@param callback fun(context)
---@param ... string
mod.panels_open_callback = function(callback, ...)
  local panels = {}
  local log = ""
  for i = 1, #arg do
    panels[arg[i]] = true
    log = log .. arg[i]
  end
  out("Added panel open callback for "..log)
  core:add_listener(
    "TTCTempListeners",
    "PanelOpenedCampaign",
    function(context)
      return not not panels[context.string]
    end,
    callback,
    false)
end

---black arks and camps have caps
---devotee armies are capped through a different system but don't show them.
---caravans have no caps, and set piece armies should never be touched.
---@param force MILITARY_FORCE_SCRIPT_INTERFACE
---@return boolean
mod.force_has_caps = function(force)
  local force_type = force:force_type():key();
  if not force:is_armed_citizenry() and force:has_general() and not force:is_set_piece_battle_army() then
    if force_type ~= "DISCIPLE_ARMY" and force_type ~= "CARAVAN" then
      return true
    end
  end
  return false
end


---@class ttc_unit
local ttc_unit = {}
mod.units = {} ---@type table<string, ttc_unit>

---@class ttc_character
local ttc_character = {}
mod.characters = {}---@type table<integer, ttc_character>



---@param unit_key string
---@param group_name string|nil
---@param unit_weight integer|nil
---@param is_special_rule boolean|nil
---@return ttc_unit
ttc_unit.new = function(unit_key, group_name, unit_weight, is_special_rule, suppress_log)
  local self = {} ---@class ttc_unit
  setmetatable(self, {
    __index = ttc_unit
  })
  out_if(not suppress_log, "Creating a unit ["..(unit_key or "Null unit").."] in group ["..(group_name or "core")..(tostring(unit_weight) or "1").."], special rule: "..tostring(is_special_rule))
  self.key = unit_key
  self.group = group_name or "core" ---@type string
  self.weight = unit_weight or 1 ---@type integer
  self.is_special_rule = is_special_rule 

  return self
end

ttc_unit.get_cost_string = function (self)
  return "[[img:"..self.group .. "_" ..self.weight.."]][[/img]]"
end


---@param character CHARACTER_SCRIPT_INTERFACE
---@return ttc_character|nil
ttc_character.new = function(character)
  local self = {} ---@class ttc_character
  setmetatable(self, {
    __index = ttc_character
  })
  if not character or character:is_null_interface() then
    out("WTF? Character is null")
    return 
  end
  self.cqi = character:command_queue_index()
  self.interface = character
  self.force = character:military_force()
  if self.force:is_null_interface() then
    out("WTF? Character "..self.cqi.." was sent to TTC character constructor but has no military_force")
    return
  end
  mod.characters[self.cqi] = self
  self.is_clone = false
  self.units = {} ---@type table<string, ttc_unit>
  self.factors = {}
  self.budget = {}
  self.count = {}

  self.potential_special_rules = {}
  local subculture = self.interface:faction():subculture()
  local faction = self.interface:faction():name()
  local subtype = self.interface:character_subtype_key()
  add_table_to_table(self.potential_special_rules, mod.subculture_potential_special_rule_bonus_values[subculture] or {})--, "subculture special rules")
  add_table_to_table(self.potential_special_rules, mod.faction_potential_special_rule_bonus_values[faction] or {})--, "faction special rules")
  add_table_to_table(self.potential_special_rules, mod.subtype_potential_special_rule_bonus_values[subtype] or {})--, "subtype special rules")

  return self
end

---Clone an existing TTC character record to create a dummy version which can be used to test hypothetical scenarios.
---@param self ttc_character
---@return ttc_character
ttc_character.clone_to_temp_record = function(self)
  local clone = {}
  setmetatable(clone, {
    __index = ttc_character
  })
  clone.is_clone = true
  clone.cqi = -1
  clone.interface = self.interface
  clone.force = self.force
  clone.units = self.units
  clone.budget = self.budget
  clone.count = {}
  for k, v in pairs(self.count) do
    self.count = {}
    clone.count[k] = v
  end
  clone.factors = {}
  self.potential_special_rules = {}
  clone.log = function(this, t)
    ModLog("DRUNFLAMINGO: "..tostring(t).." (tabletopcaps:cloned_character"..tostring(self.cqi)..")")
  end
  
  return clone
end

ttc_character.log = function(self, t)
  ModLog("DRUNFLAMINGO: "..tostring(t).." (tabletopcaps:character"..tostring(self.cqi)..")")
end

---get the command queue index
---@return integer
ttc_character.command_queue_index = function(self)
  return self.cqi
end

---@param self ttc_character
---@param unit_record ttc_unit
---@param is_queued_exchange boolean|nil
ttc_character.apply_cost_of_unit = function(self, unit_record, is_queued_exchange)
  self:log("Purchased unit "..unit_record.key)
  self.count[unit_record.group] = (self.count[unit_record.group] or 0) + unit_record.weight
  if self.is_clone then
    return
  end
  local factor_key = unit_record.key
  self.factors[factor_key] = (self.factors[factor_key] or 0) + unit_record.weight
  core:trigger_event("ModScriptEventTabletopCapsCountChanged", self.interface, unit_record.group)
  if self.count[unit_record.group] > (self.budget[unit_record.group] or 0) then
    out("WARN - after recruiting unit with key ["..unit_record.key.."], the count exceeds the budget on character ["..tostring(self.cqi).."]")
  end
end

---@param self ttc_character
---@param unit_record ttc_unit
---@param is_queued_exchange boolean|nil
ttc_character.refund_cost_of_unit = function(self, unit_record, is_queued_exchange)
  self:log("Refunded unit "..unit_record.key)
  self.count[unit_record.group] = (self.count[unit_record.group] or 0) - unit_record.weight
  if self.is_clone then
    return
  end
  local factor_key = unit_record.key
  self.factors[factor_key] = (self.factors[factor_key] or 0) - unit_record.weight
  if (self.count[unit_record.group] or 0) < 0 then
    out("WARN - after refunding unit with key ["..unit_record.key.."], the count for ["..unit_record.weight.."] is below 0 on character ["..tostring(self.cqi).."]")
  end
  core:trigger_event("ModScriptEventTabletopCapsCountChanged", self.interface, unit_record.group)
end

---refreshes the budget of the character from the bonus values attached to them.
---@param self ttc_character
ttc_character.refresh_budget = function(self)
  self.budget = {
    core = 999
  }
  if self.is_clone then
    out("Refresh budget should not be called on cloned character records")
    return
  end

  self:log("Building budget from bonus values")
  for effect_bonus_value_key, group_key in pairs(mod.budget_bonus_values) do
    local bonus_value = cm:get_characters_bonus_value(self.interface, effect_bonus_value_key)
    self:log("Bonus value ["..effect_bonus_value_key.."] value ["..tostring(bonus_value).."] applies to group "..group_key)
    self.budget[group_key] = bonus_value
  end
end

---refreshes the special rules associated with the character
ttc_character.refresh_special_rules = function(self)
  if self.is_clone then
    out("Refresh special rules should not be called on cloned character records")
    return
  end
  self:log("Refreshing special rules")
  for i = 1, #self.potential_special_rules do
    local unit_key = self.potential_special_rules[i]
    local old_info = mod.units[unit_key] or ttc_unit.new(unit_key)
    local new_group
    for suffix, group in pairs(mod.special_rule_group_override_suffixes) do
      local group_override_key = mod.special_rule_bonus_value_prefix .. unit_key .. suffix
      local group_override = cm:get_characters_bonus_value(self.interface, group_override_key)
      self:log("Checking bonus values ["..group_override_key.."] = ["..tostring(group_override).."]")
      if group_override ~= 0 and group ~= old_info.group then
        new_group = group
      end
    end
    local weight_override_key = mod.special_rule_bonus_value_prefix .. unit_key ..mod.special_rule_weight_override_suffix
    local weight_change = cm:get_characters_bonus_value(self.interface, weight_override_key)
    self:log(" Weight change  ["..weight_override_key.."] = ["..tostring(weight_change).."] ")
    if new_group then
      --this special rule is a group override
      local weight = old_info.weight + weight_change
      self.units[unit_key] = ttc_unit.new(unit_key, new_group, weight, true)
    elseif weight_change ~= 0 then
      --this special rule only overrides the weight
      local weight_override = old_info.weight + weight_change
      self.units[unit_key] = ttc_unit.new(unit_key, old_info.group, weight_override, true)
    end
  end
end

---@param self ttc_character
---@param unit_record ttc_unit
---@return boolean
ttc_character.can_afford_unit = function(self, unit_record)
  return ((self.count[unit_record.group] or 0) + unit_record.weight) 
  <= (self.budget[unit_record.group] or 0) 
end

---Can this character afford to swap one unit for another X times?
---@param self ttc_character
---@param unit_record_to_remove ttc_unit
---@param unit_record_to_add ttc_unit
---@param number_of_replacements integer|nil
---@return boolean
ttc_character.can_afford_swap = function (self, unit_record_to_remove, unit_record_to_add, number_of_replacements)
  if self.is_clone then
    out("Cannot afford swap should not be called on cloned character records")
    return false
  end
  local q = number_of_replacements or 1
  local clone = self:clone_to_temp_record()
  for i = 1, q do
    clone:refund_cost_of_unit(unit_record_to_remove)
  end
  for i = 1, q do
    if clone:can_afford_unit(unit_record_to_add) then
      clone:apply_cost_of_unit(unit_record_to_add)
    else
      return false
    end
  end
  return true
end

---@param self ttc_character
---@param group_key string
---@return boolean
ttc_character.is_over_cap = function(self, group_key)
  return ((self.count[group_key]  or 0) > (self.budget[group_key] or 0))
end

---@param self ttc_character
ttc_character.print_state = function (self)
  self:log("CURRENT STATE")
  local state_string = "Budget:\n"
  for key, value in pairs(self.budget) do
    state_string = state_string .. "\t" .. key .. ":" .. tostring(value) .. "\n"
  end
  state_string = state_string .. "Spend:\n"
  for key, value in pairs(self.count) do
    state_string = state_string .. "\t" .. key .. ":" .. tostring(value) .. "\n"
  end
  state_string = state_string .. "Special Units:\n"
  for key, value in pairs(self.units) do
    state_string = state_string .. "\t" .. key .. "\n"
  end
  self:log(state_string)
  self:log("FINISHED")
end

---@param unit_key string
---@param character_record ttc_character|nil
---@return ttc_unit
mod.get_unit = function(unit_key, character_record)
  if character_record ~= nil then
    if character_record.units[unit_key] then
      return character_record.units[unit_key]
    end
  end
  return mod.units[unit_key] or ttc_unit.new(unit_key)
end

mod.get_unit_if_existing = function(unit_key)
  return mod.units[unit_key] 
end

---is this unit already in the caps system?
---@param unit_key string
---@return boolean
mod.does_unit_exist = function(unit_key)
  return mod.units[unit_key] ~= nil
end

---@return ttc_character|nil
mod.get_selected_character_record = function()
  --[[ note: this causes bugs.
  if mod.characters[mod.selected_character] then
    return mod.characters[mod.selected_character]
  end
  --]]
  if cm:get_campaign_ui_manager():get_char_selected_cqi() == -1 then
    out("No character selected to fetch the record from")
    return nil
  end
  return mod.characters[cm:get_campaign_ui_manager():get_char_selected_cqi()] or 
  ttc_character.new(cm:get_character_by_cqi(cm:get_campaign_ui_manager():get_char_selected_cqi()))
end

-----------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

---for calling from the lua script console to generate bonus values
mod.list_bonus_values = function()
  local file = io.open("ttc_bonus_value_output.txt", "w+")
  if not file then
    return
  end
  for unit_key, info in pairs(mod.units) do
    for suffix, group in pairs(mod.special_rule_group_override_suffixes) do
      local group_override_key = mod.special_rule_bonus_value_prefix .. unit_key .. suffix
      file:write(group_override_key.."\n")
    end
    local weight_override_key = mod.special_rule_bonus_value_prefix .. unit_key ..mod.special_rule_weight_override_suffix
    file:write(weight_override_key.."\n")
  end
  file:flush()
  file:close()
end

---for clocking the refresh of bonus values
---Typically called only from the lua script console
mod.clock_bonus_value_refresh = function()
  local character_record = mod.get_selected_character_record()
  if not character_record then
    return
  end
  out("CLOCK STARTING")
  local nClock = os.clock()
  for i = 1, 50 do
    character_record:refresh_budget()
    character_record:refresh_special_rules()
  end
  local eClock = os.clock()
  out("CLOCK END")
  out("ELAPSED TIME: "..(eClock-nClock))
end

---for outputting the details needed for the cost preview webapp.
mod.print_unit_names_and_cards_for_webapp = function()
  local file = io.open("unit_names_and_cards.txt", "w+")
  if not file then
    return
  end
  for unit_key, info in pairs(mod.units) do
    local main_unit_record = cco("CcoMainUnitRecord", unit_key)
    local localized_name = main_unit_record:Call("Name")
    if not localized_name then
      localized_name = "Unlocalised Unit"
    end
    local card_path = main_unit_record:Call("IconPath")
    if not card_path then
      card_path = "ui/units/icons/placeholder.png"
    end
    file:write("\""..unit_key.."\": {\"name\":\""..localized_name.."\", \"card_path\":\""..card_path.."\"},\n")
  end
  file:flush()
  file:close()
end

---Used to dump all information about the local faction's characters to log
---@param self tabletopcaps
mod.print_all_characters = function (self)
  local char_list = cm:get_local_faction(true):character_list()
  for i = 0, char_list:num_items() - 1 do
    local this_character = char_list:item_at(i)
    if mod.characters[this_character:command_queue_index()] then
      mod.characters[this_character:command_queue_index()]:print_state()
    end
  end
end


-----------------------------------------------------------------------------------------------------------
---------------------------------------Unit Cards--------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

---comment
---@param unitCard UIC
---@param character_record ttc_character|nil
---@param unit_record ttc_unit
mod.add_listeners_to_army_unit_card = function(unitCard, character_record, unit_record)
  local cost_tooltip_loc
  local tt_restricted_loc
  if not character_record then
    out("Aborting add_listeners_to_army_unit_card; No character record for unit card")
    return 
  end
  if unit_record.group == "core" then
    local desc_loc_to_fill = common.get_localised_string("ttc_unit_no_cost")
    local detail_loc_to_fill = common.get_localised_string("ttc_army_unlimited")
    local group_name = common.get_localised_string("ttc_group_name_core")
    cost_tooltip_loc = fill_loc(desc_loc_to_fill, group_name) .. "\n\n" .. fill_loc(detail_loc_to_fill, group_name)
  else
    local desc_loc_to_fill = common.get_localised_string("ttc_unit_cost")
    local detail_loc_to_fill = common.get_localised_string("ttc_army_limited")
    local points_name = common.get_localised_string("ttc_measurement_name")
    local group_name = common.get_localised_string("ttc_group_name_"..unit_record.group)
    local cost = tostring(unit_record.weight)
    local capacity = tostring((character_record).budget[unit_record.group] or 0)
    cost_tooltip_loc = fill_loc(desc_loc_to_fill, group_name, cost, points_name) .. "\n\n" .. fill_loc(detail_loc_to_fill, capacity, points_name, group_name)
  end
  
  local this_callback = function()
      if not unitCard then
        out("Army card listener fired but the unit card it refers to is dead. A remove listener command is missing somewhere.")
        return
      end
      local should_be_visible = mod.is_exchange_panel_open() or mod.get_current_panel() ~= ""
      local pipElement = find_uicomponent(unitCard, "card_image_holder", "campaign", "ttc_pip")
      if not pipElement then
        local element_to_clone = find_uicomponent(unitCard, "card_image_holder", "campaign", "copy_of_upgradable")
        if not element_to_clone then
          --the cards are currently being touched by the game's code, don't bother doing anything to them.
        else
          pipElement = UIComponent(element_to_clone:CopyComponent("ttc_pip"))
        end
      end
      if not not pipElement then
        pipElement:SetVisible(should_be_visible)
        local y_offset = 20
        local AllyIcon = find_uicomponent(unitCard, "card_image_holder", "campaign", "faction_icon")
        if AllyIcon and AllyIcon:Visible() then
          y_offset = 32
        end
        pipElement:SetDockOffset(34, y_offset)
        local image_path = (mod.ui_settings.groups_to_pips[unit_record.group] or {})[unit_record.weight]
        --lockedOverlay:SetTooltipText(rec_unit._UIText, true)
        pipElement:SetImagePath(image_path or "ui/custom/recruitment_controls/fuckoffbutton.png")
        pipElement:SetCanResizeHeight(true)
        pipElement:SetCanResizeWidth(true)
        pipElement:Resize(24, 24)
        pipElement:SetCanResizeHeight(false)
        pipElement:SetCanResizeWidth(false)
        if cost_tooltip_loc then
          pipElement:SetTooltipText(cost_tooltip_loc, true)
        end
    end
    local harmonyIcon = find_uicomponent(unitCard, "icon_harmony")
    if harmonyIcon then
      harmonyIcon:SetDockOffset(5, 36)
    end
  end

  core:add_listener(
    "TTCArmyCardListeners",
    "ModScriptEventRefreshUnitCards",
    function (context)
      return true
    end,
    function (context)
      repeat_callback_with_timespan(this_callback, 50, 1200)
    end,
    true)
  this_callback()
end

mod.refresh_icons_on_exchange_bars = function()
  local character_record = mod.get_selected_character_record()
  out("Refreshing the icons in the exchange bars")
  local armyLists = {find_uicomponent_from_table(core:get_ui_root(), {"unit_exchange", "main_units_panel_1", "units"}), find_uicomponent_from_table(core:get_ui_root(), {"unit_exchange", "main_units_panel_2", "units"})}
  for j = 1, #armyLists do
    out("Refreshing the icons in the exchange bar "..tostring(j))
    local armyList = armyLists[j]
    for i = 0, armyList:ChildCount() - 1 do	
      out("Handling unit card "..tostring(i))
      local unitCard = UIComponent(armyList:Find(i))
      local turns = find_uicomponent(unitCard, "card_image_holder", "campaign", "Turns")
      if turns:Visible() then -- Queued Unit Card
        -- :root:hud_campaign:unit_information_parent:unit_info_panel_holder_parent:unit_info_panel_holder:unit_information
        local ok, err = pcall(function()
          local experience_icon = find_uicomponent(unitCard, "experience")
          local unitDetailsContextID = experience_icon:GetContextObjectId("CcoUnitDetails")
          out(unitCard:Id().. "is a queued unit "..tostring(unitDetailsContextID))
          local key_with_trailing_data = string.gsub(unitDetailsContextID, "UnitRecord_", "")
          local unit_key_with_faction = string.gsub(key_with_trailing_data, "_%d+_%d+%.%d+$", "")
          local unit_key = string.gsub(unit_key_with_faction, "_"..cm:get_local_faction_name(true), "")
          local unit_record = mod.get_unit(unit_key, character_record)
          mod.add_listeners_to_army_unit_card(unitCard, character_record, unit_record)
        end) if not ok then 
          out("Error reading a queued unit card")
          out(tostring(err))
        end
      elseif unitCard:Id() ~= "UnitCard1" then --regular unit_card that is not the general character
        local unitContextId = unitCard:GetContextObjectId("CcoCampaignUnit")
        local campaignUnitContext = cco("CcoCampaignUnit", unitContextId)
        local unit_key = campaignUnitContext:Call("UnitRecordContext.Key")
        if campaignUnitContext:Call("IsCharacter") then
          --nothing  
        else
          local unit_record = mod.get_unit(unit_key, character_record)
          mod.add_listeners_to_army_unit_card(unitCard, character_record, unit_record)
        end
      end
    end
  end
end

mod.refresh_icons_on_army_units_panel = function()
  core:remove_listener("TTCArmyCardListeners")
  local character_record = mod.get_selected_character_record()
  local armyList = find_uicomponent_from_table(core:get_ui_root(), {"units_panel", "main_units_panel", "units"})
  for i = 0, armyList:ChildCount() - 1 do	
    local unitCard = UIComponent(armyList:Find(i))
    if unitCard:Id():find("Queued") then -- Queued Unit Card
      unitCard:SimulateMouseOn()
      -- :root:hud_campaign:unit_information_parent:unit_info_panel_holder_parent:unit_info_panel_holder:unit_information
      local ok, err = pcall(function()
        local experience_icon = find_uicomponent(unitCard, "experience")
        local unitDetailsContextID = experience_icon:GetContextObjectId("CcoUnitDetails")
        out(unitCard:Id().. "is a queued unit "..tostring(unitDetailsContextID))
        local key_with_trailing_data = string.gsub(unitDetailsContextID, "UnitRecord_", "")
        local unit_key_with_faction = string.gsub(key_with_trailing_data, "_%d+_%d+%.%d+$", "")
        local unit_key = string.gsub(unit_key_with_faction, "_"..cm:get_local_faction_name(true), "")
        local unit_record = mod.get_unit(unit_key, character_record)
        mod.add_listeners_to_army_unit_card(unitCard, character_record, unit_record)
      end) if not ok then 
        out("Error reading a queued unit card")
        out(tostring(err))
      end
      unitCard:SimulateMouseOff()
    elseif unitCard:Id() ~= "LandUnit 0" then --regular unit_card that is not the general character
      local unitContextId = unitCard:GetContextObjectId("CcoCampaignUnit")
      if not unitContextId then
        out("No context id for unit card "..unitCard:Id())
      else
        local campaignUnitContext = cco("CcoCampaignUnit", unitContextId)
        local unit_key = campaignUnitContext:Call("UnitRecordContext.Key")
        if campaignUnitContext:Call("IsCharacter") then
          --nothing  
        else
          local unit_record = mod.get_unit(unit_key, character_record)
          mod.add_listeners_to_army_unit_card(unitCard, character_record, unit_record)
        end
      end
    end
  end
end

mod.destroy_icons_on_army_units_panel = function()
  -- :root:units_panel:main_units_panel:units
  core:remove_listener("TTCArmyCardListeners")
  local armyList = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "units")
  if not armyList then
    out("destroy_icons_on_army_units_panel: No army list found")
    return
  end
  for i = 0, armyList:ChildCount() - 1 do	
    local unitCard = UIComponent(armyList:Find(i))
    local pipElement = find_uicomponent(unitCard, "ttc_pip")
    if pipElement then
      pipElement:Destroy()
    end
  end
  core:remove_listener("TTCArmyCardListeners")
end



-----------------------------------------------------------------------------------------------------------
-----------------------------------------SELECTION---------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

---@param unitCard UIC
---@return string, boolean
mod.read_queued_unit_card = function(unitCard)
  --TODO read queued unit card generic function with ally checking
  return "", false
end

  


---@param character CHARACTER_SCRIPT_INTERFACE
---@param force boolean
mod.select_character = function(character, force)
  if not mod.is_units_panel_open() then
    out("Select character was called for ["..tostring(character:command_queue_index()).."], but the units panel isn't open!")
    return
  end
  if character:command_queue_index() == mod.selected_character then
    if not mod.characters[character:command_queue_index()] then
      out("Character "..tostring(character:command_queue_index()).." is the selected character already but has no record? Investigate this.")
    elseif not force then
      out("Aborting acquisition of budget and count for character ["..tostring(character:command_queue_index()).."] because they are already selected")
      return
    else
      out("reacquiring budget and count for character ["..tostring(character:command_queue_index()).."] because it was forced")
    end
  else
    out("Acquiring budget and count for character ["..tostring(character:command_queue_index()).."]")
  end
  
  local character_record = mod.characters[character:command_queue_index()] or ttc_character.new(character)
  character_record:refresh_special_rules()
  character_record:refresh_budget()
  character_record.count = {}
  character_record.factors = {}
  core:remove_listener("TTCArmyCardListeners")
  --refresh the character's counts from their army
  local armyList = find_uicomponent_from_table(core:get_ui_root(), {"units_panel", "main_units_panel", "units"})
  if not armyList then
    out("WARNING: called select character for ["..tostring(character:command_queue_index()).."] but acquiring the unit list failed!")
    return
  end
  local has_units_queued = false
  for i = 0, armyList:ChildCount() - 1 do	
    local unitCard = UIComponent(armyList:Find(i))
    if unitCard:Id():find("Queued") then -- Queued Unit Card
      unitCard:SimulateMouseOn()
      -- :root:hud_campaign:unit_information_parent:unit_info_panel_holder_parent:unit_info_panel_holder:unit_information
      local ok, err = pcall(function()
        local unitInfo = find_uicomponent(core:get_ui_root(), "hud_campaign", "unit_information_parent", "unit_info_panel_holder_parent",
        "unit_info_panel_holder")
        local detailContextId = unitInfo:GetContextObjectId("CcoUnitDetails")
        out("Context id was "..detailContextId)
        local key_with_trailing_data = string.gsub(detailContextId, "RecruitmentUnit_", "")
        local unit_key = string.gsub(key_with_trailing_data, "_%d+_%d+_%d+_%d+$", "")
        local unit_record = mod.get_unit(unit_key, character_record)
        mod.add_listeners_to_army_unit_card(unitCard, character_record, unit_record)
        character_record:apply_cost_of_unit(unit_record)
      end) if not ok then 
        out("Error reading a queued unit card")
        out(tostring(err))
      else
        out("Successfully read Card: "..unitCard:Id())
      end
      unitCard:SimulateMouseOff()
    elseif unitCard:Id() ~= "LandUnit 0" then --regular unit_card that is not the general character
      local unitContextId = unitCard:GetContextObjectId("CcoCampaignUnit")
      local campaignUnitContext = cco("CcoCampaignUnit", unitContextId)
      local unit_key = campaignUnitContext:Call("UnitRecordContext.Key")
      if campaignUnitContext:Call("IsCharacter") then
        --nothing  
      else
        local unit_record = mod.get_unit(unit_key, character_record)
        character_record:apply_cost_of_unit(unit_record)
        mod.add_listeners_to_army_unit_card(unitCard, character_record, unit_record)
      end
    end
  end


  mod.selected_character = character:command_queue_index()
  character_record:print_state()
end

-------------------------------------------------------
----warband upgrades
-------------------------------------------------------



----called when the player changes their unit selection
---updates the upgrade tree by adding lock icons for units which cannot be afforded.
mod.update_warband_tree = function ()
  -- :root:units_panel:main_units_panel:warband_upgrades_docker:warband_upgrades:body:upgrade_tree:slot_parent
  out("Updating Warband tree")
  local character_record = mod.get_selected_character_record()
  if not character_record then
    out("Aborting update_warband_tree; No character record for unit card")
    return 
  end
  local slot_parent = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "warband_upgrades_docker",
   "warband_upgrades", "body", "upgrade_tree", "slot_parent")

  if not slot_parent then
    out("update_warband_tree: No slot parent found")
    return
  end

  out("Slot parent has "..slot_parent:ChildCount().." children")

  for i = 0, slot_parent:ChildCount() - 1 do
    -- :wh3_main_chs_pink_horrors_exalted:CcoMainUnitRecordwh3_main_tze_inf_pink_horrors_1
    local slot = UIComponent(slot_parent:Find(i))
    
    for j = 1, slot:ChildCount() - 1 do
      local slotUnitCard = UIComponent(slot:Find(j))
      local mainUnitRecord = slotUnitCard:GetContextObjectId("CcoMainUnitRecord")
      local existing_element = find_uicomponent(slotUnitCard, "ttc_cost_pip")
      if existing_element then
        out("Existing element found for slot "..slot:Id().." "..mainUnitRecord)
      else
        local unit_record = mod.get_unit(mainUnitRecord, character_record)
        local cost_tooltip_loc

        if unit_record.group == "core" then
          local desc_loc_to_fill = common.get_localised_string("ttc_unit_no_cost")
          local detail_loc_to_fill = common.get_localised_string("ttc_army_unlimited")
          local group_name = common.get_localised_string("ttc_group_name_core")
          cost_tooltip_loc = fill_loc(desc_loc_to_fill, group_name) .. "\n\n" .. fill_loc(detail_loc_to_fill, group_name)
        else
          local desc_loc_to_fill = common.get_localised_string("ttc_unit_cost")
          local detail_loc_to_fill = common.get_localised_string("ttc_army_limited")
          local points_name = common.get_localised_string("ttc_measurement_name")
          local group_name = common.get_localised_string("ttc_group_name_"..unit_record.group)
          local cost = tostring(unit_record.weight)
          local capacity = tostring((character_record).budget[unit_record.group] or 0)
          cost_tooltip_loc = fill_loc(desc_loc_to_fill, group_name, cost, points_name) .. "\n\n" .. fill_loc(detail_loc_to_fill, capacity, points_name, group_name)
        end
        local pip_image = (mod.ui_settings.groups_to_pips[unit_record.group] or {})[unit_record.weight]
        if not pip_image then
          out("WARNING: could not find pip image for group "..unit_record.group)
        end
        
        local pip_element = UIComponent(slotUnitCard:CreateComponent("ttc_cost_pip", "ui/campaign ui/ttc_pip"))
        
        pip_element:SetImagePath(pip_image, 0)
        pip_element:SetTooltipText(cost_tooltip_loc, true)
        pip_element:SetVisible(true)
        out("Created element for slot "..slot:Id().." "..mainUnitRecord)
      end
    end
  end
end


---adds a line to the requirements list for an upgrade with the TTC points cost.
---@param upgrade_record ttc_unit
---@param quantity integer
mod.add_warband_upgrade_requirement_entry = function(unit_record, upgrade_record, quantity)
--TODO add the cost of the unit upgrade to the requirements list by cloning and modifying 
-- :root:units_panel:main_units_panel:warband_upgrades_docker:
-- warband_upgrades:body:info_holder:upgrade_info_holder:unit_info_costs:holder_requirements:body:per_unit_cost:
-- per_unit_cost_holder:dy_per_unit_cost
  local requirements = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "warband_upgrades_docker",
   "warband_upgrades", "body", "info_holder", "upgrade_info_holder", "unit_info_costs", "holder_requirements", "body")
  if not requirements then
    out("WARNING: could not find the requirements list for the upgrade "..upgrade_record.key)
    return
  end

  local cost_per_unit = upgrade_record.weight
  if unit_record.group == upgrade_record.group then
    cost_per_unit = cost_per_unit - unit_record.weight
  end
  local pip_image = (mod.ui_settings.groups_to_pips[upgrade_record.group] or {})[1]
  if not pip_image then
    out("WARNING: could not find pip image for group "..upgrade_record.group)
    return
  end

  local tt_to_fill = common.get_localised_string("ttc_warband_upgrade_cost")
  local points_name = common.get_localised_string("ttc_measurement_name")
  local group_name = common.get_localised_string("ttc_group_name_"..upgrade_record.group)
  local tt = fill_loc(tt_to_fill, tostring(cost_per_unit), group_name, points_name)

  local perUnitCostHolder =  find_uicomponent(requirements, "per_unit_cost")
  local perUnitPointCost 
  if find_uicomponent(perUnitCostHolder, "ttc_per_unit_cost") then
    perUnitPointCost = find_uicomponent(perUnitCostHolder, "ttc_per_unit_cost")
  else
    perUnitPointCost = UIComponent(perUnitCostHolder:CreateComponent("ttc_per_unit_cost", "ui/campaign ui/ttc_meter"))
  end
  if perUnitPointCost then
    perUnitPointCost:SetImagePath(pip_image, 1)
    perUnitPointCost:SetStateText(tostring(cost_per_unit))
    perUnitPointCost:SetDockingPoint(2)
    perUnitPointCost:SetCanResizeHeight(true)
    perUnitPointCost:SetCanResizeWidth(true)
    perUnitPointCost:Resize(47, 20)
    perUnitPointCost:SetDockOffset(28, -2)
    perUnitPointCost:SetTooltipText(tt, true)
    if cost_per_unit == 0 then
      perUnitPointCost:SetVisible(false)
    else
      perUnitPointCost:SetVisible(true)
    end
  else
    out("Failed to get or create a per unit point cost element")
  end
  local totalCostHolder = find_uicomponent(requirements, "total_cost")
  local totalPointsCost
  if find_uicomponent(totalCostHolder, "ttc_total_cost") then
    totalPointsCost = find_uicomponent(totalCostHolder, "ttc_total_cost")
  else
    totalPointsCost = UIComponent(totalCostHolder:CreateComponent("ttc_total_cost", "ui/campaign ui/ttc_meter"))
  end
  if totalPointsCost then
    totalPointsCost:SetImagePath(pip_image, 1)
    totalPointsCost:SetDockingPoint(2)
    totalPointsCost:SetCanResizeHeight(true)
    totalPointsCost:SetCanResizeWidth(true)
    totalPointsCost:Resize(47, 20)
    totalPointsCost:SetDockOffset(28, -2)
    totalPointsCost:SetStateText(tostring(cost_per_unit * quantity))
    totalPointsCost:SetTooltipText(tt, true)
    if cost_per_unit == 0 then
      totalPointsCost:SetVisible(false)
    else
      totalPointsCost:SetVisible(true)
    end
  else
    out("Failed to get or create a total point cost element")
  end

end


--TODO test the upgrades system and clean up any artifacts. 
---called when the player changes either their unit selection or their target unit selection
---checks the contexts attached to the invokation button, and adds a 'cost' line for the rare or special points required to upgrade.
---locks the invoke button if the player cannot afford the upgrade.
mod.update_warband_upgrade_requirements_and_invocation_button = function ()
    -- root:units_panel:main_units_panel:warband_upgrades_docker:warband_upgrades:body:info_holder:upgrade_info_holder:
    -- unit_info_costs:holder_requirements:button_invoke
    local character_record = mod.get_selected_character_record()
    if not character_record then
      out("No character selected, aborting update_warband_upgrade_requirements_and_invocation_button")
      return
    end
    --mod.add_warband_upgrade_cost_display(character_record)
    local invokeButton = find_uicomponent_from_table(core:get_ui_root(), {"units_panel", "main_units_panel", 
    "warband_upgrades_docker", "warband_upgrades", "body", "info_holder", "upgrade_info_holder", "unit_info_costs", 
    "holder_requirements", "button_invoke"})
    if not invokeButton then
      out("update_warband_upgrade_requirements_and_invocation_button called but couldn't find the invoke button!")
      return
    end
    --get the unit we are upgrading from and the unit we are upgrading to.
    local unit_to_upgrade_context = invokeButton:GetContextObjectId("CcoCampaignUnit")
    if not unit_to_upgrade_context then
      out("update_warband_upgrade_requirements_and_invocation_button called but couldn't find the unit to upgrade! There probably isn't one selected.")
      return
    end
    local campaignUnitContext = cco("CcoCampaignUnit", unit_to_upgrade_context)
    local upgrade_option_context = invokeButton:GetContextObjectId("CcoMainUnitRecord")
    if not upgrade_option_context then
      out("update_warband_upgrade_requirements_and_invocation_button called but couldn't find the upgrade option! There probably isn't one selected.")
      return
    end
    local upgradeRecordContext = cco("CcoMainUnitRecord", upgrade_option_context)
    local main_unit_key = campaignUnitContext:Call("UnitRecordContext.Key")
    local upgrade_unit_key = upgradeRecordContext:Call("Key")
    local unit_record = mod.get_unit(main_unit_key, character_record)
    local upgrade_record = mod.get_unit(upgrade_unit_key, character_record)
    --get the quantity of units to be upgraded
    local upgrade_quantity = mod.count_unit_in_selection(main_unit_key)
    --list the cost
    mod.add_warband_upgrade_requirement_entry(unit_record, upgrade_record, upgrade_quantity)
    --check if the player can afford the upgrade
    local can_afford_upgrade = character_record:can_afford_swap(unit_record, upgrade_record, upgrade_quantity)
    out("The player wishes to upgrade "..upgrade_quantity.." "..main_unit_key.."s into "..upgrade_unit_key)
    out("the player can afford the upgrade: "..tostring(can_afford_upgrade))
    if can_afford_upgrade then
      --leave it alone.
    else
      local tt_to_fill = common.get_localised_string("ttc_restriction_tooltip")
      local points_name = common.get_localised_string("ttc_measurement_name")
      local group_name = common.get_localised_string("ttc_group_name_"..upgrade_record.group)
      local tt = fill_loc(tt_to_fill, group_name, points_name)
      invokeButton:SetState("inactive")
      invokeButton:SetTooltipText(tt, true)
    end
end


mod.add_listeners_to_warband_panel = function ()
  out("Added Warband Panel Listeners")
  ---warband handling
    --update our picture of what is selected when a land unit card is clicked.
    --if the warbands upgrade panel is open, we should refresh our picture of the queued upgrade.
    core:add_listener(
        "TTCWarbandListeners",
        "ComponentLClickUp",
        function(context)
            return string.find(context.string, "LandUnit")
        end,
        function(context)
            out("Mouseclick triggered on a land unit")
            mod.update_unit_selection()
            mod.update_warband_upgrade_requirements_and_invocation_button()
        end,
        true)
    --update our picture of what is selected when an upgrade is clicked in the warband upgrade tree.
    core:add_listener(
        "TTCWarbandListeners",
        "ComponentLClickUp",
        function(context)
            local component = UIComponent(context.component)
            return uicomponent_descended_from(component, "upgrade_tree") and mod.is_warband_upgrade_panel_open()
        end,
        function(context)
            out("Mouseclick triggered on a warband unit upgrade option!")
            mod.update_warband_upgrade_requirements_and_invocation_button()
        end,
        true)
    core:add_listener(
      "TTCWarbandListeners",
      "ComponentLClickUp",
      function(context)
        return string.find(context.string, "button_toggle_tab_")
      end,
      function(context)
        out("Mouseclick triggered on a warband tab button!")
        cm:real_callback(mod.update_warband_tree, 50)
      end,
      true)
      mod.update_warband_upgrade_requirements_and_invocation_button()
      mod.update_warband_tree()
end

mod.remove_warband_listeners = function ()
  out("Removed warband listeners")
  core:remove_listener("TTCWarbandListeners")
end

-----------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

---@return boolean
---@param unitCard UIC
mod.add_listeners_to_recruitable_unit_card = function(unitCard)
  local this_card_address = unitCard:Address()
  local address_string = tostring(this_card_address)
  if mod.card_listeners_active[address_string] then
    out("Asked to attach listeners to a UI component ["..unitCard:Id()..":"..address_string.."] but there are already listeners attached to that card!")
    return false
  else
    out("Attaching listeners to a UI component ["..unitCard:Id()..":"..address_string.."]")
  end
  local this_card_context_id = unitCard:GetContextObjectId("CcoMainUnitRecord")
  local mainUnitContext = cco("CcoMainUnitRecord", this_card_context_id)
  local unit_key = mainUnitContext:Call("Key")
  local character_record = mod.get_selected_character_record()
  if not character_record then
    return false
  end
  local unit_record = mod.get_unit(unit_key, character_record)
  local is_merc = string.find(unitCard:Id(), "_mercenary")
  local cost_tooltip_loc
  local tt_restricted_loc
  if unit_record.group == "core" then
    local desc_loc_to_fill = common.get_localised_string("ttc_unit_no_cost")
    local detail_loc_to_fill = common.get_localised_string("ttc_army_unlimited")
    local group_name = common.get_localised_string("ttc_group_name_core")
    cost_tooltip_loc = fill_loc(desc_loc_to_fill, group_name) .. "\n\n" .. fill_loc(detail_loc_to_fill, group_name)
  else
    local desc_loc_to_fill = common.get_localised_string("ttc_unit_cost")
    local detail_loc_to_fill = common.get_localised_string("ttc_army_limited")
    local restriction_loc_to_fill = common.get_localised_string("ttc_restriction_tooltip")
    local points_name = common.get_localised_string("ttc_measurement_name")
    local group_name = common.get_localised_string("ttc_group_name_"..unit_record.group)
    local cost = tostring(unit_record.weight)
    local capacity = tostring(character_record.budget[unit_record.group] or 0)
    cost_tooltip_loc = fill_loc(desc_loc_to_fill, group_name, cost, points_name) .. "\n\n" .. fill_loc(detail_loc_to_fill, capacity, points_name, group_name)
    tt_restricted_loc = fill_loc(restriction_loc_to_fill, group_name, points_name)
  end
  local tt_recruitable = escape_string(common.get_localised_string("random_localisation_strings_string_StratHud_Unit_Card_Recruit_Selection"))
  local tt_recruitable_alternate = escape_string(common.get_localised_string("random_localisation_strings_string_StratHud_Unit_Card_Recruit_Selection_No_Info"))
  local tt_cannot_recruit = common.get_localised_string("random_localisation_strings_string_StratHudbutton_Cannot_Recruit_Unit0")

  --when a refresh is called, check that we can afford this unit and adjust the card accordingly
  core:add_listener(
    "TTCRecruitableUnitListeners",
    "ModScriptEventRefreshUnitCards",
    function(context)
      return true
    end,
    function(context)
      local lockedOverlay = find_uicomponent(unitCard, "disabled_script");

      --unitCard:SetState("active")
      if not not lockedOverlay then
          lockedOverlay:SetVisible(true)
          local image_path = (mod.ui_settings.groups_to_pips[unit_record.group] or {})[unit_record.weight]
          --lockedOverlay:SetTooltipText(rec_unit._UIText, true)
          lockedOverlay:SetImagePath(image_path or "ui/custom/recruitment_controls/fuckoffbutton.png")
          lockedOverlay:SetCanResizeHeight(true)
          lockedOverlay:SetCanResizeWidth(true)
          lockedOverlay:Resize(30, 30)
          lockedOverlay:SetCanResizeHeight(false)
          lockedOverlay:SetCanResizeWidth(false)
          if cost_tooltip_loc then
            lockedOverlay:SetTooltipText(cost_tooltip_loc, true)
          end
      end
      local card_tt = unitCard:GetTooltipText() or ""
      if character_record:can_afford_unit(unit_record) then
        unitCard:SetDisabled(false)
        if not string.find(card_tt, "[[col:red]]") then
          unitCard:SetState("active")
        end
      else 
        --unitCard:SetState("inactive")
        out("Locking Unit ["..unit_key.."]")
        unitCard:SetDisabled(true)
        unitCard:SetState("inactive")
        if tt_restricted_loc then
           --if we already have a cannot recruit tooltip
           if string.find(card_tt, tt_cannot_recruit) then
             --then just append our reason to the end.
             --but first, double check that we haven't already done this - we don't need to duplicate the same reason
             if not string.find(card_tt, tt_restricted_loc) then
              local new_card_tt = card_tt .. "\n" .. tt_restricted_loc
              unitCard:SetTooltipText(new_card_tt, true)
             end
           else
            --otherwise, replace the recruitable prompt, append the unable to recruit text, then append our reason.
            --out("Card TT was "..card_tt)
            --out("Text to trip was ".. tt_recruitable)
            local card_tt_stripped, removed  = string.gsub(card_tt, tt_recruitable, "")
            --out("Made "..tostring(removed).." replacements")
            if removed == 0 then
              card_tt_stripped = string.gsub(card_tt, tt_recruitable_alternate, "")
              --out("Tried the alternative")
            end
            --out("card stripped tt was "..card_tt_stripped)
            local new_card_tt = card_tt_stripped .. tt_cannot_recruit.. "\n\n" .. tt_restricted_loc
            unitCard:SetTooltipText(new_card_tt, true)
           end
        end
      end
      local harmonyIcon = find_uicomponent(unitCard, "icon_harmony")
      if harmonyIcon then
        harmonyIcon:SetDockOffset(5, 36)
      end
    end,
    true)

    mod.card_listeners_active[address_string] = true
    return true
end

mod.remove_recruitment_listeners = function()
  mod.card_listeners_active = {}
  core:remove_listener("TTCRecruitableUnitListeners")
  out("Cleared Listeners from the recruitment panel")
end

mod.add_listeners_to_mercenary_panel = function()
  out("Installing listeners on unit cards in the mercenary panel")
  local any_new_listeners = false
  local unitList
  for i = 1, #mod.ui_settings.path_to_mercenary_unit_list do
    unitList = find_uicomponent_from_table(core:get_ui_root(), mod.ui_settings.path_to_mercenary_unit_list[i])
    if unitList and unitList:ChildCount() > 0 then
      out("Found mercenary unit list "..i)
      break
    end
  end
  if not unitList then 
    out("No mercenary unit lists were found!")
    out("Either the recruitment panel doesn't exist currently, there are no mercenaries available, or the script is missing a path!")
  end
  local count = unitList:ChildCount()
  out("The mercenary unit list has: "..tostring(count).." options available")
  for i = 0, count - 1 do
    local ok = mod.add_listeners_to_recruitable_unit_card(UIComponent(unitList:Find(i)))
    if ok then any_new_listeners = true end
  end
  
  if any_new_listeners then
    out("Listeners installed: triggering card refresh")
    core:trigger_event("ModScriptEventRefreshUnitCards")
  else
    out("No new listeners installed, skipping card refresh")
  end
end

mod.add_listeners_to_allied_recruitment_panel = function()
  out("Installing listeners on unit cards in the allied panel")
  local any_new_listeners = false
  local unitList
  for i = 1, #mod.ui_settings.path_to_allied_unit_list do
    unitList = find_uicomponent_from_table(core:get_ui_root(), mod.ui_settings.path_to_allied_unit_list[i])
    if unitList and unitList:ChildCount() > 0 then
      out("Found allied unit list "..i)
      break
    end
  end
  if not unitList then 
    out("No allied unit lists were found!")
    out("Either the recruitment panel doesn't exist currently, there are no allied available, or the script is missing a path!")
  end
  local count = unitList:ChildCount()
  out("The allied unit list has: "..tostring(count).." options available")
  for i = 0, count - 1 do
    local ok = mod.add_listeners_to_recruitable_unit_card(UIComponent(unitList:Find(i)))
    if ok then any_new_listeners = true end
  end
  
  if any_new_listeners then
    out("Listeners installed: triggering card refresh")
    core:trigger_event("ModScriptEventRefreshUnitCards")
  else
    out("No new listeners installed, skipping card refresh")
  end
end

---@return boolean
mod.add_lsteners_to_recruitment_panel = function()
  out("Installing listeners on unit cards in the standard recruitment panel")
  local any_new_listeners = false 
  local any_source = false
  for k = 1, #mod.ui_settings.path_to_recruitment_sources do 
    local sourceList = find_uicomponent_from_table(core:get_ui_root(), mod.ui_settings.path_to_recruitment_sources[k])
    if sourceList and sourceList:ChildCount() > 0 then
      any_source = true
      out("Found recruitment source list "..tostring(k))
      local sourceCount = sourceList:ChildCount()
      out("Source list has: "..sourceCount.." children available")
      for i = 0,  sourceCount - 1 do	
        local recruitmentSource = UIComponent(sourceList:Find(i))
        out("Found recruitment source: "..recruitmentSource:Id())
        local recruitmentList = find_uicomponent_from_table(recruitmentSource, mod.ui_settings.path_from_source_to_unit_list)
        if not recruitmentList then
          out("No recruitment list could be found for this source")
        else 
          local count = recruitmentList:ChildCount()
          out("This source has "..count.." units available")
          for j = 0, count - 1 do
            local ok = mod.add_listeners_to_recruitable_unit_card(UIComponent(recruitmentList:Find(j)))
            if ok then any_new_listeners = true end
          end
        end
      end
    end
  end
  if not any_source then
    out("Neither source list was found!")
    out("Either the recruitment panel doesn't exist currently, there is no recruitment options available on this panel, or the paths in the script settings are wrong")
    return false
  end
  if any_new_listeners then
    out("Listeners installed: triggering card refresh")
    core:trigger_event("ModScriptEventRefreshUnitCards")
  else
    out("No new listeners installed, skipping card refresh")
  end
  return true
end
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

mod.add_listeners = function()
  out("adding main listeners")
  core:remove_listener("TTCMainListeners")

  --The listener that does most of the work.
  --Basically make sure we have the correct character and get their existing units. 
  --Then add listeners for them opening recruitment to set up the listeners for unit cards.
  core:add_listener(
    "TTCMainListeners",
    "CharacterSelected",
    function(context)
      return context:character():has_military_force() and context:character():faction():name() == cm:get_local_faction_name(true) and mod.force_has_caps(context:character():military_force())
    end,
    function(context)
      local character = context:character()
      out("TTC main path start: human selected "..character:command_queue_index())
      --clear any temporary panel open listeners we have created.
      core:remove_listener("TTCTempListeners")
      --clear any recruitment listeners we have out.
      mod.remove_recruitment_listeners()
      mod.remove_warband_listeners()
      --reset the last recruitment panel variable so that panel opened instructions fire again on the next tick.
      mod.last_panel_open = ""
      --is the panel already open?
      if mod.is_units_panel_open() then
        out("Units Panel is open already")
        --if so, we need to wait for it to refresh with the units from our new character.
        cm:callback(function() 
          out("The delayed character select callback is firing")
          mod.select_character(mod.get_selected_character_record().interface)
          if mod.get_current_panel() == "" then
            mod.destroy_icons_on_army_units_panel()
          end
        end, 0.1)
        core:trigger_event("ModScriptEventRefreshUnitCards")
      else
        out("The units panel isn't open yet")
        --queue up a panel opened callback for the units panel
        mod.panels_open_callback(function(context)
          out("Units panel open callback set on character select is firing")
          mod.select_character(mod.get_selected_character_record().interface)
          mod.destroy_icons_on_army_units_panel()
        end, "units_panel")
      end
    end,
    true)

    --when a character is deselected, make sure it is no longer listed as selected
    core:add_listener(
      "TTCMainListeners",
      "CharacterDeselected",
      function(context)
        return true
      end,
      function(context)
        out("Player Deselected Character "..mod.selected_character)
        mod.selected_character = 0
        core:remove_listener("TTCTempListeners")
        core:remove_listener("TTCArmyCardListeners")
      end,
      true)

    --handle the player swapping between panels or closing them
    --these tables define instructions for what to do when a panel is opened or closed.
    --the panel closed instructions of the panel closing are fired before the panel opened instructions of the panel opening.
    local panel_opened_switch = {
      ["units_recruitment"] = function ()
        mod.add_lsteners_to_recruitment_panel()
      end,
      ["allied_recruitment"] = function ()
        mod.add_listeners_to_allied_recruitment_panel()
      end,
      ["mercenary_recruitment"] = function ()
        mod.add_listeners_to_mercenary_panel()
      end,
      ["warband_upgrades"] = function ()
        mod.add_listeners_to_warband_panel()
        mod.update_unit_selection()
      end
    }
    local panel_closed_switch = {
      ["units_recruitment"] = function ()
        mod.remove_recruitment_listeners()
      end,
      ["allied_recruitment"] = function ()
        mod.remove_recruitment_listeners()
      end,
      ["mercenary_recruitment"] = function ()
        mod.remove_recruitment_listeners()
      end,
      ["warband_upgrades"] = function ()
        mod.remove_warband_listeners()
      end
    }
    --check every 60 ms to see if the panel has changed.
    cm:repeat_real_callback(function() 
      local new_panel_open = mod.get_current_panel()
      if mod.last_panel_open == new_panel_open then
        return 
      end
      out("Recruitment Panel changed from "..mod.last_panel_open.." to "..new_panel_open)
      if panel_closed_switch[mod.last_panel_open] then
        panel_closed_switch[mod.last_panel_open]()
      end
      if panel_opened_switch[new_panel_open] then
        cm:real_callback(panel_opened_switch[new_panel_open], 50)
      end
      if new_panel_open ~= "" then
        mod.refresh_icons_on_army_units_panel()
      else
        mod.destroy_icons_on_army_units_panel()
      end
      mod.last_panel_open = new_panel_open
    end, 50, "TTCPanelMonitor")

    --when a panel closes, reset the last panel open variable and fire the panel closed instructions.
    --this accounts for cases where the player swaps between different versions of the same panel, such as in mercenary recruitment.
    core:add_listener(
      "TTCPanelMonitor",
      "PanelClosedCampaign",
      function(context)
        return context.string == mod.last_panel_open
      end,
      function(context)
        if panel_closed_switch[mod.last_panel_open] then
          panel_closed_switch[mod.last_panel_open]()
        end
        out("Recruitment Panel closed: "..tostring(mod.last_panel_open))
        mod.last_panel_open = ""
      end,
      true)

    --when the player clicks an option in the allies dropdown menu, "close" the panel so that the panel open instructions fire again.
    core:add_listener(
      "TTCMainListeners",
      "ComponentLClickUp",
      function(context)
        return (not not string.find(context.string, "option")) and uicomponent_descended_from(UIComponent(context.component), "allied_factions_dropdown")
      end,
      function(context)
        out("Refreshing allies")
        if panel_closed_switch[mod.last_panel_open] then
          panel_closed_switch[mod.last_panel_open]()
        end
        out("Recruitment Panel closed: "..tostring(mod.last_panel_open))
        mod.last_panel_open = ""
      end,
      true)

    --after the character changes stance,  "close" the panel so that the panel open instructions fire again.
    core:add_listener(
      "TTCMainListeners",
      "ForceAdoptsStance",
      function(context)
        return context:military_force():faction():name() == cm:get_local_faction_name(true)
      end,
      function(context)
        out("Character changed stance, destroying and rebuilding recruitment listeners")
        if panel_closed_switch[mod.last_panel_open] then
          panel_closed_switch[mod.last_panel_open]()
        end
        out("Recruitment Panel Closed: "..tostring(mod.last_panel_open))
        mod.last_panel_open = ""
      end,
      true);

      --special case to handle a bug in the UI scripting interface
      --if you open a panel while you have a character selected, the character remains selected behind the panel.
      --however, when you exit that panel, the cmui manager doesn't know that the character is selected and returns -1.
      core:add_listener(
        "TTCMainListeners",
        "PanelClosedCampaign",
        function(context)
          return context.string ~= "mercenary_recruitment" and context.string ~= "units_recruitment" and context.string ~= "units_panel"
        end,
        function(context)
          cm:real_callback(function ()
            if cm:get_campaign_ui_manager():get_char_selected_cqi() == -1 then
              -- root:units_panel:main_units_panel:units:LandUnit 0
              local unitCard = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "units", "LandUnit 0")
              if unitCard and unitCard:Visible() then
                out("After panel closed, there is a unit card visible but no character selected. Selecting the unit card's character")
                local character_cqi = tonumber(unitCard:GetContextObjectId("CcoCampaignCharacter") or 0)
                ---@cast character_cqi integer
                --local characterContext = cco("CcoCampaignCharacter", character_cqi)
                --characterContext:Call("Select(false)")
                local character = cm:get_character_by_cqi(character_cqi)
                if character and not character:is_null_interface() then
                  cm:get_campaign_ui_manager().character_selected_cqi = character_cqi
                  mod.selected_character = character_cqi
                  mod.select_character(character)
                end
              end
            end
          end, 500)
        end, 
        true)

       --[[
        --TODO this shit to fix autoresolve
      core:add_listener(
        "TTCMainListeners",
        "CharacterCompletedBattle",
        function ()
          
        end
      )]]

    
    --whenever one of these panels opens, assume we want a refresh.
    core:add_listener(
      "TTCMainListeners",
      "PanelOpenedCampaign",
      function(context)
        return context.string == "units_recruitment"
      end,
      function(context)
        core:trigger_event("ModScriptEventRefreshUnitCards")
      end,
      true)
    core:add_listener(
      "TTCMainListeners",
      "PanelOpenedCampaign",
      function(context)
        return context.string == "mercenary_recruitment"
      end,
      function(context)
        core:trigger_event("ModScriptEventRefreshUnitCards")
      end,
      true)
      
    core:add_listener(
      "TTCMainListeners",
      "ComponentLClickUp",
      function(context)
          return (context.string == "button_warbands_upgrade" and uicomponent_descended_from(UIComponent(context.component), "button_group_army"))
          and mod.is_warband_upgrade_panel_open()
      end,
      function(context)
          mod.update_warband_tree()
      end,
      true)

    

    --when a unit is added to the recruitment queue, add its costs.
    core:add_listener(
      "TTCMainListeners",
      "RecruitmentItemIssuedByPlayer",
      function(context)
          return context:faction():name() == cm:get_local_faction_name(true)
      end,
      function(context)
        local character_record = mod.get_selected_character_record()
        if not character_record then
          out("The player recruited a unit but has no character selected?")
          out("This is an error")
          ttc_error()
          return
        end
        local unit_record = mod.get_unit(context:main_unit_record(), character_record)
        out("Player started recruitment of "..unit_record.key)
        character_record:apply_cost_of_unit(unit_record)
        mod.refresh_icons_on_army_units_panel()
        core:trigger_event("ModScriptEventRefreshUnitCards")
        cm:callback(function()
          mod.refresh_icons_on_army_units_panel()
        end, 0.1)
      end,
      true)

     
    --when a unit is removed from the recruitment queue, refund the costs associated with it.
    core:add_listener(
      "TTCMainListeners",
      "RecruitmentItemCancelledByPlayer",
      function(context)
          return context:faction():name() == cm:get_local_faction_name(true)
      end,
      function(context)
        local character_record = mod.get_selected_character_record()
        if not character_record then
          out("The player cancelled a unit but has no character selected?")
          out("This is an error")
          ttc_error()
          return
        end
        local unit_record = mod.get_unit(context:main_unit_record(), character_record)
        out("Player cancelled recruitment of "..unit_record.key)
        character_record:refund_cost_of_unit(unit_record)
        if mod.is_recruit_panel_open() or mod.is_merc_panel_open() then
          mod.refresh_icons_on_army_units_panel()
          core:trigger_event("ModScriptEventRefreshUnitCards")
          cm:callback(function()
            mod.refresh_icons_on_army_units_panel()
          end, 0.1)
        end
      end,
      true)
    --Adjust costs and trigger a refresh after a unit is disbanded
    core:add_listener(
      "TTCMainListeners",
      "UnitDisbanded",
      function(context)
        return context:unit():faction():name() == cm:get_local_faction_name(true)
      end,
      function(context)
        local character_record = mod.get_selected_character_record()
        if not character_record then
          out("The player disbanded a unit but has no character selected?")
          out("This is an error")
          ttc_error()
          return
        end
        local unit_record = mod.get_unit(context:unit():unit_key(), character_record)
        out("Player disbanded "..unit_record.key)
        character_record:refund_cost_of_unit(unit_record)
        if not mod.is_recruit_panel_open() and not mod.is_merc_panel_open() then
          cm:callback(function() 
            core:trigger_event("ModScriptEventRefreshUnitCards")
          end, 0.1)
        end
      end,
      true)
    --Adjust costs and trigger a refresh after unit merged
    core:add_listener(
      "TTCMainListeners",
      "UnitMergedAndDestroyed",
      function(context)
        return context:new_unit():faction():name() == cm:get_local_faction_name(true)
      end,
      function(context)
        local character_record = mod.get_selected_character_record()
        if not character_record then
          out("The player merged a unit but has no character selected?")
          out("This is an error")
          ttc_error()
          return
        end
        local unit_record = mod.get_unit(context:new_unit():unit_key(), character_record)
        out("Player merged and destroyed "..unit_record.key)
        character_record:refund_cost_of_unit(unit_record)
        if not mod.is_recruit_panel_open() and not mod.is_merc_panel_open() then
          cm:callback(function() 
            core:trigger_event("ModScriptEventRefreshUnitCards")
          end, 0.1)
        end
      end,
      true)
    

    --refresh the budget after character skills change - these may affect the budget or the special rules available to the character
    core:add_listener(
      "TTCMainListeners",
      "CharacterSkillPointAllocated", 
      function(context)
        return context:character():faction():is_human() and (not not mod.characters[context:character():command_queue_index()])
      end,
      function(context)
        local character = mod.characters[context:character():command_queue_index()]
        character:refresh_budget()
        character:refresh_special_rules()
        core:trigger_event("ModScriptEventRefreshUnitCards")
      end,
      false
    );



    --when a mercenary is added to queue, apply cost.
    core:add_listener(
      "TTCMainListeners",
      "ComponentLClickUp",
      function (context)
        return mod.is_merc_panel_open()
      end,
      function(context)
          local uic = UIComponent(context.component)
          local pin = find_uicomponent(uic, "pin_parent", "button_pin")
          if pin and string.find(pin:CurrentState(), "hover") then return end
          local component_id = tostring(uic:Id())
          --is our clicked component a unit?
          if string.find(component_id, "_mercenary") then
            out("Component Clicked was a mercenary")
            local unit_key = string.gsub(component_id, "_mercenary", "")
            local character_record = mod.get_selected_character_record()
            if not character_record then
              out("The player clicked a mercenary but has no character selected?")
              return
            end
            local unit_record = mod.get_unit(unit_key, character_record)
            mod.mercenaries_in_queue[#mod.mercenaries_in_queue+1] = unit_record
            local armyList = find_uicomponent_from_table(core:get_ui_root(), {"units_panel", "main_units_panel", "units"})
            local merc = find_uicomponent(armyList, "temp_merc_"..tostring(#mod.mercenaries_in_queue-1))
            if merc then
              out("The new queued mercenary appeared")
              character_record:apply_cost_of_unit(unit_record)
              mod.refresh_icons_on_army_units_panel()
              cm:callback(function()
                mod.refresh_icons_on_army_units_panel()
              end, 0.1)
            else
              out("No queued mercenary appeared - it probably isn't a valid click")
              mod.mercenaries_in_queue[#mod.mercenaries_in_queue] = nil
            end

          end
          core:trigger_event("ModScriptEventRefreshUnitCards")
      end,
      true);
    --When a mercenary is removed from queue, refund.
    core:add_listener(
      "TTCMainListeners",
      "ComponentLClickUp",
      function (context)
        return mod.is_merc_panel_open()
      end,
      function(context)
          --# assume context: CA_UIContext
          local component = UIComponent(context.component)
          local component_id = tostring(component:Id())
          if string.find(component_id, "temp_merc_") then
              local position = component_id:gsub("temp_merc_", "") 
              out("Component Clicked was a Queued Mercenary Unit @ ["..position.."]!")
              local character_record = mod.get_selected_character_record()
              if not character_record then
                out("The player cancelled a mercenary but has no character selected?")
                out("This is an error")
                ttc_error()
                return
              end
              local int_pos = math.floor(tonumber(position)+1)
              local unit_record = mod.mercenaries_in_queue[int_pos]
              character_record:refund_cost_of_unit(unit_record)
              table.remove(mod.mercenaries_in_queue, int_pos)
              mod.refresh_icons_on_army_units_panel()
              cm:callback(function()
                mod.refresh_icons_on_army_units_panel()
              end, 0.1)
          end
          core:trigger_event("ModScriptEventRefreshUnitCards")
      end,
      true);



    --print the game state on refresh, commented out in final versions.
    core:add_listener(
      "TTCMainListeners",
      "ModScriptEventRefreshUnitCards",
      function(context)
        return true
      end,
      function(context)
        --mod.get_selected_character_record():print_state()
      end,
      true)
end




-----------------------------------------------------------------------------------------------------------
---------------------------------------AI--------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

mod.core_unit_replacements = {} ---@type table<string, string[]>


mod.get_core_replacement_unit = function(character, unit_key)
  --TODO make this smarter using the cco main unit record
  local subculture = character:faction():subculture()
  if not mod.core_unit_replacements[subculture] then
    return false
  end
  local core_units_list = mod.core_unit_replacements[subculture]
  return core_units_list[cm:random_number(#core_units_list)]
end

---counts the units in an army, compares with the character's budget.
---if the character is over their budget, removes units.
---@param character CHARACTER_SCRIPT_INTERFACE
---@param read_only boolean|nil
mod.check_ai_character = function(character, read_only)
  local character_record = ttc_character.new(character)
  if not character_record then
    return
  end
  character_record:refresh_budget()
  character_record:refresh_special_rules()

  local unit_list = character:military_force():unit_list() ---@type any
  for i = 0, unit_list:num_items() -1 do
    local unit_record = mod.get_unit(unit_list:item_at(i):unit_key(), character_record)
    if unit_record.group ~= "core" then
      character_record:apply_cost_of_unit(unit_record)
    end
  end
  local groups = {"special", "rare"}
  local removed_units = {}
  if read_only then
    character_record:print_state()
    --mod.characters[character:command_queue_index()] = nil
    return
  end
  for k = 1, #groups do
    local group_key = groups[k]
    removed_units[group_key] = {}
    local balance = character_record.budget[group_key] - (character_record.count[group_key] or 0)
    if balance < 0 then
      out("Adjusting AI character ["..tostring(character:command_queue_index()).."] "..group_key.." balance "..balance)
      local sortable_list = {} ---@type ttc_unit[]
      for i = 0, unit_list:num_items() -1 do
        local unit_key = unit_list:item_at(i):unit_key()
        if mod.does_unit_exist(unit_key) then
          local unit_record = mod.get_unit(unit_key, character_record)
          if unit_record.group == group_key then
            sortable_list[#sortable_list+1] = unit_record
          end
        end
      end
      table.sort(sortable_list, function (a, b)
        return a.weight < b.weight
      end)
      for i = 1, #sortable_list do
        local unit_record = sortable_list[i]
        cm:remove_unit_from_character(cm:char_lookup_str(character), unit_record.key)
        table.insert(removed_units[group_key], unit_record)
        balance = balance + unit_record.weight
        out("Removed "..unit_record.key..", balance is now "..balance)
        local replacement = mod.get_core_replacement_unit(character, unit_record.key)
        if replacement then
          out("Replaced with "..replacement)
          cm:grant_unit_to_character(cm:char_lookup_str(character), replacement)
        end
        if balance >= 0 then
          break
        end
      end
      out("Finished adjusting for "..group_key.." on character "..tostring(character:command_queue_index()))
      if balance > 0 then
        out("We took too much away, seeing if we can correct.")
        --we took away too much, see if we took any units who can be returned.
        for i = 1, #removed_units[group_key] do
          local unit_record = removed_units[group_key][i]
          if unit_record.weight <= balance then
            cm:grant_unit_to_character(cm:char_lookup_str(character), unit_record.key)
            balance = balance - unit_record.weight
            out("Restored "..unit_record.key..", balance is now "..balance)
          end
          if balance < 0 then
            out("Something went wrong, we ended up giving too much back. There is bug in code")
            break
          elseif balance == 0 then
            break
          end
        end
      end
    end
  end
  if character:faction():is_human() then
    --we don't want to delete a human's record in case they're currently using the UI
  else
    local char_cqi = character:command_queue_index()
    out("Checked AI Character: "..char_cqi)
    mod.characters[char_cqi] = nil
  end
end

mod.adjustment_queue = {} ---@type integer[]
mod.characters_in_adjustment_queue = {} ---@type table<integer, boolean>

---called repeatedly while the adjustment queue has characters in it.
mod.adjustment_callback = function()
    local i = #mod.adjustment_queue
    local character = cm:get_character_by_cqi(mod.adjustment_queue[i])
    if character and character:has_military_force() and mod.force_has_caps(character:military_force()) then
      mod.check_ai_character(character, false)
    else
      out("Character "..mod.adjustment_queue[i].." in the adjustment queue has no force, or a force which is not capped")
    end
    mod.characters_in_adjustment_queue[mod.adjustment_queue[i]] = false
    table.remove(mod.adjustment_queue, i)
    --if there is still a character in the queue, call this again
    if #mod.adjustment_queue > 0 then
      out("Queued the next force for adjustment; "..#mod.adjustment_queue.." remaining")
      cm:callback(mod.adjustment_callback, 0)
    end
end

---adds a character to the adjustment queue and starts the recurring callback if it hasn't already happened.
---@param character CHARACTER_SCRIPT_INTERFACE
---@param delay boolean|nil
mod.add_character_to_adjustment_queue = function(character, delay)
  local char_cqi = character:command_queue_index()
  if mod.characters_in_adjustment_queue[char_cqi] then
    return
  end
  out("Added character: "..char_cqi.." to the adjustments Queue")
  mod.characters_in_adjustment_queue[char_cqi] = true
  table.insert(mod.adjustment_queue, char_cqi)
  if #mod.adjustment_queue == 1 then
    local t = 0
    if delay then
      t = 0.1
    end
    cm:callback(mod.adjustment_callback, t, "ttc_ai_adjustments")
  end
end




mod.add_ai_listeners = function()

  --listen for recruitment
  core:add_listener(
    "TTCAIListeners",
    "UnitTrained",
    function (context)
      return context:unit():military_force():has_general() and not context:unit():faction():is_human() 
      and mod.force_has_caps(context:unit():military_force())
    end,
    function (context)
      mod.add_character_to_adjustment_queue(context:unit():force_commander(), true)
    end,
    true)

  --listen for the AI starting its turn and adjust units.
  core:add_listener(
    "TTCAIListeners",
    "CharacterTurnStart",
    function(context)
      local character = context:character()
        return (not character:faction():is_human()) and character:has_military_force() and mod.force_has_caps(character:military_force())
    end,
    function(context)
      mod.add_character_to_adjustment_queue(context:character())
    end,
    true)


  -- disciple armies spawn
  --this actually effects humans too, I just put it here because it can reuse the AI code.
	core:add_listener(
		"TTCAIListeners",
		"MilitaryForceCreated",
		function(context)
			return context:military_force_created():general_character():character_subtype("wh3_main_sla_herald_of_slaanesh_slaanesh_disciple_army");
		end,
		function(context)
      out("Force created being checked by TTC")
      local force = context:military_force_created() ---@type MILITARY_FORCE_SCRIPT_INTERFACE
			local character_cqi = force:general_character():command_queue_index()
      local character = cm:get_character_by_cqi(character_cqi)
      mod.add_character_to_adjustment_queue(character, true)
      if cm:get_local_faction_name(true) == character:faction():name() then
        cm:callback(function()
          if mod.is_units_panel_open() then
            core:trigger_event("ModScriptEventRefreshUnitCards")
          end
        end, 0.1)
      end
		end,
		true);
  --same deal for army spawns in general.
  core:add_listener(
		"TTCAIListeners",
		"MilitaryForceCreated",
		function(context)
			return mod.force_has_caps(context:military_force_created())
		end,
		function(context)
      out("Force created being checked by TTC")
      local force = context:military_force_created() ---@type MILITARY_FORCE_SCRIPT_INTERFACE
			local character_cqi = force:general_character():command_queue_index()
      local character = cm:get_character_by_cqi(character_cqi)
      mod.add_character_to_adjustment_queue(character, true)
      if cm:get_local_faction_name(true) == character:faction():name() then
        cm:callback(function ()
            if mod.is_units_panel_open() then
              core:trigger_event("ModScriptEventRefreshUnitCards")
            end
        end, 0.1)
      end
		end,
		true);
    out("TTC AI listeners active")
end

-----------------------------------------------------------------------------------------------------------
----------------------------------Display Meters--------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------



---@param group_key "special"|"rare"
---@return UIC|nil
mod.get_or_create_group_meter = function(group_key)
  if not mod.is_units_panel_open() then
    out("Asked for the recruitment meters but the units panel isnt open")
    return nil
  end
  
  local uic_key = mod.ui_settings.ttc_meter_prefix..group_key
  local main_units_panel = find_uicomponent(core:get_ui_root(), "units_panel","main_units_panel")
  local intended_parent = find_uicomponent(main_units_panel, "tr_element_list")
  --local intended_parent = find_uicomponent(main_units_panel, "icon_list")
  local existing_element = find_uicomponent(intended_parent, uic_key)
  if is_uicomponent(existing_element) then
    return existing_element
  else
    local new_icon 
    out("Creating the meter component "..uic_key.." !")
    local ok, err = pcall(function()
      --create and return the meter element
      new_icon = UIComponent(intended_parent:CreateComponent(uic_key, "ui/campaign ui/ttc_meter"))
      local group_image = (mod.ui_settings.groups_to_pips[group_key] or {})[1]
      if group_image then
        new_icon:SetImagePath(group_image, 1)
      end
      new_icon:SetVisible(true)
      
    end)
    if not ok then
      out("Error creating the meter component")
      out(err)
    else
      return new_icon
    end
  end
end

---comment
---@param group_key string
---@param group_meter UIC|nil
---@param character_record ttc_character|nil
---@param dont_show boolean|nil
mod.populate_group_meter_text = function(group_key, group_meter, character_record, dont_show)
  if not group_meter then
    out("Group meter not created - cannot be populated. Was this event fired before the panel was open?")
    return
  end
  if not character_record then
    out("No character record provided - cannot populate group meter.")
    group_meter:SetVisible(false)
    return
  end
  --local character_record = mod.get_selected_character_record()
  local cap = character_record.budget[group_key] or 0
  local quantity = character_record.count[group_key] or 0
  local text = tostring(quantity).."/"..tostring(cap)
  if quantity > cap then
    text = "[[col:red]]"..text.."[[/col]]"
  end
  group_meter:SetStateText(text)
  group_meter:SetVisible(not dont_show)
end

---@param group_key string
---@param group_meter UIC|nil
---@param character_record ttc_character|nil
mod.populate_group_meter_tooltip_and_text = function(group_key, group_meter, character_record)
  if not group_meter then
    out("Group meter not created - cannot be populated. Was this event fired before the panel was open?")
    return
  end
  if not character_record then
    out("No character record provided - cannot populate group meter.")
    return
  end
  local ok, err = pcall(function()
    --local character_record = mod.get_selected_character_record()
    local loc_tooltip =  common.get_localised_string("ttc_meter_tooltip")
    local loc_points = common.get_localised_string("ttc_measurement_name")
    local loc_group = common.get_localised_string("ttc_group_name_"..group_key)
    local cap = character_record.budget[group_key] or 0
    local quantity = character_record.count[group_key] or 0
    local factors = character_record.factors
    local text = tostring(quantity).."/"..tostring(cap)
    if quantity > cap then
      text = "[[col:red]]"..text.."[[/col]]"
    end
    group_meter:SetStateText(text)
    local tt_string = fill_loc(loc_tooltip, tostring(quantity), tostring(cap), loc_group, loc_points)
    for unit_key, num_points in pairs(factors) do
      if num_points ~= 0 and mod.get_unit(unit_key, character_record).group == group_key then
        --out("Asking for the name of "..unit_key)
        local unit_loc = common.get_context_value("CcoMainUnitRecord", unit_key, "Name")
        tt_string = tt_string .. unit_loc .. ":  [[col:green]]" .. tostring(num_points) .. "[[/col]]\n"
      end
    end
    group_meter:SetTooltipText(tt_string, true)
  end) 
  if not ok then
    out("Error populating meter for group "..group_key)
    out(err) 
  else
    group_meter:SetVisible(true)
  end
end

mod.adjust_main_units_panel = function(is_hero)
  local main_units_panel = find_uicomponent(core:get_ui_root(), "units_panel","main_units_panel")
  if not main_units_panel then
    return
  end
  local mupX, mupY = main_units_panel:Dimensions()
  local icons_left = find_uicomponent(main_units_panel, "icon_list")
  local icons_right = find_uicomponent(main_units_panel, "tr_element_list")
  local unit_count = find_uicomponent(main_units_panel, "unit_count_frames_holder")
  main_units_panel:SetCanResizeHeight(true)
  if is_hero then
    main_units_panel:Resize(mupX, 250, false)
    icons_right:SetDockOffset(-15, 10)
  else
    main_units_panel:Resize(mupX, 270, false)
    icons_left:SetDockOffset(12, 22)
    icons_right:SetDockOffset(-15, 22)
    unit_count:SetDockOffset(0, 32)
  end

  main_units_panel:SetCanResizeHeight(false)
end

mod.add_ui_meter_listeners = function ()
  core:remove_listener("TTCUIListeners")
  core:add_listener(
    "TTCUIListeners", 
    "ModScriptEventTabletopCapsCountChanged",
    function (context)
      return context:character():faction():is_human() and mod.is_units_panel_open()
    end,
    function (context)
      local character_record = mod.get_selected_character_record()
      mod.populate_group_meter_tooltip_and_text( "special", mod.get_or_create_group_meter("special"), character_record)
      mod.populate_group_meter_tooltip_and_text( "rare", mod.get_or_create_group_meter("rare"), character_record)
      cm:remove_real_callback("ttc_refresh_meters")
      repeat_callback_with_timespan(function()
        mod.populate_group_meter_text( "special", mod.get_or_create_group_meter("special"), character_record)
        mod.populate_group_meter_text( "rare", mod.get_or_create_group_meter("rare"), character_record)
        mod.adjust_main_units_panel(false)
      end, 50, 1200, "ttc_refresh_meters")
    end,
    true)
    core:add_listener(
      "TTCUIListeners",
      "ModScriptEventRefreshUnitCards",
      function(context)
        return true
      end,
      function(context)
      local character_record = mod.get_selected_character_record()
        mod.populate_group_meter_tooltip_and_text( "special", mod.get_or_create_group_meter("special"), character_record)
        mod.populate_group_meter_tooltip_and_text( "rare", mod.get_or_create_group_meter("rare"), character_record)
        cm:remove_real_callback("ttc_refresh_meters")
        repeat_callback_with_timespan(function()
          local character = cm:get_character_by_cqi(cm:get_campaign_ui_manager():get_char_selected_cqi())
          if not character then return end
          local suppress = character:faction():name() ~= cm:get_local_faction_name(true) or (not character:has_military_force()) or (not mod.force_has_caps(character:military_force()))
          mod.populate_group_meter_text( "special", mod.get_or_create_group_meter("special"), character_record, suppress)
          mod.populate_group_meter_text( "rare", mod.get_or_create_group_meter("rare"), character_record, suppress)
          mod.adjust_main_units_panel(suppress)
        end, 50, 1200, "ttc_refresh_meters")
      end,
      true)
    core:add_listener(
    "TTCUIListeners",
    "CharacterSelected",
    function(context)
      return true
    end,
    function (context)
      local character_record = mod.get_selected_character_record()
      local suppress =  context:character():faction():name() ~= cm:get_local_faction_name(true) or (not context:character():has_military_force()) or (not mod.force_has_caps(context:character():military_force()))
      if mod.is_units_panel_open() then
        mod.populate_group_meter_text( "special", mod.get_or_create_group_meter("special"), character_record, suppress)
        mod.populate_group_meter_text( "rare", mod.get_or_create_group_meter("rare"), character_record, suppress)
      end
      cm:remove_callback("refresh_meter2")
      cm:callback(function ()
        mod.populate_group_meter_text( "special", mod.get_or_create_group_meter("special"), character_record, suppress)
        mod.populate_group_meter_text( "rare", mod.get_or_create_group_meter("rare"), character_record, suppress)
        mod.adjust_main_units_panel(suppress)
      end, 0.1, "refresh_meter2")
    end,
    true)
    core:add_listener(
      "TTCUIListeners",
      "CharacterFinishedMovingEvent",
      function(context)
        return context:character():faction():name() == cm:get_local_faction_name(true) and mod.is_units_panel_open()
      end,
      function (context)
        core:trigger_event("ModScriptEventRefreshUnitCards")
      end,
      true)

    core:add_listener(
      "TTCUIListeners",
      "PanelOpenedCampaign",
      function(context)
        return context.string == "units_panel"
      end,
      function(context)
        local character_record = mod.get_selected_character_record()
        local character = cm:get_character_by_cqi(cm:get_campaign_ui_manager():get_char_selected_cqi())
        if not character or character:is_null_interface() then return end
        local suppress = character:faction():name() ~= cm:get_local_faction_name(true) or (not character:has_military_force()) or (not mod.force_has_caps(character:military_force()))
        mod.populate_group_meter_text( "special", mod.get_or_create_group_meter("special"), character_record, suppress)
        mod.populate_group_meter_text( "rare", mod.get_or_create_group_meter("rare"), character_record, suppress)
        cm:callback(function ()
          mod.populate_group_meter_text( "special", mod.get_or_create_group_meter("special"), character_record, suppress)
          mod.populate_group_meter_text( "rare", mod.get_or_create_group_meter("rare"), character_record, suppress)
          mod.adjust_main_units_panel(suppress)
        end, 0.2, "refresh_meter2")
      end,
      true)
end

-----------------------------------------------------------------------------------------------------------
----------------------------------Unit Exchange Panel--------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

mod.character_exchanging_with = 0
mod.cards_exchanged = {[1] = {}, [2] = {}}
mod.group_key_to_transfer_ui_offset = {
  special = {-175, -4},
  rare = {-85, -4}
}

mod.position_exchange_meters = function(group_key, meters_list)
  local exchange_panel = find_uicomponent(core:get_ui_root(), "unit_exchange")
  local mups = {find_uicomponent(exchange_panel, "main_units_panel_1"),find_uicomponent(exchange_panel, "main_units_panel_2")}
  local placement_elements = {find_child_uicomponent(mups[1], "frame"), find_child_uicomponent(mups[2], "frame")}
  local offsets = mod.group_key_to_transfer_ui_offset[group_key]
  for i = 1, 2 do
    local meter = meters_list[i]
    local x1, y1 = placement_elements[i]:Position()
    meter:SetMoveable(true)
    meter:MoveTo(x1 + offsets[1], y1 + offsets[2])
    meter:SetMoveable(false)
  end
end


mod.add_or_get_exchange_panel_meters = function (group_key)
  -- :root:unit_exchange:main_units_panel_1:frame
  local uic_key = mod.ui_settings.ttc_meter_prefix..group_key
  local exchange_panel = find_uicomponent(core:get_ui_root(), "unit_exchange")
  --[[
--]]

  local intended_parent_1 = find_uicomponent(exchange_panel, "main_units_panel_1")
  local intended_parent_2 = find_uicomponent(exchange_panel, "main_units_panel_2")
  local existing_meter = find_uicomponent(intended_parent_1, uic_key.."_1")
  if is_uicomponent(existing_meter) then
    local corresponding_meter = find_uicomponent(intended_parent_2, uic_key.."_2")
    if is_uicomponent(corresponding_meter) then
      local meters_list = {existing_meter, corresponding_meter}
      mod.position_exchange_meters(group_key, meters_list)
      return meters_list
    else
      out("This shouldn't happen")
      out("Found one existing meter on the exchange panel but not the other")
      return {existing_meter}
    end
  else
    out("Creating the exchange panel meters")
    local new_meter_1
    local new_meter_2
    local ok, err = pcall(function()
      local main_units_panel = find_uicomponent(core:get_ui_root(), "units_panel","main_units_panel")
      local clonable_element_parent = find_uicomponent(main_units_panel, "tr_element_list")

      local meter_to_clone = find_uicomponent(clonable_element_parent, uic_key)
      new_meter_1 = UIComponent(meter_to_clone:CopyComponent(uic_key.."_1"))
      --out("Adopto")
      intended_parent_1:Adopt(new_meter_1:Address(), 0)
      new_meter_2 = UIComponent(meter_to_clone:CopyComponent(uic_key.."_2"))
      intended_parent_2:Adopt(new_meter_2:Address(), 0)

      mod.position_exchange_meters(group_key, {new_meter_1, new_meter_2})

      new_meter_1:SetVisible(true)
      new_meter_1:PropagatePriority(50)
      new_meter_1:RegisterTopMost()

      new_meter_2:SetVisible(true)
      new_meter_2:PropagatePriority(50)
      new_meter_2:RegisterTopMost()
    end)
    if not ok then
      out("Error creating the meters for the exchange panel")
      out(err)
    end
    if new_meter_1 and new_meter_2 then
      return {new_meter_1, new_meter_2}
    else
      out("One or both new exchange panel meters failed to create")
    end
  end
end

mod.adjust_exchange_panels = function ()
  out("Adjusting Panels")
  local exchange_panel = find_uicomponent(core:get_ui_root(), "unit_exchange")
  local mup_1 = find_uicomponent(exchange_panel, "main_units_panel_1")
  local mup_2 = find_uicomponent(exchange_panel, "main_units_panel_2")
  local unitList_1 = find_uicomponent(mup_1, "units")
  local unitList_2 = find_uicomponent(mup_2, "units")
  local x1, y1 = mup_1:Dimensions()
  local x2, y2 = mup_2:Dimensions()

    mup_2:SetCanResizeWidth(true)
    mup_2:Resize(1200, y2, false)
    local smoke = find_child_uicomponent(mup_2, "panel_smoke_t")
    local sx, sy = smoke:Dimensions()
    smoke:SetCanResizeWidth(true)
    smoke:Resize(1200, sy, false)
    smoke:SetCanResizeWidth(false)  
    mup_2:SetCanResizeWidth(false)

    mup_1:SetCanResizeWidth(true)
    mup_1:Resize(1200, y1, false)
    local smoke = find_child_uicomponent(mup_1, "panel_smoke_t")
    local sx, sy = smoke:Dimensions()
    smoke:SetCanResizeWidth(true)
    smoke:Resize(1200, sy, false)
    smoke:SetCanResizeWidth(false)  
    mup_1:SetCanResizeWidth(false)


  cm:callback(function ()
    mod.add_or_get_exchange_panel_meters("special")
    mod.add_or_get_exchange_panel_meters("rare")
  end, 0.1)
end


---Creates and fills a character record for the second army in an exchange
---@return ttc_character|nil`
mod.get_other_character_in_exchange = function()
  out("Getting exchange army")
  local exchange_panel = find_uicomponent(core:get_ui_root(), "unit_exchange")
  local mup_2 = find_uicomponent(exchange_panel, "main_units_panel_2")
  local unitList = find_uicomponent(mup_2, "units")
  local units = {}
  local success = false
  local cqi
  for i = 0, unitList:ChildCount() - 1 do
    local unitCard = UIComponent(unitList:Find(i))
    local campaignUnitContextId = unitCard:GetContextObjectId("CcoCampaignUnit")
    out("Context ID for "..unitCard:Id().." was "..tostring(campaignUnitContextId))
    if campaignUnitContextId then
      local campaignUnitContext = cco("CcoCampaignUnit", campaignUnitContextId)
      if campaignUnitContext:Call("IsCharacter") then
        local this_cqi = campaignUnitContext:Call("CharacterContext.CQI")
        local character = cm:get_character_by_cqi(this_cqi)
        if character:is_null_interface() then
          out("Character in exchange was the null interface")
        elseif not character:has_military_force() then
          out("Character has no military force, they are probably a hero")
        elseif character:military_force():general_character():command_queue_index() == this_cqi then
          cqi = this_cqi
          out(unitCard:Id().." was "..cqi.." who is the general")
          success = true
        end
      else
        local unit_key = campaignUnitContext:Call("UnitRecordContext.Key")
        out(unitCard:Id().." was a unit "..unit_key)
        table.insert(units, {unit_key, unitCard})
      end
    else
      local experience_icon = find_uicomponent(unitCard, "experience")
      local unitDetailsContextID = experience_icon:GetContextObjectId("CcoUnitDetails")
      out(unitCard:Id().. "is a queued unit "..tostring(unitDetailsContextID))
      local key_with_trailing_data = string.gsub(unitDetailsContextID, "UnitRecord_", "")
      local unit_key_with_faction = string.gsub(key_with_trailing_data, "_%d+_%d+%.%d+$", "")
      local unit_key = string.gsub(unit_key_with_faction, "_"..cm:get_local_faction_name(true), "")
 
      out("Tried 1 to get their key "..tostring(unit_key))
      table.insert(units, {unit_key, unitCard})
    end
  end
  if success and cqi then
    out("Successfully selected and loaded the other character in the exchange")
    local character_record = mod.characters[cqi] or ttc_character.new(cm:get_character_by_cqi(cqi))
    character_record.count = {}
    character_record.factors = {}
    character_record:refresh_budget()
    character_record:refresh_special_rules()
    for i = 1, #units do
      local unit_key = units[i][1]
      local card = units[i][2]
      local unit_record = mod.get_unit(unit_key, character_record)
      character_record:apply_cost_of_unit(unit_record)
      mod.add_listeners_to_army_unit_card(card, character_record, unit_record)
    end
    return character_record
  end
  out("Failed to get the other character in exchange")
  return nil
end

mod.add_listeners_to_exchange_meter = function(group_key, group_meter, command_queue_index)
  local character_record = mod.characters[command_queue_index]
  mod.populate_group_meter_tooltip_and_text(group_key, group_meter, character_record)
  core:add_listener(
    "TTCExchangeListeners",
    "ModScriptEventTabletopCapsCountChanged",
    function(context)
      return context:character():command_queue_index() == command_queue_index
    end,
    function (context)
      mod.populate_group_meter_tooltip_and_text(group_key, group_meter, character_record)
    end,
    true
  )
end

mod.setup_exchange = function ()
  mod.cards_exchanged = {[1] = {}, [2] = {}}
  out("The exchange panel has opened!")
  core:remove_listener("TTCExchangeListeners")
  mod.refresh_icons_on_exchange_bars()
  out("1")
  core:trigger_event("ModScriptEventRefreshUnitCards")
  local currently_selected_cqi = cm:get_campaign_ui_manager():get_char_selected_cqi()
  out("2")
  local character_record_1 = mod.characters[currently_selected_cqi]
  local meters_special = mod.add_or_get_exchange_panel_meters("special")
  out("3")
  local meters_rare = mod.add_or_get_exchange_panel_meters("rare")
  out("4")
  mod.add_listeners_to_exchange_meter("special", meters_special[1], currently_selected_cqi)
  out("5")
  mod.add_listeners_to_exchange_meter("rare", meters_rare[1], currently_selected_cqi)
  out("6")
  local character_record_2 = mod.get_other_character_in_exchange()
  if not character_record_2 then
    out("Failed to get the other character in exchange, exchange setup failed!")
    return
  end
  mod.character_exchanging_with = character_record_2.interface:command_queue_index()
  mod.add_listeners_to_exchange_meter("special", meters_special[2], mod.character_exchanging_with)
  mod.add_listeners_to_exchange_meter("rare", meters_rare[2], mod.character_exchanging_with)
  cm:callback(function ()
    mod.adjust_exchange_panels()
  end, 0.1)

  core:add_listener(
    "TTCExchangeListeners",
    "ComponentLClickUp",
    function (context)
      return mod.is_exchange_panel_open() and string.find(context.string, "UnitCard")
    end,
    function (context)
      local unitCard = UIComponent(context.component)
      local card_id = string.gsub(context.string, "UnitCard", "")
      local campaignUnitContextId = unitCard:GetContextObjectId("CcoCampaignUnit")
      local is_clicked = find_uicomponent(unitCard, "exchange_arrow"):Visible()
      out("clicked card "..unitCard:Id().." in exchange, is_clicked = "..tostring(is_clicked).." context was "..tostring(campaignUnitContextId))
      if campaignUnitContextId then
        local campaignUnitContext = cco("CcoCampaignUnit", campaignUnitContextId)
        local unit_key = campaignUnitContext:Call("UnitRecordContext.Key")
        if uicomponent_descended_from(unitCard, "main_units_panel_1") then
          local was_previously_clicked = mod.cards_exchanged[1][card_id] or false
          mod.cards_exchanged[1][card_id] = is_clicked
          if is_clicked and not was_previously_clicked then
            character_record_1:refund_cost_of_unit(mod.get_unit(unit_key, character_record_1), true)
            character_record_2:apply_cost_of_unit(mod.get_unit(unit_key, character_record_2), true)
          elseif was_previously_clicked and not is_clicked then
            character_record_2:refund_cost_of_unit(mod.get_unit(unit_key, character_record_2), true)
            character_record_1:apply_cost_of_unit(mod.get_unit(unit_key, character_record_1), true)
          end
        elseif uicomponent_descended_from(unitCard, "main_units_panel_2") then
          local was_previously_clicked = mod.cards_exchanged[2][card_id] or false
          mod.cards_exchanged[2][card_id] = is_clicked
          if is_clicked and not was_previously_clicked then
            character_record_2:refund_cost_of_unit(mod.get_unit(unit_key, character_record_2), true)
            character_record_1:apply_cost_of_unit(mod.get_unit(unit_key, character_record_1), true)
          elseif was_previously_clicked and not is_clicked then
            character_record_1:refund_cost_of_unit(mod.get_unit(unit_key, character_record_1), true)
            character_record_2:apply_cost_of_unit(mod.get_unit(unit_key, character_record_2), true)
          end
        end
      else
        out("No context - this unit is queued and can't be transferred")
      end
    end,
    true)  

  core:add_listener(
    "TTCExchangeListeners",
    "ModScriptEventTabletopCapsCountChanged",
    function(context)
      return true
    end,
    function (context)
      local too_many_units = false
      local over_caps = false
      --check manually if the comps are valid
      local exchange_panel = find_uicomponent(core:get_ui_root(), "unit_exchange")
      local exchange_ok_button = find_uicomponent(exchange_panel, "hud_center_docker", "ok_cancel_buttongroup", "button_ok")
      local mup_1 = find_uicomponent(exchange_panel, "main_units_panel_1")
      local num_units_1 = UIComponent(find_child_uicomponent(mup_1, "frame"):Find(0))
      local mup_2 = find_uicomponent(exchange_panel, "main_units_panel_2")
      local num_units_2 = UIComponent(find_child_uicomponent(mup_2, "frame"):Find(0))
      if string.find(num_units_1:GetStateText(), "[[col:red]]") or string.find(num_units_2:GetStateText(), "[[col:red]]") then
        out("Exchange has too many units")
        too_many_units = true
      end
      if character_record_1:is_over_cap("rare") or character_record_2:is_over_cap("rare") then
        out("exchange has too many rare units")
        over_caps = true
      end
      if character_record_1:is_over_cap("special") or character_record_2:is_over_cap("special") then
        out("exchange has too many special units")
        over_caps = true
      end
      
      if (not over_caps) and (not too_many_units) then
        out("exchange is valid")
        exchange_ok_button:SetState("active")
      else
        exchange_ok_button:SetState("inactive")
      end
    end,
    true
  )
  out("We did everything, I guess?")
end



mod.add_exchange_listeners = function ()
  core:remove_listener("TTCMainExchangeListeners")
  core:add_listener(
    "TTCMainExchangeListeners",
    "PanelOpenedCampaign",
    function(context) 
        return context.string == "unit_exchange"; 
    end,
    function(context)
      --cm:callback(function ()
      mod.setup_exchange()
      --end, 0.1)
    end,
    true)
  --handle the player swapping between panels or closing them
  core:add_listener(
    "TTCMainListeners",
    "PanelClosedCampaign",
    function(context)
      return context.string == "unit_exchange"
    end,
    function(context)
      out("The exchange panel closed")
      core:remove_listener("TTCExchangeListeners")
      cm:callback(function ()
        mod.select_character(mod.get_selected_character_record().interface, true)
        core:trigger_event("ModScriptEventRefreshUnitCards")
      end, 0.2)
    end,
    true)

end

-----------------------------------------------------------------------------------------------------------
-------------------------------UNIT BROWSER-------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------


mod.set_unit_browser_card_display = function(unitBrowserCard, visible)
  local main_unit_key = unitBrowserCard:GetContextObjectId("CcoMainUnitRecord")
  out("Unit card on browser "..unitBrowserCard:Id().." has a CcoMainUnitRecord Context Object ID of "..tostring(main_unit_key))
  local unit_record = mod.get_unit_if_existing(main_unit_key)
  if unit_record then
    local cost_tooltip_loc = ""
    if unit_record.group == "core" then
      local desc_loc_to_fill = common.get_localised_string("ttc_unit_no_cost")
      local group_name = common.get_localised_string("ttc_group_name_core")
      cost_tooltip_loc = fill_loc(desc_loc_to_fill, group_name) 
    else
      local desc_loc_to_fill = common.get_localised_string("ttc_unit_cost")
      local points_name = common.get_localised_string("ttc_measurement_name")
      local group_name = common.get_localised_string("ttc_group_name_"..unit_record.group)
      local cost = tostring(unit_record.weight)
      cost_tooltip_loc = fill_loc(desc_loc_to_fill, group_name, cost, points_name) 
    end
    -- :CcoUnitsCustomBattlePermissionRecordwh3_main_ksl_inf_kossars_0:wh3_main_ksl_kislev:0:experience
    local experience_icon = find_uicomponent(unitBrowserCard, "experience")
    if is_uicomponent(experience_icon) then
      local image_path = (mod.ui_settings.groups_to_pips[unit_record.group] or {})[unit_record.weight]
      experience_icon:SetState(1)
      experience_icon:SetImagePath(image_path or "ui/custom/recruitment_controls/fuckoffbutton.png", 1)
      experience_icon:SetTooltipText(cost_tooltip_loc, true)
      experience_icon:SetDockOffset(20, 2)
      experience_icon:SetVisible(visible)
    else
      out("Couldn't find the experience icon on the unit browser card")
      out("Children are: ")
      for k = 0, unitBrowserCard:ChildCount() - 1 do
        out("Child at "..tostring(k).." with ID "..tostring(UIComponent(unitBrowserCard:Find(k)):Id()))
      end
    end
  else
    out("This does not correspond to any stored unit")
  end
end



mod.display_costs_on_unit_browser = function()
 -- :root:spell_browser:panel_clip:units_tab_parent:main_holder:units_listview:list_clip:list_box
  local ut_parent = find_uicomponent(core:get_ui_root(), "spell_browser", "panel_clip", "units_tab_parent")
  local category_list = find_uicomponent(ut_parent, "main_holder", "units_listview", "list_clip", "list_box")
  
  local should_display = not core:svr_load_registry_bool("spell_browser_cap_toggle")
  for i = 0, category_list:ChildCount() - 1 do
    local this_category = UIComponent(category_list:Find(i))
    -- :CcoGroupList7403738784:roster_list:CcoUnitsCustomBattlePermissionRecordwh3_main_ksl_inf_kossars_0:wh3_main_ksl_kislev:0
    local roster_list = find_uicomponent(this_category, "roster_list")
    for j = 0, roster_list:ChildCount() - 1 do
      local this_unit = UIComponent(roster_list:Find(j))
      mod.set_unit_browser_card_display(this_unit, should_display)
    end
  end
  local race_holder = find_uicomponent(ut_parent, "race_holder")
  local toggle_caps, was_created = core:get_or_create_component("spell_browser_cap_toggle", "ui/templates/square_button_toggle_40", race_holder)
  if was_created and should_display then
    toggle_caps:SetState("selected")
  end
  toggle_caps:SetDockingPoint(6)
  toggle_caps:SetImagePath("ui/custom/recruitment_controls/fuckoffbutton.png")
  toggle_caps:SetTooltipText(common.get_localised_string("ttc_show_costs"), true)

  core:add_listener(
    "TTCUnitBrowser",
    "ComponentLClickUp",
    function(context)
      return context.string == "spell_browser_cap_toggle"
    end,
    function(context)
        should_display = not should_display
        core:svr_save_registry_bool("spell_browser_cap_toggle", not should_display)
    end,
    true)

  end


mod.unit_browser_listeners = function()

  if __game_mode == __lib_type_campaign then
    core:add_listener(
      "TTCUnitBrowser",
      "ComponentLClickUp",
      function(context)
        return mod.is_spell_browser_open() 
      end,
      function(context)
        cm:callback(function() mod.display_costs_on_unit_browser() end, 0.1)
      end,
      true
    )
  else
    local tm = core:get_tm()
    core:add_listener(
      "TTCUnitBrowser",
      "ComponentLClickUp",
      function(context)
        return mod.is_spell_browser_open() 
      end,
      function(context)
        tm:real_callback(function() mod.display_costs_on_unit_browser() end, 100)
      end,
      true
    )

  end
  --[[
    This doesn't fire for this panel.
  core:add_listener(
    "TTCUnitBrowser",
    "PanelOpenedCampaign",
    function(context)
      return context.string == "spell_browser"
    end,
    function(context)
      cm:callback(function() mod.display_costs_on_unit_browser() end, 0.1)
    end,
    true)
    --]] 
end


-----------------------------------------------------------------------------------------------------------
----------------------------------SETUP-------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------


--- load a lua file with the correct environment
--- ie. load_module("test", "script/my_folder/") to load script/my_folder/test.lua
---@param file_name string
---@param file_path string
---@return any
local function load_module(file_name, file_path)
  local full_path = file_path.. file_name.. ".lua"
  local file, load_error = loadfile(full_path)

  if not file then
      out("Attempted to load module with name ["..file_name.."], but loadfile had an error: ".. load_error .."")
  else
      out("Loading module with name [" .. file_name.. ".lua]")

      local global_env = core:get_env()
      setfenv(file, global_env)
      local lua_module = file(file_name)

      if lua_module ~= false then
          out("[" .. file_name.. ".lua] loaded successfully!")
      end

      return lua_module
  end

  -- run "require" to see what the specific error is
  local ok, msg = pcall(function() require(file_path .. file_name) end)

  if not ok then
      out("Tried to load module with name [" .. file_name .. ".lua], failed on runtime. Error below:")
      out(msg)
      return false
  end
end

---load all of the lua files from a specific folder
--- ie. load_modules("script/my_folder/") to load everything in ?.pack/script/my_folder/
--- code shamelessly stolen from Vandy <3
---@param path string
local function load_modules(path)
local search_override = "*.lua" -- search for all files that end in .lua within this path
local file_str = common.filesystem_lookup(path, search_override)

  for filename in string.gmatch(file_str, '([^,]+)') do
      local filename_for_out = filename

      local pointer = 1
      while true do
          local next_sep = string.find(filename, "\\", pointer) or string.find(filename, "/", pointer)

          if next_sep then
              pointer = next_sep + 1
          else
              if pointer > 1 then
                  filename = string.sub(filename, pointer)
              end
              break
          end
      end

      local suffix = string.sub(filename, string.len(filename) - 3)

      if string.lower(suffix) == ".lua" then
          filename = string.sub(filename, 1, string.len(filename) -4)
      end


      load_module(filename, string.gsub(filename_for_out, filename..".lua", ""))
  end
end


mod.setup = {}

mod.setup.callbacks = {} ---@type fun()[]

--this essentially duplicates the actual filters in a format which is easier to use for checking duplicates. erased after setup.
mod.setup.filters_set = {}
mod.setup.special_rule_lists = {}

mod.setup.post_callbacks = {} ---@type fun()[]

mod.setup.entries = {} ---@type table<string, string|integer>

---Used to tell the script when it needs to check bonus values for what units


---@alias filter_table {faction:string, subculture:string, subtype:string}

---Example of valid filter:
---{faction = "wh_main_emp_empire"}
---@param unit_key string
---@param filter filter_table
mod.add_special_rule_filter = function(unit_key, filter)
  out("Setting special rule filter for "..unit_key)
  if filter.faction then
    if mod.setup.filters_set[unit_key] and mod.setup.filters_set[unit_key][filter.faction] == true then
      --we already have this unit under this filter
      out("Disgarding the faction filter "..(filter.faction).." for this unit because it is already being checked by that faction!")
    else
      out("Faction "..(filter.faction).." will check bonus values for unit "..unit_key)
      mod.faction_potential_special_rule_bonus_values[filter.faction] = mod.faction_potential_special_rule_bonus_values[filter.faction] or {}
      table.insert(mod.faction_potential_special_rule_bonus_values[filter.faction], unit_key)
      mod.setup.filters_set[unit_key] = mod.setup.filters_set[unit_key]  or {}
      mod.setup.filters_set[unit_key][filter.faction] = true
    end
  end

  if filter.subtype then
    if mod.setup.filters_set[unit_key] and mod.setup.filters_set[unit_key][filter.subtype] == true then
      --we already have this unit under this filter
      out("Disgarding the subtype filter "..(filter.subtype).." for this unit because it is already being checked by that subtype!")
    else
      out("subtype "..(filter.subtype).." will check bonus values for unit "..unit_key)
      mod.subtype_potential_special_rule_bonus_values[filter.subtype] = mod.subtype_potential_special_rule_bonus_values[filter.subtype] or {}
      table.insert(mod.subtype_potential_special_rule_bonus_values[filter.subtype], unit_key)
      mod.setup.filters_set[unit_key] = mod.setup.filters_set[unit_key]  or {}
      mod.setup.filters_set[unit_key][filter.subtype] = true
    end
  end

  if filter.subculture then
    if mod.setup.filters_set[unit_key] and mod.setup.filters_set[unit_key][filter.subculture] == true then
      --we already have this unit under this filter
      out("Disgarding the subculture filter "..(filter.subculture).." for this unit because it is already being checked by that subculture!")
    else
      out("subculture "..(filter.subculture).." will check bonus values for unit "..unit_key)
      mod.subculture_potential_special_rule_bonus_values[filter.subculture] = mod.subculture_potential_special_rule_bonus_values[filter.subculture] or {}
      table.insert(mod.subculture_potential_special_rule_bonus_values[filter.subculture], unit_key)
      mod.setup.filters_set[unit_key] = mod.setup.filters_set[unit_key]  or {}
      mod.setup.filters_set[unit_key][filter.subculture] = true
    end
  end
end


mod.add_special_rule_list = function(special_rule_list)
  local calling_file = debug.getinfo(2).source
  out("Adding a special rule list from ["..tostring(calling_file).."]!")
  for i = 1, #special_rule_list do
    local entry = special_rule_list[i]
    local unit_key = entry[1]
    if #entry < 2 then
      out("\tThe special rule list entry for ["..unit_key.."] has no filters! This is probably a mistake")
    end
    for j = 2, #entry do
      if is_table(entry[j]) then
        mod.add_special_rule_filter(unit_key, entry[j])
      else
        out("\tThe special rule list entry for ["..unit_key.."] has an invalid entry #["..tostring(j).."] - it isn't a table")
      end
    end
  end
  out("Finished adding special rules from this list")
end



---@param callback fun()
mod.add_setup_callback = function(callback)
  local calling_file = debug.getinfo(2).source
  local pos = #mod.setup.callbacks+1
  out("Setup Callback "..tostring(pos).." being added from "..tostring(calling_file))
  mod.setup.callbacks[pos] = callback
end

---@param callback fun()
mod.add_post_setup_callback = function(callback)
  local calling_file = debug.getinfo(2).source
  local pos = #mod.setup.post_callbacks+1
  out("Post Setup Callback "..tostring(pos).." being added from "..tostring(calling_file))
  table.insert(mod.setup.post_callbacks, callback)
end

---@param subculture string
---@param unit_list string[]
mod.add_replacement_units_for_subculture = function(subculture, unit_list)
  mod.core_unit_replacements[subculture] = mod.core_unit_replacements[subculture] or {}
  for i = 1, #unit_list do
    table.insert(mod.core_unit_replacements[subculture], unit_list[i])
  end
end

---@param unit_list (string|integer)[]
---@param prioritized boolean|nil
mod.add_unit_list = function(unit_list, prioritized)
  local calling_file = debug.getinfo(2).source
  out("Adding a unit list from ["..tostring(calling_file).."]!")
  for i = 1, #unit_list do
    local entry = unit_list[i]
    if not entry then
      out("entry is nil! Something is weird in the calling file")
    else
      local unit_key = entry[1] 
      ---@cast unit_key string
      if mod.setup.entries[unit_key] then
        out("\tUnit Key: ["..unit_key.."] existing entry overwritten by prioritized list.")
        if prioritized then
          mod.setup.entries[unit_key] = entry
        else
          out("\tUnit Key: ["..unit_key.."] is being skipped because it already has an entry.")
        end
      else
        mod.setup.entries[unit_key] = entry
      end
    end
  end
end

---load all of the files within the script/ttc folder 
mod.load_ttc_folder = function ()
  load_modules("script/ttc/")
end


mod.finish_setup = function()
  out("Finishing setup!")
  out("Loading modules from the TTC folder")
  mod.load_ttc_folder()
  out("TTC running callbacks")
  for i = 1, #mod.setup.callbacks do
    local callback = mod.setup.callbacks[i]
    if type(callback) == "function" then
      callback()
    else
      out("Callback #"..tostring(i).." is not a function! It is a "..tostring(type(callback)))
    end
  end
  for key, entry in pairs(mod.setup.entries) do
    mod.units[key] = ttc_unit.new(entry[1], entry[2], entry[3], true)
  end
  out("TTC Running post setup callbacks")
  for i = 1, #mod.setup.post_callbacks do
    local callback = mod.setup.post_callbacks[i]
    if type(callback) == "function" then
      callback()
    else
      out("Callback #"..tostring(i).." is not a function! It is a "..tostring(type(callback)))
    end
  end
  out("TTC Setup successful, clearing setup data")
  mod.setup = {}
end

-----------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

core:add_static_object("tabletopcaps", mod)

