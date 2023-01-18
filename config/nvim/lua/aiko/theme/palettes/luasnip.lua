local M = {}

M.palette = function(_, colors)
  return {
    LuasnipPassive = { fg = colors.dark_purple },
    LuasnipActive = { fg = colors.nord_blue },
  }
end

return M
