local M = {}

M.statusline = function()
  return require("aiko.ui.statusline").statusline()
end

M.tabline = function()
  return require("aiko.ui.statusline").tabline()
end

M.setup = function()
  vim.opt.statusline = "%!v:lua.require('aiko.ui').statusline()"
  vim.opt.tabline = "%!v:lua.require('aiko.ui').tabline()"
end

return M
