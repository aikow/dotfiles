local dotbot = require("dotbot")

dotbot.ensure(dotbot.executable("conda"))
dotbot.run("./bootstrap-conda")

dotbot.link({
	["~/.condarc"] = "condarc",
}, { force = true, relink = true })
