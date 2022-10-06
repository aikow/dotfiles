local M = {}

M.setup = function()
  local ok_null_ls, null_ls = pcall(require, "null-ls")
  if not ok_null_ls then
    return
  end

  local builtins = null_ls.builtins

  null_ls.setup({
    sources = {
      builtins.formatting.black,
      builtins.formatting.stylua,
      builtins.formatting.markdownlint,
      builtins.formatting.sql_formatter.with({
        extra_args = function()
          return { "-l", vim.b.sqllanguage or "sqlite" }
        end,
      }),
    },
  })
end

return M
