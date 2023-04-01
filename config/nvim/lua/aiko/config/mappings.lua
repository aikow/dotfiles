local map = vim.keymap.set

-- Tmux / vim navigation
-- stylua: ignore start
map("n", "<M-h>", "<cmd>TmuxNavigateLeft<CR>", { silent = true, desc = "tmux navigate left" })
map("n", "<M-j>", "<cmd>TmuxNavigateDown<CR>", { silent = true, desc = "tmux navigate down" })
map("n", "<M-k>", "<cmd>TmuxNavigateUp<CR>", { silent = true, desc = "tmux navigate up" })
map("n", "<M-l>", "<cmd>TmuxNavigateRight<CR>", { silent = true, desc = "tmux navigate right" })
map("n", "<M-o>", "<cmd>TmuxNavigatePrevious<CR>", { silent = true, desc = "tmux navigate previous" })

map("i", "<M-h>", [[<esc>:TmuxNavigateLeft<CR>]], { silent = true, desc = "tmux navigate left" })
map("i", "<M-j>", [[<esc>:TmuxNavigateDown<CR>]], { silent = true, desc = "tmux navigate down" })
map("i", "<M-k>", [[<esc>:TmuxNavigateUp<CR>]], { silent = true, desc = "tmux navigate up" })
map("i", "<M-l>", [[<esc>:TmuxNavigateRight<CR>]], { silent = true, desc = "tmux navigate right" })
map("i", "<M-o>", [[<esc>:TmuxNavigatePrevious<CR>]], { silent = true, desc = "tmux navigate previous" })

map("t", "<M-h>", [[<C-\><C-n>:TmuxNavigateLeft<CR>]], { silent = true, desc = "tmux navigate left" })
map("t", "<M-j>", [[<C-\><C-n>:TmuxNavigateDown<CR>]], { silent = true, desc = "tmux navigate down" })
map("t", "<M-k>", [[<C-\><C-n>:TmuxNavigateUp<CR>]], { silent = true, desc = "tmux navigate up" })
map("t", "<M-l>", [[<C-\><C-n>:TmuxNavigateRight<CR>]], { silent = true, desc = "tmux navigate right" })
map("t", "<M-o>", [[<C-\><C-n>:TmuxNavigatePrevious<CR>]], { silent = true, desc = "tmux navigate previous" })
-- stylua: ignore end

-- Treat long lines as break lines.
map("n", "j", "gj")
map("n", "k", "gk")

-- Don't deselect visual when indenting in visual mode>
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Very magic regexps by default.
map("n", "?", [[?\v]])
map("n", "/", [[/\v]])
map("n", "<C-s>", [[:%s/\v]])
map("x", "<C-s>", [[:s/\v]])
map("c", "<C-s>", [[%s/\v]])

map(
  "i",
  "<C-s>",
  [[<C-g>u<Esc>[s1z=`]a<C-g>u]],
  { desc = "correct last spelling mistake" }
)

-- Clear the search buffer to remove highlighting from the last search
map(
  "n",
  "<C-_>",
  [[:let @/ = ""<CR>]],
  { silent = true, desc = "clear search buffer register" }
)
map(
  "n",
  "<C-/>",
  [[:let @/ = ""<CR>]],
  { silent = true, desc = "clear search buffer register" }
)

-- Select the text that was last pasted
map(
  "n",
  "gp",
  [['`[' . strpart(getregtype(), 0,  1) . '`]']],
  { expr = true, desc = "select the last pasted region" }
)
-- Automatically jump to the end of pasted text
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

-- Search history on command line
map("c", "<C-k>", "<Up>")
map("c", "<C-j>", "<Down>")

-- Shortcuts for inserting filename, directory name, and full path into command
-- mode.
map("c", "%H", [[<C-R>=expand('%:h:p') . '/'<CR>]])
map("c", "%T", [[<C-R>=expand('%:t')<CR>]])
map("c", "%P", [[<C-R>=expand('%:p')<CR>]])

-- stylua: ignore start
map("n", "<M-v>", "<cmd>vsplit term://fish<CR>", { desc = "Open a shell in a vertical split" })
map("n", "<M-s>", "<cmd>split term://fish<CR>", { desc = "Open a shell in a horizontal split" })
map("n", "<M-t>", "<cmd>tabnew term://fish<CR>", { desc = "Open a shell in a tab page" })
-- stylua: ignore end

-- Toggles between most recent buffers
map("n", "<leader><leader>", "<c-^>", { desc = "switch to most recent buffer" })

-- Navigate quickfix list
map("n", "]q", "<cmd>cnext<CR>", { desc = "cnext" })
map("n", "[q", "<cmd>cprev<CR>", { desc = "cprev" })
map("n", "]Q", "<cmd>clast<CR>", { desc = "clast" })
map("n", "[Q", "<cmd>cfirst<CR>", { desc = "cfirst" })

-- Navigate location list
map("n", "]l", "<cmd>lnext<CR>", { desc = "lnext" })
map("n", "[l", "<cmd>lprev<CR>", { desc = "lprev" })
map("n", "]L", "<cmd>llast<CR>", { desc = "llast" })
map("n", "[L", "<cmd>lfirst<CR>", { desc = "lfirst" })

-- navigate buffers
map("n", "]b", "<cmd>bnext<CR>", { desc = "bnext" })
map("n", "[b", "<cmd>bprev<CR>", { desc = "bprev" })
map("n", "]B", "<cmd>blast<CR>", { desc = "blast" })
map("n", "[B", "<cmd>bfirst<CR>", { desc = "bfirst" })

-- navigate files
map("n", "]f", "<cmd>next<CR>", { desc = "next" })
map("n", "[f", "<cmd>prev<CR>", { desc = "prev" })
map("n", "]F", "<cmd>last<CR>", { desc = "last" })
map("n", "[F", "<cmd>first<CR>", { desc = "first" })

-- Extra completion modes
map(
  "i",
  "<C-x><C-m>",
  [[<c-r>=luaeval("require('aiko.util.completion').complete_matching_line()")<CR>]],
  { desc = "complete matching lines from current buffer" }
)
map(
  "i",
  "<C-x><C-d>",
  [[<c-r>=luaeval("require('aiko.util.completion').complete_matching_line_cwd()")<CR>]],
  { desc = "complete matching lines from the current working directory" }
)

-- Replacing up to next _ or -
map("n", "<leader>c", "ct_", { desc = "change text up to next underscore '_'" })

-- Faster write/save current buffer
map("n", "<leader>w", "<cmd>write<CR>", { desc = "write" })

-- Enter a lua command.
map(
  "n",
  "<leader>xf",
  "<cmd>source %<CR>",
  { silent = true, desc = "source lua or vimscript file" }
)
map("n", "<leader>xl", [[:lua ]], { desc = "enter lua command" })
map("n", "<leader>xe", [[:lua =]], { desc = "display lua expression" })

-- Create a <nop> mapping for <leader>r so that I do not keep accidentally
-- replacing characters if the LSP server is not attached yet.
map("n", "<leader>r", "<nop>", { desc = "nop" })
