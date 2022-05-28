local out = function(t)
    ModLog("DRUNKFLAMINGO: "..tostring(t).." (rogue_start.lua)")
end

local rogue = core:get_static_object("rogue")





rogue_start = function ()
    --hide the normal total war UI

    --start the model
    local model = rogue(cm:get_local_faction()) ---@type ROGUE_GAME

    --State callbacks
    model:add_state_entry_callback("default", function(self)
        --log("default state entry")
        --figure out if we were in a battle
            --if we were, go to the post battle state.

        --otherwise, go to the select quest state.
    end)
    model:add_state_entry_callback("select_quest", function (self)
        --log("select_quest state entry")
        --create the quest list
            --create UI elements for each valid quest and populate
        --show the character/army management UI.
    end)
    model:add_state_entry_callback("encounter_preview", function(self)
        --log("encounter_preview state entry")
        --show the encounter preview UI using the information from the quest
        --hide other UI elements
    end)
    model:add_state_entry_callback("battle_startup", function (self)
        --log("battle_startup state entry")
        --build the battle using the forced_battles objects and set it off.
    end)
    model:add_state_entry_callback("post_battle_rewards", function(self)
        --log("post_battle_rewards state entry")
        --pick random rewards from the quest definition
        --show them to the player to pick.
    end)

    --for each quest
        --if is currently valid then
            --Create worldspace component and set location

    --on worldspace quest selection clicked.
end