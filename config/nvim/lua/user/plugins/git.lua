MiniDeps.later(function()
  MiniDeps.add({ source = "tpope/vim-fugitive" })

  MiniDeps.add({
    source = "sindrets/diffview.nvim",
    depends = { "nvim-lua/plenary.nvim" },
  })

  local actions = require("diffview.config").actions
  require("diffview").setup({
    keymaps = {
      -- stylua: ignore
      view = {
        { "n", "<leader>e", nil },
        { "n", "<leader>b", nil },
        { "n", "<leader>bf", actions.focus_files, { desc = "Bring focus to the file panel of the subject." }, },
        { "n", "<leader>bb", actions.toggle_files, { desc = "Toggle the file panel." }, },
      },
    },
  })

  vim.keymap.set(
    "n",
    "<leader>gg",
    "<cmd>DiffviewOpen<CR>",
    { desc = "open a diff against the current index" }
  )
end)
