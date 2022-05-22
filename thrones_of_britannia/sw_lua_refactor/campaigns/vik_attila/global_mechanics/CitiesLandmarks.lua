--===============================
-- Historical City Information --
--===============================

--v function(text: any)
function NAPLOG(text)
    dev.log(tostring(text), "NAP")
end



region_intros_played = {
        ["vik_reg_aberffro"] = 0, 
        ["vik_reg_aberteifi"] = 0, 
        ["vik_reg_achadh_bo"] = 0, 
        ["vik_reg_aethelingaeg"] = 0, 
        ["vik_reg_airchardan"] = 0, 
        ["vik_reg_ard_macha"] = 0, 
        ["vik_reg_bebbanburg"] = 0, 
        ["vik_reg_blascona"] = 0, 
        ["vik_reg_bornais"] = 0, 
        ["vik_reg_cair_gwent"] = 0, 
        ["vik_reg_caisil"] = 0,
        ["vik_reg_cantwaraburg"] = 0,
        ["vik_reg_carleol"] = 0,
        ["vik_reg_cathair_commain"] = 0, 
        ["vik_reg_ceaster"] = 0, 
        ["vik_reg_cetretha"] = 0, 
        ["vik_reg_cippanhamm"] = 0,
        ["vik_reg_cluain_mac_nois"] = 0, 
        ["vik_reg_colneceaster"] = 0,
        ["vik_reg_corcach"] = 0,
        ["vik_reg_din_prys"] = 0,
        ["vik_reg_dinefwr"] = 0,
        ["vik_reg_dofere"] = 0,
        ["vik_reg_doreceaster"] = 0,
        ["vik_reg_drayton"] = 0, 
        ["vik_reg_druim_da_ethiar"] = 0, 
        ["vik_reg_dun_att"] = 0, 
        ["vik_reg_dun_beccan"] = 0, 
        ["vik_reg_dun_cailden"] = 0, 
        ["vik_reg_dun_foither"] = 0, 
        ["vik_reg_dun_patraic"] = 0,
        ["vik_reg_dun_sebuirgi"] = 0,
        ["vik_reg_dyflin"] = 0,
        ["vik_reg_earmutha"] = 0, 
        ["vik_reg_eidenburg"] = 0, 
        ["vik_reg_eoferwic"] = 0, 
        ["vik_reg_exanceaster"] = 0,
        ["vik_reg_gipeswic"] = 0, 
        ["vik_reg_gleawceaster"] = 0,
        ["vik_reg_grantabrycg"] = 0,
        ["vik_reg_grianan_aileach"] = 0,
        ["vik_reg_guvan"] = 0,
        ["vik_reg_gyruum"] = 0,
        ["vik_reg_haestingas"] = 0,
        ["vik_reg_hlymrekr"] = 0,
        ["vik_reg_ioua"] = 0,
        ["vik_reg_lindcylne"] = 0,
        ["vik_reg_loidis"] = 0,
        ["vik_reg_lunden"] = 0,
        ["vik_reg_maeldune"] = 0, 
        ["vik_reg_mameceaster"] = 0, 
        ["vik_reg_mathrafal"] = 0, 
        ["vik_reg_nas"] = 0, 
        ["vik_reg_northhamtun"] = 0, 
        ["vik_reg_northwic"] = 0, 
        ["vik_reg_otergimele"] = 0, 
        ["vik_reg_rath_cruachan"] = 0, 
        ["vik_reg_rendlesham"] = 0, 
        ["vik_reg_rofeceaster"] = 0,
        ["vik_reg_scoan"] = 0,
        ["vik_reg_seolesigge"] = 0,
        ["vik_reg_snotingaham"] = 0, 
        ["vik_reg_steanford"] = 0, 
        ["vik_reg_suthhamtun"] = 0, 
        ["vik_reg_tamworthige"] = 0,
        ["vik_reg_tintagol"] = 0, 
        ["vik_reg_tor_in_duine"] = 0,
        ["vik_reg_vedrafjordr"] = 0,
        ["vik_reg_veisafjordr"] = 0,
        ["vik_reg_waerincwicum"] = 0,
        ["vik_reg_werham"] = 0,
        ["vik_reg_wintanceaster"] = 0
} --:map<string, int>

local advice_expanded = false


--v function(context: CA_CONTEXT)
local function OnSettlementSelected(context)
    local region_name = context:garrison_residence():region():name() --:string
    if region_intros_played[region_name] == nil then
        --we don't have a intro for this region
        return
    end
    if not cm:get_saved_value("region_intro_played_"..region_name) then
        NAPLOG("Playing region advice for ["..region_name.."] ")
        cm:set_saved_value("region_intro_played_"..region_name, true)
        effect.advance_scripted_advice_thread("Region.Intro." ..region_name,  1);
        if advice_expanded == false then
            advice_expanded = true
            dev.callback(function() 
                local AdviceResizable = dev.get_uic(cm:ui_root(), "advice_interface", "text_parent_list", "text_parent")
                if not not AdviceResizable then
                    NAPLOG("Resizing advice!")
                    AdviceResizable:Resize(AdviceResizable:Width(), 2*AdviceResizable:Height())
                    dev.get_uic(AdviceResizable, "advice_text_panel", "info_text"):SetVisible(false)
                    local VSlider = dev.get_uic(AdviceResizable, "vslider")
                    VSlider:Resize(VSlider:Width(), VSlider:Height()*2)
                    local Top = dev.get_uic(VSlider, "top")
                    local Bot = dev.get_uic(VSlider, "bottom")
                    if Top and Bot then
                        Bot:SimulateLClick()
                        dev.callback(function()
                            Top:SimulateLClick()
                        end, 0.1)
                    end
                end
            end, 0.1)
        end
    end
end;

cm:add_listener(
    "Cities_Landmarks",
    "SettlementSelected",
    true,
    function(context)
        OnSettlementSelected(context)
    end,
    true
)

dev.add_settlement_selected_log(function(region)
    if region_intros_played[region:name()] == nil then
        return "Place has no registered name"
    else
        return "Place has a registered name"
    end
end)


--===============================
-- Historical Wonder Information --
--===============================

local landmarks = {
		["vik_reg_aethelingaeg"] = "vik_wonder_discovered_athelingaeg", 
		["vik_reg_bebbanburg"] = "vik_wonder_discovered_bebbanburg", 
		["vik_reg_blascona"] = "vik_wonder_discovered_blascona", 
		["vik_reg_bodmine"] = "vik_wonder_discovered_bodmine", 
		["vik_reg_cissanbyrig"] = "vik_wonder_discovered_cissanbyrig",
		["vik_reg_cnodba"] = "vik_wonder_discovered_cnodba",
		["vik_reg_dun_sebuirgi"] = "vik_wonder_discovered_dun_sebuirgi",
		["vik_reg_hagustaldes"] = "vik_wonder_discovered_hagustaldes",
		["vik_reg_inber_nise"] = "vik_wonder_discovered_inber_nise",
		["vik_reg_loch_gabhair"] = "vik_wonder_discovered_loch_gabhair",
		["vik_reg_linns"] = "vik_wonder_discovered_linns",
		["vik_reg_rudglann"] = "vik_wonder_discovered_rudglann",
		["vik_reg_sancte_ye"] = {"vik_wonder_discovered_sancte_ye","vik_wonder_discovered_sancte_ye1"},
		["vik_reg_snotingaham"] = "vik_wonder_discovered_snotingaham",
		["vik_reg_wiht"] = "vik_wonder_discovered_wiht",
		["vik_reg_wiltun"] = "vik_wonder_discovered_wiltun",
		["vik_reg_ros_ailithir"] = "vik_wonder_discovered_ros_ailithir",
		["vik_reg_hripum"] = "vik_wonder_discovered_hripum",
		["vik_reg_aporcrosan"] = "vik_wonder_discovered_aporcrosan",
		["vik_reg_cathair_commain"] = "vik_wonder_discovered_cathair_commain",
		["vik_reg_brideport"] = "vik_wonder_discovered_brideport",
		["vik_reg_tintagol"] = "vik_wonder_discovered_tintagol",
		["vik_reg_laewe"] = "vik_wonder_discovered_laewe",
		["vik_reg_dofere"] = "vik_wonder_discovered_dofere",
		["vik_reg_werham"] = "vik_wonder_discovered_werham",
		["vik_reg_alt_clut"] = "vik_wonder_discovered_alt_clut"
} --:map<string, (string | vector<string>)>

cm:add_listener(
    "NamesAndPlacesConquest",
    "GarrisonOccupiedEvent",
    function(context)
        return (not not landmarks[context:garrison_residence():region():name()]) and context:character():faction():is_human()
    end,
    function(context)
        local region = context:garrison_residence():region():name()
        local incident_string = landmarks[region]
        if cm:get_saved_value("landmark_regions_conquest_"..region) then
            return
        elseif type(incident_string) == "table" then
            local incidents = incident_string 
            --# assume incidents: vector<string>
            for i = 1, #incidents do
                if cm:get_saved_value("landmark_regions_conquest_multiples_"..incidents[i]) then
                    --return
                else
                    cm:trigger_incident(context:character():faction():name(), incidents[i], true)
                    cm:set_saved_value("landmark_regions_conquest_multiples_"..incidents[i], true)
                    return
                end
                cm:set_saved_value("landmark_regions_conquest_"..region, true)
            end
        else
            --# assume incident_string: string
            cm:trigger_incident(context:character():faction():name(), incident_string, true)
            cm:set_saved_value("landmark_regions_conquest_"..region, true)
        end
    end,
true)


cm:add_listener(
    "LandmarkIncidentsRegionTurns",
    "RegionTurnStart",
    function(context)
        return( not not landmarks[context:region():name()]) and context:region():owning_faction():is_human()
    end,
    function(context)
        local region = context:region():name()
        local incident_string = landmarks[region]
        if cm:get_saved_value("landmark_regions_conquest_"..region) then
            return
        elseif type(incident_string) == "table" then
            local incidents = incident_string 
            --# assume incidents: vector<string>
            for i = 1, #incidents do
                if cm:get_saved_value("landmark_regions_conquest_multiples_"..incidents[i]) then
                    --return
                elseif cm:random_number(100) < 6 then
                    cm:trigger_incident(context:region():owning_faction():name(), incidents[i], true)
                    cm:set_saved_value("landmark_regions_conquest_multiples_"..incidents[i], true)
                    return
                end
                cm:set_saved_value("landmark_regions_conquest_"..region, true)
            end
        elseif cm:random_number(100) < 6 then
            --# assume incident_string: string
            cm:trigger_incident(context:region():owning_faction():name(), incident_string, true)
            cm:set_saved_value("landmark_regions_conquest_"..region, true)
        end
    end,
    true
)