---@param t string
local out = function(t)
    ModLog("DRUNKFLAMINGO: "..tostring(t).." (new campaign cutscene)")
end
  

core:add_listener(
    "ChaosRealmsToggle",
    "FrontendScreenTransition",
    function (context)
        return context.string == "campaign_select"
    end,
    function (context)
      out("Transition to campaign_select")
      local select = find_uicomponent("campaign_select")
      local movies = find_uicomponent("fullscreen_movie")
      movies:Destroy()
    end,
    true)