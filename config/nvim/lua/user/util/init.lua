local M = {}

---Feed the given string into neovim as if they were pressed by the user. All termcode and keycode
---sequences are replaced.
---@param keys string
function M.feedkeys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), "n", false)
end

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
    dir = vim.fs.dirname(path)
    vim.uv.chdir(dir)
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
    ".git", -- git
    "Cargo.toml", -- rust
    "Makefile", -- c/c++
    "package.json", -- javascript
    "pyproject.toml", -- python
    "setup.py", -- python
  })

  if root then
    vim.uv.chdir(root)
    vim.notify("changed directory to\n" .. root, vim.log.levels.INFO)
  else
    vim.notify("unable to find a root directory", vim.log.levels.WARN)
  end
end

M.skip_foldexpr = {} ---@type table<number,boolean>
local skip_check = assert(vim.uv.new_check())
function M.foldexpr()
  local buf = vim.api.nvim_get_current_buf()

  -- still in the same tick and no parser
  if M.skip_foldexpr[buf] then return "0" end

  -- don't use treesitter folds for non-file buffers
  if vim.bo[buf].buftype ~= "" then return "0" end

  -- as long as we don't have a filetype, don't bother
  -- checking if treesitter is available (it won't)
  if vim.bo[buf].filetype == "" then return "0" end

  local ok = pcall(vim.treesitter.get_parser, buf)

  if ok then return vim.treesitter.foldexpr() end

  -- no parser available, so mark it as skip
  -- in the next tick, all skip marks will be reset
  M.skip_foldexpr[buf] = true
  skip_check:start(function()
    M.skip_foldexpr = {}
    skip_check:stop()
  end)
  return "0"
end

function M.toggle_cursor_column()
  if vim.o.colorcolumn == "" then
    vim.o.colorcolumn = tostring(vim.o.textwidth)
  else
    vim.o.colorcolumn = ""
  end
end

return M
