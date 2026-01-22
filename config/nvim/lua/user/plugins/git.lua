-- Load immediately so that git mergetool can use the :Gvdiffsplit command.
MiniDeps.now(function()
  vim.pack.add({
    { src = gh("tpope/vim-fugitive") },
  })
end)

MiniDeps.later(function()
  vim.pack.add({
    { src = gh("nvim-lua/plenary.nvim") },
    { src = gh("sindrets/diffview.nvim") },
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
