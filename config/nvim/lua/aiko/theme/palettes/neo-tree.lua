local M = {}

M.palette = function(_, colors)
  return {
    NeoTreeNormal = { bg = colors.darker_black },
    NeoTreeNormalNC = { bg = colors.darker_black },
    NeoTreeWinSeparator = { fg = colors.darker_black, bg = colors.darker_black },
    NeoTreeEndOfBuffer = { fg = colors.darker_black },

    NeoTreeCursorLine = { bg = colors.black2 },
    NeoTreeIndentMarker = { fg = colors.grey_fg },

    NeoTreeDirectoryIcon = { fg = colors.folder_bg },
    NeoTreeDirectoryName = { fg = colors.folder_bg },

    NeoTreeFileNameOpened = { fg = colors.folder_bg },
    NeoTreeDotfile = { fg = colors.folder_bg, italic = true },
    NeoTreeFileIcon = { fg = colors.folder_bg },
    NeoTreeFileName = { fg = colors.folder_bg },
    NeoTreeRootName = { fg = colors.red, bold = true },

    NeoTreeGitAdded = { fg = colors.yellow },
    NeoTreeGitConflict = { fg = colors.red, bold = true },
    NeoTreeGitDeleted = { fg = colors.red },
    NeoTreeGitIgnored = { fg = colors.light_grey },
    NeoTreeGitModified = { fg = colors.red },
    NeoTreeGitUnstaged = { fg = colors.yellow },
    NeoTreeGitUntracked = { fg = colors.blue },
    NeoTreeGitStaged = {},

    NeoTreeBufferNumber = {},
    NeoTreeDimText = {},
    NeoTreeFilterTerm = {},
    NeoTreeFloatBorder = {},
    NeoTreeFloatTitle = {},
    NeoTreeHiddenByName = {},
    NeoTreeExpander = {},
    NeoTreeSignColumn = {},
    NeoTreeStatusLine = {},
    NeoTreeStatusLineNC = {},
    NeoTreeVertSplit = {},
    NeoTreeSymbolicLinkTarget = {},
    NeoTreeTitleBar = {},
    NeoTreeWindowsHidden = {},
  }
end

return M
