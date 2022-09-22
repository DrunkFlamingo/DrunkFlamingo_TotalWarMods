
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

local loop_limit = 5000

local escape_string = escape_search_string

--for each file, loop through
--for each XML tag which is under the hierarchy tag, save its GUID to a table
--then, for each tag under the components tag, if it's GUID is in the table, extract the whole tag
--write all of the extracted components to a new file

local file = io.open("lua/input/twui/remove_callbacks.xml", "r+")
file_text = file:read("*a")
while file_text:find("<callbacks_with_context>") do
    local next_tag_start = file_text:find("<callbacks_with_context>")
    local next_tag_end = file_text:find("</callbacks_with_context>")
    local next_tag_text = string.sub(file_text, next_tag_start, next_tag_end+string.len("</callbacks_with_context>"))
    log("Gsubbing " .. next_tag_text .. " with nothing")
    file_text = string.gsub(file_text, escape_string(next_tag_text), "")
    loop_limit = loop_limit - 1
    if loop_limit < 0 then
        break
    end
end
while file_text:find("<callbackwithcontextlist>") do
    local next_tag_start = file_text:find("<callbackwithcontextlist>")
    local next_tag_end = file_text:find("</callbackwithcontextlist>")
    local next_tag_text = string.sub(file_text, next_tag_start, next_tag_end +string.len("</callbackwithcontextlist>"))
    log("Gsubbing " .. next_tag_text .. " with nothing")
    file_text = string.gsub(file_text, escape_string(next_tag_text), "")
    loop_limit = loop_limit - 1
    if loop_limit < 0 then
        break
    end
end

local file_lines = {}
for line in string.gmatch(file_text, "[^\n]+") do
    table.insert(file_lines, line)
end


local function output_result()
    file:close()
    local new_file_path = "lua/output/twui/remove_callbacks.xml"
    local new_file = io.open(new_file_path, "w+")
    new_file:write(file_text)
    new_file:flush()
    new_file:close()
end
output_result()