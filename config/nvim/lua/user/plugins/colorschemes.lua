return {
  {
    "aikow/base.nvim",
    opts = {
      integrations = {
        "builtin.defaults",
        "builtin.git",
        "builtin.lsp",
        "builtin.semantic",
        "builtin.statusline",
        "builtin.syntax",
        "builtin.terminal",
        "builtin.treesitter",
        "plugin.indent-blankline",
        "plugin.luasnip",
        "plugin.mason",
        "plugin.mini",
        "plugin.treesitter",
      },
    },
  },

  {
    "ribru17/bamboo.nvim",
    opts = {
      style = "multiplex",
    },
  },

  {
    "rebelot/kanagawa.nvim",
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
    opts = {
      integrations = {
        diffview = true,
        mason = true,
      },
    },
  },
}
