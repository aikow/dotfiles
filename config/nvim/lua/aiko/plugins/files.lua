return {
  -- File tree in a sidebar.
  {
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeFocus" },
    keys = {
      {
        "_",
        "<cmd>NvimTreeFindFile<CR>",
        silent = true,
        desc = "open nvim-tree",
      },
    },
    config = function()
      local nvim_tree = require("nvim-tree")

      nvim_tree.setup({
        hijack_netrw = false,
        hijack_cursor = true,
        update_cwd = true,
        update_focused_file = {
          enable = true,
          update_cwd = false,
        },
        view = {
          width = 40,
          hide_root_folder = true,
        },
        actions = {
          open_file = {
            resize_window = false,
          },
        },
        renderer = {
          highlight_git = true,
          highlight_opened_files = "none",
        },
      })
    end,
  },

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
    cmd = {
      "Neotree",
      "NeoTreeLogs",
      "NeoTreeShow",
      "NeoTreeClose",
      "NeoTreeFloat",
      "NeoTreeFocus",
      "NeoTreeReveal",
      "NeoTreeShowToggle",
      "NeoTreeFloatToggle",
      "NeoTreeFocusToggle",
      "NeoTreePasteConfig",
      "NeoTreeSetLogLevel",
      "NeoTreeShowInSplit",
      "NeoTreeRevealToggle",
      "NeoTreeRevealInSplit",
      "NeoTreeShowInSplitToggle",
      "NeoTreeRevealInSplitToggle",
    },
    config = function()
      vim.g.neo_tree_remote_legacy_commands = 1

      require("neo-tree").setup({
        sources = {
          "filesystem",
          "netman.ui.neo-tree",
        },
      })
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
