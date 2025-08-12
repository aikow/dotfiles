local M = {}

---Take a buffer as input and return the path, and won't fail for buffers like terminal buffers. If
---the path doesn't exist yet, fall back to the current directory.
---@param buf_id integer
function M.buf_path(buf_id)
  local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf_id })
  if buftype == "" then
    local path = vim.api.nvim_buf_get_name(buf_id)
    if vim.uv.fs_stat(path) then return path end
  end

  return vim.uv.cwd()
end

function M.chdir_parent()
  local path = vim.api.nvim_buf_get_name(0)
  if path ~= "" then
    local dir = vim.fs.dirname(path)
    -- NOTE: Using vim.uv.chdir doesn't update buffers
    vim.fn.chdir(dir)
    vim.notify("changed directory to\n" .. dir, vim.log.levels.INFO)
  else
    vim.notify("unable to change directory, not a valid path", vim.log.levels.WARN)
  end
end

function M.chdir_root()
  local path = vim.api.nvim_buf_get_name(0)
  if path ~= "" then
    path = vim.fs.dirname(path)
  else
    path = vim.uv.cwd()
  end
  local root = vim.fs.root(path, {
    ".editorconfig", -- general editor settings
    ".exrc", -- nvim config
    ".nvimrc",
    ".nvim.lua",
    ".git", -- git
    "Cargo.toml", -- rust
    "Makefile", -- c/c++
    "package.json", -- javascript
    "pyproject.toml", -- python
    "setup.py", -- python
  })

  if root then
    -- NOTE: Using vim.uv.chdir doesn't update buffers
    vim.fn.chdir(root)
    vim.notify("changed directory to\n" .. root, vim.log.levels.INFO)
  else
    vim.notify("unable to find a root directory", vim.log.levels.WARN)
  end
end

function M.toggle_color_column()
  if vim.o.colorcolumn == "" then
    vim.o.colorcolumn = tostring(vim.o.textwidth)
  else
    vim.o.colorcolumn = ""
  end
end

function M.toggle_diff()
  if vim.o.diff then
    vim.cmd.diffoff()
  else
    vim.cmd.diffthis()
  end
end

function M.toggle_diff_all()
  if vim.o.diff then
    vim.cmd.windo({ args = { "diffoff" } })
  else
    vim.cmd.windo({ args = { "diffthis" } })
  end
end

return M
