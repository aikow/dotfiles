vim.keymap.set("n", "<localleader>f", "<cmd>%!jq<CR>", {
  buffer = true,
  desc = "Format JSON with jq",
})
vim.keymap.set("x", "<localleader>f", "<cmd>!jq<CR>", {
  buffer = true,
  desc = "Format selected JSON with jq",
})

vim.keymap.set("n", "<localleader>c", "<cmd>%!jq -c<CR>", {
  buffer = true,
  desc = "Compact JSON with jq",
})
vim.keymap.set("x", "<localleader>c", "<cmd>!jq -c<CR>", {
  buffer = true,
  desc = "Compact selected JSON with jq",
})
