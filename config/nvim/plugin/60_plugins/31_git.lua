-- Load immediately so that git mergetool can use the :Gvdiffsplit command.
safely(
  "now",
  function()
    vim.pack.add({
      { src = gh("tpope/vim-fugitive") },
      { src = gh("tpope/vim-rhubarb") },
      { src = gh("shumphrey/fugitive-gitlab.vim") },
    })
  end
)

safely("later", function()
  vim.pack.add({
    { src = gh("NicolasGB/jj.nvim") },
  })
  require("jj").setup({})

  local cmd = require("jj.cmd")
  vim.keymap.set(
    "n",
    "<leader>jl",
    function() cmd.log({ limit = 50 }) end,
    { desc = "Show the jj log" }
  )
end)

safely("later", function()
  vim.pack.add({
    { src = gh("dlyongemallo/diffview-plus.nvim") },
  })

  local actions = require("diffview.config").actions
  require("diffview").setup({
    keymaps = {
      -- stylua: ignore
      view = {
        { "n", "<leader>e", nil },
        { "n", "<leader>b", nil },
        { "n", "<leader>bf", actions.focus_files, { desc = "Focus the diff file panel" }, },
        { "n", "<leader>bb", actions.toggle_files, { desc = "Toggle the diff file panel" }, },
      },
    },
  })

  vim.keymap.set(
    "n",
    "<leader>gg",
    "<cmd>DiffviewOpen<CR>",
    { desc = "Open a diff against the index" }
  )
end)

safely("later", function()
  vim.pack.add({
    { src = gh("linrongbin16/gitlinker.nvim") },
  })

  local map = vim.keymap.set
    -- stylua: ignore start
    map({ "n", "x" }, "<leader>yB",  "<Cmd>GitLink blame current_branch",       { desc = "Copy git blame link for branch" })
    map({ "n", "x" }, "<leader>yb",  "<Cmd>GitLink blame <CR>",                 { desc = "Copy git blame permalink" })
    map({ "n", "x" }, "<leader>yG",  "<Cmd>GitLink browse current_branch<CR>",  { desc = "Copy git link for branch" })
    map({ "n", "x" }, "<leader>yg",  "<Cmd>GitLink browse<CR>",                 { desc = "Copy git permalink" })
    map({ "n", "x" }, "<leader>yoB", "<Cmd>GitLink! blame current_branch<CR>",  { desc = "Open git blame link for branch" })
    map({ "n", "x" }, "<leader>yob", "<Cmd>GitLink! blame<CR>",                 { desc = "Open git blame permalink" })
    map({ "n", "x" }, "<leader>yoG", "<Cmd>GitLink! browse current_branch<CR>", { desc = "Open git link for branch" })
    map({ "n", "x" }, "<leader>yog", "<Cmd>GitLink! browse<CR>",               { desc = "Open git permalink" })
  -- stylua: ignore end
end)
