vim.opt_local.conceallevel = 0

-- Markdown previewer
vim.keymap.set("n", "<localleader>r", "<cmd>MarkdownPreview<CR>", { buffer = true })
vim.keymap.set("n", "<localleader>s", "<cmd>MarkdownPreviewStop<CR>", { buffer = true })
vim.keymap.set("n", "<localleader>t", "<cmd>MarkdownPreviewToggle<CR>", { buffer = true })
