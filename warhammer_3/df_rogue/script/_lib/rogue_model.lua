---@class ROGUE_GAME
local mod = {}

mod.state_enum = {
    "select_quest",
    "post_battle_rewards",
    "encounter",
    "default"
}


---comment
---@return unknown
mod.init = function (player_faction_interface)
    local self = {} ---@class ROGUE_GAME
    setmetatable(self,{
        __index = mod
    })

    self.state = "default"
    self.player_faction = player_faction_interface
    self.rogue_player = {}



    return self
end