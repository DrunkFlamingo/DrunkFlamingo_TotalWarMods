--v function(t: any)
local function log(t)
    dev.log(tostring(t), "DefaultEventGroups")
end
local events = require("story/event_manager")

--defines standard groups

events:register_condition_group(events:create_new_condition_group("ProvinceCapitals", function(context)
    local region = context:region() --:CA_REGION
    if not region or region:is_null_interface() then
        log("ProvinceCapitals is attached to an event, but this event has no valid region attached!")
        return false
    end
    return region:is_province_capital()
end))

events:register_condition_group(events:create_new_condition_group("NotProvinceCapitals", function(context)
    local region = context:region() --:CA_REGION
    if not region or region:is_null_interface() then
        log("NotProvinceCapitals is attached to an event, but this event has no valid region attached!")
        return false
    end
    return not region:is_province_capital()
end))

events:register_condition_group(events:create_new_condition_group("IsSaxonFaction", function(context)
    return context:faction():subculture() == "vik_sub_cult_english"
end))
events:register_condition_group(events:create_new_condition_group("NotIsSaxonFaction", function(context)
    return context:faction():subculture() ~= "vik_sub_cult_english"
end))

return events