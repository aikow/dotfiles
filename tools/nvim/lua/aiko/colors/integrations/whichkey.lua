local M = {}

M.palette = function(theme, colors)
  return {
    WhichKey = { fg = colors.blue },
    WhichKeySeparator = { fg = colors.light_grey },
    WhichKeyDesc = { fg = colors.red },
    WhichKeyGroup = { fg = colors.green },
    WhichKeyValue = { fg = colors.green },
  }
end

return M
