local map = vim.keymap.set

-- Treat long lines as break lines.
map("n", "j", "gj")
map("n", "k", "gk")

-- Don't deselect visual when indenting in visual mode.
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Very magic regexps by default.
map("n", "?", [[?\v]])
map("n", "/", [[/\v]])
map("n", "<leader>rs", [[:%s/\v]], { desc = "search and replace" })
map("x", "<leader>rs", [[:s/\v]], { desc = "region search and replace" })
map("n", "<leader>rS", [[:cfdo %s/\v]], { desc = "global search and replace" })

-- Correct last spelling mistake
map("n", "<leader>zz", "<cmd>set invspell<CR>", { desc = "toggle spellcheck" })
map("n", "<leader>zw", "<cmd>set invwrap<CR>", { desc = "toggle wrap" })
map("i", "<C-.>", [[<C-g>u<Esc>[s1z=`]a<C-g>u]], { desc = "correct last spelling mistake" })

-- Set the working directory
map("n", "g.", function()
  local path = vim.api.nvim_buf_get_name(0)
  if path ~= "" then
    vim.fn.chdir(vim.fs.dirname(path))
  else
    vim.notify("unable to change directory, not a valid path", vim.log.levels.WARN)
  end
end, { desc = "set the working directory to the dir of the current file" })
map("n", "g>", function()
  local path = vim.api.nvim_buf_get_name(0)
  if path ~= "" then
    path = vim.fs.dirname(path)
  else
    path = vim.uv.cwd() or vim.fn.getcwd()
  end
  local root = vim.fs.root(path, {
    ".editorconfig", -- general editor settings
    ".exrc", -- nvim config
    ".git", -- git
    "Cargo.toml", -- rust
    "Makefile", -- c/c++
    "package.json", -- javascript
    "pyproject.toml", -- python
    "setup.py", -- python
  })

  if root then
    vim.fn.chdir(root)
  else
    vim.notify("unable to find a root directory", vim.log.levels.WARN)
  end
end, { desc = "recursively search for a root directory from the current file" })

-- Clear the search buffer to remove highlighting from the last search. The extra mapping for <C-_>
-- is needed for alacritty.
map("n", "<C-/>", [[:let @/ = ""<CR>]], { desc = "clear search buffer register" })
map("n", "<C-_>", [[:let @/ = ""<CR>]], { desc = "clear search buffer register" })

-- Select the text that was last pasted
map(
  "n",
  "gp",
  [['`[' . strpart(getregtype(), 0,  1) . '`]']],
  { expr = true, desc = "select the last pasted region" }
)
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

-- Open Netrw in the current window
map("n", "+", "<CMD>Explore<CR>")

-- Shortcuts for inserting filename, directory name, and full path into command mode.
map("c", "%H", [[<C-R>=expand('%:h:p') . '/'<CR>]])
map("c", "%T", [[<C-R>=expand('%:t')<CR>]])
map("c", "%P", [[<C-R>=expand('%:p')<CR>]])

-- Open a terminal session in a split.
map("n", "<M-v>", "<cmd>vsplit term://fish<CR>", { desc = "open a shell in a vertical split" })
map("n", "<M-s>", "<cmd>split term://fish<CR>", { desc = "open a shell in a horizontal split" })
map("n", "<M-t>", "<cmd>tabnew term://fish<CR>", { desc = "open a shell in a tab page" })

-- Toggles between most recent buffers
map("n", "<leader><leader>", "<c-^>", { desc = "switch to most recent buffer" })

-- Replacing up to next _
map("n", "<leader>c", "ct_", { desc = "change upto next underscore '_'" })

-- Source the current buffer.
map("n", "<leader>.", "<cmd>source %<CR>", { desc = "source lua or vimscript file" })

-- Enter a lua command.
map("n", "<leader>e", [[:lua =]], { desc = "evaluate lua expression" })
map("n", "<leader>E", [[:lua ]], { desc = "evaluate lua statement" })
