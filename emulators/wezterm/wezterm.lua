local wezterm = require("wezterm")

-- Spawn a fish shell in login mode
local shell = { "/usr/bin/fish", "-l" }

local catppuccin = require("colors/catppuccin").setup({
  -- whether or not to sync with the system's theme
  sync = true,
  -- the flavours to switch between when syncing
  -- available flavours: "latte" | "frappe" | "macchiato" | "mocha"
  sync_flavours = {
    light = "latte",
    dark = "macchiato",
  },
  -- the default/fallback flavour, when syncing is disabled
  flavour = "macchiato",
})

return {
  default_prog = shell,

  colors = catppuccin,

  enable_tab_bar = false,

  font = wezterm.font_with_fallback({
    "Hack Nerd Font",
    "JetBrains Mono",
  }),

  font_size = 11,
}
