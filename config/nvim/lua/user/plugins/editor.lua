return {

  -- Plenary provides helper functions.
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  -- Effortlessly switch between vim and tmux windows.
  {
    "christoomey/vim-tmux-navigator",
    config = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.g.tmux_navigator_disable_when_zoomed = 1

      -- Tmux / vim navigation
      -- stylua: ignore start
      vim.keymap.set("n", "<M-h>", "<cmd>TmuxNavigateLeft<CR>", { silent = true, desc = "tmux navigate left" })
      vim.keymap.set("n", "<M-j>", "<cmd>TmuxNavigateDown<CR>", { silent = true, desc = "tmux navigate down" })
      vim.keymap.set("n", "<M-k>", "<cmd>TmuxNavigateUp<CR>", { silent = true, desc = "tmux navigate up" })
      vim.keymap.set("n", "<M-l>", "<cmd>TmuxNavigateRight<CR>", { silent = true, desc = "tmux navigate right" })
      vim.keymap.set("n", "<M-o>", "<cmd>TmuxNavigatePrevious<CR>", { silent = true, desc = "tmux navigate previous" })

      vim.keymap.set("i", "<M-h>", [[<esc>:TmuxNavigateLeft<CR>]], { silent = true, desc = "tmux navigate left" })
      vim.keymap.set("i", "<M-j>", [[<esc>:TmuxNavigateDown<CR>]], { silent = true, desc = "tmux navigate down" })
      vim.keymap.set("i", "<M-k>", [[<esc>:TmuxNavigateUp<CR>]], { silent = true, desc = "tmux navigate up" })
      vim.keymap.set("i", "<M-l>", [[<esc>:TmuxNavigateRight<CR>]], { silent = true, desc = "tmux navigate right" })
      vim.keymap.set("i", "<M-o>", [[<esc>:TmuxNavigatePrevious<CR>]], { silent = true, desc = "tmux navigate previous" })

      vim.keymap.set("t", "<M-h>", [[<C-\><C-n>:TmuxNavigateLeft<CR>]], { silent = true, desc = "tmux navigate left" })
      vim.keymap.set("t", "<M-j>", [[<C-\><C-n>:TmuxNavigateDown<CR>]], { silent = true, desc = "tmux navigate down" })
      vim.keymap.set("t", "<M-k>", [[<C-\><C-n>:TmuxNavigateUp<CR>]], { silent = true, desc = "tmux navigate up" })
      vim.keymap.set("t", "<M-l>", [[<C-\><C-n>:TmuxNavigateRight<CR>]], { silent = true, desc = "tmux navigate right" })
      vim.keymap.set("t", "<M-o>", [[<C-\><C-n>:TmuxNavigatePrevious<CR>]], { silent = true, desc = "tmux navigate previous" })
      -- stylua: ignore end
    end,
  },

  -- Use '.' to repeat plugin code actions.
  { "tpope/vim-repeat" },

  {
    "echasnovski/mini.bufremove",
    opts = {},
  },
}
