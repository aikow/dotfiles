return {
  {
    "echasnovski/mini.colors",
    lazy = true,
    opts = {},
  },

  {
    "aikow/base.nvim",
    opts = {
      integrations = {
        "builtin.defaults",
        "builtin.git",
        "builtin.lsp",
        "builtin.semantic",
        "builtin.syntax",
        "builtin.terminal",
        "builtin.treesitter",
        "plugin.cmp",
        "plugin.devicons",
        "plugin.fzf-lua",
        "plugin.heirline",
        "plugin.indent-blankline",
        "plugin.luasnip",
        "plugin.mason",
        "plugin.mini",
        "plugin.neo-tree",
        "plugin.neorg",
        "plugin.telescope",
        "plugin.treesitter",
      },
    },
  },

  {
    "ribru17/bamboo.nvim",
    lazy = true,
    opts = {
      -- "vulgaris" or "multiplex"
      style = "vulgaris",
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin.nvim",
    lazy = true,
    opts = {
      integrations = {
        gitsigns = true,
        indent_blankline = {
          enabled = true,
          color_indent_levels = false,
        },
        markdown = true,
        mason = true,
        mini = true,
        neotree = true,
        cmp = true,
        dap = true,
        treesitter = true,
      },
    },
  },
}
