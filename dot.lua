local dot = require("dot")
local Path = require("dot.path").Path

dot.clean({ "~", "~/.config" })
dot.create({
  "~/.config",
  "~/.local/bin",
  "~/.local/config",
  "~/workspace",
  "~/workspace/lib",
  "~/workspace/playground",
  "~/workspace/repos",
})

dot.shell({ "git", "submodule", "update", "--init", "--recursive" })

if not Path("~/.dotfiles"):is_dir() then dot.link("~/.dotfiles", ".") end
