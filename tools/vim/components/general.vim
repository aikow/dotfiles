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
set completeopt=menuone,noinsert,noselect

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
if has("patch-8.1.0360")
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
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Turn of bell and visual bell
set novisualbell

set background=dark
colorscheme gruvbox-material

" Always show the status line and tabline
set showtabline=2
set laststatus=2
set cmdheight=1
set noshowmode

" Show character column
set colorcolumn=80
set ruler
set relativenumber 

" Wrap lines
set wrap


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 Keybindings                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Set the leader key to the space key
nnoremap <SPACE> <Nop>
let mapleader=" "

" Set local leader to the backslash
let maplocalleader = "\\"

" Treat long lines as break lines (useful when moving around in them)
noremap j gj
noremap k gk

" Don't deselect visual when indenting in visual mode
vnoremap < <gv
vnoremap > >gv

" Very magic by default
nnoremap ? ?\v
nnoremap / /\v
cnoremap %s/ %sm/

" <leader><leader> toggles between buffers
nnoremap <leader><leader> <c-^>

" <leader>, shows/hides hidden characters
nnoremap <leader>, :set invlist<cr>

" <leader>q shows stats
nnoremap <leader>q g<c-g>

" Keymap for replacing up to next _ or -
nnoremap <leader>m ct_

" Automatically correct spelling with the first option
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Clear the search buffer to remove highlighting from the last search
nnoremap <silent> <c-_> :let @/ = ""<CR>

" Use <gp> to select the text that was last pasted
nnoremap <expr> gp '`[' . strpart(getregtype(), 0,  1) . '`]'

" Switch buffers using gb and gB, similar to tabs.
nnoremap <silent> gb :bnext<CR>
nnoremap <silent> gB :bprev<CR>

" Sort the selected lines
vnoremap <leader>rs :!sort<CR>

" Make Y behave like other capital numbers
nnoremap Y y$

" Keep it centered
nnoremap n nzzzv
nnoremap N Nzzzv
" nnoremap J mzJ`z

" Undo Break points
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" Automatically jump to the end of pasted text
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Leader                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Finding searching and navigating
nnoremap <silent> <leader>; :Commands<CR>
nnoremap <silent> <leader>o :Files<CR>
nnoremap <silent> <leader>p :Buffers<CR>
nnoremap <silent> <leader>fr :Rg<CR>
nnoremap <silent> <leader>fl :Lines<CR>
nnoremap <silent> <leader>fb :BLines<CR>
nnoremap <silent> <leader>fts :Tags<CR>
nnoremap <silent> <leader>ftb :BTags<CR>
nnoremap <silent> <leader>fm :Marks<CR>
nnoremap <silent> <leader>fw :Windows<CR>
nnoremap <silent> <leader>fp :Locate<CR>
nnoremap <silent> <leader>fh :History<CR>
nnoremap <silent> <leader>f; :History:<CR>

" Git shortcuts
nnoremap <silent> <leader>go :GFiles<CR>
nnoremap <silent> <leader>gs :GFiles?<CR>
nnoremap <silent> <leader>gc :Commits<CR>
nnoremap <silent> <leader>gb :BCommits<CR>

" Cargo shortcuts
nnoremap <silent> <leader>ct :lua require('crates').toggle()<cr>
nnoremap <silent> <leader>cr :lua require('crates').reload()<cr>

nnoremap <silent> <leader>cv :lua require('crates').show_versions_popup()<cr>
nnoremap <silent> <leader>cf :lua require('crates').show_features_popup()<cr>
nnoremap <silent> K :call <SID>show_documentation()<cr>

nnoremap <silent> <leader>cu :lua require('crates').update_crate()<cr>
vnoremap <silent> <leader>cu :lua require('crates').update_crates()<cr>
nnoremap <silent> <leader>ca :lua require('crates').update_all_crates()<cr>
nnoremap <silent> <leader>cU :lua require('crates').upgrade_crate()<cr>
vnoremap <silent> <leader>cU :lua require('crates').upgrade_crates()<cr>
nnoremap <silent> <leader>cA :lua require('crates').upgrade_all_crates()<cr>

" Setting shortcuts
nnoremap <silent> <leader>hs :Settings<CR>
nnoremap <silent> <leader>hc :Colors<CR>
nnoremap <silent> <leader>hh :Helptags<CR>
nnoremap <silent> <leader>hm :Maps<CR>
nnoremap <silent> <leader>hf :Filetypes<CR>

nnoremap <silent> <leader>w :w<CR>

" Copy and paste to system clipboard
vnoremap <silent> <leader>sy "+y
vnoremap <silent> <leader>sd "+d
nnoremap <silent> <leader>sp "+p
nnoremap <silent> <leader>sP "+P
vnoremap <silent> <leader>sp "+p
vnoremap <silent> <leader>sP "+P

" Resizing splits
nnoremap <silent> <leader>wvp :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent> <leader>wvm :exe "vertical resize " . (winwidth(0) * 2/3)<CR>
nnoremap <silent> <leader>whp :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <leader>whm :exe "resize " . (winheight(0) * 2/3)<CR>
nnoremap <c-w>< 5<c-w><
nnoremap <c-w>> 5<c-w>>
nnoremap <c-w>- 5<c-w>-
nnoremap <c-w>+ 5<c-w>+

" Plugins
nnoremap <silent> <leader>ppi :PlugInstall<CR>
nnoremap <silent> <leader>ppu :PlugUpdate<CR>
nnoremap <silent> <leader>ppp :PlugUpgrade<CR>
nnoremap <silent> <leader>ps :source $MYVIMRC<CR>
nnoremap <silent> <leader>po :tabe $MYVIMRC<CR>
nnoremap <silent> <leader>pur :call UltiSnips#RefreshSnippets()<CR>

" Show syntax highlighting groups for the word under the cursor
nnoremap <leader>z :call EchoSynStack()<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                Local Leader                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"


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

" Enable the cursor line only when in insert mode
augroup cursorline
  autocmd InsertEnter * set cul
  autocmd InsertLeave * set nocul
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

