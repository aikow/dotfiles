local M = {}

M.opts = {
  black = {
    with = { extra_args = { "--preview" } },
  },
  isort = {
    with = { extra_args = { "--profile=black" } },
  },
  prettier = {
    with = {
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
    },
  },
  ruff = {
    methods = { "formatting" },
  },
  shfmt = {
    with = {
      extra_args = { "--indent", 2, "--case-indent" },
    },
  },
  sql_formatter = {
    with = {
      extra_args = function()
        return { "-l", vim.b[0].sqllanguage or "sqlite" }
      end,
    },
  },
  yamlfmt = {
    with = {
      extra_args = {
        "-conf",
        vim.fs.normalize("~/.dotfiles/config/yamlfmt/yamlfmt"),
      },
    },
  },
}

M.setup = function(_, opts)
  local null_ls = require("null-ls")
  local mason_null = require("mason-null-ls")

  mason_null.setup({
    ensure_installed = { "jq" },
    automatic_installation = false,
    automatic_setup = true,
  })

  null_ls.setup({
    sources = {},
  })

  mason_null.setup_handlers({
    function(source_name, methods)
      local source_opts = opts[source_name] or {}
      for _, method in pairs(source_opts.methods or methods) do
        null_ls.register(
          null_ls.builtins[method][source_name].with(source_opts.with or {})
        )
      end
    end,
  })
end

return M
