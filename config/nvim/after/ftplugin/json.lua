vim.keymap.set("n", "<localleader>f", "<cmd>%!jq<CR>", { buffer = true })
vim.keymap.set("x", "<localleader>f", "<cmd>!jq<CR>", { buffer = true })

vim.keymap.set("n", "<localleader>c", "<cmd>%!jq -c<CR>", { buffer = true })
vim.keymap.set("x", "<localleader>c", "<cmd>!jq -c<CR>", { buffer = true })
