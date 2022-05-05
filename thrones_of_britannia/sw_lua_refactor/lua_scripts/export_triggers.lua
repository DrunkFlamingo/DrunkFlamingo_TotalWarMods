--[[
Automatically generated via export from C:/Users/teodor.kozhukov\DaVE_local\branches/attila/vikings/rome2/raw_data/db
Edit manually at your own risk
--]]

module(..., package.seeall)

events = get_events()
require "data.lua_scripts.lib_export_triggers"

-- Trigger declarations


--[[ vik_scripted_trait_ceolwulf ]]--

function vik_scripted_trait_ceolwulf_impl (context)
		return char_is_general(context:character()) and context:character():has_trait("vik_scripted_trait_ceolwulf")
end 

events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	if vik_scripted_trait_ceolwulf_impl(context) then
		effect.trait("vik_scripted_trait_ceolwulf", "agent", 1, 100, context)
		return true
	end
	return false
end



--[[ vik_trigger_add_bg_general_born_governor ]]--

function vik_trigger_add_bg_general_born_governor_impl (context)
	local skill = "born_governor"

	return char_is_general(context:character())
	and (context:character():has_skill("vik_general_back_"..skill.."_"..string.gsub(context:character():faction():name(), "vik_fact_", "")) 
	or context:character():has_skill("vik_general_back_"..skill))
	and not context:character():has_trait("vik_bg_general_"..skill)
	and context:character():age() > 14
end 

events.CharacterCreated[#events.CharacterCreated+1] =
function (context)
	if vik_trigger_add_bg_general_born_governor_impl(context) then
		effect.trait("vik_bg_general_born_governor", "agent", 1, 100, context)
		return true
	end
	return false
end





--[[ vik_trigger_add_bg_general_defender ]]--

function vik_trigger_add_bg_general_defender_impl (context)
	local skill = "defender"

	return char_is_general(context:character())
	and (context:character():has_skill("vik_general_back_"..skill.."_"..string.gsub(context:character():faction():name(), "vik_fact_", "")) 
	or context:character():has_skill("vik_general_back_"..skill))
	and not context:character():has_trait("vik_bg_general_"..skill)
	and context:character():age() > 14
end 

events.CharacterCreated[#events.CharacterCreated+1] =
function (context)
	if vik_trigger_add_bg_general_defender_impl(context) then
		effect.trait("vik_bg_general_defender", "agent", 1, 100, context)
		return true
	end
	return false
end

--[[ vik_trigger_add_bg_general_farmer ]]--

function vik_trigger_add_bg_general_farmer_impl (context)
	local skill = "farmer"

	return char_is_general(context:character())
	and (context:character():has_skill("vik_general_back_"..skill.."_"..string.gsub(context:character():faction():name(), "vik_fact_", "")) 
	or context:character():has_skill("vik_general_back_"..skill))
	and not context:character():has_trait("vik_bg_general_"..skill)
	and context:character():age() > 14
end 

events.CharacterCreated[#events.CharacterCreated+1] =
function (context)
	if vik_trigger_add_bg_general_farmer_impl(context) then
		effect.trait("vik_bg_general_farmer", "agent", 1, 100, context)
		return true
	end
	return false
end

--[[ vik_trigger_add_bg_general_fearless ]]--

function vik_trigger_add_bg_general_fearless_impl (context)
	local skill = "fearless"

	return char_is_general(context:character())
	and (context:character():has_skill("vik_general_back_"..skill.."_"..string.gsub(context:character():faction():name(), "vik_fact_", "")) 
	or context:character():has_skill("vik_general_back_"..skill))
	and not context:character():has_trait("vik_bg_general_"..skill)
	and context:character():age() > 14
end 

events.CharacterCreated[#events.CharacterCreated+1] =
function (context)
	if vik_trigger_add_bg_general_fearless_impl(context) then
		effect.trait("vik_bg_general_fearless", "agent", 1, 100, context)
		return true
	end
	return false
end

--[[ vik_trigger_add_bg_general_landowner ]]--

function vik_trigger_add_bg_general_landowner_impl (context)
	local skill = "landowner"

	return char_is_general(context:character())
	and (context:character():has_skill("vik_general_back_"..skill.."_"..string.gsub(context:character():faction():name(), "vik_fact_", "")) 
	or context:character():has_skill("vik_general_back_"..skill))
	and not context:character():has_trait("vik_bg_general_"..skill)
	and context:character():age() > 14
end 

events.CharacterCreated[#events.CharacterCreated+1] =
function (context)
	if vik_trigger_add_bg_general_landowner_impl(context) then
		effect.trait("vik_bg_general_landowner", "agent", 1, 100, context)
		return true
	end
	return false
end

--[[ vik_trigger_add_bg_general_melee_skill ]]--

function vik_trigger_add_bg_general_melee_skill_impl (context)
	local skill = "melee_skill"

	return char_is_general(context:character())
	and (context:character():has_skill("vik_general_back_"..skill.."_"..string.gsub(context:character():faction():name(), "vik_fact_", "")) 
	or context:character():has_skill("vik_general_back_"..skill))
	and not context:character():has_trait("vik_bg_general_"..skill)
	and context:character():age() > 14	
end 

events.CharacterCreated[#events.CharacterCreated+1] =
function (context)
	if vik_trigger_add_bg_general_melee_skill_impl(context) then
		effect.trait("vik_bg_general_melee_skill", "agent", 1, 100, context)
		return true
	end
	return false
end



--[[ vik_trigger_add_bg_general_negotiator ]]--

function vik_trigger_add_bg_general_negotiator_impl (context)
	local skill = "negotiator"

	return char_is_general(context:character())
	and (context:character():has_skill("vik_general_back_"..skill.."_"..string.gsub(context:character():faction():name(), "vik_fact_", "")) 
	or context:character():has_skill("vik_general_back_"..skill))
	and not context:character():has_trait("vik_bg_general_"..skill)
	and context:character():age() > 14
end 

events.CharacterCreated[#events.CharacterCreated+1] =
function (context)
	if vik_trigger_add_bg_general_negotiator_impl(context) then
		effect.trait("vik_bg_general_negotiator", "agent", 1, 100, context)
		return true
	end
	return false
end

--[[ vik_trigger_add_bg_general_passionate ]]--

function vik_trigger_add_bg_general_passionate_impl (context)
	local skill = "passionate"

	return char_is_general(context:character())
	and (context:character():has_skill("vik_general_back_"..skill.."_"..string.gsub(context:character():faction():name(), "vik_fact_", "")) 
	or context:character():has_skill("vik_general_back_"..skill))
	and not context:character():has_trait("vik_bg_general_"..skill)
	and context:character():age() > 14
end 

events.CharacterCreated[#events.CharacterCreated+1] =
function (context)
	if vik_trigger_add_bg_general_passionate_impl(context) then
		effect.trait("vik_bg_general_passionate", "agent", 1, 100, context)
		return true
	end
	return false
end

--[[ vik_trigger_add_bg_general_pastor ]]--

function vik_trigger_add_bg_general_pastor_impl (context)
	local skill = "pastor"

	return char_is_general(context:character())
	and (context:character():has_skill("vik_general_back_"..skill.."_"..string.gsub(context:character():faction():name(), "vik_fact_", "")) 
	or context:character():has_skill("vik_general_back_"..skill))
	and not context:character():has_trait("vik_bg_general_"..skill)
	and context:character():age() > 14
end 

events.CharacterCreated[#events.CharacterCreated+1] =
function (context)
	if vik_trigger_add_bg_general_pastor_impl(context) then
		effect.trait("vik_bg_general_pastor", "agent", 1, 100, context)
		return true
	end
	return false
end


--[[ vik_trigger_add_bg_general_spearmen_skill ]]--

function vik_trigger_add_bg_general_spearmen_skill_impl (context)
	local skill = "spearmen_skill"

	return char_is_general(context:character())
	and (context:character():has_skill("vik_general_back_"..skill.."_"..string.gsub(context:character():faction():name(), "vik_fact_", "")) 
	or context:character():has_skill("vik_general_back_"..skill))
	and not context:character():has_trait("vik_bg_general_"..skill)
	and context:character():age() > 14
end 

events.CharacterCreated[#events.CharacterCreated+1] =
function (context)
	if vik_trigger_add_bg_general_spearmen_skill_impl(context) then
		effect.trait("vik_bg_general_spearmen_skill", "agent", 1, 100, context)
		return true
	end
	return false
end