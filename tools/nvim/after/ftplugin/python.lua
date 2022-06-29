vim.opt_local.expandtab = true
vim.opt_local.autoindent = true
vim.opt_local.smarttab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.fileformat = "unix"
vim.opt_local.textwidth = 80

-- Set the indent after opening parenthesis
vim.g.pyindent_open_paren = vim.bo.shiftwidth
vim.g.pyindent_nested_paren = vim.bo.shiftwidth
vim.g.pyindent_continue = vim.bo.shiftwidth

if vim.fn.executable("black") == 1 then
  vim.opt_local.formatprg = [[black --quiet - 2>/dev/null]]
end

vim.cmd([[compiler flake8]])

if vim.fn.executable("python3") == 1 then
  vim.keymap.set("n", "<localleader>r", [[:!python3 %<CR>]])
end

-- Create a buffer local keymap to reformat, using the buffer local
-- command.
local ok_python_nvim, python_nvim = pcall(require, "python-nvim")
if ok_python_nvim then
  vim.keymap.set(
    "n",
    "<localleader>f",
    python_nvim.format,
    { silent = true, buffer = 0, desc = "reformat python with black and isort" }
  )

  vim.keymap.set(
    "n",
    "<localleader>i",
    python_nvim.flake8,
    { buffer = 0, desc = "run flake8 linting" }
  )
end
