local map = vim.keymap.set

map("n", "<localleader>s", "<cmd>luafile %<CR>", { buffer = true })
