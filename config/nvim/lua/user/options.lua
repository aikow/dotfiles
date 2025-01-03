local opt = vim.opt

-- Use bash as the default shell regardless of what the user shell is
opt.shell = "bash"

-- Add snippets directory to the runtime path
opt.runtimepath:append("~/.dotfiles/config/snippets")

-- Back-up, undo files, and automatically write changes.
opt.undofile = true
opt.autowrite = true
opt.updatetime = 1000

-- Set the timeout times
opt.timeoutlen = 500
opt.ttimeoutlen = 5

-- Use system clipboard
opt.clipboard = "unnamedplus"

-- Enable local config files using a trustdb.
opt.exrc = true

-- ------------------------------------------------------------------------
-- | Editing and Searching
-- ------------------------------------------------------------------------
--
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

opt.grepprg = "rg --vimgrep --no-heading --smart-case"
opt.grepformat = "%f:%l:%c:%m"

-- Format options
-- "t" Auto-wrap using 'textwidth'
-- "c" Auto-wrap comments using 'textwidth'
-- "r" Automatically insert current comment leader in insert mode (<CR>)
-- "o" Automatically insert current comment leader in normal mode (o or O)
-- "q" Allow formatting with 'gq'
-- "n" Recognize numbered lists
-- "b" Only auto-wrap if line was entered at or before the wrap margin
-- "l" Long lines when entering insert mode are not wrapped automatically
-- "j" Remove comment leader when joining lines
opt.formatoptions:append("tcroqnblj")

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

-- Wildmenu options
opt.wildoptions:append("fuzzy")
opt.wildmode = "longest:full,full"
opt.wildignore:append({ ".o", ".so", ".a", ".git" })

-- Pop-up menu options
opt.pumheight = 16

-- -- Use treesitter for folding
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.require'user.util'.foldexpr()"
opt.foldtext = ""
opt.foldlevel = 99 -- Nothing is folded by default

-- Set 7 lines to the cursor - when moving vertically using j/k
opt.smoothscroll = true
opt.scrolloff = 7

-- Open new splits to the right or down instead of moving current window.
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"

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
-- Color scheme and background
opt.termguicolors = true -- 24-bit RGB color support

-- Tabline
vim.o.tabline = "%!v:lua.require'user.ui.tabline'.tabline()"

-- Define which helper symbols to show
opt.listchars = "tab:󰌒 ,extends:…,precedes:…,nbsp:␣"
opt.list = true

-- Show line breaks
opt.wrap = false
opt.showbreak = " -> "
opt.linebreak = true
opt.breakindent = true

-- Default to a maximum of 80 characters per line
opt.textwidth = 80

-- Enable line numbers
opt.number = true
opt.numberwidth = 2

-- Enable all mouse options.
opt.mouse = "a"
-- Remove default mouse menu options
vim.cmd.aunmenu({ "PopUp.How-to\\ disable\\ mouse" })
vim.cmd.aunmenu({ "PopUp.-1-" })

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
