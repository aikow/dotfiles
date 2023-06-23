local M = {}

---comment
---@param colors Base46Colors
---@return table<string, Color>
M.palette = function(_, colors)
  return {
    MiniStarterCurrent = {},
    MiniStarterFooter = { fg = colors.light_grey_3 },
    MiniStarterHeader = { fg = colors.light_green },
    MiniStarterInactive = {},
    MiniStarterItem = {},
    MiniStarterItemBullet = { fg = colors.light_grey_3 },
    MiniStarterItemPrefix = {},
    MiniStarterSection = { fg = colors.dark_purple },
    MiniStarterQuery = {},
  }
end

return M
