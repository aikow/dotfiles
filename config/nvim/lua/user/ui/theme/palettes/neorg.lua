local M = {}

---comment
---@param theme ThemeTheme
---@return table<string, Color>
M.palette = function(theme)
  return {
    ["@neorg.markup.italic.norg"] = { fg = theme.base09, italic = true },
  }
end

return M
