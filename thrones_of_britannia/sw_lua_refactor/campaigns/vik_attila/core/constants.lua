return {
    __script_version = 1, --used to help maintain save compatibility when I have to make changes to saved tables.
    __write_output_to_logfile = true, -- write log files
    __should_output_ui = false, --outputs UI object details on click. Spams the log a bit so leave it off when not doing UI work.
    __log_game_objects = false, --Logs all game object types to a series of files. For use once per patch.
    __should_output_save_load = false, --Outputs the internals of the functions which save and load objects. Only necessary for debugging.
    __do_not_save_or_load = false, --turns off saving and loading lua values completely.
    __no_fog = false, --turn off fog of war.
    __always_succeed_chance_checks = false, -- makes dev.chance always return true, causing all chance checks to be allowed.
    __log_settlements = true, -- log information about settlements when they are selected
    __log_characters = true, -- log information about characters when they are selected
    __unit_size_scalar = 0.5, --0.5 is shieldwalls default. Controls unit sizes for population counts.
    __testcases = { --coded routes to test functionality of gameplay systems.
        __test_riots = false, 
        __test_foreigner_events = false, 
        __test_endgame_invasions = false,
        __test_skill_events = false,
        __test_decree_payloads = false,
        __test_tribute_events = false,
    },
    __utilities = { --coded cheats or data creation scripts.
        __create_land_spawns = false,
        __human_autowins_every_battle = false -- will hard ctd in MP
    }
}