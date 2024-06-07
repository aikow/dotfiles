return {
  -- Using git from inside vim.
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "GBrowse",
      "Gcd",
      "Gclog",
      "GDelete",
      "Gdiffsplit",
      "Gdrop",
      "Gedit",
      "Ggrep",
      "Ghdiffsplit",
      "Glcd",
      "Glgrep",
      "Gllog",
      "GMove",
      "Gpedit",
      "Gread",
      "GRemove",
      "GRename",
      "Gsplit",
      "Gtabedit",
      "GUnlink",
      "Gvdiffsplit",
      "Gvsplit",
      "Gwq",
      "Gwrite",
    },
  },

  {
    "echasnovski/mini-git",
    main = "mini.git",
    dependencies = {
      -- Load vim-fugitive first so that the Git command from mini.git overrides the one from
      -- vim-fugitive.
      "tpope/vim-fugitive",
    },
    opts = {},
    config = function(_, opts)
      local minigit = require("mini.git")
      minigit.setup(opts)

      vim.keymap.set(
        { "n", "x" },
        "<leader>gk",
        minigit.show_at_cursor,
        { desc = "mini.git show object at cursor" }
      )
      vim.keymap.set(
        "n",
        "<leader>gd",
        minigit.show_diff_source,
        { desc = "mini.git show diff source at cursor position" }
      )
      vim.keymap.set(
        { "n", "x" },
        "<leader>gl",
        minigit.show_range_history,
        { desc = "mini.git show history of visual selection" }
      )
    end,
  },

  {
    "echasnovski/mini.diff",
    opts = {
      view = {
        style = "sign",
        signs = { add = "│", change = "│", delete = "-" },
      },
    },
    config = function(_, opts)
      local minidiff = require("mini.diff")
      minidiff.setup(opts)

      vim.keymap.set(
        "n",
        "<leader>gO",
        minidiff.toggle_overlay,
        { desc = "mini.diff toggle overlay" }
      )
    end,
  },

  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewLog",
      "DiffviewOpen",
      "DiffviewRefresh",
      "DiffviewToggleFiles",
    },
    keys = {
      {
        "<leader>gg",
        "<cmd>DiffviewOpen<CR>",
        desc = "open a diff against the current index.",
      },
    },
    opts = function()
      local actions = require("diffview.config").actions
      return {
        keymaps = {
          -- stylua: ignore
          view = {
            { "n", "<leader>e", nil },
            { "n", "<leader>b", nil },
            { "n", "<leader>bf", actions.focus_files, { desc = "Bring focus to the file panel of the subject." }, },
            { "n", "<leader>bb", actions.toggle_files, { desc = "Toggle the file panel." }, },
          },
        },
      }
    end,
  },
}
