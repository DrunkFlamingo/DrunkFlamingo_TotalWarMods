--implementation of the hoards mechanic for mierce 

local faction_key = "vik_fact_mierce"
dev.first_tick(function(context)
    if dev.get_faction(faction_key):is_human() then
        MIERCE_HOARDS = PettyKingdoms.FactionResource.new(faction_key, "sw_hoards", "capacity_fill", 1, 3, {})
        MIERCE_HOARDS:reapply()
    end
end)