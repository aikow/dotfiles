-- Load immediately so that git mergetool can use the :Gvdiffsplit command.
safely("now", function()
  vim.pack.add({
    { src = gh("tpope/vim-fugitive") },
  })
end)

safely("later", function()
  vim.pack.add({
    { src = gh("NicolasGB/jj.nvim") },
  })
  require("jj").setup({
    cmd = {
      keymaps = {
        log = {
          edit = "e", -- Edit revision under cursor
          edit_immutable = "<S-e>", -- Edit revision (ignore immutability)
          describe = "d", -- Describe revision under cursor
          diff = "<S-d>", -- Diff revision under cursor
          new = "n", -- Create new change branching off
          new_after = "a", -- Create new change after revision
          new_after_immutable = "<S-n>", -- Create new change after (ignore immutability)
          undo = "u", -- Undo last operation
          redo = "<C-r>", -- Redo last undone operation
          abandon = "A", -- Abandon revision under cursor
          bookmark = "b", -- Create or move bookmark to revision under cursor
          bookmark_del = "B", -- Delete bookmark of revision under cursor
          fetch = "f", -- Fetch from remote
          push = "p", -- Push bookmark of revision under cursor
          push_all = "<S-p>", -- Push all changes to remote
          open_pr = "o", -- Open PR/MR for revision under cursor
          open_pr_list = "<S-o>", -- Open PR/MR by selecting from all bookmarks
          rebase = "r", -- Enter rebase mode targeting revision under cursor or selected revisions
          rebase_mode = {
            onto = { "<CR>", "o" }, -- Select revision under cursor as rebase onto destination
            after = "a", -- Rebase after revision under cursor
            before = "b", -- Rebase before revision under cursor
            onto_immutable = { "<S-CR>", "<S-o>" }, -- Select revision as a rebase onto destination (ignore immutability)
            after_immutable = "<S-a>", -- Rebase after revision under cursor (ignore immutability)
            before_immutable = "<S-b>", -- Rebase before revision under cursor (ignore immutability)
            exit_mode = { "q", "<C-c>" }, -- Exit rebase mode
          },
          squash = "s", -- Enter squash mode targeting revision under cursor or selected revisions
          squash_mode = {
            into = "<CR>", -- Squash into revision under cursor
            into_immutable = "<S-CR>", -- Squash into revision under cursor (ignore immutability)
            exit_mode = { "q", "<C-c>" }, -- Exit squash mode
          },
          quick_squash = "<S-s>", -- Quick squash revision under cursor into its parent (ignore immutability)
          split = "<C-s>", -- Split the revision under cursor
          history = "<S-h>", -- Show a history-aware diff for the selected revision range
          change_revset = "<C-l>", -- Change the revset(s) being viewed in the log buffer
          tag_set = "<S-t>", -- Create a tag on the revision under cursor
          summary = "<S-k>", -- Show summary tooltip for revision under cursor
          select_next_revision = "j", -- Move cursor to the next revision in the log
          select_prev_revision = "k", -- Move cursor to the previous revision in the log
          summary_tooltip = {
            diff = "<S-d>", -- Diff file at this revision
            edit = "<CR>", -- Edit revision and open file
            edit_immutable = "<S-CR>", -- Edit revision (ignore immutability) and open file
            edit_file = "o", -- Open the file under cursor in a new tab like `:Jtabedit` would
          },
        },
        -- Status buffer keymaps (set to nil to disable)
        status = {
          open_file = "<CR>", -- Open file under cursor
          restore_file = "<S-x>", -- Restore file under cursor
        },
        -- Close keymaps (shared across all buffers)
        close = "q",
        -- Floating buffer keymaps
        floating = {
          close = "q", -- Close floating buffer
          hide = "<Esc>", -- Hide floating buffer
        },
      },
    },
  })

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
