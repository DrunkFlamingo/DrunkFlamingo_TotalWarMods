local region_sets = {
    ["MAJOR_SETTLEMENTS"] = "",
    ["MINOR_SETTLEMENTS"] = "",
    ["ALL_SETTLEMENTS"] = "",
    ["FOREIGNERS"] = "",
    ["BOROUGHS"] = "",
    ["LONGPHORTS"] = "",
    ["MARKETS"] = "",
    ["MONASTERIES"] = ""
}

local faction_sets = {
    ["ANY_FACTION"] = "",
    ["ENG_FACTIONS"] = "",
    ["DAN_FACTIONS"] = "",
    ["VSK_FACTIONS"] = "",
    ["IRI_FACTIONS"] = "",
    ["SCO_FACTIONS"] = "",
    ["WEL_FACTIONS"] = "",
    ["VIK_FACTIONS"] = "",
}

local localisation_keys = { 
    ["title"] = {"dilemmas_localised_title_", "incidents_localised_title_"},
    ["desc"] = {"dilemmas_localised_description_", "incidents_localised_description_"},
    ["choices"] = {"cdir_events_dilemma_choice_details_localised_choice_label_"}
  }
  --TODO redo this 

---@class payload_detail
local payload_detail = {}

---comment
---@param name string
---@param localised_choice_label string
---@return payload_detail
function payload_detail.new(key, localised_choice_label)
    local self = {} ---@class payload_detail
    setmetatable(self, {
        __index = payload_detail
    }) 

    self.key = key
    self.localised_choice_label = ""
    self.payloads = {}

    return self
end

function payload_detail.add_payload(payload_key, value)
    self.payloads[payload_key] = value
end

function payload_detail.add_localised_choice_label(localised_choice_label)
    self.localised_choice_label = localised_choice_label
end

---@class game_event
local game_event = {}

function game_event.new()
    local self = {} ---@class game_event
    setmetatable(self, {
        __index = game_event
    }) 

    self.payload_details = {}
    self.localised_name = ""
    self.localised_description = ""

    return self
end

function game_event.add_localised_name(localised_name)
    self.localised_name = localised_name
end

function game_event.add_localised_description(localised_description)
    self.localised_description = localised_description
end

function game_event.add_choice(choice_key)
    self.payload_details[choice_key] = self.payload_details[choice_key] or payload_detail.new(choice_key)
end


--fill out the structure using the data from the files


local function handle_loc_tsv(lines)

end


local function handle_payload_tsv(lines)
    
end

function handle_data_tsv(lines)
    for i = 3, #lines do
        local this_row = lines[i]
        local columns = split_string(this_row, "\t")
        log("Row "..tostring(i).." has "..tostring(#columns).." last row "..columns[#columns])
    end
end

local file_types = {
    ["#Loc PackedFile"] = handle_loc_tsv,
    ["#dilemmas_tables"] = handle_data_tsv,
    ["#missions_tables"] = handle_data_tsv,
    ["#incidents_tables"] = handle_data_tsv
}

--get the list of items to generate the event for - a list of factions or regions

local function get_concatenation_set_for_event()

    return 
end

---print the newly created events

local function output_events()

end

local function generate_events_from_files(...)
    for i = 1, #arg do
        local lines = lines_from("lua/input/shieldwall_event_input/"..arg[i]..".tsv", "r+")
        if not lines or #lines < 3 then
            log("WARN: file ".. tostring(arg[i]).." is either missing or empty")
        end
        local success
        for match_string, func in pairs(file_types) do
            if string.find(lines[2], match_string) then
                success = true
                func(lines)
            end
        end
        if not success then
            log("WARN: did not recognize "..tostring(lines[2]))
        end
    end
end

return {
    generate_events_from_files = generate_events_from_files
}