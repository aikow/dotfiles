-- stylua: ignore start
local map = vim.keymap.set

-- Treat long lines as break lines.
map("n", "j", "gj")
map("n", "k", "gk")

-- Don't deselect visual when indenting in visual mode.
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Refactoring
map("n", "<leader>rs", ":%s/",      { desc = "search and replace" })
map("x", "<leader>rs", ":s/",       { desc = "region search and replace" })
map("n", "<leader>rS", ":cfdo %s/", { desc = "global search and replace" })

-- Toggle
map("n", "<leader>tz", "<cmd>set invspell<CR>",                             { desc = "toggle spellcheck" })
map("n", "<leader>tw", "<cmd>set invwrap<CR>",                              { desc = "toggle wrap" })
map("n", "<leader>td", require("mini.basics").toggle_diagnostic,            { desc = "toggle diagnostics" })
map("n", "<leader>tD", require("user.util.lsp").toggle_virtual_diagnostics, { desc = "toggle virtual diagnostics" })
map("n", "<leader>tl", require("user.util").toggle_cursor_column,           { desc = "toggle virtual diagnostics" })
map("n", "<leader>ti", require("user.util.lsp").toggle_inlay_hints,         { desc = "toggle inlay hints" })

-- Spelling
map("i", "<C-.>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { desc = "correct last spelling mistake" })

-- Set the working directory
map("n", "g.", require("user.util").chdir_parent, { desc = "set the working directory to the dir of the current file" })
map("n", "g>", require("user.util").chdir_root,   { desc = "recursively search for a root directory from the current file" })

-- Clear the search buffer to remove highlighting from the last search.
map("n", "<C-/>", ":let @/ = ''<CR>", { desc = "clear search buffer register", silent = true })
map("n", "<C-_>", ":let @/ = ''<CR>", { desc = "clear search buffer register", silent = true })

-- Select the text that was last pasted
map("n", "gp", "'`[' . strpart(getregtype(), 0,  1) . '`]'", { expr = true, desc = "select the last pasted region" })

-- Automatically jump to the end of text when yanking and pasting
map("x", "y", "y`]")
map({ "x", "n" }, "p", "p`]")

-- Make Y behave like other capital numbers
map("n", "Y", "y$")

-- Keep it centered
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Undo breakpoints while typing
map("i", ",", ",<C-g>u")
map("i", ".", ".<C-g>u")
map("i", "!", "!<C-g>u")
map("i", "?", "?<C-g>u")

-- Faster pane resizing
map("n", "<C-w><", "5<C-w><")
map("n", "<C-w>>", "5<C-w>>")
map("n", "<C-w>-", "5<C-w>-")
map("n", "<C-w>+", "5<C-w>+")

-- Shortcuts for inserting filename, directory name, and full path into command mode.
map("c", "%H", "<C-R>=expand('%:h:p') . '/'<CR>")
map("c", "%T", "<C-R>=expand('%:t')<CR>")
map("c", "%P", "<C-R>=expand('%:p')<CR>")

-- Open a terminal session in a split.
map("n", "<leader>wb", "<cmd>split term://bash<CR>" ,    { desc = "open bash in a horizontal split" })
map("n", "<leader>wB", "<cmd>vsplit term://bash<CR>",    { desc = "open bash in a horizontal split" })
map("n", "<leader>wf", "<cmd>split term://fish<CR>" ,    { desc = "open fish in a horizontal split" })
map("n", "<leader>wF", "<cmd>vsplit term://fish<CR>",    { desc = "open fish in a vertical split" })
map("n", "<leader>wl", "<cmd>vsplit term://lazygit<CR>", { desc = "open lazygit in a vertical split" })
map('n', '<leader>ws', ":split term://" ,                { desc = "open a command in a horizontal split" })
map("n", "<leader>wv", ":vsplit term://",                { desc = "open a command in a vertical split" })
map("n", "<leader>wt", ":tabnew term://",                { desc = "open a command in a new tab" })
map("n", "<leader>wz", "<cmd>split term://zsh<CR>",      { desc = "open zsh in a horizontal split" })
map("n", "<leader>wZ", "<cmd>vsplit term://zsh<CR>",     { desc = "open zsh in a vertical split" })

-- Toggles between most recent buffers
map("n", "<leader><leader>", "<c-^>", { desc = "switch to most recent buffer" })

-- Replacing up to next _
map("n", "<leader>c", "ct_", { desc = "change upto next underscore '_'" })

-- Source the current buffer.
map("n", "<leader>.", "<cmd>source %<CR>", { desc = "source current file" })

-- Enter a lua command.
map("n", "<leader>e", ":lua =", { desc = "evaluate lua expression" })
map("n", "<leader>E", ":lua ",  { desc = "evaluate lua statement" })
