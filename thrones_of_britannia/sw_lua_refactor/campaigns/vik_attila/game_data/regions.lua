local province_to_regions = {} --:map<string, vector<string>>
local province_capitals = {} --:map<string, string>

dev.pre_first_tick(function(context)
    for i = 0, dev.region_list():num_items() - 1 do
        local region = dev.region_list():item_at(i)
        province_to_regions[region:province_name()] = province_to_regions[region:province_name()] or {}
        table.insert(province_to_regions[region:province_name()], region:name())
        if region:is_province_capital() then
            province_capitals[region:province_name()] = region:name()
        end
    end
end)


--v function(province: string) --> CA_REGION
local function get_capital_with_province_key(province)
    if province_capitals[province] then
        return dev.get_region(province_capitals[province])
    else
        return nil
    end
end

--v function(region: string | CA_REGION) --> vector<string>
local function get_regions_in_regions_province(region)
    --# assume is_region: function(faction: any) --> boolean
    local region_obj = nil --:CA_REGION
    if type(region) == "string" then
        --# assume region: string
        region_obj = dev.get_region(region) 
    elseif is_region(region) then
        --# assume region: CA_REGION
        region_obj = region
    elseif not region_obj or region_obj.province_name == nil then
        return nil
    end

    return province_to_regions[region_obj:province_name()]
end

--v function(region: string|CA_REGION) --> CA_REGION
local function get_province_capital_of_regions_province(region)
    --# assume is_region: function(faction: any) --> boolean
    local region_obj = nil --:CA_REGION
    if is_string(region) then
        --# assume region: string
        region_obj = dev.get_region(region) 
    elseif is_region(region) then
        --# assume region: CA_REGION
        region_obj = region
    else
        return nil
    end
    return dev.get_region(province_capitals[region_obj:province_name()])

end

--v function(region_list: vector<string>) --> vector<string>
local function region_list_to_province_list(region_list) 
    local provs = {} --:map<string, boolean>
    local retval = {} --:vector<string>
    for i = 1, #region_list do
        provs[dev.get_region(region_list[i]):province_name()] = true
    end
    for p,_ in pairs(provs) do retval[#retval+1] = p end
    return retval
end

--v function(province_list: vector<string>) --> vector<string>
local function province_list_to_region_list(province_list)
    local provs = {} --:map<string, boolean>
    local retval = {} --:vector<string>
    for i = 1, #province_list do
        if not provs[province_list[i]] then
            for j = 1, #province_to_regions[province_list[i]] do
                retval[#retval+1] = province_to_regions[province_list[i]][j]
            end
        end
    end
    return retval
end

return {
    get_capital_with_province_key = get_capital_with_province_key,
    get_regions_in_regions_province = get_regions_in_regions_province,
    get_province_capital_of_regions_province = get_province_capital_of_regions_province,
    region_list_to_province_list = region_list_to_province_list,
    province_list_to_region_list = province_list_to_region_list
}