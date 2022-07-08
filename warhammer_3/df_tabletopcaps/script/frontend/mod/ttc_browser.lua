--this turns on the TTC cost viewer on the front end.
local mod = core:get_static_object("tabletopcaps") ---@type tabletopcaps

mod.finish_setup()
mod.unit_browser_listeners()