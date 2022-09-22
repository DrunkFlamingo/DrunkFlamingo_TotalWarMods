---@class EOM_DATA_REGION_SET
local default_entry = {
    --- what region is the capital of this region set?
    capital = "", ---@type string
    --- what ministerial position is related to this elector seat?
    ministerial_position = "", ---@type string
    --- what ROR is made available by controlling this elector seat?
    reward_unit = "", ---@type string
    --- what runefang is made available by controlling this elector seat?
    reward_ancillary = "", ---@type string
    --- what faction can this region set be returned to? (Returns only occur if a faction is part of the empire and in the 'normal' state')
    return_faction = "", ---@type string
    --- what regions compose this set?
    regions = {}, ---@type string[]
}

local region_data = {

} ---@type table<string, EOM_DATA_REGION_SET>