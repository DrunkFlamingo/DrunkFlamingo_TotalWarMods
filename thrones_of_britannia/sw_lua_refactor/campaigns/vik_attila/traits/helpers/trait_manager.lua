--this object helps handle the implementation of a given trait.

local TM_TRIGGERED_DILEMMA = {} --:map<string, map<string, boolean>>


local event_manager = dev.GameEvents

--# assume global class TRAIT_MANAGER
local trait_manager = {} --# assume trait_manager: TRAIT_MANAGER

--v function(self: TRAIT_MANAGER, text: any)
function trait_manager.log(self, text)
    dev.log(tostring(text), "TRAITS")
end

--v function(trait_key: string) --> TRAIT_MANAGER
function trait_manager.new(trait_key)
    local self = {}
    setmetatable(self, {
        __index = trait_manager
    }) --# assume self: TRAIT_MANAGER

    self.key = trait_key
    self.start_traits_applied = false --:boolean
    self.chance_modifiers = {} --:vector<(function(character: CA_CHAR)--> int)>
    self.prohibiters = {} --:vector<(function(character:CA_CHAR) --> boolean)>
    self.anti_traits = {} --:map<string, boolean>
    self.base_chance = 100

    self.already_triggered_choices = {} --:map<string, map<string, boolean>>
    self.condition_group = dev.GameEvents:create_new_condition_group(trait_key)
    self.condition_group:set_number_allowed_in_queue(1)
    self.condition_group:set_cooldown(2)
    self.condition_group:add_queue_time_condition(function(context)
        local char = context:character() --:CA_CHAR
        return char:character_type("general") and char:is_male() and char:family_member():come_of_age()
    end)
    dev.GameEvents:register_condition_group(self.condition_group, "CharacterTurnStart")
    self.governor_condition_group = dev.GameEvents:create_new_condition_group(trait_key.."_governor")
    self.governor_condition_group:set_number_allowed_in_queue(1)
    self.governor_condition_group:set_cooldown(2)
    self.governor_condition_group:add_queue_time_condition(function(context)
        return context:region():has_governor()
    end)
    dev.GameEvents:register_condition_group(self.governor_condition_group, "RegionTurnStart")

    self.trait_effects_out = {} --:map<CA_CQI, map<string, int>>
    dev.first_tick(function(context)
        dev.eh:add_listener(self.key, "CharacterTurnStart", 
        function(context) 
            return context:character():faction():is_human() and not not self.trait_effects_out[context:character():command_queue_index()]
        end,
        function(context)
            local character = context:character() --:CA_CHAR
            local turn = dev.turn()
            self:log("Character with CQI "..tostring(character:command_queue_index()).." has active trait effects, checking them")
            local effects = self.trait_effects_out[context:character():command_queue_index()]
            local num_out = 0 --:int
            local num_removed = 0 --:int
            for suffix_key, turn_to_remove in pairs(effects) do
                num_out = num_out + 1
                local trait_key = self.key..suffix_key
                if turn >= turn_to_remove and character:has_trait(trait_key) then
                    self:log("Effect with key "..trait_key.." is scheduled to be removed")
                    dev.remove_trait(character, trait_key)
                    effects[suffix_key] = nil
                    num_removed = num_removed + 1
                end
            end
            if num_out == num_removed then
                self:log(num_out.." traits were removed, which is how many were out. No more effects remain, deleting character entry")
                self.trait_effects_out[character:command_queue_index()] = nil
            end
        end,
        true)
    end)

    self.save = {
        name = trait_key.."_manager", 
        for_save = {"start_traits_applied", "already_triggered_choices", "trait_effects_out"}
    }--:SAVE_SCHEMA
    dev.Save.attach_to_object(self)

    return self
end

--v function(self: TRAIT_MANAGER, char: CA_CHAR) --> int
function trait_manager.get_chance(self, char)
    local chance = self.base_chance 
    for i = 1, #self.chance_modifiers do
        chance = chance + self.chance_modifiers[i](char)  
    end
    return chance
end

--v function(self: TRAIT_MANAGER, character: CA_CHAR) --> boolean
function trait_manager.is_trait_valid_on_character(self, character)
    if character:faction():is_human() == false or character:character_type("general") == false or character:is_male() == false then
        return false
    end
    local pol_char = PettyKingdoms.CharacterPolitics.get(character)
    if not pol_char then
        return false
    end
    for i = 1, #pol_char.traits do
        if self.anti_traits[pol_char.traits[i]] then
            return false
        end
    end
    for i = 1, #self.prohibiters do
        if self.prohibiters[i](character) == false then
            return false
        end
    end
    return true
end

--v function(self: TRAIT_MANAGER, character: CA_CHAR, even_if_invalid: boolean?) --> boolean
function trait_manager.add_to_character(self, character, even_if_invalid)
    if even_if_invalid or self:is_trait_valid_on_character(character) then
        dev.add_trait(character, self.key, true)
        return true
    end
    return false
end

--v function(self: TRAIT_MANAGER, ...:string)
function trait_manager.set_anti_traits(self, ...)
    for i = 1, arg.n do
        self.anti_traits[arg[i]] = true
    end
end

--v function(self: TRAIT_MANAGER, chance: int)
function trait_manager.set_base_chance(self, chance)
    self.base_chance = chance
end

--v function(self: TRAIT_MANAGER, dilemma_key: string, additional_condition: function(character: CA_CHAR) --> boolean, should_use_chance: boolean, callback: (function(context: WHATEVER))?)
function trait_manager.add_trait_gained_dilemma(self, dilemma_key, additional_condition, should_use_chance, callback)
    self.already_triggered_choices[dilemma_key] = self.already_triggered_choices[dilemma_key] or {}
    local event = dev.GameEvents:create_event(dilemma_key, "dilemma", "trait_flag")
    event:add_queue_time_condition(function(context)
        local character = context:character() --:CA_CHAR
        if character:has_trait(self.key) then
            return false
        end
        return (not self.already_triggered_choices[dilemma_key][tostring(character:command_queue_index())])
        and (not character:is_faction_leader())
        and (not should_use_chance or dev.chance(self:get_chance(character))) 
        and (self:is_trait_valid_on_character(character) and additional_condition(character))
    end)
    event:join_groups(self.condition_group.name)
    event:add_callback(function(context)
        local character = context:character() --:CA_CHAR
        self.already_triggered_choices[dilemma_key][tostring(character:command_queue_index())] = true
        if callback then
            --# assume callback: function(context: WHATEVER)
            callback(context)
        end
    end)
end

--v function(self: TRAIT_MANAGER, condition: function(character: CA_CHAR) --> boolean, should_use_chance: boolean, event_key: string?, character_from_context: (function(context: WHATEVER) --> CA_CHAR)?)
function trait_manager.add_trait_gain_condition_without_event(self, condition, should_use_chance, event_key, character_from_context)
    dev.eh:add_listener(
        self.key,
        event_key or "CharacterTurnStart",
        function(context)
            local character --:CA_CHAR
            if character_from_context then
                --# assume character_from_context: function(context: WHATEVER) --> CA_CHAR
                character = character_from_context(context)
            else
                character = context:character()
            end
            if character then
                if character:has_trait(self.key) then
                    return false
                end
                local chance_passed = (not should_use_chance) or dev.chance(self:get_chance(character))
                return chance_passed and self:is_trait_valid_on_character(character) and condition(character)
            else
                self:log("Trait condition without event failed to get a character!")
                return false
            end
        end,
        function(context)
            local character --:CA_CHAR
            if character_from_context then
                --# assume character_from_context: function(context: WHATEVER) --> CA_CHAR
                character = character_from_context(context)
            else
                character = context:character()
            end
            if character then
                dev.add_trait(character, self.key, true)
            end
        end,
        true)
end

--v function(self: TRAIT_MANAGER, effect_suffix: string, duration: int, condition: function(context: WHATEVER) --> (boolean, CA_FACTION), event_key: string, incident_key: string?)
function trait_manager.add_trait_effect_condition(self, effect_suffix, duration, condition, event_key, incident_key)
    local notification_event --:GAME_EVENT
    if incident_key then
        --# assume incident_key:string
        notification_event = event_manager:create_event(incident_key, "incident", "standard")
    end
    dev.eh:add_listener(
        self.key,
        event_key,
        true,
        function(context)
            local condition_result, faction_object = condition(context)
            if faction_object:is_human() then
                if condition_result then
                    self:log("Trait effect condition "..self.key..effect_suffix.." was met by "..faction_object:name())
                    local character_list = faction_object:character_list()
                    local turn = dev.turn()
                    local did_apply = false
                    for i = 0, character_list:num_items() - 1 do
                        local char = character_list:item_at(i)
                        if char:has_trait(self.key) and (not char:is_faction_leader()) then
                            self.trait_effects_out[char:command_queue_index()] = self.trait_effects_out[char:command_queue_index()] or {}
                            self.trait_effects_out[char:command_queue_index()][effect_suffix] = turn + duration
                            dev.add_trait(char, self.key..effect_suffix, false)
                            self:log("Applied trait effect to character "..tostring(char:command_queue_index()))
                            did_apply = true
                        end
                    end
                    if notification_event and did_apply then
                        local context = event_manager:build_context_for_event(notification_event, faction_object)
                        event_manager:force_check_and_trigger_event_immediately(notification_event, context)
                    end
                end
            end
        end,
        true)
end

--v function(self: TRAIT_MANAGER, trait: string, quantity: int)
function trait_manager.set_cross_loyalty(self, trait, quantity)
    PettyKingdoms.CharacterPolitics.add_trait_cross_loyalty_to_trait(self.key, trait, quantity)
end



--v function(self: TRAIT_MANAGER, modifier: (function(character: CA_CHAR) --> int))
function trait_manager.add_chance_modifier(self, modifier)
    table.insert(self.chance_modifiers, modifier)
end
--v function(self: TRAIT_MANAGER, prohibiter: (function(character: CA_CHAR) --> boolean))
function trait_manager.add_prohibiter(self, prohibiter)
    table.insert(self.prohibiters, prohibiter)
end

--v function(self: TRAIT_MANAGER, ...:string)
function trait_manager.set_start_pos_characters(self, ...)
    dev.new_game(function(context)
        for i = 1, arg.n do
            cm:force_add_trait(arg[i], self.key, false)
        end
        dev.eh:trigger_event("StartPosTraitAdded", self.key)
    end)
end


return {
    new = trait_manager.new
}