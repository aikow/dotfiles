vim.keymap.set("n", "<localleader>f", "<cmd>%!jq<CR>", { silent = true, buffer = true })
vim.keymap.set("x", "<localleader>f", "<cmd>!jq<CR>", { silent = true, buffer = true })
