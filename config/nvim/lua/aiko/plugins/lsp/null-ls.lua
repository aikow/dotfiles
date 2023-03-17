local M = {}

---@type table<string, table>
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
    methods = { "diagnostics" },
  },
  shfmt = {
    with = {
      extra_args = { "--indent", 2, "--case-indent" },
    },
  },
  sql_formatter = {
    with = {
      extra_args = function()
        -- Override the default dialect using a buffer-local variable
        -- (`sqllanguage`).
        return { "-l", vim.b[0].sqllanguage or "sqlite" }
      end,
    },
  },
  yamlfmt = {
    with = {
      extra_args = function(params)
        -- Search for a `.yamlfmt` file in the parent directories. If no such
        -- file is found, fallback to using the default config file.

        -- Default config location
        local conf = vim.fs.normalize("~/.dotfiles/config/yamlfmt/yamlfmt")

        -- Options for vim.fs.find
        local find_opts = {
          upward = true,
          type = "file",
        }

        -- Unnamed buffers might not have a path (name) so only add the path if
        -- the name is not empty.
        local path = vim.api.nvim_buf_get_name(params.bufnr)
        if path ~= "" then
          find_opts.path = path
        end

        -- Check whether any parent dir contains a .yamlfmt file
        local configs = vim.fs.find(".yamlfmt", find_opts)
        if #configs > 0 then
          conf = configs[1]
        end

        -- Return default path.
        return { "-conf", conf }
      end,
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
