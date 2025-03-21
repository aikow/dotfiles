-- Need to run vim-vinegar immediately so that all settings are applied when opening a directory via
-- the cmdline.
MiniDeps.now(function() MiniDeps.add({ source = "tpope/vim-vinegar" }) end)

MiniDeps.later(function()
  vim.g.tmux_navigator_no_mappings = 1
  vim.g.tmux_navigator_disable_when_zoomed = 1

  MiniDeps.add({ source = "christoomey/vim-tmux-navigator" })

  -- stylua: ignore start
  vim.keymap.set("n", "<M-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "tmux navigate left" })
  vim.keymap.set("n", "<M-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "tmux navigate down" })
  vim.keymap.set("n", "<M-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "tmux navigate up" })
  vim.keymap.set("n", "<M-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "tmux navigate right" })
  vim.keymap.set("n", "<M-o>", "<cmd>TmuxNavigatePrevious<CR>", { desc = "tmux navigate previous" })

  vim.keymap.set("i", "<M-h>", [[<esc>:TmuxNavigateLeft<CR>]], { desc = "tmux navigate left" })
  vim.keymap.set("i", "<M-j>", [[<esc>:TmuxNavigateDown<CR>]], { desc = "tmux navigate down" })
  vim.keymap.set("i", "<M-k>", [[<esc>:TmuxNavigateUp<CR>]], { desc = "tmux navigate up" })
  vim.keymap.set("i", "<M-l>", [[<esc>:TmuxNavigateRight<CR>]], { desc = "tmux navigate right" })
  vim.keymap.set("i", "<M-o>", [[<esc>:TmuxNavigatePrevious<CR>]], { desc = "tmux navigate previous" })

  vim.keymap.set("t", "<M-h>", [[<C-\><C-n>:TmuxNavigateLeft<CR>]], { desc = "tmux navigate left" })
  vim.keymap.set("t", "<M-j>", [[<C-\><C-n>:TmuxNavigateDown<CR>]], { desc = "tmux navigate down" })
  vim.keymap.set("t", "<M-k>", [[<C-\><C-n>:TmuxNavigateUp<CR>]], { desc = "tmux navigate up" })
  vim.keymap.set("t", "<M-l>", [[<C-\><C-n>:TmuxNavigateRight<CR>]], { desc = "tmux navigate right" })
  vim.keymap.set("t", "<M-o>", [[<C-\><C-n>:TmuxNavigatePrevious<CR>]], { desc = "tmux navigate previous" })
  -- stylua: ignore end
end)
