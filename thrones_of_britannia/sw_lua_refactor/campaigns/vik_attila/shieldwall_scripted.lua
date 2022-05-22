CONST = require("core/constants")
--require game data
Gamedata = {}
Gamedata.unit_info = require("game_data/unit_info")
dev = require("core/dev")
dev.log("Development library loaded, starting to load gameplay scripts")
local ok, err = pcall(function()
    dev.Save = require("core/save")
    --dev.Events = require("core/Events")
    dev.Check = require("core/checks")

    dev.GameEvents = require("story/Events")
end)
if not ok then 
    dev.log("Error loading supplemental dev files")
    dev.log(tostring(err))
    dev.log(debug.traceback())
end


local ok, err = pcall( function()
    Gamedata.general = require("game_data/general_data")
    Gamedata.regions = require("game_data/regions")
    Gamedata.base_pop = require("game_data/base_pop_values")

    Gamedata.spawn_locations = require("game_data/spawn_locations")
    Gamedata.kingdoms = require("game_data/kingdoms")
end) 
if not ok then
    dev.log("Error loading module library")
    dev.log(tostring(err))
    dev.log(debug.traceback())
end


--require object models & UI Libaries
PettyKingdoms = {} 
UIScript = {}
local ok, err = pcall( function()

    PettyKingdoms.ForceTracking = require("modules/ForceTracking")
    UIScript.effect_bundles = require("ui/EffectBundleBar")
    UIScript.culture_mechanics = require("ui/CultureMechanics")
    UIScript.decree_panel = require("ui/DecreePanel")
    UIScript.recruitment_handler = require("ui/RecruitmentHandler")

    PettyKingdoms.FactionResource = require("modules/FactionResource")
    PettyKingdoms.VassalTracking = require("modules/DiplomaticEvents")
    PettyKingdoms.CharacterPolitics = require("modules/CharacterPolitics")
    PettyKingdoms.RiotManager = require("modules/RiotManager")
    PettyKingdoms.FoodStorage = require("modules/FoodStorage")
    PettyKingdoms.Decree = require("modules/Decree")
    PettyKingdoms.Rivals = require("modules/RivalFactions")
    PettyKingdoms.Geopolitics = require("modules/Geopolitical_unit")
    PettyKingdoms.RegionManpower = require("modules/RegionManpower")
    --PettyKingdoms.Traits = require("modules/Traits")

end) 
if not ok then
    dev.log("Error loading module library")
    dev.log(tostring(err))
    dev.log(debug.traceback())
end


--require mechanics scripts
local ok, err = pcall( function()
    --global mechanics; 

    require("global_mechanics/CampaignVictories")
    require("global_mechanics/Shroud")
    require("global_mechanics/CivilWarBundles")
    --require("global_mechanics/SeasonalEffects")
    require("global_mechanics/FoodStorage")
    require("global_mechanics/RiotEvents")
    require("global_mechanics/Bandits")
    require("global_mechanics/CitiesLandmarks")
    require("global_mechanics/VikingRaiders")
    require("global_mechanics/Endgame")
    --manpower
    require("global_mechanics/PeasantManpower")
    require("global_mechanics/NobleManpower")
    require("global_mechanics/Monks")
    require("global_mechanics/Foreigners")
    require("global_mechanics/ForeignWarriorEvents")
    --culture mechanics
    require("culture_mechanics/burghal")
    require("culture_mechanics/here_king")
    require("culture_mechanics/hof")
    require("culture_mechanics/slaves")
    require("culture_mechanics/tribute")
    require("culture_mechanics/heroism")
    require("culture_mechanics/legitimacy")
    
    --faction mechanics
    require("faction_mechanics/mierce_hoards")
    require("faction_mechanics/dyflin_puppet_kings")
    --decrees
    require("decrees/WestSeaxeDecrees")
    require("decrees/MierceDecrees")
    require("decrees/NorthleodeDecrees")
    require("decrees/GwinedDecrees")

    require("global_mechanics/Aversion")
    require("global_mechanics/Items")
    require("global_mechanics/tech_effects")
    building_effects = require("global_mechanics/building_effects")
    require("global_mechanics/skill_effects")
end) 
if not ok then
    dev.log("Error loading mechanics scripts!")
    dev.log(tostring(err))
    dev.log(debug.traceback())
end

--require traits
local ok, err = pcall(function()
    trait_manager = require("traits/helpers/trait_manager")
        require("traits/shield_heathen_beast_slayer")
    require("traits/shield_faithful_charitable")
    require("traits/shield_elder_legendary_elder")
    require("traits/shield_elder_beloved")
    require("traits/shield_elder_storyteller")
    require("traits/shield_heathen_old_ways")
    require("traits/shield_faithful_legendary_saint")
    require("traits/shield_brute_legendary_brute")
    require("traits/shield_brute_corrupt")
    require("traits/shield_noble_proud")
    require("traits/shield_judge_just")
    require("traits/shield_warrior_proven_warrior")
    require("traits/shield_brute_bloodythirsty")
    require("traits/shield_brute_violent")
    require("traits/shield_heathen_legendary_bearskin")
    require("traits/shield_elder_dutifull")
    require("traits/shield_magnate_seneschal")
    require("traits/shield_tyrant_oppressor")
    require("traits/shield_scholar_educated")
    require("traits/shield_elder_husbandman")
    require("traits/shield_judge_honourable")
    require("traits/shield_warrior_natural_leader")
    require("traits/shield_scholar_legendary_thinker")
    require("traits/shield_scholar_lawyer")
    require("traits/shield_warrior_legendary_warrior")
    require("traits/shield_tyrant_legendary_tyrant")
    require("traits/shield_magnate_collector")
    require("traits/shield_judge_legendary_judge")
    require("traits/shield_noble_hunter")
    require("traits/shield_tyrant_treasonous")
    require("traits/shield_warrior_champion")
    require("traits/shield_magnate_legendary_magnate")
    require("traits/shield_tyrant_subjugator")
    require("traits/shield_scholar_wise")
    require("traits/shield_noble_princely")
    require("traits/shield_noble_high_born")
    require("traits/shield_noble_legendary_king")
    require("traits/shield_faithful_repentent")
    require("traits/shield_magnate_greedy")
    require("traits/shield_heathen_pagan")
    require("traits/shield_heathen_legendary_wolfskin")
    require("traits/shield_judge_lawful")
    require("traits/shield_heathen_sailor")
    require("traits/shield_faithful_friend_of_the_church")

end)
if not ok then
    dev.log("Error loading traits!")
    dev.log(tostring(err))
    dev.log(debug.traceback())
end

--require episodic scripting
local ok, err = pcall( function()
    AIEvents = require("episodic_scripting/AIEvents")
    --faction events
    require("episodic_scripting/vik_fact_northleode")
    require("episodic_scripting/vik_fact_west_seaxe")
    require("episodic_scripting/vik_fact_mierce")

    require("episodic_scripting/vik_fact_gwined")

    --geopols
    --require("episodic_scripting/geopolitics_south_england")
end) 
if not ok then
    dev.log("Error loading episodic scripts!")
    dev.log(tostring(err))
    dev.log(debug.traceback())
end

--require vanilla files
local ok, err = pcall(function()
    require("vik_ai_personalities");


end)
if not ok then
    dev.log("Error loading ca scripts!")
    dev.log(tostring(err))
    dev.log(debug.traceback())
end


--
--

--[[ old vanilla shit
require("vik_start");
require("vik_burghal");
require("vik_war_fervour");
require("vik_rebels");
require("vik_lists");
require("vik_kingdom_events");

require("vik_trade_and_shroud");
require("vik_common");
require("vik_victory_conditions");
require("vik_campaign_random_army");
require("vik_invasions");
require("vik_starting_rebellions");
require("vik_seasonal_events");
require("vik_ai_events");
require("vik_dyflin_factions_mechanics");
require("vik_miercna_faction_mechanics");
require("vik_sudreyar_faction_mechanics");
require("vik_strat_clut_faction_mechanics");
require("vik_northymbra_faction_mechanics");
require("vik_circenn_factions_mechanics");
require("laura_test");
require("vik_culture_mechanics_sea_kings");
require("vik_culture_mechanics_viking_army");
require("vik_culture_mechanics_gaelic");
require("vik_culture_mechanics_welsh");
require("vik_culture_mechanics_english");
require("vik_culture_mechanics_common");
require("vik_legendary_traits");
require("vik_starting_traits");
require("vik_tech_locks");
require("vik_tech_unlocks");
require("vik_faction_events");
require("vik_advice");
require("vik_traits");
require("vik_decrees");
require("vik_ai_wars");
require("vik_ai_peace");
--]] 