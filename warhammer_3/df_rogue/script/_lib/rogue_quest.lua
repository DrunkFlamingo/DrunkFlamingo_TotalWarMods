local quest = {}---@class ROGUE_QUEST


---comment
---@param quest_key string
---@param location_settlement_interface SETTLEMENT_SCRIPT_INTERFACE
---@return ROGUE_QUEST
quest.new = function(quest_key, location_settlement_interface)
    local self = {} ---@class ROGUE_QUEST
    setmetatable(self, {__index = quest})

    self.key = quest_key

    self.enemy = {}
    self.reward = {}
    
    self.settlement_location = location_settlement_interface

    return self
end