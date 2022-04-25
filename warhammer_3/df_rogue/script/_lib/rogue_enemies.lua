---generates enemy armies from data

---@class ROGUE_ENEMY
local enemy = {} 

---enumerates keys to refer to a specific enemy army that can be generated
enemy.enemy_key_enum = {

}---@type string[]

---enumerates keys that refer to fragments of forces, which compose enemy armies.
enemy.force_fragment_key_enum = {

}---@type string[]


enemy.force_fragment_options = {
    ["fragment_key"] = {size = 4}
}

enemy.force_fragment_mandatory_units = {
    ["fragment_key"] = {
        "unit_key",
        "unit_b_key"
    }
} ---@type table<string, string[]>

