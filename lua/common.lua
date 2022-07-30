local file = io.open("lua/log.txt", "w+")
file:write("START\n")
file:flush()
file:close()


function log(t)
    local file = io.open("lua/log.txt", "a")
    file:write(tostring(t) .. "\n")
    file:flush()
    file:close()
end

---comment
---@param s string
---@param delimiter string
---@return string[]
function split_string(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end


function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end


---comment
---@param file string
---@return string[]
function lines_from(file)
    if not file_exists(file) then return {} end
    lines = {}
    for line in io.lines(file) do 
        lines[#lines + 1] = line
    end
    return lines
end


---take a lua table and return a string which can be loadstringed to recreate the table.
---@param t table
---@return string
function table_to_string(t, indent)
    if not indent then
        indent = 0
    end
    local prefix = ""
    for i = 1, indent do
        prefix = prefix .. "\t"
    end
    local result = "{"
    local first_result = false 
    for k, v in pairs(t) do
        if not first_result then
            first_result = true
        else
            result = result .. ",\n" 
        end
        if type(k) == "string" then
            k = string.format("%q", k)
        end
        if v == "" then
            v = "\"\"" --empty string
        elseif type(v) == "boolean" or type(v) == "number" then
            v = tostring(v)
        elseif type(v) == "string" then
            v = string.format("%q", v) 
        elseif type(v) == "table" then
            v = table_to_string(v, indent + 1)
        end
        result = result .. prefix.."[" .. k .. "]=" .. v
    end
    result = result .. "}"
    return result
end

