local modules = require("aiko.ui.statusline.modules")

local M = {}

M.statusline = function()
  return table.concat({
    modules.mode(),
    modules.fileInfo(),
    modules.git(),

    "%=",
    modules.LSP_progress(),
    "%=",

    modules.LSP_Diagnostics(),
    modules.LSP_status() or "",
    modules.cwd(),
    modules.cursor_position(),
  })
end

M.tabline = function()
  return table.concat({
    modules.tablist(),
  })
end

return M
