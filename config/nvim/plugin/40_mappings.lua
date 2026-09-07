local map = vim.keymap.set

-- ------------------------------------------------------------------------
-- | Helper
-- ------------------------------------------------------------------------
local H = {}

function H.chdir_parent()
  local path = vim.api.nvim_buf_get_name(0)
  if path ~= "" then
    local dir = vim.fs.dirname(path)
    -- NOTE: Using vim.uv.chdir doesn't update buffers
    vim.fn.chdir(dir)
    vim.notify("changed directory to\n" .. dir, vim.log.levels.INFO)
  else
    vim.notify("unable to change directory, not a valid path", vim.log.levels.WARN)
  end
end

function H.chdir_root()
  local path = vim.api.nvim_buf_get_name(0)
  if path ~= "" then
    path = vim.fs.dirname(path)
  else
    path = vim.uv.cwd()
  end
  local root = vim.fs.root(path, {
    ".editorconfig", -- general editor settings
    ".exrc", -- nvim config
    ".nvimrc",
    ".nvim.lua",
    ".git", -- git
    "Cargo.toml", -- rust
    "Makefile", -- c/c++
    "package.json", -- javascript
    "pyproject.toml", -- python
    "setup.py", -- python
  })

  if root then
    -- NOTE: Using vim.uv.chdir doesn't update buffers
    vim.fn.chdir(root)
    vim.notify("changed directory to\n" .. root, vim.log.levels.INFO)
  else
    vim.notify("unable to find a root directory", vim.log.levels.WARN)
  end
end

function H.toggle_color_column()
  if vim.o.colorcolumn == "" then
    vim.o.colorcolumn = tostring(vim.o.textwidth)
  else
    vim.o.colorcolumn = ""
  end
end

function H.toggle_diff()
  if vim.o.diff then
    vim.cmd.diffoff()
  else
    vim.cmd.diffthis()
  end
end

function H.toggle_diff_all()
  if vim.o.diff then
    vim.cmd.windo({ args = { "diffoff" } })
  else
    vim.cmd.windo({ args = { "diffthis" } })
  end
end

---Switch between showing virtual diagnostics after each line and below each line.
function H.toggle_diagnostic_virtual_lines()
  local config = vim.diagnostic.config()
  if config then
    config.virtual_lines = not config.virtual_lines
    config.virtual_text = not config.virtual_text
    vim.diagnostic.config(config)
  end
end

---Toggle showing inlay hints.
function H.toggle_inlay_hints() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end

-- ------------------------------------------------------------------------
-- | Mappings
-- ------------------------------------------------------------------------

-- stylua: ignore start
-- Treat long lines as break lines.
map("n", "j", "gj", { desc = "Move down by display line" })
map("n", "k", "gk", { desc = "Move up by display line" })

-- Don't deselect visual when indenting in visual mode.
map("x", "<", "<gv", { desc = "Unindent and keep the selection" })
map("x", ">", ">gv", { desc = "Indent and keep the selection" })

-- Refactoring
map("n", "<leader>rs", ":%s/",      { desc = "Search and replace" })
map("x", "<leader>rs", ":s/",       { desc = "Search and replace the region" })
map("n", "<leader>rS", ":cfdo %s/", { desc = "Search and replace globally" })

-- Toggle
map("n", "<leader>tD", H.toggle_diagnostic_virtual_lines, { desc = "Toggle diagnostic.virtual_lines" })
map("n", "<leader>tu", H.toggle_color_column,             { desc = "Toggle colorcolumn" })
map("n", "<leader>tn", H.toggle_inlay_hints,              { desc = "Toggle vim.lsp inlay hints" })
map("n", "<leader>tx", H.toggle_diff,                     { desc = "Toggle diff mode" })
map("n", "<leader>tX", H.toggle_diff_all,                 { desc = "Toggle diff mode for all windows" })

-- Spelling
map("i", "<C-.>", "<C-G>u<Esc>[s1z=`]a<C-G>u", { desc = "Correct the last spelling mistake" })

-- Set the working directory
map("n", "g.", H.chdir_parent, { desc = "Change to the file directory" })
map("n", "g>", H.chdir_root,   { desc = "Find and change to the project root" })

-- Clear the search buffer to remove highlighting from the last search.
map("n", "<C-/>", ":let @/ = ''<CR>", { desc = "Clear the search register", silent = true })
map("n", "<C-_>", ":let @/ = ''<CR>", { desc = "Clear the search register", silent = true })

-- Select the text that was last pasted
map("n", "gp", "'`[' . strpart(getregtype(), 0, 1) . '`]'", { expr = true, desc = "Select the last pasted region" })

-- Automatically jump to the end of text when yanking and pasting
map("x", "y", "y`]", { desc = "Jump to the end after yanking" })
map({ "x", "n" }, "p", "p`]", { desc = "Jump to the end after pasting" })

-- Make Y behave like other capital letters
map("n", "Y", "y$", { desc = "Yank to the end of the line" })

-- Keep it centered
map("n", "n", "nzzzv", { desc = "Center the next match" })
map("n", "N", "Nzzzv", { desc = "Center the previous match" })

-- Undo breakpoints while typing
map("i", ",", ",<C-G>u", { desc = "Create an undo breakpoint" })
map("i", ".", ".<C-G>u", { desc = "Create an undo breakpoint" })
map("i", "!", "!<C-G>u", { desc = "Create an undo breakpoint" })
map("i", "?", "?<C-G>u", { desc = "Create an undo breakpoint" })

-- Faster pane resizing
map("n", "<C-W><", "5<C-W><", { desc = "Decrease window width" })
map("n", "<C-W>>", "5<C-W>>", { desc = "Increase window width" })
map("n", "<C-W>-", "5<C-W>-", { desc = "Decrease window height" })
map("n", "<C-W>+", "5<C-W>+", { desc = "Increase window height" })

-- Shortcuts for inserting filename, directory name, and full path into command mode.
map("c", "%H", "<C-R>=expand('%:h:p') . '/'<CR>", { desc = "Insert the current directory" })
map("c", "%T", "<C-R>=expand('%:t')<CR>", { desc = "Insert the current filename" })
map("c", "%P", "<C-R>=expand('%:p')<CR>", { desc = "Insert the current file path" })

-- Retain normal history navigation with wildtrigger()
map('c', '<Up>', '<C-U><Up>', { desc = "Show the previous command" })
map('c', '<Down>', '<C-U><Down>', { desc = "Show the next command" })

-- Open a terminal session in a split.
map("n", "<leader>wb", "<Cmd>split term://bash<CR>",     { desc = "Open a bash terminal horizontally" })
map("n", "<leader>wB", "<Cmd>vsplit term://bash<CR>",    { desc = "Open a bash terminal vertically" })
map("n", "<leader>wf", "<Cmd>split term://fish<CR>",     { desc = "Open a fish terminal horizontally" })
map("n", "<leader>wF", "<Cmd>vsplit term://fish<CR>",    { desc = "Open a fish terminal vertically" })
map('n', '<leader>ws', ":split term://",                  { desc = "Open a command terminal horizontally" })
map("n", "<leader>wv", ":vsplit term://",               { desc = "Open a command terminal vertically" })
map("n", "<leader>wt", ":tabnew term://",               { desc = "Open a command terminal in a tab" })
map("n", "<leader>wz", "<Cmd>split term://zsh<CR>",      { desc = "Open a zsh terminal horizontally" })
map("n", "<leader>wZ", "<Cmd>vsplit term://zsh<CR>",     { desc = "Open a zsh terminal vertically" })

-- Toggles between most recent buffers
map("n", "<leader><leader>", "<c-^>", { desc = "Switch to the last buffer" })

-- Replacing up to next _
map("n", "<leader>c", "ct_", { desc = "Change up to _" })

-- Source the current buffer.
map("n", "<leader>.", "<Cmd>source %<CR>", { desc = "Source the current file" })

-- Enter a lua command.
map("n", "<leader>e", ":lua =", { desc = "Evaluate a Lua expression" })
map("n", "<leader>E", ":lua ",  { desc = "Evaluate a Lua statement" })
-- stylua: ignore end
