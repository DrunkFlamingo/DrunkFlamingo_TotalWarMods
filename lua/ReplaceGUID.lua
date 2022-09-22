require("common")

math.randomseed(os.time())

local guid_template ='xxxxxxxx-xxxx-xxxx-xxxxxxxxxxxxxxxx'

local random = math.random
local function uuid()
    return string.gsub(guid_template, '[x]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end

local problematic_characters = {".", "-"}
local function escape_string(s)
  local ret = s
  for i = 1, #problematic_characters do
    local search = "%"..problematic_characters[i]
    local replace = "%%%"..problematic_characters[i]
    ret = string.gsub(ret, search, replace)
  end
  return ret
end

local UUID_CREATED = {}
local UUID_COUNT = {}

local guid_find_pattern ='(%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x)'
total_allowed_fails = 0

local lines_to_restore = {}
local lines_to_old_context = {}
should_flag_context_command_issues = false 
--local guid_find_pattern = string.gsub(guid_template, "[^%-]", "%x")
function replace_GUID(...)
    for i = 1, #arg do
        local file = io.open("lua/input/twui/"..arg[i], "r+")
        local file_text = file:read("*a")
        file:close()

        local file_lines = {}
        for line in string.gmatch(file_text, "[^\n]+") do
            table.insert(file_lines, line)
        end

        local _, state_uniqueguid = string.gsub(file_text, "state_uniqueguid", "")
        total_allowed_fails = total_allowed_fails + state_uniqueguid
        local _, uniqueguid_in_template_count = string.gsub(file_text, "uniqueguid_in_template", "")
        total_allowed_fails = total_allowed_fails + uniqueguid_in_template_count
        for MATCHED_GUID in string.gmatch(file_text, guid_find_pattern) do
            log("Matched GUID: "..MATCHED_GUID)
            if UUID_CREATED[MATCHED_GUID] then
                log("One of ours")
                UUID_COUNT[MATCHED_GUID] = UUID_COUNT[MATCHED_GUID] + 1
                log("Incremented GUID:" ..MATCHED_GUID.." to "..UUID_COUNT[MATCHED_GUID])
                --already converted this one.
            else
                local GUID = uuid():upper()
                log("Created GUID:" ..GUID)
                UUID_CREATED[GUID] = true

                local searchable_matched_guid = escape_string(MATCHED_GUID)
                local new_file_text, c = string.gsub(file_text, searchable_matched_guid, GUID)
                log("Searching pattern "..searchable_matched_guid.." matched "..tostring(c))
                UUID_COUNT[GUID] = (UUID_COUNT[GUID]or 0) + c
                log("Incremented GUID:" ..GUID.." to "..UUID_COUNT[GUID])
                file_text = new_file_text
            end
            
        end

        for i = 1, #file_lines do
            local line = file_lines[i]
            if line:find("uniqueguid_in_template") then
                table.insert(lines_to_restore, i)
                lines_to_old_context[i] = line

            elseif line:find("Component%(&quot;"..guid_find_pattern.."&quot;%)") 
            or line:find("DoesGUIDExist%(&quot;"..guid_find_pattern.."&quot;%)") then
                for MATCHED_GUID in string.gmatch(line, guid_find_pattern) do
                    if UUID_COUNT[MATCHED_GUID] or 0 <= 1 then
                        should_flag_context_command_issues = true
                        total_allowed_fails = total_allowed_fails + 1
                    end
                end

            end
        end

        local file_lines = {}
        for line in string.gmatch(file_text, "[^\n]+") do
            table.insert(file_lines, line)
        end
        for i = 1, #lines_to_restore do
            local line = lines_to_old_context[lines_to_restore[i]]
            file_lines[lines_to_restore[i]] = line
        end
        new_file_text = file_lines[1]
        for i = 2, #file_lines do
            new_file_text = new_file_text.."\n" ..file_lines[i]
        end
        local new_file_path = "lua/output/twui/" .. arg[i] 

        local new_file = io.open(new_file_path, "w+")
        new_file:write(new_file_text)
        new_file:flush()
        new_file:close()
    end
end

replace_GUID("replace_guid.xml")
local failed = 0
for guid, count in pairs(UUID_COUNT) do

    if count == 1 then
        log("GUID "..guid.." was only used once.")
        failed = failed + 1
    end
end


local error_msg = ""
if failed > total_allowed_fails then
    --error_msg = error_msg .. (failed.." lone GUIDs found, "..total_allowed_fails.." allowed.\n")
else
    log(failed.." lone GUIDs found, "..total_allowed_fails.." allowed.")
end


if should_flag_context_command_issues then
    error_msg = error_msg ..("There are context commands in this file which reference UIComponents by GUID. They probably don't work anymore. \bIts possible to rewrite this script a bit to fix it, but you can do that.\n")
end

if error_msg ~= "" then
    error(error_msg)
end
