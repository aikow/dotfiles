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

M.lspkind = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "ﰠ",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "塞",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "פּ",
  Event = "",
  Operator = "",
  TypeParameter = "",
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
