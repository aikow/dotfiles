local M = {}

---@type table<string, table>
M.opts = {
  black = {
    with = { extra_args = { "--preview" } },
  },
  fish_indent = {
    null = true,
    methods = { "formatting" },
  },
  fish = {
    null = true,
    methods = { "diagnostics" },
  },
  isort = {
    with = { extra_args = { "--profile=black" } },
  },
  jq = {},
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
  stylua = {
    null = true,
    methods = { "formatting" },
  },
}

M.setup = function(_, opts)
  local null_ls = require("null-ls")
  local mason_null = require("mason-null-ls")

  local mason_sources = {}
  local null_sources = {}

  -- Partition the sources into sources managed by mason and sources managed
  -- directly by null-ls. The partitioning is done by checking the `null`
  -- field of the source's options.
  for source_name, source_opts in pairs(opts) do
    source_opts = source_opts or {}
    -- If `null` isn't a table field, default to false.
    if source_opts.null then
      for _, method in pairs(source_opts.methods or {}) do
        table.insert(
          null_sources,
          null_ls.builtins[method][source_name].with(source_opts.with or {})
        )
      end
    else
      mason_sources[source_name] = source_opts
    end
  end

  mason_null.setup({
    ensure_installed = { "jq" },
    automatic_installation = false,
    automatic_setup = true,
    handlers = {
      -- Use the generic handler function to inject extra arguments for the
      -- sources.
      function(source_name, methods)
        local source_opts = mason_sources[source_name] or {}

        -- Set a default value for `enabled`.
        if source_opts.enabled == nil then
          source_opts.enabled = true
        end

        if source_opts.enabled then
          for _, method in pairs(source_opts.methods or methods) do
            null_ls.register(
              null_ls.builtins[method][source_name].with(source_opts.with or {})
            )
          end
        end
      end,
    },
  })

  -- Setup all sources not managed by mason-null-ls.
  null_ls.setup({
    sources = null_sources,
  })
end

return M
