vim.keymap.set(
  "n",
  "<localleader>r",
  "<cmd>%!jq<CR>",
  { silent = true, buffer = true }
)

vim.keymap.set(
  "x",
  "<localleader>r",
  "<cmd>!jq<CR>",
  { silent = true, buffer = true }
)
