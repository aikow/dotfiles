local awful = require("awful")

local M = {}

M.setup = function()
	awful.spawn.with_shell([[nitrogen --restore]])
	awful.spawn.with_shell([[picom]])
	awful.spawn.with_shell([[ps aux | grep yakuake || command -v yakuake &>/dev/null && yakuake &]])
	awful.spawn.with_shell([[xmodmap -e 'clear lock']])
	awful.spawn.with_shell([[xmodmap -e 'keysym Caps_Lock = Escape']])
end

return M
