local M = {}

function M.setup()
  require("user.config.builtin")
  require("user.config.filetype")
  require("user.config.mappings")
  require("user.config.options")
  require("user.config.autocmds")
  require("user.config.commands")

  if vim.fn.exists("neovide") == 1 then require("user.config.neovide") end

  local ok, mod = pcall(require, "vim._extui")
  if ok then mod.enable({
    enable = true,
    msg = { pos = "box" },
  }) end
end

return M
