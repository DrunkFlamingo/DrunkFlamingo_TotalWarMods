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