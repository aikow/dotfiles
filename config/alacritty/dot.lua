local dot = require("dot")
local Path = require("dot.path").Path

if dot.executable("alacritty") then
  dot.create({ " ~/.config/alacritty" })
  dot.clean({ "~/.config/alacritty" })

  -- Link config files
  Path("alacritty.toml"):symlink_to("~/.config/alacritty/alacritty.toml", { force = true })
  Path("alacritty/themes/gruvbox-material-dark-medium.toml"):symlink_to("current-theme.toml")
  Path(string.format("~/.config/alacritty/os/%s.toml", dot.get_os())):symlink_to("current-os.toml")
end
