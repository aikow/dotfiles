local wezterm = require("wezterm")

---Capture command output as a single string with newlines.
---@param cmd string The command to run
---@param trim boolean If set to true, strip leading and trailing whitespace
---from each line
---@param normalize_line_endings boolean If set to true, replace windows line
---endings with linux ones.
---@return string
local capture = function(cmd, opts)
  opts = opts or {}
  local f = assert(io.popen(cmd, "r"))
  local s = assert(f:read("*a"))
  f:close()

  -- Trim each line and normalize new line characters.
  if opts.trim or true then
    s = string.gsub(s, "^%s+", "")
    s = string.gsub(s, "%s+$", "")
  end

  if opts.normalize_line_endings or true then
    s = string.gsub(s, "[\n\r]+", "\n")
  end
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
  send_composed_key_when_left_alt_is_pressed = false,
  send_composed_key_when_right_alt_is_pressed = false,
  use_ime = false,
  font = wezterm.font_with_fallback({
    "Hack Nerd Font",
    "JetBrains Mono",
  }),
  font_size = font_size,
}
