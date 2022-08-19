local M = {}

M.setup = function()
  -- Setup packer and plugins
  require("aiko.plugins").bootstrap()
  require("aiko.plugins").setup()

  -- Setup options, key-maps and personal auto commands.
  require("aiko.config").setup()
  require("aiko.ui").setup()
end

return M
