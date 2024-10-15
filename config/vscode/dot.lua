local dot = require("dot")

dot.copy_default(
  "settings.json",
  dot.os_switch({
    darwin = "~/Library/Application Support/Code/User",
    linux = "$XDG_CONFIG_HOME/Code/User",
  })
)
