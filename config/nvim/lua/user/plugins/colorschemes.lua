return {
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
      style = "multiplex",
    },
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {
      overrides = function()
        return {
          ["@comment.todo.comment"] = { bg = "none" },
          ["@comment.note.comment"] = { bg = "none" },
          ["@comment.error.comment"] = { bg = "none" },
          ["@comment.warning.comment"] = { bg = "none" },
        }
      end,
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin.nvim",
    lazy = true,
    opts = {
      integrations = {
        gitsigns = false,
        indent_blankline = {
          enabled = true,
          color_indent_levels = false,
        },
        markdown = true,
        mason = true,
        mini = true,
        neotree = false,
        cmp = true,
        dap = false,
        treesitter = true,
      },
    },
  },
}
