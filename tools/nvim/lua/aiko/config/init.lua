local M = {}

M.setup = function()
  require("aiko.config.mappings")
  require("aiko.config.options")
  require("aiko.config.autocmds")
end

return M
