local recruitment_resource_handler = {} --# assume recruitment_resource_handler:RECRUITMENT_HANDLER
local unit_recruit_percentage = 0.5

--v function(text: any)
local function log(text)
    if CONST.__should_output_ui then
        dev.log(tostring(text), "RECHANDLER")
    end
end



--v function(resource: string, resource_getter: (function(faction_key: string)--> number), resource_mod: function(faction_key: string, change: number), uic_name: string) --> RECRUITMENT_HANDLER
function recruitment_resource_handler.new(resource, resource_getter, resource_mod, uic_name)
    local self = {}
    setmetatable(self, {
        __index = recruitment_resource_handler
    }) --# assume self: RECRUITMENT_HANDLER

    self.faction_key = cm:get_local_faction(true)
    self.key = resource
    self.get = resource_getter
    self.mod = resource_mod
    self.uic_name = uic_name
    self.selected_character = -1 --:int

    self.tooltip = " " --:string
    self.image_state = "" --:string
    self.unit_costs = {} --:map<string, number>
    
    self.has_faction_whitelist = false
    self.faction_whitelist = {} --:map<string, boolean>

    self.panel = nil --:CA_UIC
    self.queued_units = {} --:vector<string>
    self.available_units = {} --:map<string, string>
    self.pending_cost = 0 --:number
    return self
end


--v function(self: RECRUITMENT_HANDLER, unit_key: string, cost: number)
function recruitment_resource_handler.set_cost_of_unit(self, unit_key, cost)
    self.unit_costs[unit_key] = cost*unit_recruit_percentage
end

--v function(self: RECRUITMENT_HANDLER, tooltip: string)
function recruitment_resource_handler.set_resource_tooltip(self, tooltip)
    self.tooltip = tooltip
end

--v function(self: RECRUITMENT_HANDLER, faction_name: string)
function recruitment_resource_handler.add_faction_to_whitelist(self, faction_name)
    self.has_faction_whitelist = true
    self.faction_whitelist[faction_name] = true
end

--v function(self: RECRUITMENT_HANDLER, unit_card: CA_UIC, apply: boolean, cost: number)
function recruitment_resource_handler.restrict_unit_card(self, unit_card, apply, cost)
    local restriction_uic = dev.get_uic(unit_card, "disabled_script")
    local icon_uic = dev.get_uic(unit_card, "unit_clip", "unit_icon")
    if apply then
        icon_uic:SetState("inactive")
        --icon_uic:ShaderTechniqueSet("set_grayscale_t0")
        --icon_uic:ShaderVarsSet(1, 1, 1, 0)
    elseif not dev.get_uic(unit_card, "tech_required_icon"):Visible() then
        icon_uic:SetState("active")
    end
    unit_card:SetInteractive(not apply)
    restriction_uic:SetInteractive(true)
    if self.image_state then
        restriction_uic:SetState(self.image_state)
    end
    restriction_uic:SetVisible(apply) 
    local total_available = self.get(self.faction_key) - self.pending_cost
    local cost_string = tostring(total_available).."/"..tostring(cost)
    restriction_uic:SetTooltipText("[[col:red]]You do not have the manpower required to recruit this unit (".. cost_string..")[[/col]]\n\n"..self.tooltip)
end


--v function(self: RECRUITMENT_HANDLER)
function recruitment_resource_handler.update_restrictions(self)
    if not self.panel then
        log("Called update restrictions but the panel is not available!")
        return
    end
    local total_available = self.get(self.faction_key) - self.pending_cost
    for unit_key, category in pairs(self.available_units) do
        if self.unit_costs[unit_key] then
            local unit_card = dev.get_uic(self.panel, "recuitment_list", "listview", "list_clip", "list_box", category, "units_box", unit_key.. "_mercenary")
            if unit_card then
                if self.unit_costs[unit_key] > total_available then 
                    log("Unit key: " .. unit_key .. " restricted from recruitment.")
                    self:restrict_unit_card(unit_card, true, self.unit_costs[unit_key])
                else
                    self:restrict_unit_card(unit_card, false, self.unit_costs[unit_key])
                end
            end
        end
    end
end

--v function(self: RECRUITMENT_HANDLER)
function recruitment_resource_handler.update_cost_uic(self)
    if not self.panel then
        log("Called update cost UIC but the panel is not available!")
        return
    end
    log("Updating recruitment cost UIC")
    local costUIC = dev.get_uic(self.panel, "recuitment_list", "costs_list", self.uic_name)
    if costUIC then
        local total_available = self.get(self.faction_key)
        local cost = 0 --:number
        for i = 1, #self.queued_units do
            local unit = self.queued_units[i]
            if self.unit_costs[unit] then
                cost = cost + self.unit_costs[unit]
            end
        end
        self.pending_cost = cost
        costUIC:SetStateText(tostring(cost).."/"..tostring(total_available))
        costUIC:SetTooltipText(self.tooltip)
    else
        log("CostUIC not found!")
    end
end

--v function(self: RECRUITMENT_HANDLER, unit_name: string)
function recruitment_resource_handler.add_unit_to_queue(self, unit_name)
    cm:steal_user_input(true)
    table.insert(self.queued_units, unit_name)
    log(self.key .." recruit resource tracker added "..unit_name.. "to its queue @"..tostring(#self.queued_units))
    if self.unit_costs[unit_name] then
        self:update_cost_uic()
        self:update_restrictions()
    end
    cm:steal_user_input(false)
end

--v function(self: RECRUITMENT_HANDLER, queue_position: int)
function recruitment_resource_handler.remove_unit_from_queue(self, queue_position)
    cm:steal_user_input(true)
    local unit = self.queued_units[queue_position]
    if not unit then
        log("Warning: asked to remove a unit which doesn't exist at queue "..tostring(queue_position).."?")
        cm:steal_user_input(false)
        return
    end
    log("Removing "..self.queued_units[queue_position].." from character Queue")
    table.remove(self.queued_units, queue_position)
    if self.unit_costs[unit] then
        self:update_cost_uic()
        self:update_restrictions()
    end
    cm:steal_user_input(false)
end

--v function (self: RECRUITMENT_HANDLER, suspected_key: string)
function recruitment_resource_handler.long_check_for_new_unit(self, suspected_key)
    log("performing long refresh of unit queues")
    cm:steal_user_input(true)
    for i = 1, #self.queued_units do
        local uic = dev.get_uic(cm:ui_root(), "units_panel","main_units_panel", "units", "temp_merc_"..tostring(i-1))
        if not uic then
            log("Non-matching unit found in queue "..self.queued_units[i])
            for j = i, #self.queued_units do
                self:remove_unit_from_queue(j)
            end
            cm:steal_user_input(false)
            return
        end
    end
    local uic = dev.get_uic(cm:ui_root(), "units_panel","main_units_panel", "units", "temp_merc_"..tostring(#self.queued_units))
    if uic then
        self:add_unit_to_queue(suspected_key)
        cm:steal_user_input(false)
    else
        log("No unit found!")
        cm:steal_user_input(false)
    end
end

--v [NO_CHECK] function(self: RECRUITMENT_HANDLER, cqi: (CA_CQI|int)?)
function recruitment_resource_handler.clear_queue(self, cqi)
    log("Clearing Queue")
    if cqi then
        --# assume cqi: CA_CQI
        if cqi == self.selected_character then
            log("CQI matches selected char")
            for i = 1, #self.queued_units do
                local uic = dev.get_uic(cm:ui_root(), "units_panel","main_units_panel", "units", "temp_merc_"..tostring(i-1))
                if not uic then
                    log("Non-matching unit found in queue "..self.queued_units[i])
                    for j = i, #self.queued_units do
                        self:remove_unit_from_queue(j)
                    end
                    return
                end
            end
            return
        end
    end
    dev.remove_callback("LongCheckRec")
    self.available_units = {}
    self.queued_units = {}
    self.pending_cost = 0
    self.selected_character = cqi or -1
end

local instances = {} --:map<string, RECRUITMENT_HANDLER>

--v function(resource: string, resource_getter: (function(faction_key: string)--> number), resource_mod: function(faction_key: string, change: number), uic_name: string) --> RECRUITMENT_HANDLER
local function add_recruitment_resource(resource, resource_getter, resource_mod, uic_name)
    local instance = recruitment_resource_handler.new(resource, resource_getter, resource_mod, uic_name)
    log("Created recruitment handler for resource: ".. resource)
    dev.eh:add_listener(
        "RecHandlerPanelOpenedCampaign",
        "PanelOpenedCampaign",
        function(context)
            return context.string == "recruitment"
        end,
        function(context)
            log("Recruitment Panel Opened!")
            instance:clear_queue(instance.selected_character)
            instance.panel = UIComponent(context.component)
            local list_box = dev.get_uic(instance.panel, "recuitment_list", "listview", "list_clip", "list_box")
            if list_box then
                for i = 0, list_box:ChildCount() - 1 do
                    local recruitmentCategory = UIComponent(list_box:Find(i))
                    local category_id = recruitmentCategory:Id()
                    local units_box = dev.get_uic(recruitmentCategory, "units_box")
                    for j = 0, units_box:ChildCount() - 1 do
                        local unit_key = string.gsub(UIComponent(units_box:Find(j)):Id(), "_mercenary", "")
                        log("Found available unit: "..unit_key.." in category "..category_id)
                        instance.available_units[unit_key] = category_id
                    end
                end
            else
                log("Failed to get the list box!")
            end
            instance:update_cost_uic()
            instance:update_restrictions()
        end, true)
    dev.eh:add_listener(
        "RecHandlerPanelClosedCampaign",
        "PanelClosedCampaign",
        function(context)
            return context.string == "recruitment"
        end,
        function(context)
            log("Recruitment Panel Closed")
            instance.panel = nil
            instance:clear_queue()
        end, true)
    dev.eh:add_listener(
        "RecHandlerComponentLClickUp",
        "ComponentLClickUp",
        true,
        function(context)
            local component = UIComponent(context.component)
            local queue_component_ID = tostring(component:Id())
            if string.find(queue_component_ID, "temp_merc_") then
                local position = string.gsub(queue_component_ID, "temp_merc_", "") 
                local queue_pos = tonumber(position) + 1
                --# assume queue_pos: int
                log("Unit in position "..queue_pos .. " being removed from queue")
                instance:remove_unit_from_queue(queue_pos)
            end
        end, true)
    dev.eh:add_listener(
        "RecHandlerComponentLClickUp",
        "ComponentLClickUp",
        true,
        function(context)
            local unit_component_ID = tostring(UIComponent(context.component):Id())
            --is our clicked component a unit?
            if string.find(unit_component_ID, "_mercenary") then
                local unitID = string.gsub(unit_component_ID, "_mercenary", "")
                if UIComponent(context.component):CurrentState() == "active" 
                and (not UIComponent(context.component):GetTooltipText():find("col:red"))
                and (not UIComponent(context.component):GetTooltipText():find("cannot")) then
                    instance:add_unit_to_queue(unitID)
                else
                    dev.callback(function()
                        instance:long_check_for_new_unit(unitID)
                    end, 0.1, "LongCheckRec")
                end
            end
        end, true)
    dev.eh:add_listener(
        "RecHandlerComponentMouseOn",
        "ComponentMouseOn",
        function(context)
            return not not string.find(context.string, "_mercenary")
        end,
        function(context)
            local unit_card = UIComponent(context.component)
            local unit_component_ID = tostring(unit_card:Id())
            local unitID = string.gsub(unit_component_ID, "_mercenary", "")
            if instance.unit_costs[unitID] then
                local pops = dev.get_uic(unit_card, "RecruitmentCost", "Cost", "Pops")
                pops:SetState(instance.image_state)
                pops:SetStateText(tostring(instance.unit_costs[unitID]))
            end
        end,
        true
    )
    dev.eh:add_listener(
        "RecHandlerCharacterSelected",
        "CharacterSelected",
        true,
        function(context)
            instance:clear_queue(context:character():command_queue_index())
        end,
        true
    )
    dev.eh:add_listener(
        "RecHandlerSettlementSelected",
        "SettlementSelected",
        true,
        function(context)
            instance:clear_queue()
        end,
        true
    )

    --gameplay impacting listeners
    dev.eh:add_listener(
        "RecHandlerUnitTrained",
        "UnitTrained",
        function(context)
            return context:unit():faction():is_human()
        end,
        function(context)
            local unit_key = context:unit():unit_key()
            if instance.unit_costs[unit_key] then
                instance.mod(context:unit():faction():name(), instance.unit_costs[unit_key]*-1)
            end
            if context:unit():faction():name() == cm:get_local_faction(true) then
                instance:clear_queue()
            end
        end,
        true)
       dev.eh:add_listener(
        "RecHandlerUnitTrained",
        "UnitDisbanded",
        function(context)
            local unit = context:unit() --:CA_UNIT
            return unit:faction():is_human() and unit:military_force():has_general()
        end,
        function(context)
            local unit = context:unit() --:CA_UNIT
            local unit_key = unit:unit_key()
            local character = unit:military_force():general_character()
            local generals = Gamedata.unit_info.general_units
            if instance.unit_costs[unit_key] and (not generals[unit_key]) then
                local strength = unit:percentage_proportion_of_full_strength()
                local returned_pop = dev.mround(instance.unit_costs[unit_key]*((strength/unit_recruit_percentage)/100), 1)
                log("Character "..tostring(character:command_queue_index()).." disbanded "..unit_key.. " at "..strength.." strength worth "..returned_pop.." pop")
                instance.mod(context:unit():faction():name(), returned_pop)
            end
            if context:unit():faction():name() == cm:get_local_faction(true) then
                instance:clear_queue()
            end
        end,
        true)
    dev.eh:add_listener(
        "SerfsCharacterReplenishmentCached",
        "CharacterReplenishmentCached",
        true,
        function(context)
            local replen_cache = context:table_data()
            local faction_name = context:character():faction():name()
            for unit_key, quantity in pairs(replen_cache) do 
                if instance.unit_costs[unit_key] then
                    instance.mod(faction_name, dev.mround(instance.unit_costs[unit_key]*-1*((quantity/unit_recruit_percentage)/100), 1))
                    --Since we store unit size with the proportion of a unit available at the time of recruitment already factored in, 
                    --we factor unit recruit percent here to reverse that and get replenishment based on the full unit size.
                    --40*-1*((11.25/0.5)/100) = 9 men 
                end
            end
        end,
        true)

    return instance
end

--v function(resource: string) --> RECRUITMENT_HANDLER
local function get_handler_for_faction_resource(resource)
    return instances[resource]
end

--v function(faction: string, icon_name: string)
local function disable_recruitment_cost_type_for_faction(faction, icon_name)
    dev.eh:add_listener(
        "RecHandlerPanelOpenedCampaign",
        "PanelOpenedCampaign",
        function(context)
            return context.string == "recruitment"
        end,
        function(context)
            local costUIC = dev.get_uic(UIComponent(context.component), "recuitment_list", "costs_list", icon_name)
            if costUIC then
                costUIC:SetVisible(false)
            end
        end,
        true)
end

return {
    get_handler_for_faction_resource = get_handler_for_faction_resource,
    add_resource = add_recruitment_resource,
    disable_recruitment_cost_type_for_faction = disable_recruitment_cost_type_for_faction
}