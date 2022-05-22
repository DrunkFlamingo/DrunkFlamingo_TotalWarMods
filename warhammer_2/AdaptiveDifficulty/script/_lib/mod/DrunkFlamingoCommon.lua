local util = {}
local should_log = false --:boolean
if should_log then
    local popLog = io.open("df_logs.txt", "w+")
    local logTimeStamp = os.date("%d, %m %Y %X")
    --# assume logTimeStamp: string
    popLog:write("NEW LOG: ".. logTimeStamp .. "\n")
    popLog :flush()
    popLog :close()
end

--v function(text: string, context: string?)
function util.log(text, context)
    if not should_log then
        return; 
    end
    local pre = context --:string
    if not context then
        pre = "DEV"
    end
    local logText = tostring(text)
    local logTimeStamp = os.date("%d, %m %Y %X")
    local popLog = io.open("df_logs.txt","a")
    --# assume logTimeStamp: string
    popLog :write(pre..":  [".. logTimeStamp .. "]:  "..logText .. "  \n")
    popLog :flush()
    popLog :close()
end




--v [NO_CHECK] function(item:number, min:number?, max:number?) --> number
function util.clamp(item, min, max)
    local ret = item 
    if max and ret > max then
        ret = max
    elseif min and ret < min then
        ret = min
    end
    return ret
end

--v function(num: number, mult: int) --> int
function util.mround(num, mult)
    --round num to the nearest multiple of mult
    return (math.floor((num/mult)+0.5))*mult
end


df_util = util

util.log("Util loaded")