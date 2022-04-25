---@class ROGUE_PLAYER
---An object which holds the current state of the player within the game progression.
local player = {}


---Section: Settings---

player.campaign_difficulty_to_rogue_difficulty_modifier = {
    [1] = 0.7,
    [2] = 1,
    [3] = 1.1,
    [4] = 1.3,
    [5] = 1.5
}---@type table<integer, number>

---0 is used as a default entry
---Each entry in this list specifies the target army size, special, and rare points to allow in the player's army at a given level
---  
player.rogue_difficulty_values = {
    [0] = {target_num_units = 10, target_rare_points = 5, target_special_points = 10},
    [1]= {target_num_units = 5, target_rare_points = 0, target_special_points = 0},
    [2]= {target_num_units = 6, target_rare_points = 0, target_special_points = 0},
    [3]= {target_num_units = 6, target_rare_points = 0, target_special_points = 0},
    [4]= {target_num_units = 6, target_rare_points = 0, target_special_points = 2},
    [5]= {target_num_units = 7, target_rare_points = 0, target_special_points = 2},
    [6]= {target_num_units = 7, target_rare_points = 0, target_special_points = 2},
    [7]= {target_num_units = 7, target_rare_points = 1, target_special_points = 2},
    [8]= {target_num_units = 7, target_rare_points = 1, target_special_points = 2},
    [9]= {target_num_units = 8, target_rare_points = 1, target_special_points = 2},
    [10]= {target_num_units = 8, target_rare_points = 1, target_special_points = 2},
    [11]= {target_num_units = 8, target_rare_points = 1, target_special_points = 2},
}



---Section: Code---
-------------------

---Creates a new player progression entry.
---@param player_faction_interface FACTION_SCRIPT_INTERFACE
---@return ROGUE_PLAYER
player.new = function (player_faction_interface)
    
    local self = {} ---@class ROGUE_PLAYER
    
    setmetatable(self, {
        __index = player
    })

    self.faction = player_faction_interface
    self.character = player_faction_interface:faction_leader()

    self.quests_completed = {}


    return self
end

---we use the level as a proxy for difficulty because it naturally goes up as you complete missions.
---this gets altered by the difficulty level selected.
player.get_difficulty_level = function(self, ignore_difficulty_modifier)
    local rogue_difficulty_level = self.character:rank()
    if not ignore_difficulty_modifier then
        local campaign_difficulty_level = cm:get_difficulty()
        rogue_difficulty_level = rogue_difficulty_level * (player.campaign_difficulty_to_rogue_difficulty_modifier[campaign_difficulty_level] or 1)
    end
    return rogue_difficulty_level
end