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
set nocompatible

set rtp+=~/.dotfiles/vim/rtp

" Search recursively downward from CWD; provides TAB completion for filenames
" e.g., `:find vim* <TAB>`
set path+=**

" Set working directory to the current files
" set autochdir

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
" set wildmode=longest,list
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
  let s:pynvim_path = expand("$HOME/.miniconda3/envs/pynvim/bin/python")
  let s:pynvim3_path = expand("$HOME/.miniconda3/envs/pynvim3/bin/python")

  " Check if the conda envs exist
  if !filereadable(s:pynvim_path)
    " Bootstrap the python2 conda env with pynvim 
    echom "Bootstrapping the conda python2 env..."
    execute "!" . expand('conda env create -f $HOME/.dotfiles/vim/envs/pynvim.yml')
  endif

  if !filereadable(s:pynvim3_path)
    " Bootstrap the python3 conda env with pynvim
    echom "Bootstrapping the conda python3 env..."
    execute "!" . expand('conda env create -f $HOME/.dotfiles/vim/envs/pynvim3.yml')
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
set novisualbell

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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 Keybindings                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Automatically correct spelling with the first option
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Clear the search buffer to remove highlighting from the last search
nnoremap <silent> <c-_> :let @/ = ""<CR>

" Use <gp> to select the text that was last pasted
nnoremap <expr> gp '`[' . strpart(getregtype(), 0,  1) . '`]'

" Use <c-f> to search for the word under the cursor with ag
nnoremap <C-f> :grep! "\b<C-R><C-W>\b"<CR>:cwindow<CR>

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

" Number 2: Jumplist mutations
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" Moving lines
vnoremap <c-j> :m '>+1<CR>gv=gv
vnoremap <c-k> :m '<-2<CR>gv=gv
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>== 

" Automatically jump to the end of pasted text
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Leader                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Set the leader key to the space key
nnoremap <SPACE> <Nop>
let mapleader=" "

nnoremap <leader>: :Commands<CR>
nnoremap <leader>o :Files<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fr :Rg<CR>
nnoremap <leader>fa :Ag<CR>
nnoremap <leader>fls :Lines<CR>
nnoremap <leader>flb :BLines<CR>
nnoremap <leader>fts :Tags<CR>
nnoremap <leader>ftb :BTags<CR>
nnoremap <leader>fm :Marks<CR>
nnoremap <leader>fw :Windows<CR>
nnoremap <leader>fp :Locate<CR>
nnoremap <leader>fh :History<CR>
nnoremap <leader>f: :History:<CR>

nnoremap <leader>go :GFiles<CR>
nnoremap <leader>gs :GFiles?<CR>
nnoremap <leader>gc :Commits<CR>
nnoremap <leader>gb :BCommits<CR>

command! Settings call fzf#run(fzf#wrap({'source': ':options', 'sink': ':set'}))

nnoremap <leader>hs :Settings<CR>
nnoremap <leader>hc :Colors<CR>
nnoremap <leader>hh :Helptags<CR>
nnoremap <leader>hm: :Maps<CR>
nnoremap <leader>hf :Filetypes<CR>

nnoremap <leader>w :w<CR>

" Copy and paste to system clipboard
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P


" Show syntax highlighting groups for the word under the cursor
" 
nmap <leader>z :call EchoSynStack()<CR>

" You Complete Me goto definition
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>

" Map leader v to open the corresponding .vimrc
nnoremap <leader>sv :source $MYVIMRC


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                Local Leader                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Set local leader to the backslash
let maplocalleader = "\\"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Functions                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Reset cursors when coming from bash
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" reset the cursor on start (for older versions of vim, usually not required)
augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END

autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul

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

augroup ft_python
  autocmd!
  autocmd FileType python setlocal tabstop=4
  autocmd FileType python setlocal softtabstop=4
  autocmd FileType python setlocal shiftwidth=4
  autocmd FileType python setlocal textwidth=79
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
let defaultvirtualenv = $HOME . "/.virtualenvs/stable"

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

augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
