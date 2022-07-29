local M = {}

M.setup = function()
  local builtin = require("aiko.config.builtin")
  builtin.disable_plugins()
  builtin.disable_providers()

  require("aiko.config.mappings")
  require("aiko.config.options")
  require("aiko.config.autocmds")

  if vim.fn.exists("neovide") == 1 then
    require("aiko.config.neovide")
  end
end

return M
