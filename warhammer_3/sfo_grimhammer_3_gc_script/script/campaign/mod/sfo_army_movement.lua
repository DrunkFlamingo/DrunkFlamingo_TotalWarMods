---@param t string
local out = function(t)
    ModLog("SFO: "..tostring(t).." (sfo_army_movement)")
end


--Movement speed bonus reduced per unit in the army

local movement_bonus_bundle = "wh_army_movement_per_unit"
local movement_bonus_effect =  "wh_main_effect_force_campaign_movement_range"
local movement_bonus_scope = "force_to_force_own_owned_territory"
local movement_bonus_base_value = 42
local movement_bonus_per_unit_modifier = -2
local movement_min_bonus_to_apply = 2 --won't apply an effect lower than this.

local function refresh_movement_bonus_from_unit_count(character)
    local unit_list = character:military_force():unit_list() ---@type any
    local value = math.floor(movement_bonus_base_value + (unit_list:num_items()*movement_bonus_per_unit_modifier))
    out("Character "..tostring(character:command_queue_index()).." is being given the dynamic movement range bonus "..tostring(value))
    if value >= movement_min_bonus_to_apply then
        ---@diagnostic disable: undefined-field
        local custom_bundle = cm:create_new_custom_effect_bundle(movement_bonus_bundle)   
        custom_bundle:set_duration(0)
        custom_bundle:add_effect(movement_bonus_effect, movement_bonus_scope, value)
        cm:apply_custom_effect_bundle_to_characters_force(custom_bundle, character)
    else
        out("Bonus is too low to apply")
        cm:remove_effect_bundle_from_characters_force(movement_bonus_bundle, character:command_queue_index())
    end
end

local function setup_movement_bonus_from_unit_count()
    local humans = cm:get_human_factions()
    for i = 1, #humans do
        local faction = cm:get_faction(humans[i])
        local character_list = faction:character_list()
        for j = 0, character_list:num_items()-1 do
            local character = character_list:item_at(j)
            if character:has_military_force() then
                local force = character:military_force()  
                if (not force:is_armed_citizenry()) and (not force:is_set_piece_battle_army()) then
                    local force_type = force:force_type():key()
                    if not character:character_subtype("wh2_main_def_black_ark") and force_type ~= "DISCIPLE_ARMY" and force_type ~= "OGRE_CAMP" and force_type ~= "CARAVAN" then
                        refresh_movement_bonus_from_unit_count(character)
                    end
                end
            end
        end
    end
    core:add_listener("DynamicBonusesSFO", "CharacterTurnStart", function(context) return --[[context:character():faction():is_human() and--]]  context:character():has_military_force() end,
     function(context)
        local character = context:character()
        local force = character:military_force()  
        if (not force:is_armed_citizenry()) and (not force:is_set_piece_battle_army()) then
            local force_type = force:force_type():key()
            if not character:character_subtype("wh2_main_def_black_ark") and force_type ~= "DISCIPLE_ARMY" and force_type ~= "OGRE_CAMP" and force_type ~= "CARAVAN" then
                refresh_movement_bonus_from_unit_count(character)
            end
        end
     end, true)
     core:add_listener("DynamicBonusesSFO", "MilitaryForceCreated", function(context) return --[[context:military_force_created():faction():is_human() and--]] true end,
     function(context)
        local force = context:military_force_created()  
        if (not force:is_armed_citizenry()) and (not force:is_set_piece_battle_army()) and force:has_general() then
            local character = force:general_character()
            local force_type = force:force_type():key()
            if not character:character_subtype("wh2_main_def_black_ark") and force_type ~= "DISCIPLE_ARMY" and force_type ~= "OGRE_CAMP" and force_type ~= "CARAVAN" then
                refresh_movement_bonus_from_unit_count(character)
            end
        end
     end, true)
end


cm:add_first_tick_callback(function(context)
    setup_movement_bonus_from_unit_count()
end)