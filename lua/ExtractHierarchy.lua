require("common")

local tag_match_string = "<[%w_]+"
local guid_gsub = "this=\""
local tag_end_gsub = "\"[/?]>"
local guid_find_pattern ='(%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x)'

local hierarchy_end_tag = "</hierarchy>"
new_file_text = ""
local GUID_to_tag_name = {}
local seen_hierarchy_end = false
tag_level_of_last_tag = 0

local file = io.open("lua/input/extract_hierarchy.xml", "r+")
local file_text = file:read("*a")
local backup_file_text = file_text

local function escape_string(str)
    return str:gsub("([%(%)%.%%%+%-%*%?%[%^%$%]])", "%%%1")
end


function export_tag(line, n)
    local hierarchy_end_index = string.find(file_text, hierarchy_end_tag)
    local tag_guid = string.match(line, guid_find_pattern)
    if tag_guid then
        local tag_name = GUID_to_tag_name[tag_guid]
        if tag_name then

            local tag_start_index = string.find(file_text, tag_name, hierarchy_end_index)
            local tag_end_search = string.gsub(tag_name, "<", "") .. ">"
            local tag_end_index = string.find(file_text, tag_end_search, hierarchy_end_index) 
            local tag_text = string.sub(file_text, tag_start_index, tag_end_index+string.len(tag_end_search))
            file_text, c = string.gsub(file_text, escape_string(tag_text), "")
            log("Removed tag "..tag_name.." "..tag_guid.." on line "..n.." "..c.." times: "..tag_text)
            for i = 1, tag_level_of_last_tag -1 do
                new_file_text = new_file_text .. "\t"
            end 
            new_file_text = new_file_text .. tag_text
        end
    end
end

local function handle_lines(file_lines)
    for i = 1, #file_lines do
        local line = file_lines[i]
        local _, count = string.gsub(line, "\t", "")
        tag_level_of_last_tag = count
        if not seen_hierarchy_end then
            if string.match(line, tag_match_string) then
                local tag_name = string.match(line, tag_match_string)
                local tag_guid = string.match(line, guid_find_pattern)
                if tag_guid then
                    GUID_to_tag_name[tag_guid] = tag_name
                end
            end
        end
        if string.match(line, hierarchy_end_tag) then
            seen_hierarchy_end = true
        end
        if string.match(line, guid_gsub) and not string.match(line, tag_match_string) then
            export_tag(line, i)
        end
    end
end


--for each file, loop through
--for each XML tag which is under the hierarchy tag, save its GUID to a table
--then, for each tag under the components tag, if it's GUID is in the table, extract the whole tag
--write all of the extracted components to a new file



local file_lines = {}
for line in string.gmatch(file_text, "[^\n]+") do
    table.insert(file_lines, line)
end
handle_lines(file_lines)

local function output_result()
    file:close()
    local new_file_path = "lua/output/extract_hierarchy.xml"
    local new_file = io.open(new_file_path, "w+")

    local components_tag_start = string.find(backup_file_text, "<components>")
    local components_tag_end = string.find(backup_file_text, "</components>")
    local components_tag_text = string.sub(backup_file_text, components_tag_start, components_tag_end+string.len("</components>"))
    local new_components = "<components>\n" .. new_file_text .. "\t</components>\n"
    local new_file_text = string.gsub(backup_file_text, escape_string(components_tag_text), new_components)

    new_file:write(new_file_text)
    new_file:flush()
    new_file:close()
end
output_result()