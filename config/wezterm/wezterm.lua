local wezterm = require("wezterm")
local util = require("user.util")
local info = require("user.info")

local config = wezterm.config_builder()

-- Colors
config.color_scheme = "Gruvbox dark, medium (base16)"

-- Appearance
config.default_cursor_style = "SteadyBar"

-- Tab
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- Window
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

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
if info.os() == "darwin" then
  config.default_prog = { "/usr/local/bin/fish", "-l" }
  config.font_size = 13
end

-- Load a module called local and use it to apply local settings
local ok, module = pcall(require, "local")
if ok and type(module.setup) == "function" then
  module.setup(config)
end

return config
