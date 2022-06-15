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

M.autocmd = function(name, autocmds, clear)
  clear = clear ~= nil and clear or true

  if autocmds.event ~= nil then
    autocmds = { autocmds }
  end

  local group = vim.api.nvim_create_augroup(name, { clear = clear })

  for _, autocmd in ipairs(autocmds) do
    vim.api.nvim_create_autocmd(autocmd.event, {
      group = group,
      pattern = autocmd.pattern,
      buffer = autocmd.buffer,
      desc = autocmd.desc,
      callback = autocmd.callback,
      command = autocmd.command,
      once = autocmd.once,
      nested = autocmd.nested,
    })
  end
end

return M
