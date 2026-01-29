local H = {}

---Take a buffer as input and return the path, and won't fail for buffers like terminal buffers. If
---the path doesn't exist yet, fall back to the current directory.
---@param buf_id integer
function H.buf_path_or_cwd(buf_id)
  local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf_id })
  if buftype == "" then
    local path = vim.api.nvim_buf_get_name(buf_id)
    if vim.uv.fs_stat(path) then return path end
  end

  return vim.uv.cwd()
end

return H
