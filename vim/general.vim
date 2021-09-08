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
" Search recursively downward from CWD; provides TAB completion for filenames
" e.g., `:find vim* <TAB>`
set path+=**

" Set working directory to the current files
set autochdir

" number of lines at the beginning and end of files checked for file-specific vars
set modelines=0
set modeline

" Reload files changed outside of Vim not currently modified in Vim 
set autoread
augroup general_autoread
  autocmd!
  autocmd FocusGained,BufEnter * :silent! !
augroup END

" use Unicode
set encoding=utf-8

" make Backspace work like Delete
set backspace=indent,eol,start

" make scrolling and painting fast
" ttyfast kept for vim compatibility but not needed for nvim
set ttyfast
set lazyredraw

" Backups and Swap files
set nobackup
set swapfile
"
" open new buffers without saving current modifications (buffer remains open)
set hidden

" Wildmenu options
set wildmenu
set wildmode=list:longest,full
set wildignore=*.o,*~,*.pyc

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

" TODO: Export to global variable
if has('nvim')
  let s:pynvim_path = expand("$HOME/.conda3/envs/pynvim/bin/python")
  let s:pynvim3_path = expand("$HOME/.conda3/envs/pynvim3/bin/python")

  " Check if the conda envs exist
  if !filereadable(s:pynvim_path)
    " Bootstrap the python2 conda env with pynvim 
    echom "Bootstrapping the conda python2 env..."
    " call system(expand('conda env create -f $HOME/.dotfiles/vim/python_envs/pynvim.yml'))
    execute "!" . expand('conda env create -f $HOME/.dotfiles/vim/python_envs/pynvim.yml')
  endif

  if !filereadable(s:pynvim3_path)
    " Bootstrap the python3 conda env with pynvim
    echom "Bootstrapping the conda python3 env..."
    " call system(expand('conda env create -f $HOME/.dotfiles/vim/python_envs/pynvim3.yml'))
    execute "!" . expand('conda env create -f $HOME/.dotfiles/vim/python_envs/pynvim3.yml')
  endif

  " Set the python provider for neovim
  let g:python_host_prog = s:pynvim_path
  let g:python3_host_prog = s:pynvim3_path
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Editing                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Tab key enters 2 spaces
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2 

" Indent new line the same as the preceding line
set autoindent

" highlight matching parens, braces, brackets, etc
set showmatch

" Searching
set hlsearch 
set incsearch
set ignorecase
set smartcase

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  set grepformat=%f:%l:%m
endif

" Folding
set foldmethod=indent
set foldnestmax=1
set foldlevelstart=1

" Set 7 lines to the cursor - when moving vertically using j/k
set scrolloff=7

" Open new splits to the right or down instead of moving current window
set splitright
set splitbelow

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

" errors flash screen rather than emit beep
set visualbell

colorscheme nord
set background=dark

" Always show the status line and tabline
set showtabline=2
set laststatus=2
set cmdheight=1
set noshowmode

" Show character column
set colorcolumn=80
set ruler
set cursorline
set relativenumber 

" Wrap lines
set wrap

