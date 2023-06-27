local opt = vim.opt

opt.shell = "/bin/bash"

-- make scrolling and painting fast
opt.lazyredraw = true

-- Search recursively downward from CWD; provides TAB completion for filenames
-- e.g., `:find vim* <TAB>`
-- opt.path:append(",**")

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

-- Enable local config files using a trustdb.
if vim.secure.read or vim.secure_read then
  opt.exrc = true
end

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

-- Searching
opt.ignorecase = true
opt.smartcase = true

-- Set ripgrep as default search tool
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --no-heading --smart-case"
  opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- Format options
opt.formatoptions = opt.formatoptions
  + "t" -- Auto-wrap using 'textwidth'
  + "c" -- Auto-wrap comments using 'textwidth'
  + "r" -- Automatically insert current comment leader in insert mode (<CR>)
  + "o" -- Automatically insert current comment leader in normal mode (o or O)
  + "q" -- Allow formatting with 'gq'
  + "n" -- Recognize numbered lists
  + "b" -- Only auto-wrap if line was entered at or before the wrap margin
  + "l" -- Long lines when entering insert mode are not wrapped automatically
  + "j" -- Remove comment leader when joining lines

-- Completion menu options
vim.opt.completeopt = vim.opt.completeopt
  + "menu" -- Use a popup menu to show possible completions
  + "menuone" -- Show menu even with one result
  + "noselect" -- Don't automatically select a match

-- Avoid showing extra messages when using completion
vim.opt.shortmess = vim.opt.shortmess + "c" -- Don't give ins-complete-menu messages

-- Use treesitter for folding
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99 -- Nothing is folded by default

-- Set 7 lines to the cursor - when moving vertically using j/k
opt.smoothscroll = true
opt.scrolloff = 7

-- Open new splits to the right or down instead of moving current window
opt.splitright = true
opt.splitbelow = true

-- Make diffing better: https://vimways.org/2018/the-power-of-diff/
opt.diffopt = opt.diffopt
  + "iwhite" -- No whitespace in vimdiff
  + "algorithm:patience"
  + "indent-heuristic"
  + "linematch:60"

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
opt.showmode = false -- Hide mode indicator

opt.ruler = false -- Don't show column and row position, handled by theme.

-- Show a ruler at 80 characters.
opt.textwidth = 80
opt.colorcolumn = { 80 }

opt.number = true
opt.numberwidth = 2

-- Disable using the mouse inside Neovim.
opt.mouse = "nvi"
-- Remove how-to disable mouse and previous line from right-click menu.
vim.cmd([[
  aunmenu PopUp.How-to\ disable\ mouse
  aunmenu PopUp.-1-
]])

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

opt.conceallevel = 2
opt.showbreak = " -> "
opt.fillchars = { eob = " " }

vim.cmd.colorscheme("everforest")
