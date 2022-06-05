---@alias encounter_kind "FIELD_BATTLE"|"SIEGE_BATTLE"|"DILEMMA_EVENT"|"DUNGEON_ENTRANCE"|"NO_GEN"

---@class ROGUE_ENCOUNTER_DATA
local template_encounter = 
{  
    
    id = "template_encounter",
    encounter_kind = "NO_GEN", ---@type encounter_kind
    encounter_settlement_location = "", --the settlement where the encounter worldspace icon will be placed
    is_unknown_encounter = true, --should the player have forewarning of what will happen in this encounter?
    force_keys = {}, ---@string[] ---randomized between these keys
    offensive_battle = false, --should the player attack the enemy? or vice versa?
    ambush_battle = false, --should the attacker get an ambush?
    dilemma_keys = {},---@string[] --randomized between these keys
    reward_set_keys = {}, ---@string[] --randomized between these keys,
    requires_completed_encounters = {
        ["preceeding_encounter_key"] = true
    }, --encounters that must be completed before this encounter can be generated
    requires_not_completed_encounters = {
        ["mutually_exclusive_encounter_key"] = true
    } --encounters that must not be completed for this encounter to be generated
} 

return {
    {
        id = "start_encounter_1",
        encounter_kind = "FIELD_BATTLE", --no gen is ignored, used for this template
        encounter_settlement_location = "wh3_main_chaos_region_doomkeep", --the settlement where the encounter worldspace icon will be placed
        is_unknown_encounter = false, --should the player have no forewarning of what will happen in this encounter?
        force_keys = {"sla_marauder_cult_easy"}, --randomized between these keys
        offensive_battle = false, --should the player attack the enemy? or vice versa?
        ambush_battle = false, --should the attacker get an ambush?
        dilemma_keys = {}, --randomized between these keys
        reward_set_keys = {}, --randomized between these keys,
        requires_completed_encounters = {
            ["preceeding_encounter_key"] = true
        }, --encounters that must be completed before this encounter can be generated
        requires_not_completed_encounters = {
            ["mutually_exclusive_encounter_key"] = true
        } --encounters that must not be completed for this encounter to be generated
    }  
} ---@type ROGUE_ENCOUNTER_DATA[]