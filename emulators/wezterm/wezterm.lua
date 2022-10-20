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
local font_size
if hostname == "Darwin" then
  shell = { "/usr/local/bin/fish", "-l" }
  font_size = 13
else
  shell = { "/usr/bin/fish", "-l" }
  font_size = 11
end

return {
  default_prog = shell,
  color_scheme = "Gruvbox Dark",
  default_cursor_style = "SteadyBar",
  enable_tab_bar = false,
  send_composed_key_when_alt_is_pressed = false,
  use_ime = false,
  font = wezterm.font_with_fallback({
    "Hack Nerd Font",
    "JetBrains Mono",
  }),
  font_size = font_size,
}
