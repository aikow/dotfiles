require('plugins')

local g = vim.g
local o, wo, bo = vim.o, vim.wo, vim.bo

local utils = require('utils')
local opt = utils.opt
local autocmd = utils.autocmd
local map = utils.map
local smap = utils.smap

-- Check the host operating system
if vim.fn.has('win64') == 1 
  or vim.fn.has('win32') == 1
  or vim.fn.has('win16') == 1
then
  g.os = "Windows"
else
  g.os = vim.fn.substitute(vim.fn.system('uname'), '\n', '', '')
end


-- =======================
-- |=====================|
-- ||                   ||
-- || Internal Settings ||
-- ||                   ||
-- |=====================|
-- =======================
--
-- Set runtimepath to the source files in the dotfiles directory
o.rtp = o.rtp .. ',' .. vim.fn.expand('~/.dotfiles/tools/vim/rtp')

-- If launching vim from fish, set the shell to bash.
if string.match(vim.o.shell, 'fish$') then
  o.shell = 'bash'
end

-- Don't need vi compatibility
o.compatible = false

-- make scrolling and painting fast
-- ttyfast kept for vim compatibility but not needed for nvim
o.ttyfast = true
o.lazyredraw = true

-- use Unicode
o.encoding = 'utf-8'

-- Search recursively downward from CWD; provides TAB completion for filenames
-- e.g., `:find vim* <TAB>`
o.path = o.path .. ',**'

-- Set working directory to the current files
o.autochdir = false

-- Number of lines at the beginning and end of files checked for file-specific vars
o.modelines = 3
o.modeline = true

-- make Backspace work like Delete
o.backspace = 'indent,eol,start'

-- Permanent undo
o.undofile = true

-- Backups and Swap files
o.backup = false
o.swapfile = true

-- Better display for messages
o.updatetime = 1000

-- open new buffers without saving current modifications (buffer remains open)
o.hidden = true

-- Set the timeout times
o.timeoutlen = 500
o.ttimeoutlen = 5

-- Use system clipboard
if g.os == 'Darwin' then
  o.clipboard = 'unnamed'
elseif g.os == 'Linux' then
  o.clipboard = 'unnamedplus'
elseif g.os == 'Windows' then
end

-- Filetype plugins
vim.cmd [[
filetype plugin on
filetype indent on
]]

-- Set the python provider for neovim
vim.cmd [[
let s:pynvim_path = expand("$HOME/.miniconda3/envs/pynvim3/bin/python")

if !filereadable(s:pynvim_path)
" Bootstrap the python3 conda env with pynvim
echom "Bootstrapping the conda python3 env..."
execute "!" . expand('conda env create -f $HOME/.dotfiles/tools/vim/envs/pynvim3.yml')
endif

let g:python3_host_prog = s:pynvim_path
]]


-- ===========================
-- |=========================|
-- ||                       ||
-- || Editing and Searching ||
-- ||                       ||
-- |=========================|
-- ===========================
--
-- Indent new line the same as the preceding line
o.autoindent = true

-- Tab key enters 2 spaces
o.expandtab = true
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2 

-- highlight matching parens, braces, brackets, etc
o.showmatch = true

-- Wildmenu options
o.wildmenu = true
o.wildmode = 'list:longest'
o.wildignore = [[*.o,*~,*.pyc,.hg,.svn,*.png,*.jpg,*.gif,*.settings,*.min.js,*.swp,publish/*]]

-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force user to select one from the menu
o.completeopt = 'menuone,noinsert,noselect'

-- Avoid showing extra messages when using completion
o.shortmess = 'filnxtToOF'
o.shortmess = o.shortmess .. 'c'

-- Searching
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.smartcase = true

-- Set ripgrep as default search tool
vim.cmd [[
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
  set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  set grepformat=%f:%l:%m
endif
]]

-- Format options
-- + 't'    -- auto-wrap text using textwidth
-- + 'c'    -- auto-wrap comments using textwidth
-- + 'r'    -- auto insert comment leader on pressing enter
-- - 'o'    -- don't insert comment leader on pressing o
-- + 'q'    -- format comments with gq
-- - 'a'    -- don't autoformat the paragraphs (use some formatter instead)
-- + 'n'    -- autoformat numbered list
-- + 'b'    -- auto-wrap in insert mode, and do not wrap old long lines
-- - '2'    -- I am a programmer and not a writer
-- + 'j'    -- Join comments smartly
o.formatoptions = 'tcroqnbj2'

-- Folding
o.foldmethod = 'expr'
o.foldexpr = 'nvim_treesitter#foldexpr()'
o.foldlevel = 20

-- Set 7 lines to the cursor - when moving vertically using j/k
o.scrolloff = 7


-- Open new splits to the right or down instead of moving current window
o.splitright = true
o.splitbelow = true

-- Diff options
vim.cmd [[
set diffopt+=iwhite " No whitespace in vimdiff
if has('patch-8.1.0360')
  " Make diffing better: https://vimways.org/2018/the-power-of-diff/
  set diffopt+=algorithm:patience
  set diffopt+=indent-heuristic
endif
]]

-- Set spell location to English and German
wo.spell = true
o.spelllang = 'en,de'

-- -----------------------
-- | Appearance Settings |
-- -----------------------
--
-- Enable syntax highlighting for languages
vim.cmd [[syntax enable]]

-- Turn of bell and visual bell
o.visualbell = false

-- Colorscheme and background
o.termguicolors = true
o.background = 'dark'
vim.cmd [[colorscheme gruvbox-material]]

-- Always show the status line and tabline
o.showtabline = 2
o.laststatus = 2
o.cmdheight = 1
o.showmode = false

-- Show character column
o.colorcolumn = '80'
o.ruler = true
o.relativenumber = true
o.cursorline = true

-- Wrap lines
o.wrap = true

-- =========================
-- |=======================|
-- ||                     ||
-- || General Keybindings ||
-- ||                     ||
-- |=======================|
-- =========================
--
-- Set the leader key to the space key
map('n', '<SPACE>', '<Nop>')
g.mapleader = ' '

-- Set local leader to the backslash
g.maplocalleader = [[\]]

-- ----------------------------------
-- | Vim Tmux Navigator keybindings |
-- ----------------------------------
g.tmux_navigator_no_mappings = 1

smap('n', '<M-h>', [[<cmd>TmuxNavigateLeft<CR>]])
smap('n', '<M-j>', [[<cmd>TmuxNavigateDown<CR>]])
smap('n', '<M-k>', [[<cmd>TmuxNavigateUp<CR>]])
smap('n', '<M-l>', [[<cmd>TmuxNavigateRight<CR>]])
smap('n', '<M-o>', [[<cmd>TmuxNavigatePrevious<CR>]])

-- Treat long lines as break lines (useful when moving around in them)
map('n', 'j', 'gj')
map('n', 'k', 'gk')

-- Don't deselect visual when indenting in visual mode
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Very magic by default
map('n', '?', [[?\v]])
map('n', '/', [[/\v]])
map('n', '<C-s>', [[:%s/\v]])
map('c', '<C-s>', [[%s/\v]])

-- <leader><leader> toggles between buffers
map('n', '<leader><leader>', '<c-^>')

-- <leader>, shows/hides hidden characters
smap('n', '<leader>,', ':set invlist<CR>')

-- <leader>q shows stats
map('n', '<leader>q', 'g<C-g>')

-- Keymap for replacing up to next _ or -
map('n', '<leader>m', 'ct_')

-- Automatically correct spelling with the first option
map('i', '<C-l>', '<C-g>u<Esc>[s1z=`]a<C-g>u')

map('i', '<c-_>', '<C-o><Plug>CommentaryLine', { noremap = false })
map('n', '<C-c>', '<Plug>CommentaryLine', { noremap = false })

-- Clear the search buffer to remove highlighting from the last search
smap('n', '<c-_>', [[:let @/ = ""<CR>]])

-- Use <gp> to select the text that was last pasted
map('n', 'gp', [['`[' . strpart(getregtype(), 0,  1) . '`]']], { noremap=true, expr=true })

-- Switch buffers using gb and gB, similar to tabs.
smap('n', 'gb', ':bnext<CR>')
smap('n', 'gB', ':bprev<CR>')

-- Sort the selected lines
smap('v', '<leader>rs', ':!sort<CR>')

-- Make Y behave like other capital numbers
map('n', 'Y', 'y$')

-- Keep it centered
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')
-- map('n', 'J', 'mzJ`z')

-- Undo Break points
map('i', ',', ',<C-g>u')
map('i', '.', '.<C-g>u')
map('i', '!', '!<C-g>u')
map('i', '?', '?<C-g>u')

-- Automatically jump to the end of pasted text
map('v', 'y', 'y`]')
map({'v', 'n'}, 'p', 'p`]')

-- ----------------------------------------------------
-- | Telescope, LSP, Diagnostics, and Git keybindings |
-- ----------------------------------------------------
--
-- Diagnostics
-- See `:help vim.diagnostic.*` for documentation on any of the below
-- functions
map('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
map('n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
map('n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>')
map('n', '<space>dq', '<cmd>lua vim.diagnostic.setloclist()<CR>')
map('n', '<space>do', [[:lua require('telescope.builtin').diagnostics()<CR>]])
map('n', '<space>ds', [[:lua require('telescope.builtin').spell_suggest()<CR>]])

-- LSP functions
-- See `:help vim.lsp.*` for documentation on any of the below functions
map('n', '<leader>k', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<leader>l', '<cmd>lua vim.lsp.buf.signature_help()<CR>')

-- Goto references with <leader>j...
map('n', '<leader>jc', '<cmd>lua vim.lsp.buf.declaration()<CR>')
map('n', '<leader>jD', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<leader>jd', [[<cmd>lua require('telescope.builtin').lsp_definitions()<CR>]])
map('n', '<leader>jR', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<leader>jr', [[<cmd>lua require('telescope.builtin').lsp_references()<CR>]])
map('n', '<leader>jI', '<cmd>lua vim.lsp.buf.implementation()<CR>')
map('n', '<leader>ji', [[<cmd>lua require('telescope.builtin').lsp_implementations()<CR>]])
map('n', '<leader>jT', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
map('n', '<leader>jt', [[<cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>]])

-- Telescope LSP pickers
map('n', '<leader>ja', [[<cmd>lua require('telescope.builtin').lsp_code_actions()<CR>]])
map('n', '<leader>jA', [[<cmd>lua require('telescope.builtin').lsp_range_code_actions()<CR>]])
map('n', '<leader>jw', [[<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>]])
map('n', '<leader>js', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])

-- Workspace settings with <leader>w...
map('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
map('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
map('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')

-- Refactoring with <leader>r...
map('n', '<leader>rr', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<leader>rq', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', '<leader>rf', '<cmd>lua vim.lsp.buf.formatting()<CR>')

-- Finding searching and navigating
smap('n', '<leader>;', [[<cmd>lua require('telescope.builtin').commands()<CR>]])
smap('n', '<leader>o', [[<cmd>lua require('telescope.builtin').find_files()<CR>]])
smap('n', '<leader>p', [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
smap('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]])
smap('n', '<leader>fs', [[<cmd>lua require('telescope.builtin').spell_suggest()<CR>]])
smap('n', '<leader>fb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]])
smap('n', '<leader>fts', [[<cmd>lua require('telescope.builtin').tags()<CR>]])
smap('n', '<leader>fh', [[<cmd>lua require('telescope.builtin').search_history()<CR>]])
smap('n', '<leader>f;', [[<cmd>lua require('telescope.builtin').command_history()<CR>]])

-- Git shortcuts
smap('n', '<leader>go', [[<cmd>lua require('telescope.builtin').git_files()<CR>]])
smap('n', '<leader>gC', [[<cmd>lua require('telescope.builtin').git_commits()<CR>]])
smap('n', '<leader>gc', [[<cmd>lua require('telescope.builtin').git_bcommits()<CR>]])
smap('n', '<leader>gb', [[<cmd>lua require('telescope.builtin').git_branches()<CR>]])
smap('n', '<leader>gt', [[<cmd>lua require('telescope.builtin').git_status()<CR>]])
smap('n', '<leader>gh', [[<cmd>lua require('telescope.builtin').git_stash()<CR>]])

-- Navigation
smap('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
smap('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

-- -- Git actions related actions with <leader>g...
smap({'n', 'v'}, '<leader>gs', '<cmd>Gitsigns stage_hunk<CR>')
smap({'n', 'v'}, '<leader>gr', '<cmd>Gitsigns reset_hunk<CR>')
smap('n', '<leader>gS', '<cmd>Gitsigns stage_buffer<CR>')
smap('n', '<leader>gu', '<cmd>Gitsigns undo_stage_hunk<CR>')
smap('n', '<leader>gR', '<cmd>Gitsigns reset_buffer<CR>')
smap('n', '<leader>gp', '<cmd>Gitsigns preview_hunk<CR>')
smap('n', '<leader>gL', '<cmd>Gitsigns toggle_current_line_blame<CR>')
smap('n', '<leader>gd', '<cmd>Gitsigns diffthis<CR>')
smap('n', '<leader>gtd', '<cmd>Gitsigns toggle_deleted<CR>')

-- -- Text object
smap({'o', 'x'}, 'ig', ':<C-U>Gitsigns select_hunk<CR>')

-- Cargo shortcuts
smap('n', '<leader>ct', [[<cmd>lua require('crates').toggle()<CR>]])
smap('n', '<leader>cr', [[<cmd>lua require('crates').reload()<CR>]])

smap('n', '<leader>cv', [[<cmd>lua require('crates').show_versions_popup()<CR>]])
smap('n', '<leader>cf', [[<cmd>lua require('crates').show_features_popup()<CR>]])
smap('n', 'K', [[:call <SID>show_documentation()<CR>]])

-- update creates
smap('n', '<leader>cu', [[<cmd>lua require('crates').update_crate()<CR>]])
smap('n', '<leader>cu', [[<cmd>lua require('crates').update_crates()<CR>]])
smap('n', '<leader>ca', [[<cmd>lua require('crates').update_all_crates()<CR>]])
smap('n', '<leader>cU', [[<cmd>lua require('crates').upgrade_crate()<CR>]])
smap('n', '<leader>cU', [[<cmd>lua require('crates').upgrade_crates()<CR>]])
smap('n', '<leader>cA', [[<cmd>lua require('crates').upgrade_all_crates()<CR>]])

-- Setting shortcuts
smap('n', '<leader>ho', [[<cmd>lua require('telescope.builtin').vim_options()<CR>]])
smap('n', '<leader>hc', [[<cmd>lua require('telescope.builtin').colorscheme()<CR>]])
smap('n', '<leader>hh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]])
smap('n', '<leader>hm', [[<cmd>lua require('telescope.builtin').man_pages()<CR>]])
smap('n', '<leader>h\'', [[<cmd>lua require('telescope.builtin').marks()<CR>]])
smap('n', '<leader>hk', [[<cmd>lua require('telescope.builtin').keymaps()<CR>]])
smap('n', '<leader>hf', [[<cmd>lua require('telescope.builtin').filetypes()<CR>]])
smap('n', '<leader>hr', [[<cmd>lua require('telescope.builtin').registers()<CR>]])
smap('n', '<leader>ha', [[<cmd>lua require('telescope.builtin').autocommands()<CR>]])
smap('n', '<leader>ht', [[<cmd>lua require('telescope.builtin').pickers()<CR>]])

-- Faster write/save current buffer
smap('n', '<leader>w', ':w<CR>')

-- Resizing splits
smap('n', '<leader>wvp', ':exe "vertical resize " . (winwidth(0) * 3/2)<CR>')
smap('n', '<leader>wvm', ':exe "vertical resize " . (winwidth(0) * 2/3)<CR>')
smap('n', '<leader>whp', ':exe "resize " . (winheight(0) * 3/2)<CR>')
smap('n', '<leader>whm', ':exe "resize " . (winheight(0) * 2/3)<CR>')
map('n', '<C-w><', '5<C-w><')
map('n', '<C-w>>', '5<C-w>>')
map('n', '<C-w>-', '5<C-w>-')
map('n', '<C-w>+', '5<C-w>+')


vim.cmd [[
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Functions                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Reload files changed outside of Vim not currently modified in Vim 
set autoread
augroup general_autoread
  autocmd!
  autocmd FocusGained,BufEnter * :silent! !
augroup END

" Prevent accidental writes to buffers that shouldn't be edited
augroup unmodifiable
  autocmd BufRead *.orig set readonly
  autocmd BufRead *.pacnew set readonly
augroup END

" Jump to last edit position on opening file
if has("autocmd")
  " https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
  au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Help filetype detection
augroup filetype_help
  autocmd BufRead *.plot set filetype=gnuplot
  autocmd BufRead *.md set filetype=markdown
  autocmd BufRead *.lds set filetype=ld
  autocmd BufRead *.tex set filetype=tex
  autocmd BufRead *.trm set filetype=c
  autocmd BufRead *.xlsx.axlsx set filetype=ruby
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 Functions                                  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Show the cargo.toml documentation.
function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (index(['man'], &filetype) >= 0)
        execute 'Man '.expand('<cword>')
    elseif (expand('%:t') == 'Cargo.toml')
        lua require('crates').show_popup()
    else
        lua vim.lsp.buf.hover()
    endif
endfunction

" Prints the syntax stack at the current cursor
function! EchoSynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                    Rust                                    "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Set rust specific vim settings.
augroup ft_rust
  autocmd FileType rust setlocal colorcolumn=100
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Python                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Set settings for python files
augroup ft_python
  autocmd!
  autocmd FileType python setlocal tabstop=4
  autocmd FileType python setlocal softtabstop=4
  autocmd FileType python setlocal shiftwidth=4
  autocmd FileType python setlocal textwidth=80
  autocmd FileType python setlocal expandtab
  autocmd FileType python setlocal autoindent
  autocmd FileType python setlocal fileformat=unix
augroup END

" Function to activate a virtualenv in the embedded interpeter
function! LoadVirtualEnv(path)
  let activate_this = a:path . '/bin/activate_this.py'
  if getftype(a:path) == "dir" && filereadable(activate_this)
    python << EOF
import vim
activate_this = vim.eval('l:activate_this')
execfile(activate_this, dict(__file__=activate_this))
EOF
  endif
endfunction

" Set default virtual environment
let defaultvirtualenv = $HOME . "/.miniconda3/bin"

" Only attempt to load this virtualenv if the defaultvirtualenv actually
" exists and we aren't running with a virtualenv active.
if has("python")
  if empty($VIRTUAL_ENV) && getftype(defaultvirtualenv) == "dir"
    call LoadVirtualEnv(defaultvirtualenv)
  endif
endif

]]

