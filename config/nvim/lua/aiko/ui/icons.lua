local M = {}

M.diagnostics = {
  hint = "",
  info = "",
  warn = "",
  error = "",
}

M.packer = {
  working = "ﲊ",
  error = "✗ ",
  done = " ",
  removed = " ",
  moved = "",
}

M.mason = {
  pending = " ",
  installed = " ",
  uninstalled = "ﮊ ",
}

-- ------------------------------------------------------------------------
-- | Status Line Separators
-- ------------------------------------------------------------------------
M.separators = {
  top_slant = {
    fill = {
      right = " ",
      left = " ",
    },
    outline = {
      right = " ",
      left = " ",
    },
  },

  bottom_slant = {
    fill = {
      right = " ",
      left = " ",
    },
    outline = {
      right = " ",
      left = " ",
    },
  },

  round = {
    fill = {
      right = "",
      left = "",
    },
    outline = {
      right = "",
      left = "",
    },
  },

  block = {
    fill = {
      right = "█",
      left = "█",
    },
    outline = {
      right = "|",
      left = "|",
    },
  },

  arrow = {
    fill = {
      right = "",
      left = "",
    },
    outline = {
      right = "",
      left = "",
    },
  },
}

return M
