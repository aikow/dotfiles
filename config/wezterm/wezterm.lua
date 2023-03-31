local wezterm = require("wezterm")
local util = require("util")

local config = {}

-- Colors
config.color_scheme = "Gruvbox dark, medium (base16)"

-- Appearance
config.default_cursor_style = "SteadyBar"
config.enable_tab_bar = true

-- Fonts
config.font = wezterm.font_with_fallback({ "Hack Nerd Font", "JetBrains Mono" })
config.font_size = 11
config.use_ime = false

-- Behavior
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- Shell
config.default_prog = { "/usr/bin/fish", "-l" }

-- MacOS specific overrides.
if util.capture("uname") == "Darwin" then
  config.default_prog = { "/usr/local/bin/fish", "-l" }
  config.font_size = 13
end

return config
