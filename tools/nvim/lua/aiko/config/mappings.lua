-- Key Mappings
-- ============
--
-- Leader Mappings
-- ---------------
--
-- | leader<key> | Layered | Category                       |
-- | ----------- |         | ------------------------       |
-- | c           |         | Change text up to next _       |
-- | d           |         | Diagnostics                    |
-- | e           |         | Open diagnostic window         |
-- | f           |         | Find                           |
-- | g           | Yes     | Git                            |
-- | h           |         | Vim internal settings and help |
-- | i           |         | Telescope previous picker      |
-- | j           |         | Telescope LSP                  |
-- | k           |         | LSP signature help             |
-- | l           |         | Builtin LSP                    |
-- | o           |         | Telescope find files           |
-- | p           |         | Telescope buffers              |
-- | r           |         | Refactoring                    |
-- | s           |         | Snippets                       |
-- | v           |         | Tree-Sitter select region      |
-- | w           |         | Write current file             |
-- | W           |         | Write all files                |
-- | <leader>    |         | Switch to most recent buffer   |
-- | ;           |         | Telescope commands             |

local map = vim.keymap.set

-- Vim tmux navigator keybindings to seamlessly switch between vim and tmux
-- panes.
map("n", "<M-h>", [[<cmd>TmuxNavigateLeft<CR>]], { silent = true })
map("n", "<M-j>", [[<cmd>TmuxNavigateDown<CR>]], { silent = true })
map("n", "<M-k>", [[<cmd>TmuxNavigateUp<CR>]], { silent = true })
map("n", "<M-l>", [[<cmd>TmuxNavigateRight<CR>]], { silent = true })
map("n", "<M-o>", [[<cmd>TmuxNavigatePrevious<CR>]], { silent = true })

map("i", "<M-h>", [[<esc>:TmuxNavigateLeft<CR>]], { silent = true })
map("i", "<M-j>", [[<esc>:TmuxNavigateDown<CR>]], { silent = true })
map("i", "<M-k>", [[<esc>:TmuxNavigateUp<CR>]], { silent = true })
map("i", "<M-l>", [[<esc>:TmuxNavigateRight<CR>]], { silent = true })
map("i", "<M-o>", [[<esc>:TmuxNavigatePrevious<CR>]], { silent = true })

map("t", "<M-h>", [[<C-\><C-n>:TmuxNavigateLeft<CR>]], { silent = true })
map("t", "<M-j>", [[<C-\><C-n>:TmuxNavigateDown<CR>]], { silent = true })
map("t", "<M-k>", [[<C-\><C-n>:TmuxNavigateUp<CR>]], { silent = true })
map("t", "<M-l>", [[<C-\><C-n>:TmuxNavigateRight<CR>]], { silent = true })
map("t", "<M-o>", [[<C-\><C-n>:TmuxNavigatePrevious<CR>]], { silent = true })

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

-- Enter a lua command.
map("n", "<C-l>", [[:lua ]], { desc = "enter lua command" })
map("n", "<C-l><C-l>", [[:lua =]], { desc = "display lua expression" })

-- Search history on command line
map("c", "<C-p>", "<Up>")
map("c", "<C-n>", "<Down>")

-- Toggles between most recent buffers
map("n", "<leader><leader>", "<c-^>", { desc = "switch to most recent buffer" })

-- More ergonomic normal mode from integrated terminal.
map("t", "<M-e>", [[<c-\><C-n>]])

-- Navigate quickfix list
map("n", "]q", [[<cmd>cnext<CR>]])
map("n", "[q", [[<cmd>cprev<CR>]])
map("n", "]Q", [[<cmd>clast<CR>]])
map("n", "[Q", [[<cmd>cfirst<CR>]])

-- Navigate location list
map("n", "]l", [[<cmd>lnext<CR>]])
map("n", "[l", [[<cmd>lprev<CR>]])
map("n", "]L", [[<cmd>llast<CR>]])
map("n", "[L", [[<cmd>lfirst<CR>]])

-- navigate buffers
map("n", "]b", [[<cmd>bnext<CR>]])
map("n", "[b", [[<cmd>bprev<CR>]])
map("n", "]B", [[<cmd>blast<CR>]])
map("n", "[B", [[<cmd>bfirst<CR>]])

-- navigate files
map("n", "]f", [[<cmd>next<CR>]])
map("n", "[f", [[<cmd>prev<CR>]])
map("n", "]F", [[<cmd>last<CR>]])
map("n", "[F", [[<cmd>first<CR>]])

-- Replacing up to next _ or -
map("n", "<leader>c", "ct_", { desc = "change text up to next underscore '_'" })

-- TODO: Find out why this isn't working. Possible create issue on GitHub.
-- Automatically correct spelling with the first option
map(
  "i",
  "<C-s>",
  [[<C-g>u<Esc>[s1z=`]a<C-g>u]],
  { desc = "correct last spelling mistake" }
)
vim.cmd([[imap <C-s> <C-g>u<Esc>[s1z=`]a<C-g>u]])

-- Clear the search buffer to remove highlighting from the last search
map(
  "n",
  "<C-_>",
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

-- Sort the selected lines
map("v", "<leader>rs", ":!sort<CR>", {
  silent = true,
  desc = "sort the selected region with the sort command via the shell",
})

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

-- Shortcuts for inserting filename, directory name, and full path into command
-- mode.
map("c", "%H", [[<C-R>=expand('%:h:p') . '/'<CR>]])
map("c", "%T", [[<C-R>=expand('%:t')<CR>]])
map("c", "%P", [[<C-R>=expand('%:p')<CR>]])

-- Faster write/save current buffer
map("n", "<leader>w", "<cmd>write<CR>")
map("n", "<leader>W", "<cmd>wall<CR>")

-- Faster pane resizing
map("n", "<C-w><", "5<C-w><")
map("n", "<C-w>>", "5<C-w>>")
map("n", "<C-w>-", "5<C-w>-")
map("n", "<C-w>+", "5<C-w>+")

-- -----------------
-- |   Telescope   |
-- -----------------
map(
  "n",
  "<leader>i",
  function() require("telescope.builtin").resume() end,
  { silent = true, desc = "telescope reopen last telescope window" }
)

map(
  "n",
  "<leader>do",
  function()
    require("telescope.builtin").diagnostics(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true, desc = "telescope open diagnostics" }
)

map(
  "n",
  "<leader>ds",
  function()
    require("telescope.builtin").spell_suggest(
      require("telescope.themes").get_cursor()
    )
  end,
  { silent = true, desc = "telescope spell suggest" }
)

map(
  "n",
  "<leader>jf",
  function()
    require("telescope.builtin").treesitter(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true, desc = "telescope treesitter" }
)

map(
  "n",
  "<leader>jd",
  function()
    require("telescope.builtin").lsp_definitions(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true, desc = "telescope lsp list definitions" }
)

map(
  "n",
  "<leader>jr",
  function()
    require("telescope.builtin").lsp_references(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true, desc = "telescope lsp list references" }
)

map(
  "n",
  "<leader>ji",
  function()
    require("telescope.builtin").lsp_implementations(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true, desc = "telescope lsp list implementations" }
)

map(
  "n",
  "<leader>jt",
  function()
    require("telescope.builtin").lsp_type_definitions(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true, desc = "telescope lsp list type definitions" }
)

map(
  "n",
  "<leader>jw",
  function()
    require("telescope.builtin").lsp_workspace_symbols(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true, desc = "telescope lsp list workspace symbols" }
)

map(
  "n",
  "<leader>jW",
  function()
    require("telescope.builtin").lsp_dynamic_workspace_symbols(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true, desc = "telescope lsp list dynamic workspace symbols" }
)

map(
  "n",
  "<leader>js",
  function()
    require("telescope.builtin").lsp_document_symbols(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true, desc = "telescope lsp list document symbols" }
)

-- Finding searching and navigating
map(
  "n",
  "<leader>;",
  function()
    require("telescope.builtin").commands(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>o",
  function()
    require("telescope.builtin").find_files(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>p",
  function()
    require("telescope.builtin").buffers(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

-- Find shortcuts
map(
  "n",
  "<leader>ff",
  function()
    require("telescope.builtin").live_grep(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>fs",
  function()
    require("telescope.builtin").spell_suggest(
      require("telescope.themes").get_cursor()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>fb",
  function()
    require("telescope.builtin").current_buffer_fuzzy_find(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>ft",
  function()
    require("telescope.builtin").tags(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>f/",
  function()
    require("telescope.builtin").search_history(
      require("telescope.themes").get_dropdown()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>f;",
  function()
    require("telescope.builtin").command_history(
      require("telescope.themes").get_dropdown()
    )
  end,
  { silent = true }
)

-- Git shortcuts
map(
  "n",
  "<leader>go",
  function()
    require("telescope.builtin").git_files(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>gC",
  function()
    require("telescope.builtin").git_commits(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>gc",
  function()
    require("telescope.builtin").git_bcommits(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>gb",
  function()
    require("telescope.builtin").git_branches(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>gt",
  function()
    require("telescope.builtin").git_status(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>gh",
  function()
    require("telescope.builtin").git_stash(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

-- Setting shortcuts
map(
  "n",
  "<leader>ho",
  function()
    require("telescope.builtin").vim_options(
      require("telescope.themes").get_dropdown()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>hc",
  function()
    require("telescope.builtin").colorscheme(
      require("telescope.themes").get_dropdown()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>hh",
  function()
    require("telescope.builtin").help_tags(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>hm",
  function()
    require("telescope.builtin").man_pages(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

map(
  "n",
  [[<leader>h']],
  function()
    require("telescope.builtin").marks(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>hk",
  function()
    require("telescope.builtin").keymaps(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>hf",
  function()
    require("telescope.builtin").filetypes(
      require("telescope.themes").get_dropdown()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>hr",
  function()
    require("telescope.builtin").registers(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>hs",
  function()
    require("telescope").extensions.luasnip.luasnip(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>ha",
  function()
    require("telescope.builtin").autocommands(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>ht",
  function()
    require("telescope.builtin").builtin(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>hq",
  function()
    require("telescope.builtin").quickfix(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

map(
  "n",
  "<leader>hl",
  function()
    require("telescope.builtin").loclist(
      require("aiko.plugins.configs.telescope").dynamic()
    )
  end,
  { silent = true }
)

-- ---------------
-- |   Neotree   |
-- ---------------
-- map(
--   "n",
--   "<leader>to",
--   [[<cmd>NvimTreeFocus<CR>]],
--   { silent = true, desc = "Neotree reveal filesystem" }
-- )

map(
  "n",
  "-",
  [[<cmd>NvimTreeFocus<CR>]],
  { silent = true, desc = "Neotree reveal filesystem" }
)

-- map(
--   "n",
--   "<leader>tt",
--   [[<cmd>NvimTreeToggle<CR>]],
--   { silent = true, desc = "Neotree reveal filesystem" }
-- )
