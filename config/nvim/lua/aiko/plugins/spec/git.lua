return {
  -- -----------
  -- |   Git   |
  -- -----------
  --
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
      -- Navigation
      {
        mode = { "n", "v", "o" },
        "]c",
        function()
          return vim.wo.diff and "]c" or "<cmd>Gitsigns next_hunk<CR>"
        end,
        expr = true,
        silent = true,
        desc = "go to next git hunk",
      },

      {
        mode = { "n", "v", "o" },
        "[c",
        function()
          return vim.wo.diff and "[c" or "<cmd>Gitsigns prev_hunk<CR>"
        end,
        expr = true,
        silent = true,
        desc = "go to previous git hunk",
      },

      -- Git actions related actions with <leader>g...
      {
        mode = { "n", "v" },
        "<leader>gs",
        "<cmd>Gitsigns stage_hunk<CR>",
        silent = true,
        desc = "git stage hunk",
      },
      {
        "<leader>gr",
        "<cmd>Gitsigns reset_hunk<CR>",
        mode = { "n", "v" },
        silent = true,
        desc = "git reset hunk",
      },
      {
        "<leader>gS",
        "<cmd>Gitsigns stage_buffer<CR>",
        mode = "n",
        silent = true,
        desc = "git stage buffer",
      },
      {
        "<leader>gu",
        "<cmd>Gitsigns undo_stage_hunk<CR>",
        mode = "n",
        silent = true,
        desc = "git undo stage buffer",
      },
      {
        "<leader>gR",
        "<cmd>Gitsigns reset_buffer<CR>",
        mode = "n",
        silent = true,
        desc = "git reset buffer",
      },
      {
        "<leader>gp",
        "<cmd>Gitsigns preview_hunk<CR>",
        mode = "n",
        silent = true,
        desc = "git preview hunk",
      },
      {
        "<leader>gl",
        "<cmd>Gitsigns toggle_current_line_blame<CR>",
        mode = "n",
        silent = true,
        desc = "git toggle inline blame",
      },
      {
        "<leader>gd",
        "<cmd>Gitsigns diffthis<CR>",
        mode = "n",
        silent = true,
        desc = "git diff current file",
      },
      {
        "<leader>gD",
        "<cmd>Gitsigns toggle_deleted<CR>",
        mode = "n",
        silent = true,
        desc = "git toggle showing deleted lines",
      },

      -- Text object
      {
        "ic",
        ":<C-u>Gitsigns select_hunk<CR>",
        mode = { "o", "x" },
        silent = true,
        desc = "git hunk text object",
      },
    },
    config = function()
      require("gitsigns").setup({
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
      })
    end,
  },
}
