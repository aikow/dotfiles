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

  -- Git status signs in buffer.
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre" },
    keys = {
      {
        "]c",
        function() return vim.wo.diff and "]c" or "<cmd>Gitsigns next_hunk<CR>" end,
        mode = { "n", "v", "o" },
        expr = true,
        desc = "go to next git hunk",
      },
      {
        "[c",
        function() return vim.wo.diff and "[c" or "<cmd>Gitsigns prev_hunk<CR>" end,
        mode = { "n", "v", "o" },
        expr = true,
        desc = "go to previous git hunk",
      },
      {
        "<leader>gs",
        "<cmd>Gitsigns stage_hunk<CR>",
        mode = { "n", "v" },
        desc = "git stage hunk",
      },
      {
        "<leader>gr",
        "<cmd>Gitsigns reset_hunk<CR>",
        mode = { "n", "v" },
        desc = "git reset hunk",
      },
      {
        "<leader>gS",
        "<cmd>Gitsigns stage_buffer<CR>",
        desc = "git stage buffer",
      },
      {
        "<leader>gu",
        "<cmd>Gitsigns undo_stage_hunk<CR>",
        desc = "git undo stage buffer",
      },
      {
        "<leader>gR",
        "<cmd>Gitsigns reset_buffer<CR>",
        desc = "git reset buffer",
      },
      {
        "<leader>gp",
        "<cmd>Gitsigns preview_hunk<CR>",
        desc = "git preview hunk",
      },
      {
        "<leader>gl",
        "<cmd>Gitsigns toggle_current_line_blame<CR>",
        desc = "git toggle inline blame",
      },
      {
        "<leader>gd",
        "<cmd>Gitsigns diffthis<CR>",
        desc = "git diff current file",
      },
      {
        "<leader>gD",
        "<cmd>Gitsigns toggle_deleted<CR>",
        desc = "git toggle showing deleted lines",
      },
      {
        "ic",
        ":<C-u>Gitsigns select_hunk<CR>",
        mode = { "o", "x" },
        desc = "git hunk text object",
      },
    },
    opts = {
      signs = {
        add = { hl = "DiffAdd", text = "│", numhl = "GitSignsAddNr" },
        change = {
          hl = "DiffChange",
          text = "│",
          numhl = "GitSignsChangeNr",
        },
        delete = {
          hl = "DiffDelete",
          text = "-",
          numhl = "GitSignsDeleteNr",
        },
        topdelete = {
          hl = "DiffDelete",
          text = "‾",
          numhl = "GitSignsDeleteNr",
        },
        changedelete = {
          hl = "DiffChangeDelete",
          text = "~",
          numhl = "GitSignsChangeNr",
        },
      },
      preview_config = {
        border = "rounded",
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
