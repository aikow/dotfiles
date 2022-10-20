local M = {}

M.palette = function(_, colors)
  return {
    AlphaHeader = { fg = colors.grey_fg },
    AlphaButtons = { fg = colors.light_grey },
  }
end

return M
