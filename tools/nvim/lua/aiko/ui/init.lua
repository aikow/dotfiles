local M = {}

M.setup = function()
  vim.o.statusline = [[%!v:lua.require'aiko.ui.statusline'.statusline()]]
  vim.o.tabline = [[%!v:lua.require'aiko.ui.statusline'.tabline()]]
  vim.o.winbar = [[%{%v:lua.require'aiko.ui.statusline'.winbar()%}]]
end

return M
