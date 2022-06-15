vim.opt_local.expandtab = true
vim.opt_local.autoindent = true
vim.opt_local.smarttab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.fileformat = "unix"
vim.opt_local.textwidth = 80

-- Create a buffer local keymap to reformat, using the buffer local
-- command.
vim.keymap.set(
  "n",
  "<localleader>rf",
  require("python-nvim").format,
  { silent = true, buffer = 0, desc = "reformat python with black and isort" }
)

vim.keymap.set(
  "n",
  "<localleader>if",
  require("python-nvim").flake8,
  { buffer = 0, desc = "run flake8 linting" }
)
