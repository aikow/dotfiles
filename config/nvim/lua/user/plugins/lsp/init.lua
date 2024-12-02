return {
  -- Provide adapter and helper functions for setting up language servers.
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "folke/lazydev.nvim", opts = {} },
    },
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
        { "rust_analyzer", setup = "lspconfig", install = false },
        { "nushell", setup = "lspconfig", install = false },
      },
    },
    config = require("user.plugins.lsp.lspconfig").setup,
  },

  -- Easily install any LSP, DAP, linter, or formatter from inside neovim.
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },

  -- JSON schemastore integration for JSON LS.
  {
    "b0o/SchemaStore.nvim",
  },
}
