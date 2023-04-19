local M = {}

---comment
---@param colors Colors
---@return table<string, Color>
M.palette = function(_, colors)
  return {
    LuasnipPassive = { fg = colors.dark_purple },
    LuasnipActive = { fg = colors.nord_blue },
  }
end

return M
