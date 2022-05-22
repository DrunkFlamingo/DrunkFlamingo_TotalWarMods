
local food_manager = {} --# assume food_manager: FOOD_MANAGER
--v method(text: any)
function food_manager:log(text)
    dev.log(tostring(text), "STORES")
end

-------------------------
-----STATIC CONTENT------
-------------------------

building_food_storage = {} --:map<string, number>
--v function(building: string, cap_effect: number)
local function add_food_storage_effect_to_building(building, cap_effect)
    building_food_storage[building] = cap_effect
end

food_storage_bundle = "shield_food_storage_bundle_" --:string
food_storage_cap_base = 100 --:number
food_storage_cap_absolute = 2000 --:number
food_storage_percentage = 1 --:number

----------------------------
----OBJECT CONSTRUCTOR------
----------------------------

--v function(faction_key: string) --> FOOD_MANAGER
function food_manager.new(faction_key)
    local self = {}
    setmetatable(self, {
        __index = food_manager,
        __tostring = function() return "FACTION_FOOD_MANAGER" end
    })--# assume self: FOOD_MANAGER


    self.owning_faction = faction_key
    self.save_name = "food_storage_"..faction_key .. "_"
    return self
end


--v function(self: FOOD_MANAGER, region: CA_REGION) --> boolean
function food_manager.does_region_have_food_storage(self, region)
    if region:owning_faction():name() ~= self.owning_faction then
        return false
    end
    for building, quantity in pairs(building_food_storage) do
        if region:building_exists(building) then
            return true
        end
    end
    return false
end



--v [NO_CHECK] function(self: FOOD_MANAGER) --> number
function food_manager.food_being_drawn(self)
    return cm:get_saved_value(self.save_name.."_current_draw") or 0
end

--v [NO_CHECK] function(self: FOOD_MANAGER) --> number
function food_manager.food_in_storage(self)
    return cm:get_saved_value(self.save_name.."_current_stores") or 0
end

--v [NO_CHECK] function(self: FOOD_MANAGER) --> number
function food_manager.food_store_cap(self)
    return cm:get_saved_value(self.save_name.."_storage_cap") or food_storage_cap_base
end

--v function(self: FOOD_MANAGER, draw: number)
function food_manager.set_food_draw(self, draw)
    local old_draw = self:food_being_drawn()
    draw = dev.mround(dev.clamp(draw, 0, self:food_in_storage()), 1)
    if draw == old_draw then
        return
    end
    self:log("Changing the current food draw for ["..self.owning_faction.."] from ["..old_draw.."] to ["..draw.."]")
    if old_draw > 0 then
        cm:remove_effect_bundle(food_storage_bundle..tostring(old_draw), self.owning_faction)
    end
    if draw > 0 then
        cm:apply_effect_bundle(food_storage_bundle..tostring(draw), self.owning_faction, 0)
    end
    cm:set_saved_value(self.save_name.."_current_draw", draw)
end

--v function(self: FOOD_MANAGER, stores: number)
function food_manager.set_food_in_storage(self, stores)
    local stores = dev.clamp(stores, 0, self:food_store_cap())
    cm:set_saved_value(self.save_name.."_current_stores", stores)
end

--v function(self: FOOD_MANAGER, storage_cap: number)
function food_manager.set_storage_cap(self, storage_cap)
    local storage_cap = dev.mround(dev.clamp(storage_cap, 0, food_storage_cap_absolute), 1)
    cm:set_saved_value(self.save_name.."_storage_cap", storage_cap)
end

--v function(self: FOOD_MANAGER, old_stores: number, cap: number, quantity: number) --> number
function food_manager.calculate_potential_food_change(self, old_stores, cap, quantity)
    local old_val = old_stores
    local new_val = old_val + quantity
    --clamp the value to the current cap
    new_val = dev.clamp(new_val)
    return (new_val - old_val)
end

--v function(self: FOOD_MANAGER, region: CA_REGION) --> number
function food_manager.food_storage_from_region(self, region)
    local region_cap = 0 --:number
    for building, quantity in pairs(building_food_storage) do
        if region:building_exists(building) then
            region_cap = region_cap + quantity
        end
    end
    return region_cap
end


--v function(self: FOOD_MANAGER)
function food_manager.update_food_storage(self)
    local faction = dev.get_faction(self.owning_faction)
    self:log("Updating food storage for ["..self.owning_faction.."] ")
    --first update our cap
    local cap = food_storage_cap_base --:number
    for i = 0, faction:region_list():num_items() - 1 do
        cap = cap + self:food_storage_from_region(faction:region_list():item_at(i))
    end
    --now calculate our change
    local drawn = self:food_being_drawn()
    local stored = self:food_in_storage()
    local total_food = faction:total_food()
    if not is_number(total_food) then
        dev.log("WARNING: total food returned a non-number type! This usually ends badly", "ERR")
        return
    end
    local food_actual = total_food - drawn -- drawn is 0 when nothing is drawn
    local new_stored = stored - drawn
    if food_actual > 0 then
        new_stored = new_stored + dev.mround((food_actual*food_storage_percentage), 1) --only factor this if its positive.
    end
    local new_stored = dev.clamp(new_stored, 0, cap)
    local new_draw =  -1*food_actual
    self:set_storage_cap(cap)
    self:set_food_in_storage(new_stored)
    self:set_food_draw(new_draw)
end

--v function(self: FOOD_MANAGER, quantity: number)
function food_manager.mod_food_storage(self, quantity)
    local drawn = self:food_being_drawn()
    local stored = self:food_in_storage()
    local cap = self:food_store_cap()
    local new_stored = dev.clamp((stored+quantity), 0, cap)
    self:set_food_in_storage(new_stored)
    if drawn > new_stored then
        self:set_food_draw(drawn) --will autoclamp down to a value within range
    end
end

--v function(self: FOOD_MANAGER, region: CA_REGION)
function food_manager.lose_food_from_region(self, region)
    local cap_from_region = self:food_storage_from_region(region)
    if cap_from_region == 0 then
        return
    end
    local food_in_storage = self:food_in_storage()
    local food_store_cap = self:food_store_cap()
    local prop = cap_from_region/(food_store_cap - food_storage_cap_base) 
    local loss = dev.mround(food_in_storage*prop, 1)
    self:mod_food_storage(-1*loss)
end


local instances = {} --:map<string, FOOD_MANAGER>

dev.pre_first_tick(function(context)
    local humans = cm:get_human_factions()
    for i = 1, #humans do
        local current_faction = humans[i]
        instances[current_faction] = food_manager.new(current_faction)
        dev.eh:add_listener(
            "FoodStorageFactionTurnStart",
            "FactionTurnStart",
            function(context)
                return context:faction():has_home_region() and not not instances[context:faction():name()] 
            end,
            function(context)
                instances[context:faction():name()]:update_food_storage()
            end,
            true)
        dev.eh:add_listener(
            "FoodStorageRegionChangesOwnership",
            "RegionChangesOwnership",
            function(context)
                return not not instances[context:prev_faction():name()]
            end,
            function(context)
                local instance = instances[context:prev_faction():name()]
                local region = context:region()
                instance:lose_food_from_region(region)
            end,
            true)
        dev.eh:add_listener(
            "FoodStorageDisplay",
            "ComponentMouseOn",
            function(context)
                local HoverComponent = UIComponent(context.component)
                return uicomponent_descended_from(HoverComponent, "food") or context.string == "food"
            end,
            function(context)            
                dev.callback(function()
                    local TooltipComponent = dev.get_uic(cm:ui_root(), "FoodBreakdownTooltip")
                    if not not TooltipComponent then
                        local DescriptionWindow = dev.get_uic(TooltipComponent, "description_window")
                        local BuildingTitle = dev.get_uic(TooltipComponent, "title_frame", "dy_building_title")
                        if BuildingTitle and DescriptionWindow then
                            local faction = dev.get_faction(cm:get_local_faction(true))
                            local fm = instances[faction:name()]
                            local stores = fm:food_in_storage()
                            local stores_drawn = fm:food_being_drawn()
                            local before_stores = faction:total_food() - stores_drawn
                            --storesDetail = "Your stores will increase by "..tostring(food_storage_percentage*100).." percent of your surplus food each turn"
                            local col = "green"
                            if before_stores < 0 then
                                col = "red"
                            end
                        
                            BuildingTitle:SetStateText("[[col:"..col.."]]"..before_stores.."[[/col]] Net Food This Turn")
                            --oldText = DescriptionWindow:GetStateText()
            
                            if before_stores >= stores_drawn then
                                local raw_change = (before_stores*food_storage_percentage)
                                local cap = fm:food_store_cap()
                                local increase_val = fm:calculate_potential_food_change(stores, cap, raw_change)
                                DescriptionWindow:SetStateText("You have "..stores.."/"..cap.." Food Stores. Your stores will increase by [[col:green]]"..increase_val.."[[/col]] next turn.")
                            else
                                local cap = fm:food_store_cap()
                                local decrease_val = stores_drawn
                                DescriptionWindow:SetStateText("You have "..stores.."/"..cap.." Food Stores. Your Stores will decrease by [[col:red]]"..decrease_val.."[[/col]] next turn.")
                            end
                        end
                    end
                end, 0.1)
            end,
            true)
    end
end)


--v function(faction_key: string) --> FOOD_MANAGER
local function get_instance(faction_key)
    return instances[faction_key]
end


return {
    get = get_instance,
    --content API
    add_food_storage_effect_to_building =  add_food_storage_effect_to_building
}