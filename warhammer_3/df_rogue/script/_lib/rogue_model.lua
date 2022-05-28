---@class ROGUE_GAME
local mod = {}

mod.state_enum = {
    "select_quest",
    "post_battle_rewards",
    "encounter_preview",
    "battle_startup",
    "default"
}---@type string[]


---comment
---@param player_faction_interface FACTION_SCRIPT_INTERFACE
---@return ROGUE_GAME
mod.init = function (player_faction_interface)
    local self = {} ---@class ROGUE_GAME
    setmetatable(self,{
        __index = mod
    })

    self.state = "default"
    self.player_faction = player_faction_interface
    self.rogue_player = {}

    self.quests = {}

    self.state_entry_callbacks = {}
    self.state_exit_callacks = {}

    return self
end

---comment
---@param self ROGUE_GAME
---@param new_state string
mod.enter_state = function(self, new_state)
    if self.state_exit_callacks[self.state] then
        for i = 1, #self.state_exit_callacks[self.state] do
            self.state_exit_callacks[self.state](self)
        end
    end
    self.state = new_state
    if self.state_entry_callbacks[new_state] then
        for i = 1, #self.state_entry_callbacks[new_state] do
            self.state_entry_callbacks[self.state](self)
        end
    end
end

---comment
---@param self ROGUE_GAME
---@param state string
---@param callback function
mod.add_state_entry_callback = function (self, state, callback)
    self.state_entry_callbacks[state][#self.state_entry_callbacks[state]+1] = callback
end

---comment
---@param self ROGUE_GAME
---@param state string
---@param callback function
mod.add_state_exit_callback = function (self, state, callback)
    self.state_exit_callacks[state][#self.state_exit_callacks[state]+1] = callback
end

core:add_static_object("rogue", mod.init)