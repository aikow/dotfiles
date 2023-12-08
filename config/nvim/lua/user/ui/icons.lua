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
-- | LSP
-- ------------------------------------------------------------------------
M.lsp = {
  kinds = {
    Array = " ",
    Boolean = " ",
    Class = " ",
    Color = " ",
    Constant = " ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = "󰊕 ",
    Interface = " ",
    Key = " ",
    Keyword = "󰌋 ",
    Method = " ",
    Module = " ",
    Namespace = " ",
    Null = " ",
    Number = " ",
    Object = " ",
    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = " ",
    String = " ",
    Struct = " ",
    Text = " ",
    TypeParameter = " ",
    Unit = "塞",
    Value = " ",
    Variable = "󰫧 ",
  },
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
