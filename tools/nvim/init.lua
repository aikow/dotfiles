require('plugins')

local g = vim.g
local cmd = vim.cmd
local o, wo, bo = vim.o, vim.wo, vim.bo

local utils = require('utils')
local opt = utils.opt
local autocmd = utils.autocmd
local map = utils.map
local smap = utils.smap


vim.api.nvim_exec([[
" Check the host operating system
if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
    else
        let g:os = substitute(system('uname'), '\n', '', '')
    endif
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Internal                                  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Set runtimepath to the source files in the dotfiles directory
set rtp+=~/.dotfiles/tools/vim/rtp

" If launching vim from fish, set the shell to bash.
if &shell =~# 'fish$'
    set shell=bash
endif

" Don't need vi compatibility
set nocompatible

" make scrolling and painting fast
" ttyfast kept for vim compatibility but not needed for nvim
set ttyfast
set lazyredraw

if !(has('nvim') || has('gvim'))
  set noesckeys
endif

" use Unicode
set encoding=utf-8

" Search recursively downward from CWD; provides TAB completion for filenames
" e.g., `:find vim* <TAB>`
set path+=**

" Set working directory to the current files
set noautochdir

" Number of lines at the beginning and end of files checked for file-specific vars
set modelines=3
set modeline

" make Backspace work like Delete
set backspace=indent,eol,start

" Permanent undo
set undodir=~/.vimdid
set undofile

" Backups and Swap files
set nobackup
set swapfile

" Better display for messages
set updatetime=1000

" open new buffers without saving current modifications (buffer remains open)
set hidden

" Set the timeout times
set timeoutlen=500
set ttimeoutlen=5

" Use system clipboard
if g:os == "Darwin"
  set clipboard+=unnamed
elseif g:os == "Linux"
  set clipboard+=unnamedplus
elseif g:os == "Windows"
endif

" Filetype plugins
filetype plugin on
filetype indent on

" Set the python provider for neovim
if has('nvim')
  let s:pynvim_path = expand("$HOME/.miniconda3/envs/pynvim3/bin/python")

  if !filereadable(s:pynvim_path)
    " Bootstrap the python3 conda env with pynvim
    echom "Bootstrapping the conda python3 env..."
    execute "!" . expand('conda env create -f $HOME/.dotfiles/tools/vim/envs/pynvim3.yml')
  endif

  let g:python3_host_prog = s:pynvim_path
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Editing                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Indent new line the same as the preceding line
set autoindent

" Tab key enters 2 spaces
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2 

" highlight matching parens, braces, brackets, etc
set showmatch

" Wildmenu options
set wildmenu
set wildmode=list:longest
set wildignore=*.o,*~,*.pyc,.hg,.svn,*.png,*.jpg,*.gif,*.settings,*.min.js,*.swp,publish/*

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
if has('patch-7.4.775')
  set completeopt=menuone,noinsert,noselect
endif

" Avoid showing extra messages when using completion
set shortmess+=c

" Searching
set hlsearch 
set incsearch
set ignorecase
set smartcase

if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
  set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  set grepformat=%f:%l:%m
endif

" Wrapping options
set formatoptions=tc " wrap text and comments using textwidth
set formatoptions+=r " continue comments when pressing ENTER in I mode
set formatoptions+=q " enable formatting of comments with gq
set formatoptions+=n " detect lists for formatting
set formatoptions+=b " auto-wrap in insert mode, and do not wrap old long lines

" Folding
set foldmethod=indent
set foldnestmax=1
set foldlevelstart=1

" Set 7 lines to the cursor - when moving vertically using j/k
set scrolloff=7

" Open new splits to the right or down instead of moving current window
set splitright
set splitbelow

" Diff options
set diffopt+=iwhite " No whitespace in vimdiff
if has('patch-8.1.0360')
  " Make diffing better: https://vimways.org/2018/the-power-of-diff/
  set diffopt+=algorithm:patience
  set diffopt+=indent-heuristic
endif

" Set spell location to English and German
setlocal spell
set spelllang=en,de


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 Appearance                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Enable syntax highlighting for languages
syntax enable

" Neovim only
if has("nvim")
  set termguicolors 
endif

if exists('+termguicolors')
  let &t_8f = '\<Esc>[38;2;%lu;%lu;%lum'
  let &t_8b = '\<Esc>[48;2;%lu;%lu;%lum'
  set termguicolors
endif
]], false)

-- Turn of bell and visual bell
o.visualbell = false

o.background = 'dark'
cmd [[colorscheme gruvbox-material]]

-- Always show the status line and tabline
o.showtabline = 2
o.laststatus = 2
o.cmdheight = 1
o.showmode = false

-- Show character column
o.colorcolumn = 80
o.ruler = true
o.relativenumber = true
o.cursorline = true

-- Wrap lines
o.wrap = true

-- Keybindings
-- Set the leader key to the space key
map('n', '<SPACE>', '<Nop>')
g.mapleader = ' '

-- Set local leader to the backslash
g.maplocalleader = [[\]]
-- Treat long lines as break lines (useful when moving around in them)
map('n', 'j', 'gj')
map('n', 'k', 'gk')

-- Don't deselect visual when indenting in visual mode
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Very magic by default
map('n', '?', [[?\v]])
map('n', '/', [[/\v]])
map('c', [[%s/]], [[%sm/]])

-- <leader><leader> toggles between buffers
map('n', '<leader><leader>', '<c-^>')

-- <leader>, shows/hides hidden characters
smap('n', '<leader>,', ':set invlist<cr>')

-- <leader>q shows stats
map('n', '<leader>q', 'g<c-g>')

-- Keymap for replacing up to next _ or -
map('n', '<leader>m', 'ct_')

-- Automatically correct spelling with the first option
map('i', '<C-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u')

-- Clear the search buffer to remove highlighting from the last search
smap('n', '<c-_>', [[:let @/ = ""<CR>]])

-- Use <gp> to select the text that was last pasted
map('n', 'gp', [=[`[' . strpart(getregtype(), 0,  1) . '`]]=], { noremap=true, expr=true })

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
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', '!', '!<c-g>u')
map('i', '?', '?<c-g>u')

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
map('n', '<space>do', [[:lua require('telescope.builtin').diagnostics()<cr>]])
map('n', '<space>ds', [[:lua require('telescope.builtin').spell_suggest()<cr>]])

-- LSP functions
-- See `:help vim.lsp.*` for documentation on any of the below functions
map('n', '<leader>k', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<leader>l', '<cmd>lua vim.lsp.buf.signature_help()<CR>')

-- Goto references with <leader>j...
map('n', '<leader>jc', '<cmd>lua vim.lsp.buf.declaration()<CR>')
map('n', '<leader>jd', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<leader>jr', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<leader>ji', '<cmd>lua vim.lsp.buf.implementation()<CR>')
map('n', '<leader>jt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')

-- Workspace settings with <leader>w...
map('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
map('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
map('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')

-- Refactoring with <leader>r...
map('n', '<leader>rr', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<leader>rq', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', '<leader>rf', '<cmd>lua vim.lsp.buf.formatting()<CR>')

-- Finding searching and navigating
smap('n', '<leader>;', [[<cmd>lua require('telescope.builtin').commands()<cr>]])
smap('n', '<leader>o', [[<cmd>lua require('telescope.builtin').find_files()<cr>]])
smap('n', '<leader>p', [[<cmd>lua require('telescope.builtin').buffers()<cr>]])
smap('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').live_grep()<cr>]])
smap('n', '<leader>fs', [[:lua require('telescope.builtin').spell_suggest()<cr>]])
smap('n', '<leader>fb', [[:lua require('telescope.builtin').current_buffer_fuzzy_fund()<cr>]])
smap('n', '<leader>fts', [[<cmd>lua require('telescope.builtin').tags()<cr>]])
smap('n', '<leader>fh', [[<cmd>lua require('telescope.builtin').search_history()<cr>]])
smap('n', '<leader>f;', [[<cmd>lua require('telescope.builtin').command_history()<cr>]])

-- Git shortcuts
smap('n', '<leader>go', [[<cmd>lua require('telescope.builtin').git_files()<cr>]])
smap('n', '<leader>gC', [[<cmd>lua require('telescope.builtin').git_commits()<cr>]])
smap('n', '<leader>gc', [[<cmd>lua require('telescope.builtin').git_bcommits()<cr>]])
smap('n', '<leader>gb', [[<cmd>lua require('telescope.builtin').git_branches()<cr>]])
smap('n', '<leader>gt', [[<cmd>lua require('telescope.builtin').git_status()<cr>]])
smap('n', '<leader>gh', [[<cmd>lua require('telescope.builtin').git_stash()<cr>]])


-- Cargo shortcuts
smap('n', '<leader>ct', [[<cmd>lua require('crates').toggle()<cr>]])
smap('n', '<leader>cr', [[<cmd>lua require('crates').reload()<cr>]])

smap('n', '<leader>cv', [[<cmd>lua require('crates').show_versions_popup()<cr>]])
smap('n', '<leader>cf', [[<cmd>lua require('crates').show_features_popup()<cr>]])
smap('n', 'K', [[:call <SID>show_documentation()<cr>]])

-- update creates
smap('n', '<leader>cu', [[<cmd>lua require('crates').update_crate()<cr>]])
smap('n', '<leader>cu', [[<cmd>lua require('crates').update_crates()<cr>]])
smap('n', '<leader>ca', [[<cmd>lua require('crates').update_all_crates()<cr>]])
smap('n', '<leader>cU', [[<cmd>lua require('crates').upgrade_crate()<cr>]])
smap('n', '<leader>cU', [[<cmd>lua require('crates').upgrade_crates()<cr>]])
smap('n', '<leader>cA', [[<cmd>lua require('crates').upgrade_all_crates()<cr>]])

-- Setting shortcuts
smap('n', '<leader>ho', [[<cmd>lua require('telescope.builtin').vim_options()<cr>]])
smap('n', '<leader>hc', [[<cmd>lua require('telescope.builtin').colorscheme()<cr>]])
smap('n', '<leader>hh', [[<cmd>lua require('telescope.builtin').help_tags()<cr>]])
smap('n', '<leader>hm', [[<cmd>lua require('telescope.builtin').man_pages()<cr>]])
smap('n', '<leader>h\'', [[<cmd>lua require('telescope.builtin').marks()<cr>]])
smap('n', '<leader>hk', [[<cmd>lua require('telescope.builtin').keymaps()<cr>]])
smap('n', '<leader>hf', [[<cmd>lua require('telescope.builtin').filetypes()<cr>]])
smap('n', '<leader>hr', [[<cmd>lua require('telescope.builtin').registers()<cr>]])
smap('n', '<leader>ha', [[<cmd>lua require('telescope.builtin').autocommands()<cr>]])
smap('n', '<leader>ht', [[<cmd>lua require('telescope.builtin').pickers()<cr>]])

-- Faster write/save current buffer
smap('n', '<leader>w', ':w<CR>')

-- Resizing splits
smap('n', '<leader>wvp', ':exe "vertical resize " . (winwidth(0) * 3/2)<CR>')
smap('n', '<leader>wvm', ':exe "vertical resize " . (winwidth(0) * 2/3)<CR>')
smap('n', '<leader>whp', ':exe "resize " . (winheight(0) * 3/2)<CR>')
smap('n', '<leader>whm', ':exe "resize " . (winheight(0) * 2/3)<CR>')
map('n', '<c-w><', '5<c-w><')
map('n', '<c-w>>', '5<c-w>>')
map('n', '<c-w>-', '5<c-w>-')
map('n', '<c-w>+', '5<c-w>+')


vim.api.nvim_exec([[
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
  autocmd FileType python setlocal foldmethod=indent
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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 VimScript                                  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Set the fold method to marker for vim files
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

]], false)

