
local g = vim.g
local opt, wo, bo = vim.opt, vim.wo, vim.opt_local
local o, wo, bo = vim.o, vim.wo, vim.bo
local fn = vim.fn

local utils = require("aiko.utils")
local autocmd = utils.autocmd
local map = utils.map
local smap = utils.smap

local keymap = require("aiko.keymap")
local imap = keymap.imap
local nmap = keymap.nmap
local cmap = keymap.cmap
local vmap = keymap.vmap
local xmap = keymap.xmap
local tmap = keymap.tmap

-- =========================
-- |=======================|
-- ||                     ||
-- || General Keybindings ||
-- ||                     ||
-- |=======================|
-- =========================
--
-- Set the leader key to the space key
nmap("<SPACE>", "<NOP>")
g.mapleader = " "

-- Set local leader to the backslash
nmap([[\]], "<NOP>")
g.maplocalleader = [[\]]

-- ----------------------------------
-- | Vim Tmux Navigator keybindings |
-- ----------------------------------
g.tmux_navigator_no_mappings = 1

vim.keymap.set({ "i", "n", "t" }, "<M-h>", [[<cmd>TmuxNavigateLeft<CR>]])
vim.keymap.set({ "i", "n", "t" }, "<M-j>", [[<cmd>TmuxNavigateDown<CR>]])
vim.keymap.set({ "i", "n", "t" }, "<M-k>", [[<cmd>TmuxNavigateUp<CR>]])
vim.keymap.set({ "i", "n", "t" }, "<M-l>", [[<cmd>TmuxNavigateRight<CR>]])
vim.keymap.set({ "i", "n", "t" }, "<M-o>", [[<cmd>TmuxNavigatePrevious<CR>]])

-- Treat long lines as break lines (useful when moving around in them)
nmap("j", "gj")
nmap("k", "gk")

-- Don't deselect visual when indenting in visual mode
xmap("<", "<gv")
xmap(">", ">gv")

-- Very magic by default
nmap("?", [[?\v]])
nmap("/", [[/\v]])
nmap("<C-s>", [[:%s/\v]])
cmap("<C-s>", [[%s/\v]])

-- Search history on command line
cmap("<C-p>", "<Up>")
cmap("<C-n>", "<Down>")

-- Toggles between most recent buffers
nmap("<leader><leader>", "<c-^>")

-- More ergonomic normal mode from integrated terminal
tmap("jk", [[<c-\><c-n>]])
tmap("kj", [[<c-\><c-n>]])

-- Shows/hides hidden characters
nmap("<leader>,", ":set invlist<CR>", { silent = true })

-- Replacing up to next _ or -
nmap("<leader>c", "ct_")

-- Automatically correct spelling with the first option
imap("<C-l>", [[<C-g>u<Esc>[s1z=`]a<C-g>u]])

-- Clear the search buffer to remove highlighting from the last search
nmap("<c-_>", [[:let @/ = ""<CR>]])

-- Select the text that was last pasted
nmap("gp", [['`[' . strpart(getregtype(), 0,  1) . '`]']], { expr = true })

-- Sort the selected lines
vmap("<leader>rs", ":!sort<CR>", { silent = true })

-- Make Y behave like other capital numbers
nmap("Y", "y$")

-- Keep it centered
nmap("n", "nzzzv")
nmap("N", "Nzzzv")

-- Undo breakpoints while typing
imap(",", ",<C-g>u")
imap(".", ".<C-g>u")
imap("!", "!<C-g>u")
imap("?", "?<C-g>u")

-- Automatically jump to the end of pasted text
xmap("y", "y`]")
map({ "x", "n" }, "p", "p`]")

-- Shortcuts for inserting filename, directory name, and full path into command
-- mode.
cmap("%H", [[<C-R>=expand('%:h:p') . '/'<CR>]])
cmap("%T", [[<C-R>=expand('%:t')<CR>]])
cmap("%P", [[<C-R>=expand('%:p')<CR>]])
cmap("E<S-space>", [[e<space>]])

-- ----------------------------------------------------
-- | Telescope, LSP, Diagnostics, and Git keybindings |
-- ----------------------------------------------------
--
-- Custom themes
telescope_dynamic_theme = function(opts)
	opts = opts or {}

	local theme_opts = {
		layout_strategy = (o.columns < 120) and "vertical" or "horizontal",
	}

	return vim.tbl_deep_extend("force", theme_opts, opts)
end

--
-- Diagnostics
-- See `:help vim.diagnostic.*` for documentation on any of the below
-- functions
smap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>")
smap({ "n", "v", "o" }, "[e", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
smap({ "n", "v", "o" }, "]e", "<cmd>lua vim.diagnostic.goto_next()<CR>")
smap("n", "<space>dl", "<cmd>lua vim.diagnostic.setloclist()<CR>")
smap("n", "<space>do", [[:lua require("telescope.builtin").diagnostics(telescope_dynamic_theme())<CR>]])
smap(
	"n",
	"<space>ds",
	[[:lua require("telescope.builtin").spell_suggest(require("telescope.themes").get_cursor())<CR>]]
)

-- LSP functions
-- See `:help vim.lsp.*` for documentation on any of the below functions
smap("n", "<leader>k", "<cmd>ShowDocumentation<CR>")
smap("n", "<leader>l", "<cmd>lua vim.lsp.buf.signature_help()<CR>")

-- Goto references with <leader>j...
smap("n", "<leader>jf", [[<cmd>lua require("telescope.builtins").treesitter(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>jc", "<cmd>lua vim.lsp.buf.declaration()<CR>")
smap("n", "<leader>jD", "<cmd>lua vim.lsp.buf.definition()<CR>")
smap("n", "<leader>jd", [[<cmd>lua require("telescope.builtin").lsp_definitions(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>jR", "<cmd>lua vim.lsp.buf.references()<CR>")
smap("n", "<leader>jr", [[<cmd>lua require("telescope.builtin").lsp_references(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>jI", "<cmd>lua vim.lsp.buf.implementation()<CR>")
smap("n", "<leader>ji", [[<cmd>lua require("telescope.builtin").lsp_implementations(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>jT", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
smap("n", "<leader>jt", [[<cmd>lua require("telescope.builtin").lsp_type_definitions(telescope_dynamic_theme())<CR>]])

-- Telescope LSP pickers
smap(
	"n",
	"<leader>ja",
	[[<cmd>lua require("telescope.builtin").lsp_code_actions(require("telescope.themes").get_cursor())<CR>]]
)
smap(
	"n",
	"<leader>jA",
	[[<cmd>lua require("telescope.builtin").lsp_range_code_actions(require("telescope.themes").get_cursor())<CR>]]
)
smap("n", "<leader>jT", [[<cmd>lua require("telescope.builtin").lsp_workspace_symbols(telescope_dynamic_theme())<CR>]])
smap(
	"n",
	"<leader>jt",
	[[<cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols(telescope_dynamic_theme())<CR>]]
)
smap("n", "<leader>js", [[<cmd>lua require("telescope.builtin").lsp_document_symbols(telescope_dynamic_theme())<CR>]])

-- Workspace settings with <leader>w...
smap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
smap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
smap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")

-- Refactoring with <leader>r...
smap("n", "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>")
smap("n", "<leader>rq", "<cmd>lua vim.lsp.buf.code_action()<CR>")
smap("n", "<leader>rf", "<cmd>lua vim.lsp.buf.formatting()<CR>")

-- Finding searching and navigating
smap("n", "<leader>;", [[<cmd>lua require("telescope.builtin").commands(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>o", [[<cmd>lua require("telescope.builtin").find_files(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>p", [[<cmd>lua require("telescope.builtin").buffers(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>ff", [[<cmd>lua require("telescope.builtin").live_grep(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>fs", [[<cmd>lua require("telescope.builtin").spell_suggest(telescope_dynamic_theme())<CR>]])
smap(
	"n",
	"<leader>fb",
	[[<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find(telescope_dynamic_theme())<CR>]]
)
smap("n", "<leader>ft", [[<cmd>lua require("telescope.builtin").tags(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>f/", [[<cmd>lua require("telescope.builtin").search_history(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>f;", [[<cmd>lua require("telescope.builtin").command_history(telescope_dynamic_theme())<CR>]])

-- Git shortcuts
smap("n", "<leader>go", [[<cmd>lua require("telescope.builtin").git_files(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>gC", [[<cmd>lua require("telescope.builtin").git_commits(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>gc", [[<cmd>lua require("telescope.builtin").git_bcommits(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>gb", [[<cmd>lua require("telescope.builtin").git_branches(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>gt", [[<cmd>lua require("telescope.builtin").git_status(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>gh", [[<cmd>lua require("telescope.builtin").git_stash(telescope_dynamic_theme())<CR>]])

-- Navigation
smap({ "n", "v", "o" }, "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
smap({ "n", "v", "o" }, "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

-- -- Git actions related actions with <leader>g...
smap({ "n", "v" }, "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>")
smap({ "n", "v" }, "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>")
smap("n", "<leader>gS", "<cmd>Gitsigns stage_buffer<CR>")
smap("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>")
smap("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>")
smap("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>")
smap("n", "<leader>gL", "<cmd>Gitsigns toggle_current_line_blame<CR>")
smap("n", "<leader>gd", "<cmd>Gitsigns diffthis<CR>")
smap("n", "<leader>gD", "<cmd>Gitsigns toggle_deleted<CR>")

-- -- Text object
smap({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>")

-- Setting shortcuts
smap("n", "<leader>ho", [[<cmd>lua require("telescope.builtin").vim_options(telescope_dynamic_theme())<CR>]])
smap(
	"n",
	"<leader>hc",
	[[<cmd>lua require("telescope.builtin").colorscheme(require("telescope.themes").get_dropdown())<CR>]]
)
smap("n", "<leader>hh", [[<cmd>lua require("telescope.builtin").help_tags(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>hm", [[<cmd>lua require("telescope.builtin").man_pages(telescope_dynamic_theme())<CR>]])
smap("n", [[<leader>h']], [[<cmd>lua require("telescope.builtin").marks(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>hk", [[<cmd>lua require("telescope.builtin").keymaps(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>hf", [[<cmd>lua require("telescope.builtin").filetypes(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>hr", [[<cmd>lua require("telescope.builtin").registers(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>hs", [[<cmd>lua require("telescope").extensions.ultisnips.ultisnips(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>ha", [[<cmd>lua require("telescope.builtin").autocommands(telescope_dynamic_theme())<CR>]])
smap("n", "<leader>ht", [[<cmd>lua require("telescope.builtin").pickers(telescope_dynamic_theme())<CR>]])

-- Faster write/save current buffer
nmap("<leader>w", "<cmd>write<CR>")
nmap("<leader>W", "<cmd>wall<CR>")

-- Resizing splits
smap("n", "<leader>wvp", [[<cmd>exe "vertical resize " . (winwidth(0) * 3/2)<CR>]])
smap("n", "<leader>wvm", [[<cmd>exe "vertical resize " . (winwidth(0) * 2/3)<CR>]])
smap("n", "<leader>whp", [[<cmd>exe "resize " . (winheight(0) * 3/2)<CR>]])
smap("n", "<leader>whm", [[<cmd>exe "resize " . (winheight(0) * 2/3)<CR>]])
nmap("<C-w><", "5<C-w><")
nmap("<C-w>>", "5<C-w>>")
nmap("<C-w>-", "5<C-w>-")
nmap("<C-w>+", "5<C-w>+")
