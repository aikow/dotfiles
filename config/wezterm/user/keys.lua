local wezterm = require("wezterm")
local disable = wezterm.action.DisableDefaultAssignment

return {
  { key = "Enter", mods = "ALT", action = disable },
}
