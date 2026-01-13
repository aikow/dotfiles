vim.wo.conceallevel = 0

-- Markdown previewer
vim.keymap.set(
  "n",
  "<localleader>v",
  "<cmd>Markview toggle<CR>",
  { desc = "markview toggle", buffer = true }
)
