local dot = require("dot")

dot.ensure(dot.executable("conda"))
dot.run("./bootstrap-conda")

dot.link({
  ["~/.condarc"] = "condarc",
}, { force = true, relink = true })
