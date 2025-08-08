local o = vim.o

-- ------------------------------------------------------------------------
-- | General
-- ------------------------------------------------------------------------
-- Always use bash as the shell
o.shell = "bash"

-- Add snippets directory to the runtime path
vim.opt.runtimepath:append(vim.fs.normalize("~/.dotfiles/config/snippets"))

-- Enable local config files using a trustdb.
o.exrc = true

-- Use system clipboard
o.clipboard = "unnamedplus"

-- Don't store backup while overwriting the file
o.backup = false
o.writebackup = false
o.updatetime = 1000
o.undofile = true
o.autowrite = true

-- Set the timeout times
o.timeoutlen = 500
o.ttimeoutlen = 5

-- Enable all mouse options
o.mouse = "a"

-- Remove default mouse menu options
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("remove mouse", {}),
  once = true,
  callback = function()
    vim.cmd.aunmenu({ "PopUp.How-to\\ disable\\ mouse" })
    if vim.fn.has("nvim-0.11") == 1 then
      vim.cmd.aunmenu({ "PopUp.-2-" })
    else
      vim.cmd.aunmenu({ "PopUp.-1-" })
    end
  end,
})

-- Set 7 lines to the cursor - when moving vertically using j/k
o.smoothscroll = true
o.scrolloff = 7
o.sidescrolloff = 2

-- Open new splits to the right or down instead of moving current window.
o.splitright = true
o.splitbelow = true
o.splitkeep = "screen"

-- Default to a maximum of 80 characters per line
o.textwidth = 80

-- ------------------------------------------------------------------------
-- | Editing and Searching
-- ------------------------------------------------------------------------

-- Tab key enters 2 spaces
o.expandtab = true
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.smartindent = true

-- highlight matching parens, braces, brackets, etc
o.showmatch = true

-- Searching
o.ignorecase = true
o.smartcase = true
o.inccommand = "split"

-- Set grepprg to use ripgrep
o.grepprg = "rg --vimgrep --no-heading --smart-case"
o.grepformat = "%f:%l:%c:%m"

-- Format options
o.formatoptions = "qjl1ortc"

-- Builtin completion options
o.infercase = true -- Make completion case-insensitive.
if vim.fn.has("nvim-0.11") == 1 then
  o.completeopt = "menuone,noselect,fuzzy"
else
  o.completeopt = "menuone,noselect"
end

-- Don't give ins-complete-menu messages
o.shortmess = o.shortmess .. "WcCI"

-- Use treesitter for folding
o.foldmethod = "expr"
-- o.foldexpr = "v:lua.require'user.util'.foldexpr()"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldtext = ""
o.foldlevel = 99 -- Nothing is folded by default

-- Spell options.
o.spelloptions = "camel"

-- Make diffing better: https://vimways.org/2018/the-power-of-diff/
o.diffopt = o.diffopt .. ",iwhite,algorithm:patience,indent-heuristic,linematch:60"

-- ------------------------------------------------------------------------
-- | Appearance and Themes
-- ------------------------------------------------------------------------

-- Wildmenu options
o.wildmode = "noselect,longest:full,full"
o.wildoptions = "pum,fuzzy"
o.cmdheight = 1

-- Pop-up menu options
o.pumheight = 16

-- Default floating window options
o.winborder = "solid"

-- Tabline
o.tabline = "%!v:lua.require'user.ui.tabline'.tabline()"
o.showmode = false

-- Statuscolumn
o.statuscolumn = "%{%v:lua.require'user.ui'.statuscolumn()%}"

-- Define which helper symbols to show
o.listchars = "tab:󰌒 ,extends:…,precedes:…,nbsp:␣"
o.list = true

-- Show line breaks
o.wrap = true
o.showbreak = " -> "
o.linebreak = true
o.breakindent = true

-- Show cursor line
o.cursorline = true

-- Enable line numbers
o.number = true
o.numberwidth = 2

-- Conceal
o.conceallevel = 2
o.fillchars = "foldopen:,foldclose:,fold: ,foldsep: ,diff:╱,eob: "
