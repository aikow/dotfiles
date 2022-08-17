local M = {}

M.palette = function(theme, colors)
  return {
    AlphaHeader = { fg = colors.grey_fg },
    AlphaButtons = { fg = colors.light_grey },
  }
end

return M
