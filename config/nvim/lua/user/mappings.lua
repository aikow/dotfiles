-- Treat long lines as break lines.
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- Don't deselect visual when indenting in visual mode>
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")

-- Very magic regexps by default.
vim.keymap.set("n", "?", [[?\v]])
vim.keymap.set("n", "/", [[/\v]])
vim.keymap.set("n", "<C-s>", [[:%s/\v]])
vim.keymap.set("x", "<C-s>", [[:s/\v]])
vim.keymap.set("c", "<C-s>", [[%s/\v]])

vim.keymap.set(
  "i",
  "<C-s>",
  [[<C-g>u<Esc>[s1z=`]a<C-g>u]],
  { desc = "correct last spelling mistake" }
)

-- Clear the search buffer to remove highlighting from the last search
vim.keymap.set(
  "n",
  "<C-_>",
  [[:let @/ = ""<CR>]],
  { silent = true, desc = "clear search buffer register" }
)
vim.keymap.set(
  "n",
  "<C-/>",
  [[:let @/ = ""<CR>]],
  { silent = true, desc = "clear search buffer register" }
)

-- Select the text that was last pasted
vim.keymap.set(
  "n",
  "gp",
  [['`[' . strpart(getregtype(), 0,  1) . '`]']],
  { expr = true, desc = "select the last pasted region" }
)
-- Automatically jump to the end of pasted text
vim.keymap.set("x", "y", "y`]")
vim.keymap.set({ "x", "n" }, "p", "p`]")

-- Make Y behave like other capital numbers
vim.keymap.set("n", "Y", "y$")

-- Keep it centered
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Undo breakpoints while typing
vim.keymap.set("i", ",", ",<C-g>u")
vim.keymap.set("i", ".", ".<C-g>u")
vim.keymap.set("i", "!", "!<C-g>u")
vim.keymap.set("i", "?", "?<C-g>u")

-- Faster pane resizing
vim.keymap.set("n", "<C-w><", "5<C-w><")
vim.keymap.set("n", "<C-w>>", "5<C-w>>")
vim.keymap.set("n", "<C-w>-", "5<C-w>-")
vim.keymap.set("n", "<C-w>+", "5<C-w>+")

-- Search history on command line
vim.keymap.set("c", "<C-k>", "<Up>")
vim.keymap.set("c", "<C-j>", "<Down>")

-- Shortcuts for inserting filename, directory name, and full path into command
-- mode.
vim.keymap.set("c", "%H", [[<C-R>=expand('%:h:p') . '/'<CR>]])
vim.keymap.set("c", "%T", [[<C-R>=expand('%:t')<CR>]])
vim.keymap.set("c", "%P", [[<C-R>=expand('%:p')<CR>]])

-- stylua: ignore start
vim.keymap.set("n", "<M-v>", "<cmd>vsplit term://fish<CR>", { desc = "Open a shell in a vertical split" })
vim.keymap.set("n", "<M-s>", "<cmd>split term://fish<CR>", { desc = "Open a shell in a horizontal split" })
vim.keymap.set("n", "<M-t>", "<cmd>tabnew term://fish<CR>", { desc = "Open a shell in a tab page" })
-- stylua: ignore end

-- Toggles between most recent buffers
vim.keymap.set(
  "n",
  "<leader><leader>",
  "<c-^>",
  { desc = "switch to most recent buffer" }
)

-- Extra completion modes
vim.keymap.set(
  "i",
  "<C-x><C-m>",
  [[<c-r>=luaeval("require('user.util.completion').complete_matching_line()")<CR>]],
  { desc = "complete matching lines from current buffer" }
)
vim.keymap.set(
  "i",
  "<C-x><C-d>",
  [[<c-r>=luaeval("require('user.util.completion').complete_matching_line_cwd()")<CR>]],
  { desc = "complete matching lines from the current working directory" }
)

-- Replacing up to next _ or -
vim.keymap.set(
  "n",
  "<leader>c",
  "ct_",
  { desc = "change text up to next underscore '_'" }
)

-- Faster write/save current buffer
vim.keymap.set("n", "<leader>w", "<cmd>write<CR>", { desc = "write" })

-- Enter a lua command.
vim.keymap.set(
  "n",
  "<leader>xf",
  "<cmd>source %<CR>",
  { silent = true, desc = "source lua or vimscript file" }
)
vim.keymap.set("n", "<leader>xl", [[:lua ]], { desc = "enter lua command" })
vim.keymap.set(
  "n",
  "<leader>xe",
  [[:lua =]],
  { desc = "display lua expression" }
)

-- Create a <nop> mapping for <leader>r so that I do not keep accidentally
-- replacing characters if the LSP server is not attached yet.
vim.keymap.set("n", "<leader>r", "<nop>", { desc = "nop" })
