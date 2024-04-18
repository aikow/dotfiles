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
      "Git",
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
    "echasnovski/mini.diff",
    opts = {
      view = {
        style = "sign",
        signs = { add = "│", change = "│", delete = "-" },
      },
    },
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
