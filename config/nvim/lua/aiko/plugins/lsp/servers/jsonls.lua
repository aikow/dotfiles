local M = {}

--   {
--     description = "Packer config",
--     fileMatch = { "packer.json" },
--     url = "https://json.schemastore.org/packer",
--   },

M.opts = {
  settings = {
    json = {
      format = { enabled = false },
      schemas = require("schemastore").json.schema(),
      validate = { enable = true },
    },
  },
}

return M
