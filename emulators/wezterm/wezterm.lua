local wezterm = require("wezterm")

local capture = function(cmd, raw)
  local f = assert(io.popen(cmd, "r"))
  local s = assert(f:read("*a"))
  f:close()

  if raw then
    return s
  end

  -- Trim each line and normalize new line characters.
  s = string.gsub(s, "^%s+", "")
  s = string.gsub(s, "%s+$", "")
  s = string.gsub(s, "[\n\r]+", "\n")
  return s
end

local hostname = capture("uname")

-- Spawn a fish shell in login mode
local shell
if hostname == "Darwin" then
  shell = { "/usr/local/bin/fish", "-l" }
else
  shell = { "/usr/bin/fish", "-l" }
end

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
