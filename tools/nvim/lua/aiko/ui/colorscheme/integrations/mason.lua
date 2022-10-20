local M = {}

M.palette = function(_, colors)
  return {
    MasonHeader = { bg = colors.red, fg = colors.black },
    MasonHighlight = { fg = colors.blue },
    MasonHighlightBlock = { fg = colors.black, bg = colors.green },
    MasonHighlightBlockBold = { link = "MasonHighlightBlock" },
    MasonHeaderSecondary = { link = "MasonHighlightBlock" },
    MasonMuted = { fg = colors.light_grey },
    MasonMutedBlock = { fg = colors.light_grey, bg = colors.one_bg },
  }
end

return M
