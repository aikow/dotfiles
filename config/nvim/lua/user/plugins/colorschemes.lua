return {
  {
    "echasnovski/mini.colors",
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
      style = "vulgaris", -- "vulgaris" or "multiplex"
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
        symbols_outline = true,
        lsp_trouble = true,
      },
    },
  },

  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      on_highlights = function(hl, c)
        local prompt = "2d3149"
        hl.TelescopeNormal = {
          bg = c.bg_dark,
          fg = c.fg_dark,
        }
        hl.TelescopeBorder = {
          bg = c.bg_dark,
          fg = c.bg_dark,
        }
        hl.TelescopePromptNormal = {
          bg = prompt,
        }
        hl.TelescopePromptBorder = {
          bg = prompt,
          fg = prompt,
        }
        hl.TelescopePromptTitle = {
          bg = prompt,
          fg = prompt,
        }
        hl.TelescopePreviewTitle = {
          bg = c.bg_dark,
          fg = c.bg_dark,
        }
        hl.TelescopeResultsTitle = {
          bg = c.bg_dark,
          fg = c.bg_dark,
        }
      end,
    },
  },
}
