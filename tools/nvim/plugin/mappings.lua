local map = vim.keymap.set

-- =========================
-- |=======================|
-- ||                     ||
-- || General Keybindings ||
-- ||                     ||
-- |=======================|
-- =========================
--
-- Vim Tmux Navigator keybindings
vim.g.tmux_navigator_no_mappings = 1
map({ "i", "n", "t" }, "<M-h>", [[<cmd>TmuxNavigateLeft<CR>]])
map({ "i", "n", "t" }, "<M-j>", [[<cmd>TmuxNavigateDown<CR>]])
map({ "i", "n", "t" }, "<M-k>", [[<cmd>TmuxNavigateUp<CR>]])
map({ "i", "n", "t" }, "<M-l>", [[<cmd>TmuxNavigateRight<CR>]])
map({ "i", "n", "t" }, "<M-o>", [[<cmd>TmuxNavigatePrevious<CR>]])

-- Treat long lines as break lines (useful when moving around in them)
map("n", "j", "gj")
map("n", "k", "gk")

-- Don't deselect visual when indenting in visual mode
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Very magic by default
map("n", "?", [[?\v]])
map("n", "/", [[/\v]])
map("n", "<C-s>", [[:%s/\v]])
map("c", "<C-s>", [[%s/\v]])

map("n", "<C-l>", [[:lua ]])
map("n", "<C-l><C-l>", [[:lua =]])

-- Search history on command line
map("c", "<C-p>", "<Up>")
map("c", "<C-n>", "<Down>")

-- Toggles between most recent buffers
map("n", "<leader><leader>", "<c-^>")

-- More ergonomic normal mode from integrated terminal
map("t", "jk", [[<c-\><c-n>]])
map("t", "kj", [[<c-\><c-n>]])

-- Replacing up to next _ or -
map("n", "<leader>c", "ct_")

-- Automatically correct spelling with the first option
map("i", "<C-l>", [[<C-g>u<Esc>[s1z=`]a<C-g>u]])

-- Clear the search buffer to remove highlighting from the last search
map("n", "<c-_>", [[:let @/ = ""<CR>]])

-- Select the text that was last pasted
map("n", "gp", [['`[' . strpart(getregtype(), 0,  1) . '`]']], { expr = true })

-- Sort the selected lines
map("v", "<leader>rs", ":!sort<CR>", { silent = true })

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

-- Automatically jump to the end of pasted text
map("x", "y", "y`]")
map({ "x", "n" }, "p", "p`]")

-- Shortcuts for inserting filename, directory name, and full path into command
-- mode.
map("c", "%H", [[<C-R>=expand('%:h:p') . '/'<CR>]])
map("c", "%T", [[<C-R>=expand('%:t')<CR>]])
map("c", "%P", [[<C-R>=expand('%:p')<CR>]])
map("c", "E<S-space>", [[e<space>]])

-- ----------------------------------------------------
-- | Telescope, LSP, Diagnostics, and Git keybindings |
-- ----------------------------------------------------
--
-- Diagnostics
-- See `:help vim.diagnostic.*` for documentation on any of the below
-- functions
map("n", "<space>e", vim.diagnostic.open_float, { silent = true, desc = "open diagnostic window" })
map({ "n", "v", "o" }, "[e", vim.diagnostic.goto_prev, { silent = true, desc = "go to previous diagnostic" })
map({ "n", "v", "o" }, "]e", vim.diagnostic.goto_next, { silent = true, desc = "go to next diagnostic" })
map("n", "<space>dl", vim.diagnostic.setloclist, { silent = true, desc = "set location list to diagnostics" })

-- LSP functions
-- See `:help vim.lsp.*` for documentation on any of the below functions
vim.keymap.set("n", "K", function()
  local ft = vim.bo.filetype
  if ft == "vim" or ft == "help" then
    vim.api.nvim_command("help " .. vim.fn.expand("<cword>"))
  elseif ft == "man" then
    vim.api.nvim_command("Man " .. vim.fn.expand("<cword>"))
  elseif vim.fn.expand("%:t") == "Cargo.toml" then
    require("crates").show_popup()
  else
    vim.lsp.buf.hover()
  end
end, { desc = "show documentation" })
vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, { desc = "signature help" })

-- Goto references with <leader>j...
map("n", "<leader>lc", vim.lsp.buf.declaration, { silent = true, desc = "lsp go to declaration" })
map("n", "<leader>lD", vim.lsp.buf.definition, { silent = true, desc = "lsp go to definition" })
map("n", "<leader>lR", vim.lsp.buf.references, { silent = true, desc = "lsp go to references" })
map("n", "<leader>lI", vim.lsp.buf.implementation, { silent = true, desc = "lsp go to implementation" })
map("n", "<leader>lT", vim.lsp.buf.type_definition, { silent = true, desc = "lsp go to type definition" })

-- Workspace settings with <leader>w...
map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { silent = true, desc = "lsp add workspace folder" })
map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { silent = true, desc = "lsp remove workspace folder" })
map("n", "<leader>wl", function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { silent = true, desc = "print lsp workspace folders" })

-- Refactoring with <leader>r...
map("n", "<leader>rr", vim.lsp.buf.rename, { silent = true })
map("n", "<leader>rq", vim.lsp.buf.code_action, { silent = true })
map("n", "<leader>rf", vim.lsp.buf.formatting, { silent = true })

-- Faster write/save current buffer
map("n", "<leader>w", "<cmd>write<CR>")
map("n", "<leader>W", "<cmd>wall<CR>")

-- Resizing splits
map("n", "<leader>wvp", [[<cmd>exe "vertical resize " . (winwidth(0) * 3/2)<CR>]], { silent = true })
map("n", "<leader>wvm", [[<cmd>exe "vertical resize " . (winwidth(0) * 2/3)<CR>]], { silent = true })
map("n", "<leader>whp", [[<cmd>exe "resize " . (winheight(0) * 3/2)<CR>]], { silent = true })
map("n", "<leader>whm", [[<cmd>exe "resize " . (winheight(0) * 2/3)<CR>]], { silent = true })
map("n", "<C-w><", "5<C-w><")
map("n", "<C-w>>", "5<C-w>>")
map("n", "<C-w>-", "5<C-w>-")
map("n", "<C-w>+", "5<C-w>+")

map("n", "<space>do", function()
  require("telescope.builtin").diagnostics(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true, desc = "telescope open diagnostics" })

map("n", "<space>ds", function()
  require("telescope.builtin").spell_suggest(require("telescope.themes").get_cursor())
end, { silent = true, desc = "telescope spell suggest" })

map("n", "<leader>jf", function()
  require("telescope.builtin").treesitter(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true, desc = "telescope treesitter" })

map("n", "<leader>jd", function()
  require("telescope.builtin").lsp_definitions(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true, desc = "telescope lsp list definitions" })

map("n", "<leader>jr", function()
  require("telescope.builtin").lsp_references(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true, desc = "telescope lsp list references" })

map("n", "<leader>ji", function()
  require("telescope.builtin").lsp_implementations(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true, desc = "telescope lsp list implementations" })

map("n", "<leader>jt", function()
  require("telescope.builtin").lsp_type_definitions(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true, desc = "telescope lsp list type definitions" })

map("n", "<leader>ja", function()
  require("telescope.builtin").lsp_code_actions(require("telescope.themes").get_cursor())
end, { silent = true, desc = "telescope lsp list code actions" })

map("n", "<leader>jA", function()
  require("telescope.builtin").lsp_range_code_actions(require("telescope.themes").get_cursor())
end, { silent = true, desc = "telescope lsp list range code actions" })

map("n", "<leader>jw", function()
  require("telescope.builtin").lsp_workspace_symbols(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true, desc = "telescope lsp list workspace symbols" })

map("n", "<leader>jW", function()
  require("telescope.builtin").lsp_dynamic_workspace_symbols(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true, desc = "telescope lsp list dynamic workspace symbols" })

map("n", "<leader>js", function()
  require("telescope.builtin").lsp_document_symbols(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true, desc = "telescope lsp list document symbols" })

-- Finding searching and navigating
map("n", "<leader>;", function()
  require("telescope.builtin").commands(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true })

map("n", "<leader>o", function()
  require("telescope.builtin").find_files(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true })

map("n", "<leader>p", function()
  require("telescope.builtin").buffers(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true })

map("n", "<leader>ff", function()
  require("telescope.builtin").live_grep(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true })

map("n", "<leader>fs", function()
  require("telescope.builtin").spell_suggest(require("telescope.themes").get_cursor())
end, { silent = true })

map("n", "<leader>fb", function()
  require("telescope.builtin").current_buffer_fuzzy_find(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true })

map("n", "<leader>ft", function()
  require("telescope.builtin").tags(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true })

map("n", "<leader>f/", function()
  require("telescope.builtin").search_history(require("telescope.themes").get_dropdown())
end, { silent = true })

map("n", "<leader>f;", function()
  require("telescope.builtin").command_history(require("telescope.themes").get_dropdown())
end, { silent = true })

-- Git shortcuts
map("n", "<leader>go", function()
  require("telescope.builtin").git_files(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true })

map("n", "<leader>gC", function()
  require("telescope.builtin").git_commits(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true })

map("n", "<leader>gc", function()
  require("telescope.builtin").git_bcommits(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true })

map("n", "<leader>gb", function()
  require("telescope.builtin").git_branches(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true })

map("n", "<leader>gt", function()
  require("telescope.builtin").git_status(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true })

map("n", "<leader>gh", function()
  require("telescope.builtin").git_stash(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true })

-- Setting shortcuts
map("n", "<leader>ho", function()
  require("telescope.builtin").vim_options(require("telescope.themes").get_dropdown())
end, { silent = true })

map("n", "<leader>hc", function()
  require("telescope.builtin").colorscheme(require("telescope.themes").get_dropdown())
end, { silent = true })

map("n", "<leader>hh", function()
  require("telescope.builtin").help_tags(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true })

map("n", "<leader>hm", function()
  require("telescope.builtin").man_pages(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true })

map("n", [[<leader>h']], function()
  require("telescope.builtin").marks(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true })

map("n", "<leader>hk", function()
  require("telescope.builtin").keymaps(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true })

map("n", "<leader>hf", function()
  require("telescope.builtin").filetypes(require("telescope.themes").get_dropdown())
end, { silent = true })

map("n", "<leader>hr", function()
  require("telescope.builtin").registers(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true })

map("n", "<leader>hs", function()
  require("telescope").extensions.ultisnips.ultisnips({
    layout_strategy = "vertical",
    layout_config = {
      width = function(_, max_columns, max_lines)
        if max_columns > 120 then
          max_columns = 120
        end
        return require("math").floor(max_columns * 0.80)
      end,
    },
  })
end, { silent = true })

map("n", "<leader>ha", function()
  require("telescope.builtin").autocommands(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true })

map("n", "<leader>ht", function()
  require("telescope.builtin").builtin(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true })

map("n", "<leader>hq", function()
  require("telescope.builtin").quickfix(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true })

map("n", "<leader>hl", function()
  require("telescope.builtin").loclist(require("aiko.plugins.configs.telescope").dynamic())
end, { silent = true })

-- Navigation
map(
  { "n", "v", "o" },
  "]c",
  "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'",
  { expr = true, silent = true, desc = "go to next git hunk" }
)
map(
  { "n", "v", "o" },
  "[c",
  "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'",
  { expr = true, silent = true, desc = "go to previous git hunk" }
)

-- Git actions related actions with <leader>g...
map({ "n", "v" }, "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", { silent = true })
map({ "n", "v" }, "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", { silent = true })
map("n", "<leader>gS", "<cmd>Gitsigns stage_buffer<CR>", { silent = true })
map("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", { silent = true })
map("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", { silent = true })
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { silent = true })
map("n", "<leader>gL", "<cmd>Gitsigns toggle_current_line_blame<CR>", { silent = true })
map("n", "<leader>gd", "<cmd>Gitsigns diffthis<CR>", { silent = true })
map("n", "<leader>gD", "<cmd>Gitsigns toggle_deleted<CR>", { silent = true })

-- Text object
map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", { silent = true })
