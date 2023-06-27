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
    end,
  },

  -- Use '.' to repeat plugin code actions.
  { "tpope/vim-repeat" },

  {
    "echasnovski/mini.bufremove",
    opts = {},
  },
}
