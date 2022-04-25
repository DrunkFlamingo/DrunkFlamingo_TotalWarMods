---@class ROGUE_REWARD
local reward = {}


---Section: Settings---

reward.reward_pool_key_enum = {
    "daniel_dae",
    "daniel_sla",
    "daniel_kho",
    "daniel_nur",
    "daniel_tzn"
}

reward.armory_item_data = {
    ["armory_item_tables_key"] = {}
}

reward.reward_pool_to_armory_item_junctions = {
    ["reward_pool_key"] = {"anc_key_a", "anc_key_b"}
}---@type table<string, string[]>

reward.main_unit_data = {
    ["main_units_keys"] = {}
}

reward.reward_pool_to_main_unit_junctions = {
    ["reward_pool_key"] = {"main_units_key_a", "main_units_key_b"}
}