local M = {}

M.palette = function(_, colors)
  return {
    IndentBlanklineChar = { fg = colors.line },
    IndentBlanklineSpaceChar = { fg = colors.line },
    IndentBlanklineContextChar = { fg = colors.grey },
    IndentBlanklineContextStart = { bg = colors.one_bg2 },
  }
end

return M
