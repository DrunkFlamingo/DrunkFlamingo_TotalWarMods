return {

    ["reward_key"] = {
        mandatory_reward_components = { --all keys listed in this section are always added to the reward when generating.
            unit_keys = {},
            armory_keys = {},
            unit_purchasable_effect_keys = {},
            effect_bundle_keys = {},
            replenishment = 0 -- 0 to 100 how much % of units should be replenished
        },
        generated_reward_components = {
            {
                unit_keys = {},
                num_generated_unit_rewards = 0,
                armory_keys = {},
                num_generated_armory_rewards = 0,
                unit_purchasable_effect_keys = {},
                num_generated_unit_purchasable_effect_rewards = 0,
                effect_bundle_keys = {},
                num_generated_effect_bundle_rewards = 0,
                replenishment = 0 -- between 0 and this number replenishment will be added to the replenishment reward defined in the mandatory rewards
            }
        }
    }

}