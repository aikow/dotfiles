local M = {}

M.palette = function(_, colors)
  return {
    TelescopeNormal = { bg = colors.darker_black },
    TelescopeBorder = { fg = colors.darker_black, bg = colors.darker_black },
    TelescopeSelection = { bg = colors.black2, fg = colors.white },

    TelescopePromptNormal = { fg = colors.white, bg = colors.black2 },
    TelescopePromptBorder = { fg = colors.black2, bg = colors.black2 },
    TelescopePromptTitle = { fg = colors.black, bg = colors.red },
    TelescopePromptPrefix = { fg = colors.red, bg = colors.black2 },

    TelescopePreviewNormal = { bg = colors.darker_black },
    TelescopePreviewBorder = {
      fg = colors.darker_black,
      bg = colors.darker_black,
    },
    TelescopePreviewTitle = { fg = colors.darker_black, bg = colors.green },

    TelescopeResultsNormal = { bg = colors.darker_black },
    TelescopeResultsBorder = {
      fg = colors.darker_black,
      bg = colors.darker_black,
    },
    TelescopeResultsTitle = {
      fg = colors.darker_black,
      bg = colors.darker_black,
    },

    TelescopeResultsDiffAdd = { fg = colors.green },
    TelescopeResultsDiffChange = { fg = colors.yellow },
    TelescopeResultsDiffDelete = { fg = colors.red },
  }
end

return M
