local M = {}

M.setup = function()
  vim.opt.statusline = [[%!v:lua.require'aiko.ui.statusline'.statusline()]]
  vim.opt.tabline = [[%!v:lua.require'aiko.ui.statusline'.tabline()]]
end

return M
