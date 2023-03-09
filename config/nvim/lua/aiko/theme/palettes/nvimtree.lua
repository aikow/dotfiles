local M = {}

M.palette = function(_, colors)
  return {
    NvimTreeCursorLine = { bg = colors.black2 },
    NvimTreeEmptyFolderName = { fg = colors.folder_bg },
    NvimTreeEndOfBuffer = { fg = colors.darker_black },
    NvimTreeFolderIcon = { fg = colors.folder_bg },
    NvimTreeFolderName = { fg = colors.folder_bg },
    NvimTreeGitDeleted = { fg = colors.red },
    NvimTreeGitDirty = { fg = colors.red },
    NvimTreeGitIgnored = { fg = colors.light_grey },
    NvimTreeGitNew = { fg = colors.yellow },
    NvimTreeIndentMarker = { fg = colors.grey_fg },
    NvimTreeNormal = { bg = colors.darker_black },
    NvimTreeOpenedFolderName = { fg = colors.folder_bg },
    NvimTreeRootFolder = { fg = colors.red, bold = true },
    NvimTreeSpecialFile = { fg = colors.yellow, bold = true },
    NvimTreeWinSeparator = {
      fg = colors.darker_black,
      bg = colors.darker_black,
    },
    NvimTreeWindowPicker = { fg = colors.red, bg = colors.black2 },
  }
end

return M
