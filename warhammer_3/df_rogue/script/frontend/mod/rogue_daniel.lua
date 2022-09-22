---@diagnostic disable-next-line
--frontend.start_campaign("wh3_main_chaos","wh3_main_dae_daemon_prince", "wh3_main_political_party_dae_daemon_prince")

--the above doesn't seem to work anymore

--TODO start the correct campaign via CCO.

---@alias rogue_modes "roguelike"|"roguelite"|"freeplay"

local has_valid_continue = core:svr_load_registry_bool("rogue_can_continue") or 0
common.set_context_value("rogue_can_continue", has_valid_continue)
local mode = core:svr_load_registry_string("rogue_mode") or "roguelike"
common.set_context_value("rogue_mode", mode)

local rogue_campaigns_playable = {
    ["856762626"] = true
}
common.set_context_value("rogue_campaigns_playable", rogue_campaigns_playable)


local rogue_cultures_playable = {
    ["wh3_main_dae_daemons"] = true
}
common.set_context_value("rogue_cultures_playable", rogue_cultures_playable)

local rogue_factions_playable = {
    ["wh3_main_dae_daemon_prince"] = true
}
common.set_context_value("rogue_factions_playable", rogue_factions_playable)



