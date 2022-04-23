local mod = core:get_static_object("tabletopcaps")


function ttc_start()
  core:trigger_event("ModScriptEventTabletopCapsSetup")
  mod.finish_setup()
  mod.add_listeners()
  mod.add_ai_listeners()
  mod.add_ui_meter_listeners()
  mod.add_exchange_listeners() 
  mod.unit_browser_listeners()
  return mod
end


