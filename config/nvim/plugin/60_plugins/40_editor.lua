safely("later", function()
  vim.pack.add({
    { src = gh("lukas-reineke/indent-blankline.nvim") },
  })

  require("ibl").setup({
    indent = { char = "▏" },
  })
end)

safely("later", function()
  vim.g.tmux_navigator_no_mappings = 1
  vim.g.tmux_navigator_disable_when_zoomed = 1

  vim.pack.add({
    { src = gh("christoomey/vim-tmux-navigator") },
  })

  local map = vim.keymap.set
  local nmap = function(lhs, rhs, desc) map("n", lhs, rhs, { desc = desc, silent = true }) end
  local imap = function(lhs, rhs, desc) map("i", lhs, rhs, { desc = desc, silent = true }) end
  local tmap = function(lhs, rhs, desc) map("t", lhs, rhs, { desc = desc, silent = true }) end

  -- stylua: ignore start
  nmap("<M-h>", "<cmd>TmuxNavigateLeft<CR>",             "tmux navigate left")
  nmap("<M-j>", "<cmd>TmuxNavigateDown<CR>",             "tmux navigate down")
  nmap("<M-k>", "<cmd>TmuxNavigateUp<CR>",               "tmux navigate up")
  nmap("<M-l>", "<cmd>TmuxNavigateRight<CR>",            "tmux navigate right")
  nmap("<M-o>", "<cmd>TmuxNavigatePrevious<CR>",         "tmux navigate previous")

  imap("<M-h>", [[<esc>:TmuxNavigateLeft<CR>]],          "tmux navigate left")
  imap("<M-j>", [[<esc>:TmuxNavigateDown<CR>]],          "tmux navigate down")
  imap("<M-k>", [[<esc>:TmuxNavigateUp<CR>]],            "tmux navigate up")
  imap("<M-l>", [[<esc>:TmuxNavigateRight<CR>]],         "tmux navigate right")
  imap("<M-o>", [[<esc>:TmuxNavigatePrevious<CR>]],      "tmux navigate previous")

  tmap("<M-h>", [[<C-\><C-n>:TmuxNavigateLeft<CR>]],     "tmux navigate left")
  tmap("<M-j>", [[<C-\><C-n>:TmuxNavigateDown<CR>]],     "tmux navigate down")
  tmap("<M-k>", [[<C-\><C-n>:TmuxNavigateUp<CR>]],       "tmux navigate up")
  tmap("<M-l>", [[<C-\><C-n>:TmuxNavigateRight<CR>]],    "tmux navigate right")
  tmap("<M-o>", [[<C-\><C-n>:TmuxNavigatePrevious<CR>]], "tmux navigate previous")
  -- stylua: ignore end
end)
