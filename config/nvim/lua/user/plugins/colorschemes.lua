return {
  {
    "echasnovski/mini.colors",
    lazy = true,
    opts = {},
  },

  {
    "aikow/base.nvim",
    opts = {},
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
        lsp_trouble = true,
      },
    },
  },
}
