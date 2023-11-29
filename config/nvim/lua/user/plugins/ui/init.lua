return {
  {
    "rebelot/heirline.nvim",
    config = function() require("user.plugins.ui.heirline").config() end,
  },

  {
    "echasnovski/mini.starter",
    event = "VimEnter",
    opts = require("user.plugins.ui.starter").opts,
    config = require("user.plugins.ui.starter").config,
  },

  -- Show indentation.
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup({
        exclude = {
          filetypes = {
            "",
            "Outline",
            "TelescopePrompt",
            "TelescopeResults",
            "help",
            "lazy",
            "lspinfo",
            "man",
            "mason",
            "norg",
            "starter",
            "terminal",
          },
          buftypes = {
            "terminal",
          },
        },
      })
    end,
  },

  -- Override neovim default UI components for user input.
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        insert_only = false,
        start_in_insert = true,
        win_options = {
          winblend = 0,
          winhighlight = "NormalFloat:DiagnosticError",
        },
      },
      select = {
        backend = { "telescope" },
      },
    },
  },

  -- Dev icons for file types.
  {
    "nvim-tree/nvim-web-devicons",
  },
}
