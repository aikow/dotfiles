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
map("n", "<leader>tD", H.toggle_diagnostic_virtual_lines, { desc = "Toggle diagnostic.virtual_lines" })
map("n", "<leader>tu", H.toggle_color_column,             { desc = "Toggle 'colorcolumn'" })
map("n", "<leader>tn", H.toggle_inlay_hints,              { desc = "Toggle lsp.inlay_hints" })
map("n", "<leader>tx", H.toggle_diff,                     { desc = "Toggle 'diff'" })
map("n", "<leader>tX", H.toggle_diff_all,                 { desc = "Toggle 'diff' (all)" })

-- Spelling
map("i", "<C-.>", "<C-G>u<Esc>[s1z=`]a<C-G>u", { desc = "correct last spelling mistake" })

-- Set the working directory
map("n", "g.", H.chdir_parent, { desc = "set the working directory to the dir of the current file" })
map("n", "g>", H.chdir_root,   { desc = "recursively search for a root directory from the current file" })

-- Clear the search buffer to remove highlighting from the last search.
map("n", "<C-/>", ":let @/ = ''<CR>", { desc = "clear search buffer register", silent = true })
map("n", "<C-_>", ":let @/ = ''<CR>", { desc = "clear search buffer register", silent = true })

-- Select the text that was last pasted
map("n", "gp", "'`[' . strpart(getregtype(), 0, 1) . '`]'", { expr = true, desc = "select the last pasted region" })

-- Automatically jump to the end of text when yanking and pasting
map("x", "y", "y`]")
map({ "x", "n" }, "p", "p`]")

-- Make Y behave like other capital numbers
map("n", "Y", "y$")

-- Keep it centered
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Undo breakpoints while typing
map("i", ",", ",<C-G>u")
map("i", ".", ".<C-G>u")
map("i", "!", "!<C-G>u")
map("i", "?", "?<C-G>u")

-- Faster pane resizing
map("n", "<C-W><", "5<C-W><")
map("n", "<C-W>>", "5<C-W>>")
map("n", "<C-W>-", "5<C-W>-")
map("n", "<C-W>+", "5<C-W>+")

-- Shortcuts for inserting filename, directory name, and full path into command mode.
map("c", "%H", "<C-R>=expand('%:h:p') . '/'<CR>")
map("c", "%T", "<C-R>=expand('%:t')<CR>")
map("c", "%P", "<C-R>=expand('%:p')<CR>")

-- Retain normal history navigation with wildtrigger()
map('c', '<Up>', '<C-U><Up>')
map('c', '<Down>', '<C-U><Down>')

-- Open a terminal session in a split.
map("n", "<leader>wb", "<Cmd>split term://bash<CR>",     { desc = "open bash (horizontal)" })
map("n", "<leader>wB", "<Cmd>vsplit term://bash<CR>",    { desc = "open bash (horizontal)" })
map("n", "<leader>wf", "<Cmd>split term://fish<CR>",     { desc = "open fish (horizontal)" })
map("n", "<leader>wF", "<Cmd>vsplit term://fish<CR>",    { desc = "open fish (vertical)" })
map("n", "<leader>wl", "<Cmd>tabnew term://lazygit<CR>", { desc = "open lazygit (tab)" })
map('n', '<leader>ws', ":split term://",                 { desc = "open a command (horizontal)" })
map("n", "<leader>wv", ":vsplit term://",                { desc = "open a command (vertical)" })
map("n", "<leader>wt", ":tabnew term://",                { desc = "open a command (tab)" })
map("n", "<leader>wz", "<Cmd>split term://zsh<CR>",      { desc = "open zsh (horizontal)" })
map("n", "<leader>wZ", "<Cmd>vsplit term://zsh<CR>",     { desc = "open zsh (vertical)" })

-- Toggles between most recent buffers
map("n", "<leader><leader>", "<c-^>", { desc = "switch to most recent buffer" })

-- Replacing up to next _
map("n", "<leader>c", "ct_", { desc = "change upto next underscore '_'" })

-- Source the current buffer.
map("n", "<leader>.", "<Cmd>source %<CR>", { desc = "source current file" })

-- Enter a lua command.
map("n", "<leader>e", ":lua =", { desc = "evaluate lua expression" })
map("n", "<leader>E", ":lua ",  { desc = "evaluate lua statement" })
-- stylua: ignore end
