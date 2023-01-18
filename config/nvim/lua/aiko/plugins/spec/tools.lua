return {
  -- Plenary provides helper functions.
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  -- Measure startup time.
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
  },

  -- Focus a single window in zen mode.
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = function()
      require("zen-mode").setup({})
    end,
  },

  {
    "krivahtoo/silicon.nvim",
    cmd = "Silicon",
    build = "./install.sh",
    config = function()
      require("silicon").setup({ font = "Hack=16" })
    end,
  },
}
