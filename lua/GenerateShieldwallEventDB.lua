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

local iuid = 27272701
local function uid() 
    iuid = iuid +1 return tostring(iuid-1) 
end


---@class payload_detail
local payload_detail = {}

---comment
---@param event game_event
---@param choice_key string
---@return payload_detail
function payload_detail.new(event, choice_key)
    local self = {} ---@class payload_detail
    setmetatable(self, {
        __index = payload_detail
    }) 
    self.event = event
    self.choice_key = choice_key
    self.localised_choice_label = ""
    self.payloads = {} --- pairs of payload key to value
    log("Added "..choice_key.." to "..event.key)
    return self
end

function payload_detail.add_payload(self, payload_key, value)
    log("Added "..payload_key.." | "..value.." to "..self.choice_key.." on "..self.event.key)
    self.payloads[payload_key] = value
end

---@class game_event
local game_event = {}

---@type table<string, game_event>
local game_events = {} 

---comment
---@param key string
---@param type string
---@return game_event
function game_event.new(key, type)
    local self = {} ---@class game_event
    setmetatable(self, {
        __index = game_event
    }) 

    self.key = key
    self.EVENT_TYPE = type
    self.payload_details = {}
    self.localised_title = ""
    self.localised_description = ""
    self.event_category = ""
    self.ui_image = ""
    self.ui_icon = ""
    self.mission_type = ""
    game_events[key] = self
    log("created event: "..key.." as "..type)
    return self
end


function game_event.add_or_get_choice(self, choice_key)
    self.payload_details[choice_key] = self.payload_details[choice_key] or payload_detail.new(self, choice_key)
    return self.payload_details[choice_key]
end

local function get_or_create_game_event(key, param_key)
    return game_events[key] or game_event.new(key, param_key)
end


local event_table_fields = {
    key = true,
    ui_icon = true,
    ui_image = true,
    event_category = true,
    mission_type = true
}

local function get_schema_for_event_table(first_line)
    local schema = {}
    local columns = split_string(first_line, "\t")
    for i = 1, #columns do
        if event_table_fields[columns[i]] then
            schema[i] = columns[i]
        end
    end
    return schema
end

local payload_table_fields = {
    mission_key = "key",
    dilemma_key = "key",
    incident_key = "key",
    status_key = "choice_key",
    choice_key = "choice_key",
    payload_key = "payload_key",
    value = "payload_value"
}

local function get_schema_for_payload_table(first_line)
    local schema = {}
    local columns = split_string(first_line, "\t")
    for i = 1, #columns do
        if payload_table_fields[columns[i]] then
            schema[i] = payload_table_fields[columns[i]]
        end
    end
    return schema
end

local loc_keys = {
    missions_localised_title_ = "localised_title",
    dilemmas_localised_title_ = "localised_title",
    incidents_localised_title_ = "localised_title",
    dilemmas_localised_description_ = "localised_description",
    incidents_localised_description_ = "localised_description",
    missions_localised_description_ = "localised_description"
}

local choice_keys_for_loc = {"FIRST", "SECOND", "THIRD", "FOURTH"}


--fill out the structure using the data from the files


local function handle_loc_tsv(lines)
    log("Handling localization file "..lines[2])
    for j = 3, #lines do
        local this_row = lines[j]
        local columns = split_string(this_row, "\t")
        log("Row "..tostring(j).." has "..tostring(#columns))
        --column one contains a key which tells us what this is, column is always the localised text.
        if columns[1]:find("dilemma_choice_details") then
            local matched_choice_key
            for k = 1, #choice_keys_for_loc do
                 if columns[1]:find(choice_keys_for_loc[k]) then matched_choice_key = choice_keys_for_loc[k] end 
            end
            if not matched_choice_key then
                log("Couldn't match a choice key for "..columns[1])
            else
                local stripped_of_choice_key = columns[1]:gsub(matched_choice_key, "")
                local key = stripped_of_choice_key:gsub("cdir_events_dilemma_choice_details_localised_choice_label_", "")
                if not game_events[key] then
                    log("Stripped loc tags off of "..columns[1].." but didn't get a registered event?")
                else
                    local this_event = game_events[key]
                    local this_choice = this_event:add_or_get_choice(matched_choice_key)
                    this_choice.localised_choice_label = columns[2]
                end
            end
        else
            for loc_prefix, field in pairs(loc_keys) do
                if columns[1]:find(loc_prefix) then
                    local key = columns[1]:gsub(loc_prefix, "")
                    if not game_events[key] then
                        log("Stripped loc tags off of "..columns[1].." but didn't get a registered event?")
                    else
                        local this_event = game_events[key]
                        this_event[field] = columns[2]
                    end
                end
            end
        end
    end
end


local function handle_payload_tsv(lines, event_type_param)
    local schema = get_schema_for_payload_table(lines[1])
    log("Handling payload file "..lines[2])
    for j = 3, #lines do
        local this_row = lines[j]
        local columns = split_string(this_row, "\t")
        log("Row "..tostring(j).." has "..tostring(#columns))
        --the key of the event is not usually the first key.
        local line_info = {}
        for i = 1, #columns do
            log("Column "..tostring(i).." Schema entry: "..tostring(schema[i]))
            if schema[i] then
                line_info[schema[i]] = columns[i]
            end
        end
        if line_info.key then
            --for k, v in pairs(line_info) do log(k) log(v) end
            if event_type_param == "incidents" then
                line_info.choice_key = "ONLY"
            end
            local this_event = get_or_create_game_event(line_info.key, event_type_param)
            local this_choice = this_event:add_or_get_choice(line_info.choice_key)
            this_choice:add_payload(line_info.payload_key, line_info.payload_value)
        else
            log("The payload on line "..tostring(j).." has no key?")
        end
    end
end

function handle_data_tsv(lines, event_type_param)
    local schema = get_schema_for_event_table(lines[1])
    log("Handling data file "..lines[2])
    for j = 3, #lines do
        local this_row = lines[j]
        local columns = split_string(this_row, "\t")
        log("Row "..tostring(j).." has "..tostring(#columns))
        -- 7 columns is a mission, 8 is a dilemma, 5 is an incident
        local this_event
        for i = 1, #columns do
            log("Column "..tostring(i).." Schema entry: "..tostring(schema[i]))
            if schema[i] then
                if schema[i] == "key" then
                    this_event = get_or_create_game_event(columns[i], event_type_param)
                elseif this_event then
                    this_event[schema[i]] = columns[i]
                end
            end
        end
    end
end

local file_types = {
    ["#Loc PackedFile"] = {func = handle_loc_tsv},
    ["#dilemmas_tables"] = {func = handle_data_tsv, event_type_param = "dilemmmas"},
    ["#missions_tables"] = {func = handle_data_tsv, event_type_param = "missions"},
    ["#incidents_tables"] = {func = handle_data_tsv, event_type_param = "incidents"},
    ["#cdir_events_dilemma_payloads_tables"] = {func = handle_payload_tsv, event_type_param = "dilemmmas"},
    ["#cdir_events_mission_payloads_tables"] = {func = handle_payload_tsv, event_type_param = "missions"},
    ["#cdir_events_incident_payloads_tables"] = {func = handle_payload_tsv, event_type_param = "incidents"}
}

--get the list of items to generate the event for - a list of factions or regions

local function get_concatenation_set_for_event()

    return 
end

local function as_tab_seperated_values(...)
    local str = arg[1]
    if not arg[2] then return str end
    for i = 2, #arg do
        str = str .. "\t" .. arg[i]
    end
    return str
end

---print the newly created events

local function output_events()
    local dilemmas_table = io.open("lua/output/shieldwall_event_output/dilemmas_tables/shieldwall_generated_events.tsv", "w+")
    dilemmas_table:write("key\tgenerate\tlocalised_description\tlocalised_title\tui_icon\tui_image\tprioritized\tevent_category\n")
    dilemmas_table:write("#dilemmas_tables;3;db/dilemmas_tables/shieldwall_generated_events\t\t\t\t\t\t\t\n")

    local dilemmas_payloads = io.open("lua/output/shieldwall_event_output/cdir_events_dilemma_payloads_tables/shieldwall_generated_events.tsv", "w+")
    dilemmas_payloads:write("id\tchoice_key\tdilemma_key\tpayload_key\tvalue\n")
    dilemmas_payloads:write("#cdir_events_dilemma_payloads_tables;2;db/cdir_events_dilemma_payloads_tables/sw_pop_update_new_region_dilemmas\t\t\t\t\n")

    local dilemmas_loc = io.open("lua/output/shieldwall_event_output/text/db/shieldwall_generated_dilemmas.tsv", "w+")
    dilemmas_loc:write("key\ttext\ttooltip\n")
    dilemmas_loc:write("#Loc PackedFile;1;text/db/hof_events.loc\t\t\n")

    --TODO add options, choice details

    ---write a dilemma
    ---@param event_key string
    ---@param event_info game_event
    local function output_dilemma(event_key, event_info, is_factional)
        --write main table
        dilemmas_table:write(
            as_tab_seperated_values(event_key, "false", "", "", event_info.ui_icon, event_info.ui_image, "true", event_info.event_category) .. "\n"
        )
        --write localization
        dilemmas_loc:write(
            as_tab_seperated_values("dilemmas_localised_title_"..event_key, event_info.localised_title, "true") .. "\n"
            .. as_tab_seperated_values("dilemmas_localised_description_"..event_key, event_info.localised_description, "true") .. "\n"
        )
        --write options table
        for choice_key, payload_info in pairs(event_info.payload_details) do
            --write choice details

            --write localisation
            dilemmas_loc:write(
                as_tab_seperated_values(
                    "cdir_events_dilemma_choice_details_localised_choice_label_" .. event_key .. choice_key,
                    payload_info.localised_choice_label,
                    "true"
                ) .. "\n"
            )
            for payload_key, payload_value in pairs(payload_info.payloads) do
            --write payload table
                dilemmas_payloads:write(
                    as_tab_seperated_values(uid(), event_key, payload_key, payload_value) .. "\n"
            )
            end
        end
    end



    for event_key, event_info in pairs(game_events) do
        if event_info.EVENT_TYPE == "dilemmmas" then
            --TODO: pass the same event info with concates added
           output_dilemma(event_key, event_info)
        elseif event_info.EVENT_TYPE == "missions" then
            
        elseif event_info.EVENT_TYPE == "incidents" then

        end
    end
end

local function generate_events_from_files(...)
    for i = 1, #arg do
        local lines = lines_from("lua/input/shieldwall_event_input/"..arg[i]..".tsv", "r+")
        if not lines or #lines < 3 or not lines[2] then
            log("WARN: file ".. tostring(arg[i]).." is either missing or empty")
        end
        local success
        for match_string, instructions in pairs(file_types) do
            if string.find(lines[2], match_string) then
                success = true
                instructions.func(lines, instructions.event_type_param)
            end
        end
        if not success then
            log("WARN: did not recognize "..tostring(lines[2]))
        end
    end

    output_events()
end


return {
    generate_events_from_files = generate_events_from_files
}


