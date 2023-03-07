return {
  -- Provide adapter and helper functions for setting up language servers.
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    event = { "BufReadPre" },
    opts = {
      autoformat = true,
      servers = {
        "bashls",
        "clangd",
        "dockerls",
        "gopls",
        "jsonls",
        "ltex",
        "marksman",
        "pyright",
        "sqls",
        "lua_ls",
        "taplo",
        "tsserver",
        "yamlls",
      },
    },
    config = require("aiko.plugins.lsp.lspconfig").setup,
  },

  -- Hook into the builtin LSP features.
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
    event = "BufReadPre",
    opts = require("aiko.plugins.lsp.null-ls").opts,
    config = require("aiko.plugins.lsp.null-ls").setup,
  },

  -- Easily install any LSP, DAP, linter, or formatter from inside neovim.
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonLog",
      "MasonUninstall",
      "MasonUninstallAll",
    },
    config = function()
      local icons = require("aiko.ui.icons").mason

      require("mason").setup({
        ui = {
          icons = {
            package_pending = icons.pending,
            package_installed = icons.installed,
            package_uninstalled = icons.uninstalled,
          },
        },
      })
    end,
  },

  -- JSON schemastore integration for JSON LS.
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
  },

  -- A tree like view for symbols using LSP.
  {
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
    config = function()
      require("symbols-outline").setup({
        symbol_blacklist = {},
        autofold_depth = 2,
        keymaps = {
          close = { "<Esc>", "q" },
          code_actions = "a",
          focus_location = "o",
          fold = "h",
          fold_all = "W",
          fold_reset = "R",
          goto_location = "<CR>",
          hover_symbol = { "<C-space>", "K" },
          rename_symbol = "r",
          toggle_preview = "p",
          unfold = "l",
          unfold_all = "E",
        },
      })
    end,
  },

  -- SQL language server helper.
  {
    "nanotee/sqls.nvim",
    enabled = false,
    lazy = true,
    ft = "sql",
  },

  -- Neovim development with lua.
  {
    "folke/neodev.nvim",
    enabled = true,
    ft = { "lua" },
    config = function()
      require("neodev").setup({})
    end,
  },
}
