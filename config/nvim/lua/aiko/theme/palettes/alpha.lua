local M = {}

---comment
---@param colors Colors
---@return table<string, Color>
M.palette = function(_, colors)
  return {
    AlphaHeader = { fg = colors.light_grey_1 },
    AlphaButtons = { fg = colors.light_grey_3 },
  }
end

return M
