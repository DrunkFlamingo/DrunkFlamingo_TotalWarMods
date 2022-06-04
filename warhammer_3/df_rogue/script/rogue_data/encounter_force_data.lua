---@class ROGUE_FORCE_DATA
 local template_force = {
    id = "template_force",
    commanding_characters = { --one random character from the list is selected to lead the force.
        {               
            agent_subtype_key = "",
            forename_set = "",
            surname_set = "",
            effect_bundles = {}
        }
    },
    generated_fragments = { --from each set, one key is selected and a fragment is generated. 
        {"fragment_key", "fragment_key"},
        {}
    },
    difficulty_details = {
        difficulty_level = 0, --0 to 50
        special_point_offset = 0,
        rare_point_offset = 0
    }
}

return {
    --- easy forces
    --sla
    {
        id = "sla_marauder_cult_easy",
        commanding_characters = { --one random character from the list is selected to lead the force.
            {               
                agent_subtype_key = "wh3_main_sla_herald_of_slaanesh_slaanesh",
                forename_set = "sla_herald_names",
                surname_set = "empty_name_set",
                effect_bundles = {}
            }
        },
        generated_fragments = { --from each set, one key is selected and a fragment is generated. 
            {"sla_marauder_infantry"},
            {"sla_marauder_cultist", "sla_marauder_cavalry"}
        },
        difficulty_details = {
            difficulty_level = 0, --0 to 50
            special_point_offset = 0,
            rare_point_offset = 0
        }
    }
}---@type ROGUE_FORCE_DATA[]