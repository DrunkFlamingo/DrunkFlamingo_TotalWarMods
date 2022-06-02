---@alias encounter_kind "FIELD_BATTLE"|"SIEGE_BATTLE"|"DILEMMA_EVENT"|"DUNGEON_ENTRANCE"|"NO_GEN"

return {
    {
        encounter_kind = "NO_GEN", --no gen is ignored, used for this template
        is_unknown_encounter = true, --should the player have forewarning of what will happen in this encounter?
        force_keys = {}, --randomized between these keys
        dilemma_keys = {}, --randomized between these keys
        reward_set_keys = {}, --randomized between these keys,
        requires_completed_encounters = {
            ["preceeding_encounter_key"] = true
        }, --encounters that must be completed before this encounter can be generated
        requires_not_completed_encounters = {
            ["mutually_exclusive_encounter_key"] = true
        } --encounters that must not be completed for this encounter to be generated
    }
}