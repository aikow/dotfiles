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
  if executable('zsh')
    set shell=zsh
  else
    set shell=bash
  endif
endif

" Don't need vi compatibility
set nocompatible

" make scrolling and painting fast
" ttyfast kept for vim compatibility but not needed for nvim
set ttyfast
set lazyredraw

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
set foldlevelstart=99

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

" Turn of bell and visual bell
set novisualbell

set background=dark
try
  colorscheme gruvbox-material
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme slate
endtry

" Always show the status line and tabline
set showtabline=2
set laststatus=2
set cmdheight=1
set noshowmode

" Show character column
set colorcolumn=80
set ruler
set relativenumber 
set cursorline

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
nnoremap <silent> <leader>ff :Rg<CR>
nnoremap <silent> <leader>fl :Lines<CR>
nnoremap <silent> <leader>fb :BLines<CR>
nnoremap <silent> <leader>ft :Tags<CR>
nnoremap <silent> <leader>fT :BTags<CR>
nnoremap <silent> <leader>f' :Marks<CR>
nnoremap <silent> <leader>fw :Windows<CR>
nnoremap <silent> <leader>fp :Locate<CR>
nnoremap <silent> <leader>f/ :History<CR>
nnoremap <silent> <leader>f; :History:<CR>

" Git shortcuts
nnoremap <silent> <leader>go :GFiles<CR>
nnoremap <silent> <leader>gO :GFiles?<CR>
nnoremap <silent> <leader>gC :Commits<CR>
nnoremap <silent> <leader>gc :BCommits<CR>

" Setting shortcuts
nnoremap <silent> <leader>hc :Colors<CR>
nnoremap <silent> <leader>hh :Helptags<CR>
nnoremap <silent> <leader>hk :Maps<CR>
nnoremap <silent> <leader>hf :Filetypes<CR>

nnoremap <silent> <leader>w :w<CR>
nnoremap <silent> <leader>W :wa<CR>

" Plugins
nnoremap <silent> <leader>ppi :PlugInstall<CR>
nnoremap <silent> <leader>ppu :PlugUpdate<CR>
nnoremap <silent> <leader>ppp :PlugUpgrade<CR>
nnoremap <silent> <leader>ps :source $MYVIMRC<CR>
nnoremap <silent> <leader>po :tabe $MYVIMRC<CR>
nnoremap <silent> <leader>pur :call UltiSnips#RefreshSnippets()<CR>

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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 VimScript                                  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Set the fold method to marker for vim files
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

