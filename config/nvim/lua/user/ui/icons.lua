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
  Class = "ﴯ",
  Color = "",
  Constant = "",
  Constructor = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "ﰠ",
  File = "",
  Folder = "",
  Function = "",
  Interface = "",
  Keyword = "",
  Method = "",
  Module = "",
  Operator = "",
  Property = "ﰠ",
  Reference = "",
  Snippet = "",
  Struct = "פּ",
  Text = "",
  TypeParameter = "",
  Unit = "塞",
  Value = "",
  Variable = "",
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
    Constant = " ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = " ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
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
    Snippet = " ",
    String = " ",
    Struct = " ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = " ",
  },
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
