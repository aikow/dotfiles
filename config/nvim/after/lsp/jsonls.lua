return {
  settings = {
    json = {
      format = { enabled = false },
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}
