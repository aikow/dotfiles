local M = {}

M.mason = {
  pending = " ",
  installed = " ",
  uninstalled = " ",
}

-- ------------------------------------------------------------------------
-- | Diagnostics
-- ------------------------------------------------------------------------
M.diagnostics = {
  hint = " ",
  info = " ",
  warn = " ",
  error = " ",
}

-- ------------------------------------------------------------------------
-- | Status Line Separators
-- ------------------------------------------------------------------------
M.separators = {
  top_slant = {
    fill = {
      left = "",
      right = "",
    },
    outline = {
      left = "",
      right = "",
    },
  },

  bottom_slant = {
    fill = {
      left = "",
      right = "",
    },
    outline = {
      left = "",
      right = "",
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

  half = {
    fill = {
      left = "▐",
      right = "▌",
    },
    outline = {
      left = "|",
      right = "|",
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
