local M = {}

M.palette = function(theme, colors)
  return {
    StatusLine = { bg = colors.statusline_bg },
    StatusLineGitIcons = {
      fg = colors.light_grey,
      bg = colors.statusline_bg,
      bold = true,
    },

    -- LSP
    StatusLineLspError = { fg = colors.red, bg = colors.statusline_bg },
    StatusLineLspWarning = { fg = colors.yellow, bg = colors.statusline_bg },
    StatusLineLspHints = { fg = colors.purple, bg = colors.statusline_bg },
    StatusLineLspInfo = { fg = colors.green, bg = colors.statusline_bg },
    StatusLineLspStatus = { fg = colors.nord_blue, bg = colors.statusline_bg },
    StatusLineLspProgress = { fg = colors.green, bg = colors.statusline_bg },
    StatusLineLspStatusIcon = { fg = colors.black, bg = colors.nord_blue },

    -- MODES
    StatusLineNormalMode = {
      bg = colors.nord_blue,
      fg = colors.black,
      bold = true,
    },
    StatusLineInsertMode = {
      bg = colors.dark_purple,
      fg = colors.black,
      bold = true,
    },
    StatusLineTerminalMode = {
      bg = colors.green,
      fg = colors.black,
      bold = true,
    },
    StatusLineNTerminalMode = {
      bg = colors.yellow,
      fg = colors.black,
      bold = true,
    },
    StatusLineVisualMode = {
      bg = colors.cyan,
      fg = colors.black,
      bold = true,
    },
    StatusLineReplaceMode = {
      bg = colors.orange,
      fg = colors.black,
      bold = true,
    },
    StatusLineConfirmMode = {
      bg = colors.teal,
      fg = colors.black,
      bold = true,
    },
    StatusLineCommandMode = {
      bg = colors.green,
      fg = colors.black,
      bold = true,
    },
    StatusLineSelectMode = {
      bg = colors.nord_blue,
      fg = colors.black,
      bold = true,
    },

    -- ------------------------------------------------------------------------
    -- | Separators
    -- ------------------------------------------------------------------------
    StatusLineNormalModeSep = { fg = colors.nord_blue, bg = colors.grey },
    StatusLineInsertModeSep = { fg = colors.dark_purple, bg = colors.grey },
    StatusLineTerminalModeSep = { fg = colors.green, bg = colors.grey },
    StatusLineNTerminalModeSep = { fg = colors.yellow, bg = colors.grey },
    StatusLineVisualModeSep = { fg = colors.cyan, bg = colors.grey },
    StatusLineReplaceModeSep = { fg = colors.orange, bg = colors.grey },
    StatusLineConfirmModeSep = { fg = colors.teal, bg = colors.grey },
    StatusLineCommandModeSep = { fg = colors.green, bg = colors.grey },
    StatusLineSelectModeSep = { fg = colors.nord_blue, bg = colors.grey },

    -- ------------------------------------------------------------------------
    -- | Modules
    -- ------------------------------------------------------------------------

    StatusLineEmptySpace = { fg = colors.grey, bg = colors.lightbg },
    StatusLineEmptySpace2 = { fg = colors.grey, bg = colors.statusline_bg },

    StatusLineFileInfo = { bg = colors.lightbg, fg = colors.white },
    StatusLineFileSep = { bg = colors.statusline_bg, fg = colors.lightbg },

    StatusLineCwdIcon = { fg = colors.one_bg, bg = colors.red },
    StatusLineCwdText = { fg = colors.white, bg = colors.lightbg },
    StatusLineCwdSep = { fg = colors.red, bg = colors.statusline_bg },

    StatusLinePosSep = { fg = colors.green, bg = colors.lightbg },
    StatusLinePosIcon = { fg = colors.black, bg = colors.green },
    StatusLinePosText = { fg = colors.green, bg = colors.lightbg },

    StatusLineActiveTab = { fg = colors.white, bg = colors.red },
    StatusLineInactiveTab = { fg = colors.grey, bg = colors.black },

    -- ------------------------------------------------------------------------
    -- | Tab Line
    -- ------------------------------------------------------------------------
    TabLine = { bg = colors.black2 },
  }
end

return M
