local dotbot = require("dotbot")
local Path = require("dotbot.path").Path

if dotbot.executable("alacritty") then
	dotbot.create({ " ~/.config/alacritty" })
	dotbot.clean({ "~/.config/alacritty" })

	-- Link config files
	Path("alacritty.toml"):link("~/.config/alacritty/alacritty.toml", { force = true })
	Path("alacritty/themes/gruvbox-material-dark-medium.toml"):link("current-theme.toml")
	Path(string.format("~/.config/alacritty/os/%s.toml", dotbot.get_os())):link("current-os.toml")
end
