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
        "sumneko_lua",
        "taplo",
        "tsserver",
        "yamlls",
      },
    },
    config = function(_, opts)
      require("aiko.plugins.spec.lsp.setup").setup(opts)
    end,
  },

  -- Hook into the builtin LSP features.
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
    },
    event = "BufReadPre",
    config = function()
      local null_ls = require("null-ls")
      local builtins = null_ls.builtins

      -- local registry = require("mason-registry")
      -- local packages = registry.get_installed_packages()
      -- local sources = {}
      --
      -- for _, package in pairs(packages) do
      --   for cat in package.spec.categories do
      --     if cat == "Formatter" then
      --       table.insert(sources, builtins.formatting[package.name])
      --     elseif cat == "Linter" then
      --       table.insert(sources, builtins.linter[package.name])
      --     end
      --   end
      -- end

      null_ls.setup({
        sources = {
          -- Lua
          builtins.formatting.stylua,

          -- -- Markdown
          -- builtins.formatting.markdownlint,

          -- SQL
          builtins.formatting.sql_formatter.with({
            extra_args = function()
              return { "-l", vim.b.sqllanguage or "sqlite" }
            end,
          }),

          -- Python
          builtins.formatting.black,
          -- builtins.diagnostics.ruff,

          -- JSON
          builtins.formatting.jq,

          -- Shell scripts
          builtins.formatting.shfmt.with({
            extra_args = {
              "--indent",
              2,
              "--case-indent",
            },
          }),

          -- typescript, javascript, html,{css
          builtins.formatting.prettier.with({
            filetypes = {
              "handlebars",
              "javascript",
              -- "jsonc",
              "typescriptreact",
              "scss",
              "graphql",
              -- "markdown.mdx",
              -- "markdown",
              "html",
              -- "json",
              -- "yaml",
              "css",
              "vue",
              "less",
              "javascriptreact",
              "typescript",
            },
          }),

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
