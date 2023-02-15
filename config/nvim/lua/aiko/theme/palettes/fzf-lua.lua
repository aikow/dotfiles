local M = {}

M.palette = function(_, colors)
  return {
    FzfLuaNormal = { bg = colors.darker_black },
    FzfLuaBorder = { fg = colors.darker_black, bg = colors.darker_black },

    FzfLuaSearchNormal = { fg = colors.white, bg = colors.black2 },
    FzfLuaTitle = { fg = colors.black, bg = colors.red },

    FzfLuaCursor = { bg = colors.darker_black, fg = colors.red },
    FzfLuaCursorLine = { bg = colors.darker_black, fg = colors.darker_black },
    FzfLuaCursorLineNr = { bg = colors.darker_black, fg = colors.darker_black },

    FzfLuaHelpNormal = { bg = colors.darker_black },
    FzfLuaHelpBorder = {
      fg = colors.darker_black,
      bg = colors.darker_black,
    },
    FzfLuaHelpTitle = { fg = colors.darker_black, bg = colors.green },

    FzfLuaScrollBorderFull = {
      fg = colors.darker_black,
      bg = colors.darker_black,
    },
    FzfLuaScrollBorderEmpty = {
      fg = colors.darker_black,
      bg = colors.darker_black,
    },

    FzfLuaScrollFloatFull = {
      fg = colors.darker_black,
      bg = colors.darker_black,
    },
    FzfLuaScrollFloatEmpty = {
      fg = colors.darker_black,
      bg = colors.darker_black,
    },

    -- FzfLuaHelpNormal = { bg = colors.darker_black },
    -- FzfLuaHelpBorder = {
    --   fg = colors.darker_black,
    --   bg = colors.darker_black,
    -- },
    -- FzfLuaHelpTitle = {
    --   fg = colors.darker_black,
    --   bg = colors.darker_black,
    -- },
  }
end

return M
