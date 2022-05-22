--# type global SAVE_SPEC = {save: (function(any) --> string), load: (function(string) --> any)}
--# type global SAVE_SCHEMA = {name: string, for_save: vector<string>, callback: (function(WHATEVER))?
--#}

--# assume global class RECRUITMENT_HANDLER
--# assume global class TRAITS
--# assume global class FACTION_RESOURCE
--# type global RESOURCE_KIND = "population" | "capacity_fill" | "resource_bar" | "faction_focus" | "imaginary"
--# type global EVENT_RESPONSE = {context: WHATEVER, character: CA_CQI?, has_character: boolean, has_region: boolean, region: string?}


--# assume global class FACTION_DECREE_HANDLER
--# assume global class DECREE
--# assume global class VASSAL_FACTION
--# assume global class DIPLOMACY_FACTION
--# assume global class FORCE_TRACKER
--# assume global class EVENT_SCHEDULE

--# assume global class REGION_MANPOWER
--# assume global class RIOT_MANAGER
--# assume global class CHARACTER_POLITICS
--# assume global class FOOD_MANAGER
--# assume global class RIVAL
--# assume global class GEOPOLITICS


--# assume global class GAME_EVENT_MANAGER
--# assume global class GAME_EVENT
--# assume global class GAME_MISSION
--# assume global class EVENT_CONDITION_GROUP
--# type global QUEUED_GAME_EVENT = {char_cqi: CA_CQI?, region_key: string?, 
--# faction_key: string, event_key: string, other_faction: string?, target_cqi: CA_CQI?}
--# type global GAME_EVENT_TRIGGER_KIND = "trait_flag" | "standard" | "concatenate_region" | "concatenate_faction"
--# type global GAME_EVENT_TYPE = "dilemma" | "mission" | "incident"
--# type global GAME_EVENT_QUEUE_TIMES = "FactionTurnStart" | "CharacterTurnStart" | "RegionTurnStart" |
--# "ShieldwallCharacterCompletedBattle" | "CharacterRetreatedFromBattle" | "CharacterEntersGarrison" |
--# "MissionTargetGeneratorFactionAtWarWith"

