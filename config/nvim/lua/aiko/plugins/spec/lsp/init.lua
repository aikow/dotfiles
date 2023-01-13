return {
  -- ------------------
  -- |   LSP Config   |
  -- ------------------
  --
  -- Provide adapter and helper functions for setting up language servers.
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
    },
    event = { "BufReadPre" },
    config = function()
      require("aiko.plugins.spec.lsp.config").setup()
    end,
  },

  -- Hook into the builtin LSP features.
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    event = "BufReadPre",
    config = function()
      local null_ls = require("null-ls")
      local builtins = null_ls.builtins

      null_ls.setup({
        sources = {
          -- Lua
          builtins.formatting.stylua,

          -- Markdown
          builtins.formatting.markdownlint,

          -- SQL
          builtins.formatting.sql_formatter.with({
            extra_args = function()
              return { "-l", vim.b.sqllanguage or "sqlite" }
            end,
          }),

          -- Python
          builtins.formatting.black,
          builtins.diagnostics.ruff,

          -- JSON
          builtins.formatting.jq,

          builtins.formatting.prettier,

          -- YAML
          builtins.formatting.yamlfmt.with({
            extra_args = {
              "-conf",
              vim.fs.normalize("~/.dotfiles/config/yamlfmt/yamlfmt"),
            },
          }),
        },
      })
    end,
  },

  -- -----------------------------
  -- |   Mason Package Manager   |
  -- -----------------------------
  --
  -- Easily install any LSP, DAP, linter, or formatter from inside neovim.
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
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

      require("mason-lspconfig").setup({
        ensure_installed = { "sumneko_lua" },
      })
    end,
  },

  -- JSON schemastore integration for JSON LS.
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
  },

  -- SQL language server helper.
  {
    "nanotee/sqls.nvim",
    enabled = false,
    lazy = true,
    ft = "sql",
  },
}
