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
      left = " ",
      right = " ",
    },
    outline = {
      left = " ",
      right = " ",
    },
  },

  bottom_slant = {
    fill = {
      left = " ",
      right = " ",
    },
    outline = {
      left = " ",
      right = " ",
    },
  },

  round = {
    fill = {
      left = "",
      right = "",
    },
    outline = {
      left = "",
      right = "",
    },
  },

  block = {
    fill = {
      left = "█",
      right = "█",
    },
    outline = {
      left = "|",
      right = "|",
    },
  },

  arrow = {
    fill = {
      left = "",
      right = "",
    },
    outline = {
      left = "",
      right = "",
    },
  },
}

return M
