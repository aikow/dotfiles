local M = {}

M.setup = function()
  local builtin = require("user.config.builtin")
  builtin.disable_plugins()
  builtin.disable_providers()

  require("user.config.globals")
  require("user.config.filetype")
  require("user.config.mappings")
  require("user.config.options")
  require("user.config.autocmds")
  require("user.config.commands")

  if vim.fn.exists("neovide") == 1 then
    require("user.config.neovide")
  end
end

return M
