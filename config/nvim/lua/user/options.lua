local opt = vim.opt

-- ------------------------------------------------------------------------
-- | General
-- ------------------------------------------------------------------------
-- Always use bash as the shell
opt.shell = "bash"

-- Add snippets directory to the runtime path
opt.runtimepath:append("~/.dotfiles/config/snippets")

-- Enable local config files using a trustdb.
opt.exrc = true

-- Use system clipboard
opt.clipboard = "unnamedplus"

-- Don't store backup while overwriting the file
opt.backup = false
opt.writebackup = false
opt.updatetime = 1000
opt.undofile = true
opt.autowrite = true
--
-- Set the timeout times
opt.timeoutlen = 500
opt.ttimeoutlen = 5

-- Enable all mouse options
opt.mouse = "a"

-- Remove default mouse menu options
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("remove mouse", {}),
  once = true,
  callback = function()
    vim.cmd.aunmenu({ "PopUp.How-to\\ disable\\ mouse" })
    vim.cmd.aunmenu({ "PopUp.-1-" })
  end,
})

-- Enable all filetype plugins
vim.cmd.filetype({ "plugin", "indent", "on" })

-- Set 7 lines to the cursor - when moving vertically using j/k
opt.smoothscroll = true
opt.scrolloff = 7
opt.sidescrolloff = 2

-- Open new splits to the right or down instead of moving current window.
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"

-- Default to a maximum of 80 characters per line
opt.textwidth = 80

-- ------------------------------------------------------------------------
-- | Editing and Searching
-- ------------------------------------------------------------------------
-- Tab key enters 2 spaces
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.smartindent = true

-- highlight matching parens, braces, brackets, etc
opt.showmatch = true

-- Searching
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"

-- Set grepprg to use ripgrep
opt.grepprg = "rg --vimgrep --no-heading --smart-case"
opt.grepformat = "%f:%l:%c:%m"

-- Format options
opt.formatoptions = "qjl1ortc"

-- Builtin completion options
opt.infercase = true -- Make completion case-insensitive.
opt.completeopt:append({
  "menu", -- Use a popup menu to show possible completions
  "menuone", -- Show menu even with one result
  "noselect", -- Don't automatically select a match
})
if vim.fn.has("nvim-0.11") == 1 then opt.completeopt:append({ "fuzzy" }) end

-- Don't give ins-complete-menu messages
opt.shortmess:append("WcCI")

-- -- Use treesitter for folding
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.require'user.util'.foldexpr()"
opt.foldtext = ""
opt.foldlevel = 99 -- Nothing is folded by default

-- Spell options.
opt.spelloptions = { "camel" }

-- Make diffing better: https://vimways.org/2018/the-power-of-diff/
opt.diffopt:append({
  "iwhite", -- No whitespace in vimdiff
  "algorithm:patience",
  "indent-heuristic",
  "linematch:60",
})

-- ------------------------------------------------------------------------
-- | Appearance and Themes
-- ------------------------------------------------------------------------

-- Wildmenu options
opt.wildoptions:append("fuzzy")
opt.wildmode = "longest:full,full"
opt.cmdheight = 1

-- Pop-up menu options
opt.pumheight = 16

-- Color scheme and background
opt.termguicolors = true -- 24-bit RGB color support

-- Tabline
vim.o.tabline = "%!v:lua.require'user.ui.tabline'.tabline()"
opt.showmode = false

-- Define which helper symbols to show
opt.listchars = "tab:󰌒 ,extends:…,precedes:…,nbsp:␣"
opt.list = true

-- Show line breaks
opt.wrap = false
opt.showbreak = " -> "
opt.linebreak = true
opt.breakindent = true

-- Enable line numbers
opt.number = true
opt.numberwidth = 2

-- Conceal
opt.conceallevel = 2
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.fillchars:append(require("user.ui.border").win_borders_fillchars.single)

vim.cmd.colorscheme({ "base-everforest" })
