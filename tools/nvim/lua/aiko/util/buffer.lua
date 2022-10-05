local M = {}

M.close_buffer = function(force)
  if vim.bo.buftype == "terminal" then
    vim.api.nvim_win_hide(0)
    return
  end

  local fileExists = vim.fn.filereadable(vim.fn.expand("%p"))
  local modified = vim.api.nvim_buf_get_option(vim.fn.bufnr(), "modified")

  -- if file doesnt exist & its modified
  if fileExists == 0 and modified then
    print("no file name? add it now!")
    return
  end

  force = force or not vim.bo.buflisted or vim.bo.buftype == "nofile"

  -- if not force, change to prev buf and then close current
  local close_cmd = force and ":bd!" or ":bp | bd" .. vim.fn.bufnr()
  vim.cmd(close_cmd)
end

return M
