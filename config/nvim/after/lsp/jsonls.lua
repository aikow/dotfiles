return {
  settings = {
    json = {
      format = { enabled = false },
      schemas = require("schemastore").json.schema(),
      validate = { enable = true },
    },
  },
}
