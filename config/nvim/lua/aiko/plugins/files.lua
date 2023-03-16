return {
  -- View tree-like structures from different providers.
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "miversen33/netman.nvim",
    },
    cmd = { "Neotree" },
    keys = {
      { "_", "<cmd>Neotree reveal=true<CR>", desc = "reveal file in neo-tree" },
    },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
    end,
    opts = {
      sources = {
        "filesystem",
        "netman.ui.neo-tree",
      },
      filesystem = {
        hijack_netrw_behavior = "disabled",
        use_libuv_file_watcher = true,
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
    end,
  },

  -- Interface for remote network protocols.
  {
    "miversen33/netman.nvim",
    lazy = true,
    config = function()
      require("netman")
    end,
  },

  -- Enhance vim's builtin netrw plugin.
  {
    "tpope/vim-vinegar",
  },
}
