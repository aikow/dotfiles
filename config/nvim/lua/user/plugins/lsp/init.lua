return {
  -- Provide adapter and helper functions for setting up language servers.
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "folke/lazydev.nvim", opts = {} },
      "cmp-nvim-lsp",
    },
    event = { "BufReadPre" },
    opts = {
      servers = {
        "bashls",
        "jsonls",
        "ltex",
        "lua_ls",
        "marksman",
        "pyright",
        "taplo",
        "yamlls",
        { "nushell", setup = "lspconfig", install = false },
      },
    },
    config = require("user.plugins.lsp.lspconfig").setup,
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
    build = ":MasonUpdate",
    config = function()
      local icons = require("user.ui.icons").mason

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
}
