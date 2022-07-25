local M = {}

M.setup = function()
  local ok_null_ls, null_ls = pcall(require, "null-ls")
  if not ok_null_ls then
    return
  end

  local builtins = null_ls.builtins

  null_ls.setup({
    sources = {
      builtins.formatting.stylua,
      builtins.formatting.black,
    },
  })
end

return M
