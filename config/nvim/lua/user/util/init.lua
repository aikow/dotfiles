local M = {}

---Feed the given string into neovim as if they were pressed by the user. All
---termcode and keycode sequences are replaced.
---@param keys string
M.feedkeys = function(keys)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(keys, true, true, true),
    "n",
    false
  )
end

---Take a buffer as input and return the path, and won't fail for buffers like
---terminal buffers.
---@param buf_id integer
M.buf_path = function(buf_id)
  local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf_id })
  if buftype == "" then
    return vim.api.nvim_buf_get_name(buf_id)
  else
    return vim.fn.getcwd()
  end
end

return M
