local opt = vim.opt

-- make scrolling and painting fast
opt.lazyredraw = true

-- Search recursively downward from CWD; provides TAB completion for filenames
-- e.g., `:find vim* <TAB>`
opt.path = opt.path:append(",**")

-- Set working directory to the current files
opt.autochdir = false

-- Number of lines at the beginning and end of files checked for file-specific vars
opt.modelines = 3
opt.modeline = true

-- make Backspace work like Delete
opt.backspace = "indent,eol,start"

-- Permanent undo
opt.undofile = true

-- Backups and Swap files
opt.backup = false
opt.swapfile = true

-- Automatically update buffer if modified outside of neovim.
opt.autoread = true

-- Better display for messages
opt.updatetime = 1000

-- open new buffers without saving current modifications (buffer remains open)
opt.hidden = true

-- Set the timeout times
opt.timeoutlen = 500
opt.ttimeoutlen = 5

-- Use system clipboard
if vim.g.os == "Darwin" then
  opt.clipboard = "unnamed"
elseif vim.g.os == "Linux" then
  opt.clipboard = "unnamedplus"
elseif vim.g.os == "Windows" then
end

-- ===========================
-- |=========================|
-- ||                       ||
-- || Editing and Searching ||
-- ||                       ||
-- |=========================|
-- ===========================
--
-- Indent new line the same as the preceding line
opt.autoindent = true

-- Tab key enters 2 spaces
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2

-- highlight matching parens, braces, brackets, etc
opt.showmatch = true

-- Menu options
opt.pumblend = 17

-- Wildmenu options
opt.wildmenu = true
opt.wildmode = "longest:full"
opt.wildoptions = "pum" -- Fancy menu
opt.wildignore = [[*.o,*~,*.pyc,.hg,.svn,*.png,*.jpg,*.gif,*.settings,*.min.js,*.swp,publish/*]]

-- Searching
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Set ripgrep as default search tool
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --no-heading --smart-case"
  opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- Format options
opt.formatoptions = opt.formatoptions
  + "t" -- auto wrap text using textwidth
  + "c" -- auto wrap comments using textwidth
  + "r" -- auto insert comment leader on pressing enter
  + "o" -- auto insert comment leader on pressing o
  + "q" -- format comments with gq
  - "a" -- don't autoformat the paragraphs
  + "n" -- auto format numbered list
  - "2" -- use the first line to specify indent width, not the second
  + "b" -- auto wrap in insert mode, and do not wrap old long lines
  + "l" -- long lines are not broken in insert mode
  + "j" -- remove comment leader when joining lines

-- Use treesitter for folding
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99 -- Nothing is folded by default

-- Set 7 lines to the cursor - when moving vertically using j/k
opt.scrolloff = 7

-- Open new splits to the right or down instead of moving current window
opt.splitright = true
opt.splitbelow = true

-- Diff options
vim.cmd([[
set diffopt+=iwhite " No whitespace in vimdiff
" Make diffing better: https://vimways.org/2018/the-power-of-diff/
set diffopt+=algorithm:patience
set diffopt+=indent-heuristic
]])

-- Set spell location to English and German
opt.spell = true
opt.spelllang = "en,de"

-- ==============================
-- |============================|
-- ||                          ||
-- ||   Appearance and Theme   ||
-- ||                          ||
-- |============================|
-- ==============================
--
-- Turn of bell and visual bell
opt.visualbell = false
opt.belloff = "all" -- Turn off the bell for everything for good measure

-- Colorscheme and background
opt.termguicolors = true -- 24-bit RGB color support
opt.background = "dark"
vim.cmd([[colorscheme gruvbox-material]])

-- Always show the status line and tabline
opt.showtabline = 2 -- Always show the tab line
opt.laststatus = 3 -- Use the global status line
opt.cmdheight = 1 -- Only need 1 line for the command prompt
opt.showmode = false -- Don't show the mode in the prompt, handled by the theme
opt.showcmd = true --Show the last line of the last command

-- Show a ruler at 80 characters.
opt.textwidth = 80
opt.colorcolumn = { 80 }
opt.ruler = true

-- Enable relative numbers, but display the line number in the current line.
opt.relativenumber = true
opt.number = true

-- Only enable the cursor line in the current buffer.
opt.cursorline = true -- Highlight the current line
local group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
local set_cursorline = function(event, value, pattern)
  vim.api.nvim_create_autocmd(event, {
    group = group,
    pattern = pattern,
    callback = function()
      vim.opt_local.cursorline = value
    end,
  })
end
set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)
set_cursorline("FileType", false, "TelescopePrompt")

-- Wrap lines
opt.wrap = true
opt.showbreak = string.rep(" ", 3)
