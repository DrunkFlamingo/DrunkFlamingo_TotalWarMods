local num_items_by_rank = {
    [0] = 0,
    [1] = 0,
    [2] = 1,
    [3] = 1,
    [4] = 2,
    [5] = 2,
    [6] = 3,
    [7] = 3,
    [8] = 4,
    [9] = 4,
    [10] = 5
}--:map<int, int>

--v function(t: string)
local function log(t)
    dev.log(t, "ITEM")
end

local swords = {
    "vik_item_ingelrd_sword",
    "vik_item_ulfberht_sword",
    "vik_item_garnet_hilt_sword"
}--:vector<string> 

--v function(char: CA_CHAR) --> boolean
local function already_has_sword(char)
    for i = 1, #swords do
        if char:has_trait(swords[i]) then
            return true
        end
    end
    return false
end

local smith_items = {
    ["vik_item_drinking_horn"] = function(char) --:CA_CHAR
        return true
    end,
    ["vik_item_elaborate_brooch"] = function(char) --:CA_CHAR
        return true
    end,
    ["vik_item_garnet_hilt_sword"] = function(char) --:CA_CHAR
        return not already_has_sword(char)
    end,
    ["vik_item_gilt_hemlet"] = function(char) --:CA_CHAR
        return true
    end,
    ["vik_item_gold_jewellry"] = function(char) --:CA_CHAR
        return true
    end,
    ["vik_item_gold_ring"] = function(char) --:CA_CHAR
        return true
    end,
    ["vik_item_ingelrd_sword"] = function(char) --:CA_CHAR
        return not already_has_sword(char)
    end,
    ["vik_item_inscribed_knife"] = function(char) --:CA_CHAR
        return true
    end,
    ["vik_item_jewelled_chalice"] = function(char) --:CA_CHAR
        return true
    end,
    ["vik_item_scales_weights"] = function(char) --:CA_CHAR
        return true
    end,
    ["vik_item_ulfberht_sword"] = function(char) --:CA_CHAR
        return (not already_has_sword(char)) and (not char:region():is_null_interface()) and char:region():building_superchain_exists("vik_master_forge")
    end
} --:map<string, function(char: CA_CHAR) --> boolean>

local scribe_items = {
    ["vik_item_decorated_bible"] = function(char) --:CA_CHAR
        return not char:has_trait("shield_heathen_pagan")
    end,
    ["vik_item_genealogies"] = function(char) --:CA_CHAR
        return true
    end,
    ["vik_item_prayer_book"] = function(char) --:CA_CHAR
        return not char:has_trait("shield_heathen_pagan")
    end,
    ["vik_item_tapestry"] = function(char) --:CA_CHAR
        return true
    end
}--:map<string, function(char: CA_CHAR) --> boolean>


local item_additional_callbacks = {
    ["vik_item_geneologies"] = function(char) --:CA_CHAR
        if not char:has_trait("shield_noble_high_born") then
            dev.add_trait(char, "shield_noble_high_born", true)
        end
    end
}--:map<string, function(char: CA_CHAR)>

--v function(char: CA_CHAR) --> boolean
local function char_has_room_for_item(char)
    local pol_char = PettyKingdoms.CharacterPolitics.get(char)
    if pol_char then
        local num_items = pol_char.num_items
        local rank = char:rank()
        local num_items_allowed = num_items_by_rank[rank]
        log("Char with cqi "..tostring(char:command_queue_index()) .." is allowed "..num_items_allowed.." and has "..num_items)
        return num_items_allowed > num_items
    end
    log("Couldn't get a pol char to test for items on cqi "..tostring(char:command_queue_index()))
    return false
end


--v function(char: CA_CHAR, has_scribe: bool, has_smith: bool, is_gov: bool)
local function grant_char_random_item(char, has_scribe, has_smith, is_gov)
    local items_to_award = {} --:vector<string>
    if has_scribe then
        for item_key, check_function in pairs(scribe_items) do
            if not char:has_trait(item_key) and check_function(char) then
                table.insert(items_to_award, item_key)
            end
        end
    end
    if has_smith then
        for item_key, check_function in pairs(smith_items) do
            if not char:has_trait(item_key) and check_function(char) then
                table.insert(items_to_award, item_key)
            end
        end
    end
    local item = items_to_award[cm:random_number(#items_to_award)]
    log("Awarding "..item.." to character")
    dev.add_trait(char, item, true)
    if item_additional_callbacks[item] then
        item_additional_callbacks[item](char) 
    end
end



dev.first_tick(function(context)
    dev.eh:add_listener(
        "CharacterTurnStartItems",
        "CharacterTurnStart",
        function(context)
            return context:character():faction():is_human() and char_has_room_for_item(context:character())
        end,
        function(context)
            local char = context:character() --:CA_CHAR
            log("Human character "..tostring(char:command_queue_index()).."is eligible to recieve an item")
            local has_scribe = false --:boolean
            local has_smith = false --:boolean
            local is_governor = ((not char:region():is_null_interface()) 
            and char:region():has_governor() 
            and char:region():governor():command_queue_index() == char:command_queue_index()) 
            if dev.Check.does_char_have_scribe(char) then
                log("Character has a scribe skill")
                has_scribe = true
            elseif is_governor then
                if char:region():building_superchain_exists("vik_scribes") then
                    log("Character governs a scribe building")
                    has_scribe = true
                end
            end
            if dev.Check.does_char_have_smith(char) then
                log("Character has a smith skill")
                has_smith = true
            elseif is_governor then
                if char:region():building_superchain_exists("vik_forge")
                or char:region():building_superchain_exists("vik_master_forge") then
                    log("Character governs a smith building")
                    has_smith = true
                end
            end
            if has_smith or has_scribe then
                log("The character has either a scribe or a smith, Awarding a random item to the character")
                grant_char_random_item(char, has_scribe, has_smith, is_governor)
            end
        end,
        true)
        log("Added listeners")
end)