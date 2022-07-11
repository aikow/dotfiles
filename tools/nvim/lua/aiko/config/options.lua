local opt = vim.opt
local g = vim.g

-- Opt into lua filetype recognition.
g.do_filetype_lua = 1

opt.shell = "/bin/bash"

-- make scrolling and painting fast
opt.lazyredraw = true

-- Search recursively downward from CWD; provides TAB completion for filenames
-- e.g., `:find vim* <TAB>`
opt.path = opt.path:append(",**")

-- Permanent undo
opt.undofile = true

-- Backups and Swap files
opt.backup = false

-- Better display for messages
opt.updatetime = 1000

-- Set the timeout times
opt.timeoutlen = 500
opt.ttimeoutlen = 5

-- Use system clipboard
opt.clipboard = "unnamedplus"

-- ===========================
-- |=========================|
-- ||                       ||
-- || Editing and Searching ||
-- ||                       ||
-- |=========================|
-- ===========================
--
-- Tab key enters 2 spaces
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2

-- highlight matching parens, braces, brackets, etc
opt.showmatch = true

-- Wild menu options
opt.wildmode = "longest:full"
opt.wildoptions = "pum" -- Fancy menu
opt.wildignore =
  [[*.o,*~,*.pyc,.hg,.svn,*.png,*.jpg,*.gif,*.settings,*.min.js,*.swp,publish/*]]

-- Searching
opt.ignorecase = true
opt.smartcase = true

-- Set ripgrep as default search tool
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --no-heading --smart-case"
  opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- Format options
opt.formatoptions = "tcroqnblj"

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
--
-- Make diffing better: https://vimways.org/2018/the-power-of-diff/
opt.diffopt = opt.diffopt
  + "iwhite" -- No whitespace in vimdiff
  + "algorithm:patience"
  + "indent-heuristic"

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
-- Color scheme and background
opt.termguicolors = true -- 24-bit RGB color support

-- Always show the status line and tabline
opt.showtabline = 2 -- Always show the tab line
opt.laststatus = 3 -- Use the global status line
opt.showmode = false -- Don't show the mode in the prompt, handled by theme.
opt.ruler = false -- Don't show column and row position, handled by theme.

-- Show a ruler at 80 characters.
opt.textwidth = 80
opt.colorcolumn = { 80 }

-- Enable relative numbers, but display the line number in the current line.
opt.relativenumber = true
opt.number = true
opt.numberwidth = 2

-- Only enable the cursor line in the current buffer.
opt.cursorline = true -- Highlight the current line
local group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
local set_cursorline = function(event, value, pattern)
  vim.api.nvim_create_autocmd(event, {
    group = group,
    pattern = pattern,
    callback = function() vim.opt_local.cursorline = value end,
  })
end
set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)
set_cursorline("FileType", false, "TelescopePrompt")

opt.conceallevel = 2
opt.showbreak = " -> "
opt.fillchars = { eob = " " }
