local dotbot = require("dotbot")
local Path = require("dotbot.path").Path

dotbot.clean({ "~", "~/.config" })
dotbot.create({
	"~/.config",
	"~/.local/bin",
	"~/.local/config",
	"~/workspace",
	"~/workspace/lib",
	"~/workspace/playground",
	"~/workspace/repos",
})

dotbot.shell({ "git", "submodule", "update", "--init", "--recursive" })

if not Path("~/.dotfiles"):is_dir() then
	dotbot.link("~/.dotfiles", ".")
end
