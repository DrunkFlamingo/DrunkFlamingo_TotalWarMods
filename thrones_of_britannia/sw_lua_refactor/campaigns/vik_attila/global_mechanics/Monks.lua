local MANPOWER_MONK = {} --:map<string, FACTION_RESOURCE>

--v function(resource: FACTION_RESOURCE) --> string
local function value_converter(resource)
    local offset = 0
    local god_damn_pagan_idolatry = dev.get_faction(resource.owning_faction):faction_leader():has_trait("shield_heathen_pagan")
    if god_damn_pagan_idolatry then
        offset = 16
    end
    return tostring(dev.clamp(math.ceil(resource.value/18)+1+offset, 1+offset, 16+offset))
end

local sizes = {
		["vik_court_school_1"] = { ["building"] = "vik_court_school_1", ["value"] = 10 },
		["vik_court_school_2"] = { ["building"] = "vik_court_school_2", ["value"] = 15 },
		["vik_court_school_3"] = { ["building"] = "vik_court_school_3", ["value"] = 20 },
		["vik_benedictine_abbey_1"] = { ["building"] = "vik_benedictine_abbey_1", ["value"] = 10 },
		["vik_benedictine_abbey_2"] = { ["building"] = "vik_benedictine_abbey_2", ["value"] = 20 },
		["vik_benedictine_abbey_b_2"] = { ["building"] = "vik_benedictine_abbey_b_2", ["value"] = 10 },
		["vik_celi_de_abbey_1"] = { ["building"] = "vik_celi_de_abbey_1", ["value"] = 10 },
		["vik_celi_de_abbey_2"] = { ["building"] = "vik_celi_de_abbey_2", ["value"] = 20 },
		["vik_ceil_de_abbey_b_2"] = { ["building"] = "vik_ceil_de_abbey_b_2", ["value"] = 10 },
		["vik_abbey_1"] = { ["building"] = "vik_abbey_1", ["value"] = 10 },
		["vik_abbey_2"] = { ["building"] = "vik_abbey_2", ["value"] = 20 },
		["vik_abbey_b_2"] = { ["building"] = "vik_abbey_b_2", ["value"] = 10 },
		["vik_scoan_abbey_1"] = { ["building"] = "vik_scoan_abbey_1", ["value"] = 10 },
		["vik_scoan_abbey_2"] = { ["building"] = "vik_scoan_abbey_2", ["value"] = 20 },
		["vik_scoan_abbey_3"] = { ["building"] = "vik_scoan_abbey_3", ["value"] = 30 },
		["vik_st_brigit_1"] = { ["building"] = "vik_st_brigit_1", ["value"] = 20 },
		["vik_st_brigit_2"] = { ["building"] = "vik_st_brigit_2", ["value"] = 30 },
		["vik_st_brigit_3"] = { ["building"] = "vik_st_brigit_3", ["value"] = 40 },
		["vik_st_swithun_1"] = { ["building"] = "vik_st_swithun_1", ["value"] = 20 },
		["vik_st_swithun_2"] = { ["building"] = "vik_st_swithun_2", ["value"] = 30 },
		["vik_st_swithun_3"] = { ["building"] = "vik_st_swithun_3", ["value"] = 40 },
		["vik_nunnaminster_1"] = { ["building"] = "vik_nunnaminster_1", ["value"] = 40 },
		["vik_achad_bo_1"] = { ["building"] = "vik_achad_bo_1", ["value"] = 20 },
		["vik_achad_bo_2"] = { ["building"] = "vik_achad_bo_2", ["value"] = 20 },
		["vik_achad_bo_3"] = { ["building"] = "vik_achad_bo_3", ["value"] = 40 },
		["vik_achad_bo_4"] = { ["building"] = "vik_achad_bo_4", ["value"] = 40 },
		["vik_achad_bo_5"] = { ["building"] = "vik_achad_bo_5", ["value"] = 40 },
		["vik_st_ciaran_1"] = { ["building"] = "vik_st_ciaran_1", ["value"] = 20 },
		["vik_st_ciaran_2"] = { ["building"] = "vik_st_ciaran_2", ["value"] = 20 },
		["vik_st_ciaran_3"] = { ["building"] = "vik_st_ciaran_3", ["value"] = 40 },
		["vik_st_ciaran_4"] = { ["building"] = "vik_st_ciaran_4", ["value"] = 40 },
		["vik_st_ciaran_5"] = { ["building"] = "vik_st_ciaran_5", ["value"] = 40 },
		["vik_st_columbe_1"] = { ["building"] = "vik_st_columbe_1", ["value"] = 20 },
		["vik_st_columbe_2"] = { ["building"] = "vik_st_columbe_2", ["value"] = 20 },
		["vik_st_columbe_3"] = { ["building"] = "vik_st_columbe_3", ["value"] = 40 },
		["vik_st_columbe_4"] = { ["building"] = "vik_st_columbe_4", ["value"] = 40 },
		["vik_st_columbe_5"] = { ["building"] = "vik_st_columbe_5", ["value"] = 40 },
		["vik_st_patraic_1"] = { ["building"] = "vik_st_patraic_1", ["value"] = 20 },
		["vik_st_patraic_2"] = { ["building"] = "vik_st_patraic_2", ["value"] = 20 },
		["vik_st_patraic_3"] = { ["building"] = "vik_st_patraic_3", ["value"] = 40 },
		["vik_st_patraic_4"] = { ["building"] = "vik_st_patraic_4", ["value"] = 40 },
		["vik_st_patraic_5"] = { ["building"] = "vik_st_patraic_5", ["value"] = 40 },
		["vik_monastery_1"] = { ["building"] = "vik_monastery_1", ["value"] = 20 },
		["vik_monastery_2"] = { ["building"] = "vik_monastery_2", ["value"] = 20 },
		["vik_monastery_3"] = { ["building"] = "vik_monastery_3", ["value"] = 40 },
		["vik_monastery_4"] = { ["building"] = "vik_monastery_4", ["value"] = 40 },
		["vik_monastery_5"] = { ["building"] = "vik_monastery_5", ["value"] = 40 },
		["vik_rock_caisil_1"] = { ["building"] = "vik_rock_caisil_1", ["value"] = 20 },
		["vik_rock_caisil_2"] = { ["building"] = "vik_rock_caisil_2", ["value"] = 20 },
		["vik_rock_caisil_3"] = { ["building"] = "vik_rock_caisil_3", ["value"] = 40 },
		["vik_rock_caisil_4"] = { ["building"] = "vik_rock_caisil_4", ["value"] = 40 },
		["vik_rock_caisil_5"] = { ["building"] = "vik_rock_caisil_5", ["value"] = 40 },
		["vik_st_ringan_1"] = { ["building"] = "vik_st_ringan_1", ["value"] = 20 },
		["vik_st_ringan_2"] = { ["building"] = "vik_st_ringan_2", ["value"] = 20 },
		["vik_st_ringan_3"] = { ["building"] = "vik_st_ringan_3", ["value"] = 30 },
		["vik_st_ringan_4"] = { ["building"] = "vik_st_ringan_4", ["value"] = 40 },
		["vik_st_ringan_5"] = { ["building"] = "vik_st_ringan_5", ["value"] = 50 },
		["vik_st_cuthbert_1"] = { ["building"] = "vik_st_cuthbert_1", ["value"] = 20 },
		["vik_st_cuthbert_2"] = { ["building"] = "vik_st_cuthbert_2", ["value"] = 20 },
		["vik_st_cuthbert_3"] = { ["building"] = "vik_st_cuthbert_3", ["value"] = 30 },
		["vik_st_cuthbert_4"] = { ["building"] = "vik_st_cuthbert_4", ["value"] = 40 },
		["vik_st_cuthbert_5"] = { ["building"] = "vik_st_cuthbert_5", ["value"] = 50 },
		["vik_st_dewi_1"] = { ["building"] = "vik_st_dewi_1", ["value"] = 10 },
		["vik_st_dewi_2"] = { ["building"] = "vik_st_dewi_2", ["value"] = 20 },
		["vik_st_dewi_3"] = { ["building"] = "vik_st_dewi_3", ["value"] = 30 },
		["vik_st_dewi_4"] = { ["building"] = "vik_st_dewi_4", ["value"] = 40 },
		["vik_st_dewi_5"] = { ["building"] = "vik_st_dewi_5", ["value"] = 50 },
		["vik_st_edmund_1"] = { ["building"] = "vik_st_edmund_1", ["value"] = 20 },
		["vik_st_edmund_2"] = { ["building"] = "vik_st_edmund_2", ["value"] = 20 },
		["vik_st_edmund_3"] = { ["building"] = "vik_st_edmund_3", ["value"] = 30 },
		["vik_st_edmund_4"] = { ["building"] = "vik_st_edmund_4", ["value"] = 40 },
		["vik_st_edmund_5"] = { ["building"] = "vik_st_edmund_5", ["value"] = 50 },
		["vik_school_ros_1"] = { ["building"] = "vik_school_ros_1", ["value"] = 20 },
		["vik_school_ros_2"] = { ["building"] = "vik_school_ros_2", ["value"] = 20 },
		["vik_school_ros_3"] = { ["building"] = "vik_school_ros_3", ["value"] = 30 },
		["vik_school_ros_4"] = { ["building"] = "vik_school_ros_4", ["value"] = 40 },
		["vik_school_ros_5"] = { ["building"] = "vik_school_ros_5", ["value"] = 50 },
		["vik_island_monastery_1"] = { ["building"] = "vik_island_monastery_1", ["value"] = 25 },
		["vik_island_monastery_2"] = { ["building"] = "vik_island_monastery_2", ["value"] = 40 },
		["vik_island_monastery_3"] = { ["building"] = "vik_island_monastery_3", ["value"] = 60 },
		["vik_church_1"] = { ["building"] = "vik_church_1", ["value"] = 5 },
		["vik_church_2"] = { ["building"] = "vik_church_2", ["value"] = 10 },
		["vik_church_3"] = { ["building"] = "vik_church_3", ["value"] = 15 }
		
} --:map<string, {building: string, value: number}>

for building, data in pairs(sizes) do
    PettyKingdoms.RegionManpower.add_monastery_pop_cap(building, data.value)
end
local sizes = nil


dev.first_tick(function(context)
    local human_factions = cm:get_human_factions()

    for i = 1, #human_factions do
        MANPOWER_MONK[human_factions[i]] = PettyKingdoms.FactionResource.new(human_factions[i], "sw_pop_monk", "population", 0, 30000, {}, value_converter)
        local monk = MANPOWER_MONK[human_factions[i]]
        monk.uic_override = {"layout", "top_center_holder", "resources_bar2", "culture_mechanics"} 
        monk:reapply()
        
    end

    PettyKingdoms.RegionManpower.activate("monk", function(faction_key, factor_key, change)
        local pop = PettyKingdoms.FactionResource.get("sw_pop_monk", dev.get_faction(faction_key))
        if pop then
            pop:change_value(change, factor_key)
        end
	end)
	if dev.is_new_game() then
    	for i = 1, #human_factions do
			local region_list = dev.get_faction(human_factions[i]):region_list()
			for j = 0, region_list:num_items() - 1 do
				local current_region = region_list:item_at(j)     
				local manpower_obj = PettyKingdoms.RegionManpower.get(current_region:name())
				if manpower_obj.monk_cap > 0 then
					manpower_obj:set_default_monk_train_turns(9)
				end
			end
		end
	end
end)


