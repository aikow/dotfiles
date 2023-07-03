local M = {}

M.setup = function()
  vim.opt.statusline = "%!v:lua.require('user.ui.line.statusline').run()"
  vim.opt.winbar = "%!v:lua.require('user.ui.line.winbar').run()"
  vim.opt.tabline = "%!v:lua.require('user.ui.line.tabline').run()"
end

return M
