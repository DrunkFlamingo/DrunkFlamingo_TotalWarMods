local character_cross_trait_loyalties = {} --:map<string, map<string, int>>

local subcultures_to_title_sets = {
    vik_sub_cult_anglo_viking = "norse",
    vik_sub_cult_english = "saxon",
    vik_sub_cult_irish = "irish",
    vik_sub_cult_scots = "scotish",
    vik_sub_cult_viking = "norse",
    vik_sub_cult_viking_gael = "norse",
    vik_sub_cult_welsh = "welsh"
} --:map<string, string>

local startpos_skills = {
   ["vik_fact_dyflin"] = "vik_follower_champion_dyflin",
   ["vik_fact_east_engle"] = "vik_follower_champion_east_engle",
   ["vik_fact_sudreyar"] = "vik_follower_bard_sudreyar",
   ["vik_fact_strat_clut"] = "vik_follower_bard_strat_clut",
   ["vik_fact_west_seaxe"] = "vik_follower_scribe_west_seaxe",
   ["vik_fact_circenn"] = "vik_follower_champion_circenn"
} --:map<string, string>


local factions_with_trait_overrides = {
    ["vik_fact_gwined"] = true,
    ["vik_fact_strat_clut"] = true,
    ["vik_fact_dyflin"] = true,
    ["vik_fact_sudreyar"] = true,
    ["vik_fact_circenn"] = true,
    ["vik_fact_mide"] = true,
    ["vik_fact_mierce"] = true,
    ["vik_fact_west_seaxe"] = true,
    ["vik_fact_east_engle"] = true,
    ["vik_fact_northymbre"] = true,
    ["vik_fact_northleode"]  = true
} --:map<string, boolean>
local basic_king_title = "shield_leader_titles_king"
local basic_vassal_title = "shield_leader_titles_vassal"

local general_level_trait = "shield_general_" --:string
local admin_level_trait = "vik_gov_province_" --:string
local loyalty_trait = "shield_trait_loyal" --:string
local disloyalty_trait = "shield_trait_disloyal" --:string
local friendship_level_trait = "shield_friendship_" --:string
local fame_trait = "shield_fame_"
local fame_family_trait = "shield_family_fame_"
local personal_fame_max = 15 --:int

local faction_histories = {} --:map<string, map<string, int>>
dev.Save.attach_to_table(faction_histories, "FACTION_HISTORIES")

local character_politics = {} --# assume character_politics:CHARACTER_POLITICS

--v function(cqi: CA_CQI) --> CHARACTER_POLITICS
function character_politics.new(cqi)
    local self = {}
    setmetatable(self, {
        __index = character_politics
    }) --# assume self: CHARACTER_POLITICS

    self.cqi = cqi
    self.game_interface = dev.get_character(cqi)
    self.faction_key = self.game_interface:faction():name()
    self.last_governorship = "none" --:string
    self.friendship_level = 2 --:int
    self.plot_vulnerability = 0
    self.general_level = 0 --:int
    self.title = 0 --:int
    self.king_level = 0 --:int
    self.last_title = "none" --:string
    self.home_region = "none" --:string
    self.traits = {} --:vector<string>
    self.skills = {} --:map<string, int>
    self.personal_fame = 1
    self.num_items = 0

    self.character_history = {} --:map<string, int>
    faction_histories[self.faction_key] = faction_histories[self.faction_key] or {}
    self.faction_history = faction_histories[self.faction_key]
    self.save = {
        name = "politics_"..tostring(self.cqi), 
        for_save = {"last_governorship", "friendship_level", "general_level", "title", "last_title", "plot_vulnerability", "skills", "personal_fame", "character_history"}
    }--:SAVE_SCHEMA
    dev.Save.attach_to_object(self)
    return self
end 

--v function(self: CHARACTER_POLITICS, t: any)
function character_politics.log(self, t)
    dev.log(tostring(t), "CHAR"..tostring(self.cqi))
end

--v function(self: CHARACTER_POLITICS, history_key: string) --> int
function character_politics.get_character_history(self, history_key)
    return self.character_history[history_key] or 0
end

--v function(self: CHARACTER_POLITICS, history_key: string)
function character_politics.increment_character_history(self, history_key)
    self.character_history[history_key] = (self.character_history[history_key] or 0) + 1
end

--v function(self: CHARACTER_POLITICS, history_key: string)
function character_politics.reset_character_history(self, history_key)
    self.character_history[history_key] = 0
end

--v function(self: CHARACTER_POLITICS, history_key: string) --> int
function character_politics.get_faction_history(self, history_key)
    return self.faction_history[history_key] or 0
end

--v function(self: CHARACTER_POLITICS, history_key: string)
function character_politics.increment_faction_history(self, history_key)
    self.faction_history[history_key] = (self.faction_history[history_key] or 0) + 1
end

--v function(self: CHARACTER_POLITICS, history_key: string)
function character_politics.reset_faction_history(self, history_key)
    self.faction_history[history_key] = 0
end

--v function(self: CHARACTER_POLITICS)
function character_politics.refresh_plot_vulnerability(self)
    local char = dev.get_character(self.cqi)
    local is_king = char:is_faction_leader()
    local loyal_side = is_king or char:has_trait(loyalty_trait)
    local authority = char:gravitas()
    local risk = 0
    for i = 0, char:faction():character_list():num_items() - 1 do
        local other_char = char:faction():character_list():item_at(i)
        if not (other_char:command_queue_index() == char:command_queue_index()) then
            local bonus = 1 --:number
            if other_char:is_faction_leader() then
                bonus = (5 - other_char:gravitas())/2
            elseif other_char:faction():home_region():has_governor() and other_char:faction():home_region():governor():command_queue_index() == other_char:command_queue_index() then
                bonus = 1.5
            elseif other_char:has_trait(general_level_trait.."2") then
                bonus = 1.3
            end
            if other_char:has_trait(loyalty_trait) then
                if loyal_side then
                    authority = dev.mround(authority + (other_char:gravitas() * bonus), 1)
                else
                    risk = dev.mround(risk + (other_char:gravitas() * bonus), 1)
                end
            elseif other_char:has_trait(disloyalty_trait) then
                if not loyal_side then
                    authority = dev.mround(authority + (other_char:gravitas() * bonus), 1)
                else
                    risk = dev.mround(risk + (other_char:gravitas() * bonus), 1)
                end
            end
        end
    end

end

--v function(self: CHARACTER_POLITICS, region: CA_REGION)
function character_politics.do_governor_trait(self, region)
    local province_key = region:province_name()
    local character = region:governor()
    if character == "nil" or character:is_null_interface() then
        self:log(tostring(self.cqi) .. " is returning nil! They're probably dead")
        return
    end
    self:increment_character_history("turns_as_governor_in_row")
    self:increment_character_history("turns_as_governor")
    local trait_key = province_key:gsub("vik_prov_", admin_level_trait)
    local changed_trait = false --:boolean
    if self.last_governorship ~= trait_key and character:has_trait(self.last_governorship) then
        self:log("Removing old Governor trait "..self.last_title)
        cm:force_remove_trait(dev.lookup(character), self.last_title)
        changed_trait = true
    end
    if self.last_governorship ~= trait_key and not character:has_trait(trait_key) then
        self:log("adding new Governor trait "..trait_key)
        dev.add_trait(character, trait_key, changed_trait)
    end
    self.last_governorship = trait_key
end

--v function(self: CHARACTER_POLITICS, character: CA_CHAR)
function character_politics.update_loyalty_traits(self, character)
    self:log("Checking friendship loyalty trait")
    local king = character:faction():faction_leader()
    if not king or king:is_null_interface() then
        self:log("ERROR: could not get a handle on the king!")
        return
    end
    local friendship = 2 --:int
    --update cross loyalty
    for trait_key, relation_pairs in pairs(character_cross_trait_loyalties) do
        if character:has_trait(trait_key) then
            --we have a trait which has cross loyalty effects.
            for other_trait, change_value in pairs(relation_pairs) do
                --if the king has the trait that is cross loyalty, apply the change
                if king:has_trait(other_trait) then
                    self:log("Cross loyalty found between trait: "..trait_key.." and trait: "..other_trait)
                    friendship = friendship + change_value
                end
            end
        end
    end
    local friendship = dev.mround(dev.clamp(friendship, 0, 4), 1)
    self:log("Friendship is: "..friendship)
    local old_bundle = friendship_level_trait..tostring(self.friendship_level)
    local new_bundle = friendship_level_trait..tostring(friendship)
    local changed_trait = false --:boolean
    if old_bundle ~= new_bundle and character:has_trait(old_bundle) then  
        self:log("Removing old friendship trait "..old_bundle)
        cm:force_remove_trait(dev.lookup(character), old_bundle)
        changed_trait = true
    end
    if old_bundle ~= new_bundle and not character:has_trait(new_bundle) then
        self:log("adding new friendship trait "..new_bundle)
        dev.add_trait(character, new_bundle, changed_trait)
    end
    self.friendship_level = friendship
    self:log("Not faction leader: checking loyalty")
    if character:loyalty() > 4 then
        local old_bundle = disloyalty_trait
        local new_bundle = loyalty_trait
        local changed_trait = false --:boolean
        if old_bundle ~= new_bundle and character:has_trait(old_bundle) then
            self:log("Removing old loyalty trait "..old_bundle)
            cm:force_remove_trait(dev.lookup(character), old_bundle)
            changed_trait = true
        end
        if old_bundle ~= new_bundle and not character:has_trait(new_bundle) then
            self:log("adding new loyalty trait "..new_bundle)
            dev.add_trait(character, new_bundle, changed_trait)
        end
        self:increment_character_history("turns_loyal_in_row")
        self:reset_character_history("turns_disloyal_in_row")
    else
        local old_bundle = loyalty_trait
        local new_bundle = disloyalty_trait
        if old_bundle ~= new_bundle and character:has_trait(old_bundle) then
            self:log("Removing old loyalty trait "..old_bundle)
            cm:force_remove_trait(dev.lookup(character), old_bundle)
            changed_trait = true
        end
        if old_bundle ~= new_bundle  and not character:has_trait(new_bundle)then
            self:log("adding new loyalty trait "..new_bundle)
            dev.add_trait(character, new_bundle, changed_trait)
        end
        self:reset_character_history("turns_loyal_in_row")
        self:increment_character_history("turns_disloyal_in_row")
    end
end

--v function(self: CHARACTER_POLITICS, character: CA_CHAR)
function character_politics.update_king_traits(self, character)
    self:log("Checking faction leader trait")
    if character:has_trait(loyalty_trait) or character:has_trait(disloyalty_trait) then
        --if they have either of these, they haven't been king very long.
        --we need to remove any traits that kings can't get.
        dev.remove_trait(character, loyalty_trait)
        dev.remove_trait(character, disloyalty_trait)
        dev.remove_trait(character, friendship_level_trait..tostring(self.friendship_level))
        dev.eh:trigger_event("TraitsClearedFromFactionLeader", character)
    end
    local trait_key = basic_king_title
    local changed_trait = false --:boolean
    if PettyKingdoms.VassalTracking.is_faction_vassal(character:faction():name()) then
        trait_key = basic_vassal_title
    end
    if factions_with_trait_overrides[character:faction():name()] then
        trait_key = "shield_leader_titles_"..character:faction():name().."_"..self.king_level
    end
    if self.last_title ~= trait_key and character:has_trait(self.last_title) then
        self:log("Removing old King trait "..self.last_title)
        cm:force_remove_trait(dev.lookup(character), self.last_title)
        changed_trait = true
    end
    if self.last_title ~= trait_key and not character:has_trait(trait_key) then
        self:log("adding new King trait "..trait_key)
        dev.add_trait(character, trait_key, changed_trait)
    end
    self.last_title = trait_key
end

--v function(self: CHARACTER_POLITICS, character: CA_CHAR)
function character_politics.update_general_trait(self, character)
    if character:has_military_force() and character:military_force():is_army() and (not character:military_force():is_armed_citizenry()) then
        self:log("Checking general trait")
        self:increment_character_history("turns_as_general_in_row")
        self:increment_character_history("turns_as_general")
        if character:military_force():unit_list():num_items() > 15 then
            local old_bundle = general_level_trait..tostring(self.general_level-1)
            local new_bundle = general_level_trait.."1"
            if old_bundle ~= new_bundle then
                if character:has_trait(old_bundle) then
                    self:log("Removing old general trait "..old_bundle)
                    dev.remove_trait(character, old_bundle)
                end
                if not character:has_trait(new_bundle) then
                    self:log("adding new general trait "..new_bundle)
                    dev.add_trait(character, new_bundle, true)
                end
            end
            self.general_level = 2
        else
            local old_bundle = general_level_trait..tostring(self.general_level-1)
            local new_bundle = general_level_trait.."0"
            if old_bundle ~= new_bundle then
                if character:has_trait(old_bundle) then
                    self:log("Removing old general trait "..old_bundle)
                    dev.remove_trait(character, old_bundle)
                    changed_trait = true
                end
                if  not character:has_trait(new_bundle) then
                    self:log("adding new general trait "..new_bundle)
                    dev.add_trait(character, new_bundle, true)
                end
            end
            self.general_level = 1
        end
    elseif self.general_level > 0 then
        self:reset_character_history("turns_as_general_in_row")
        self:log("Not a general")
        dev.remove_trait(character, general_level_trait..tostring(self.general_level-1))
        self.general_level = 0
    end
end


--v function(self: CHARACTER_POLITICS)
function character_politics.refresh_fame_traits(self)
    local character = dev.get_character(self.cqi)
    if not character:faction():is_human() then
        return
    end
    self:log("Refreshing fame trait")

    local daddy_issues = 1
    local own_fame = self.personal_fame
    --note to self: you have to use "has_father" to avoid crashes here. FamilyMember:father() returns an interface that isn't null but crashes when used.
    if character:family_member():has_father() then 
        local dad = character:family_member()
        self:log("Dad exists")
        for i = 1, personal_fame_max do
            --self:log("About to ask if dad has "..fame_trait..i)
            if dad:has_trait(fame_trait..i) then
                self:log("Father has fame trait level "..i)
                daddy_issues = i
            end
        end
    end
    local fam_trait = fame_family_trait..daddy_issues
    local own_trait = fame_trait..own_fame
    self:log("Own trait should be "..own_trait.." family trait should be "..fam_trait)
    if daddy_issues > own_fame then
        --when dad is more famous than you
        if not character:has_trait(fam_trait) then
            dev.add_trait(character, fam_trait, daddy_issues > 1)
        end
        if character:has_trait(own_trait) then
            dev.remove_trait(character, own_trait) 
        end
    else
        --when you are known personally.
        for i = 1, personal_fame_max do
            local old_trait = fame_trait..i
            if character:has_trait(old_trait) then
                if i ~= own_fame then
                    dev.remove_trait(character, old_trait)
                end
            end
        end
        if character:has_trait(fam_trait) then
            dev.remove_trait(character, fam_trait)
        end
        if not character:has_trait(own_trait) then
            dev.add_trait(character, own_trait, own_fame > 1)
        end
    end
end



--v function(self: CHARACTER_POLITICS)
function character_politics.increase_personal_fame(self)
    if self.personal_fame == personal_fame_max then
        self:log("Asked to increase personal fame, but it is already at 5! This should be checked for on personal-fame-granting events")
        return
    end
    self.personal_fame = self.personal_fame + 1
    self:refresh_fame_traits()
end


--v function(self: CHARACTER_POLITICS)
function character_politics.turn_start(self)
    local character = dev.get_character(self.cqi)
    self:log("processing turn start")
    if character == "nil" or character:is_null_interface() then
        self:log(tostring(self.cqi) .. " is returning nil! They're probably dead")
        return
    end
    self:refresh_plot_vulnerability()
    self:refresh_fame_traits()
    self:log("Checking faction leader status")
    if character:is_faction_leader() then
        self:update_king_traits(character)
    else 
        self:update_loyalty_traits(character)
    end
    self:update_general_trait(character) 
end





--v function(self: CHARACTER_POLITICS, skill: string) --> int
function character_politics.get_skill_points(self, skill)
    return self.skills[skill] or 0
end

local instances = {} --:map<CA_CQI, CHARACTER_POLITICS>

dev.first_tick(function(context)
    local humans = cm:get_human_factions()
    for i = 1, #humans do
        local characters = dev.get_faction(humans[i]):character_list()
        for j = 0, characters:num_items() - 1 do
            local current = characters:item_at(j)
            if current:character_type("general")  and is_number(current:command_queue_index()) then
                instances[current:command_queue_index()] = character_politics.new(current:command_queue_index())
                instances[current:command_queue_index()]:log("Created pols char")
            end
            if dev.is_new_game() and instances[current:command_queue_index()] then
                local sp_skills = startpos_skills[humans[i]]
                if sp_skills then
                    if current:has_skill(sp_skills) then
                        instances[current:command_queue_index()].skills[sp_skills] = 1
                        instances[current:command_queue_index()]:log("\tcreated character had startpos skill ["..sp_skills.."]")
                    end
                end
                instances[current:command_queue_index()]:turn_start()
            end
        end
        local regions = dev.get_faction(humans[i]):region_list()
        for j = 0, regions:num_items() - 1 do
            local current = regions:item_at(j)
            if current:has_governor() and instances[current:governor():command_queue_index()] then
                instances[current:governor():command_queue_index()]:do_governor_trait(current)
            end
        end
    end

    dev.eh:add_listener(
        "CharacterPoliticsTurnStart",
        "CharacterTurnStart",
        function(context)
            return context:character():faction():is_human() and dev.is_char_normal(context:character())
        end,
        function(context)
            local char = context:character() --:CA_CHAR
            if not instances[char:command_queue_index()] then
                instances[char:command_queue_index()] = character_politics.new(char:command_queue_index())
            end
            instances[char:command_queue_index()]:turn_start()
        end,
        true)
    dev.eh:add_listener(
        "CharacterPoliticsTurnStart",
        "RegionTurnStart",
        function(context)
            return context:region():owning_faction():is_human() and context:region():has_governor()
        end,
        function(context)
            local char = context:region():governor() --:CA_CHAR
            if not instances[char:command_queue_index()] then
                instances[char:command_queue_index()] = character_politics.new(char:command_queue_index())
            end
            instances[char:command_queue_index()]:do_governor_trait(context:region())
        end,
        true)
    dev.eh:add_listener(
        "CharacterPoliticsGovernorAssignedCharacterEvent",
        "GovernorAssignedCharacterEvent",
        function(context)
            return context:region():owning_faction():is_human() and context:region():has_governor()
        end,
        function(context)
            local region = context:region() --:CA_REGION
            local char = region:governor() 
            if not instances[char:command_queue_index()] then
                instances[char:command_queue_index()] = character_politics.new(char:command_queue_index())
                return
            end
            local province_key = region:province_name()
            local trait_key = province_key:gsub("vik_prov_", admin_level_trait)
            local character_list = region:owning_faction():character_list()
            for i = 0, character_list:num_items() - 1 do
                local old_gov_char = character_list:item_at(i)
                if instances[old_gov_char:command_queue_index()] and old_gov_char:has_trait(trait_key) then
                    dev.remove_trait(old_gov_char, trait_key)
                    instances[old_gov_char:command_queue_index()].last_governorship = "none"
                    instances[old_gov_char:command_queue_index()]:reset_character_history("turns_as_governor_in_row")
                end
            end
        end,
        true)
    dev.eh:add_listener(
        "CharacterPoliticsFactionFormsKingdom",
        "FactionFormsKingdom",
        function(context)
            return context:faction():is_human()
        end,
        function(context)
            local char = context:faction():faction_leader() --:CA_CHAR
            if not instances[char:command_queue_index()] then
                instances[char:command_queue_index()] = character_politics.new(char:command_queue_index())
            end
            instances[char:command_queue_index()].king_level = instances[char:command_queue_index()].king_level + 1
        end,
        true)
        dev.eh:add_listener(
            "CharacterGainsTraitPolitics",
            "CharacterGainsTrait",
            function(context)
                return context:character():faction():is_human() and dev.is_char_normal(context:character())
            end,
            function(context)
                local char = context:character() --:CA_CHAR
                if not instances[char:command_queue_index()] then
                    instances[char:command_queue_index()] = character_politics.new(char:command_queue_index())
                end
                instances[char:command_queue_index()].traits[#instances[char:command_queue_index()].traits+1] = context.string
                instances[char:command_queue_index()]:log("Gained trait: "..context.string)
                if string.find(context.string, "item_") then
                    instances[char:command_queue_index()].num_items = instances[char:command_queue_index()].num_items + 1
                end
            end,
            true)
        dev.eh:add_listener(
            "CharacterSkillPointAllocatedPolitics",
            "CharacterSkillPointAllocated",
            function(context)
                return context:character():faction():is_human()
            end,
            function(context)
                local char = context:character() --:CA_CHAR
                if not instances[char:command_queue_index()] then
                    instances[char:command_queue_index()] = character_politics.new(char:command_queue_index())
                end
                local instance = instances[char:command_queue_index()]
                local skill = context:skill_point_spent_on()
                instance.skills[skill] = (instance.skills[skill] or 0) + 1
                instance:log("Human Character skilled ["..skill.."] and has ["..tostring(instance.skills[skill]).."] skill points")
            end,
            true)
        dev.eh:add_listener(
            "CharacterCompletedBattlePolitics",
            "ShieldwallCharacterCompletedBattle",
            function(context)
                return context:character():faction():is_human()
            end,
            function(context)
                local char = context:character() --:CA_CHAR
                if not instances[char:command_queue_index()] then
                    instances[char:command_queue_index()] = character_politics.new(char:command_queue_index())
                end
                local pol_char = instances[char:command_queue_index()]
                local significance = PettyKingdoms.ForceTracking.get_last_battle_significance_for_faction(char:faction())
                pol_char:increment_character_history("battles_participated_in")
                local pb = char:model():pending_battle()
                local attacker_won = pb:attacker():won_battle()
                if char:won_battle() then
                    pol_char:increment_character_history("battles_won")
                    pol_char:increment_character_history("battles_won_in_row")
                    if significance > 30 then
                        pol_char:increment_character_history("significant_battles_won")
                    end
                    if attacker_won then
                        local victory_type = pb:attacker_battle_result()
                        pol_char:increment_character_history("attacking_battles_won")
                        pol_char:increment_character_history("num_"..victory_type)
                    else
                        local victory_type = pb:defender_battle_result()
                        pol_char:increment_character_history("defending_battles_won")
                        pol_char:increment_character_history("num_"..victory_type)
                    end
                else
                    pol_char:increment_character_history("battles_lost")
                    pol_char:reset_character_history("battles_won_in_row")
                    if significance > 30 then
                        pol_char:increment_character_history("significant_battles_lost")
                    end
                    if attacker_won then
                        local defeat_type = pb:defender_battle_result()
                        pol_char:increment_character_history("defending_battles_lost")
                        pol_char:increment_character_history("num_"..defeat_type)
                    else
                        local defeat_type = pb:attacker_battle_result()
                        pol_char:increment_character_history("attacking_battles_lost")
                        pol_char:increment_character_history("num_"..defeat_type)
                    end
                end
            end,
            true)
        dev.eh:add_listener(
            "CharacterPerformsOccupationDecisionSackPolitics",
            "CharacterPerformsOccupationDecisionSack",
            function(context)
                return context:character():faction():is_human()
            end,
            function(context)
                local char = context:character() --:CA_CHAR
                if not instances[char:command_queue_index()] then
                    instances[char:command_queue_index()] = character_politics.new(char:command_queue_index())
                end
                local pol_char = instances[char:command_queue_index()]
                local faction_leader_char = char:faction():faction_leader()

                pol_char:increment_character_history("settlements_sacked")
                pol_char:increment_faction_history("settlements_sacked")
                if (not faction_leader_char:is_null_interface()) then
                    if not instances[faction_leader_char:command_queue_index()] then
                        instances[faction_leader_char:command_queue_index()] = character_politics.new(faction_leader_char:command_queue_index())
                    end
                    local pol_char_faction_leader = instances[faction_leader_char:command_queue_index()]
                    pol_char:increment_character_history("settlements_sacked_while_king")
                end
            end,
            true)
        dev.eh:add_listener(
            "CharacterPerformsOccupationDecisionOccupyPolitics",
            "CharacterPerformsOccupationDecisionOccupy",
            function(context)
                return context:character():faction():is_human()
            end,
            function(context)
                local char = context:character() --:CA_CHAR
                if not instances[char:command_queue_index()] then
                    instances[char:command_queue_index()] = character_politics.new(char:command_queue_index())
                end
                local pol_char = instances[char:command_queue_index()]
                local faction_leader_char = char:faction():faction_leader()

                pol_char:increment_character_history("settlements_captured")
                pol_char:increment_faction_history("settlements_captured")
                if (not faction_leader_char:is_null_interface()) then
                    if not instances[faction_leader_char:command_queue_index()] then
                        instances[faction_leader_char:command_queue_index()] = character_politics.new(faction_leader_char:command_queue_index())
                    end
                    local pol_char_faction_leader = instances[faction_leader_char:command_queue_index()]
                    pol_char:increment_character_history("settlements_captured_while_king")
                end
            end,
            true)
end)
--v function(trait_key: string, to_trait: string, effect_bonus_value: int)
local function add_trait_cross_loyalty_to_trait(trait_key, to_trait, effect_bonus_value)
    character_cross_trait_loyalties[trait_key] = character_cross_trait_loyalties[trait_key] or {}
    character_cross_trait_loyalties[trait_key][to_trait] = effect_bonus_value
end

--v function(char: CA_CQI|CA_CHAR) --> CHARACTER_POLITICS
local function get_char_politics(char)
    if not is_number(char) then
        --# assume char: WHATEVER
        char = char:command_queue_index()
    end
    --# assume char: CA_CQI
    return instances[char]
end

--v function(faction:CA_FACTION) --> CHARACTER_POLITICS
local function get_faction_leader_politics(faction)
    if not faction:is_human() or not faction:has_faction_leader() then
        return nil
    end
    return instances[faction:faction_leader():command_queue_index()]
end

return {
    get_faction_leader = get_faction_leader_politics,
    get = get_char_politics,
    add_trait_cross_loyalty_to_trait = add_trait_cross_loyalty_to_trait
}