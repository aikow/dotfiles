local M = {}

---@type table<string, table>
M.opts = {
  black = {
    with = { extra_args = { "--preview" } },
  },
  isort = {
    with = { extra_args = { "--profile=black" } },
  },
  jq = {
    enabled = false,
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
}

M.setup = function(_, opts)
  local null_ls = require("null-ls")
  local mason_null = require("mason-null-ls")

  null_ls.setup({
    sources = {},
  })

  mason_null.setup({
    ensure_installed = { "jq" },
    automatic_installation = false,
    automatic_setup = true,
    handlers = {
      function(source_name, methods)
        local source_opts = opts[source_name] or {}
        if source_opts.enabled == false then
          -- Skip this source
        else
          for _, method in pairs(source_opts.methods or methods) do
            null_ls.register(
              null_ls.builtins[method][source_name].with(source_opts.with or {})
            )
          end
        end
      end,
    },
  })
end

return M
