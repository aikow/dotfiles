local M = {}

---comment
---@param colors Colors
---@return table<string, Color>
M.palette = function(_, colors)
  return {
    IndentBlanklineChar = { fg = colors.line },
    IndentBlanklineSpaceChar = { fg = colors.line },
    IndentBlanklineContextChar = { fg = colors.grey },
    IndentBlanklineContextStart = { bg = colors.bg_3 },
  }
end

return M
