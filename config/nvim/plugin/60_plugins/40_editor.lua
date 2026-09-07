safely("later", function()
  vim.pack.add({
    { src = gh("lukas-reineke/indent-blankline.nvim") },
  })

  require("ibl").setup({
    indent = { char = "▏" },
  })
end)

safely("later", function()
  vim.pack.add({
    { src = gh("yorickpeterse/nvim-pqf") },
  })

  require("pqf").setup()
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
  nmap("<M-h>", "<cmd>TmuxNavigateLeft<CR>",             "Navigate left with tmux")
  nmap("<M-j>", "<cmd>TmuxNavigateDown<CR>",             "Navigate down with tmux")
  nmap("<M-k>", "<cmd>TmuxNavigateUp<CR>",               "Navigate up with tmux")
  nmap("<M-l>", "<cmd>TmuxNavigateRight<CR>",            "Navigate right with tmux")
  nmap("<M-o>", "<cmd>TmuxNavigatePrevious<CR>",         "Navigate to the previous pane")

  imap("<M-h>", [[<esc>:TmuxNavigateLeft<CR>]],          "Navigate left with tmux")
  imap("<M-j>", [[<esc>:TmuxNavigateDown<CR>]],          "Navigate down with tmux")
  imap("<M-k>", [[<esc>:TmuxNavigateUp<CR>]],            "Navigate up with tmux")
  imap("<M-l>", [[<esc>:TmuxNavigateRight<CR>]],         "Navigate right with tmux")
  imap("<M-o>", [[<esc>:TmuxNavigatePrevious<CR>]],      "Navigate to the previous pane")

  tmap("<M-h>", [[<C-\><C-n>:TmuxNavigateLeft<CR>]],     "Navigate left with tmux")
  tmap("<M-j>", [[<C-\><C-n>:TmuxNavigateDown<CR>]],     "Navigate down with tmux")
  tmap("<M-k>", [[<C-\><C-n>:TmuxNavigateUp<CR>]],       "Navigate up with tmux")
  tmap("<M-l>", [[<C-\><C-n>:TmuxNavigateRight<CR>]],    "Navigate right with tmux")
  tmap("<M-o>", [[<C-\><C-n>:TmuxNavigatePrevious<CR>]], "Navigate to the previous pane")
  -- stylua: ignore end
end)
