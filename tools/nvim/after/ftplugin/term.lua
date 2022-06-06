-- Set options for terminals inside nvim.
vim.opt_local.spell = false
vim.opt_local.number = false
vim.opt_local.relativenumber = false

vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "<localleader>r",
  [[a<C-k><CR><C-\><C-n>G]],
  { noremap = true, silent = true }
)
