local M = {}

M.setup = function()
  local ok_null_ls, null_ls = pcall(require, "null-ls")
  if not ok_null_ls then
    return
  end

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

      -- YAML
      builtins.formatting.yamlfmt.with({
        extra_args = {
          "-conf",
          vim.fs.normalize("~/.dotfiles/config/yamlfmt/yamlfmt"),
        },
      }),
    },
  })
end

return M
