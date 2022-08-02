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

local guid_find_pattern ='(%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x)'

--local guid_find_pattern = string.gsub(guid_template, "[^%-]", "%x")
function replace_GUID(...)
    for i = 1, #arg do
        local file = io.open("lua/input/"..arg[i], "r+")
        local file_text = file:read("*a")
        file:close()
        for MATCHED_GUID in string.gmatch(file_text, guid_find_pattern) do
            log("Matched GUID: "..MATCHED_GUID)
            if UUID_CREATED[MATCHED_GUID] then
                log("One of ours")
                --already converted this one.
            else
                local GUID = uuid():upper()
                log("Created GUID:" ..GUID)
                UUID_CREATED[GUID] = true
                local searchable_matched_guid = escape_string(MATCHED_GUID)
                local new_file_text, c = string.gsub(file_text, searchable_matched_guid, GUID)
                log("Searching pattern "..searchable_matched_guid.." matched "..tostring(c))
                file_text = new_file_text
            end
            
        end
        local new_file_path = "lua/output/" .. arg[i] 
        local new_file = io.open(new_file_path, "w+")
        new_file:write(file_text)
        new_file:flush()
        new_file:close()
    end
end

replace_GUID("file_to_convert.twui.xml")