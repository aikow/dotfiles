if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
    else
        let g:os = substitute(system('uname'), '\n', '', '')
    endif
endif

" Search recursively downward from CWD; provides TAB completion for filenames
" e.g., `:find vim* <TAB>`
set path+=**

" number of lines at the beginning and end of files checked for file-specific vars
set modelines=0
set modeline

" http://stackoverflow.com/questions/2490227/how-does-vims-autoread-work#20418591
" reload files changed outside of Vim not currently modified in Vim (needs below)
set autoread
au FocusGained,BufEnter * :silent! !

" use Unicode
set encoding=utf-8

" errors flash screen rather than emit beep
set visualbell

" make Backspace work like Delete
set backspace=indent,eol,start

" don't create `filename~` backups
set nobackup

" don't create temp files
" set noswapfile

" line numbers and distances
set relativenumber 
" set number 

" Tab key enters 2 spaces
" To enter a TAB character when `expandtab` is in effect,
" CTRL-v-TAB
set expandtab tabstop=2 shiftwidth=2 softtabstop=2 

" Indent new line the same as the preceding line
set autoindent

" StatusLine always visible, display full path
" http://learnvimscriptthehardway.stevelosh.com/chapters/17.html
" set laststatus=2 statusline=%F

" Hide mode indicator
set noshowmode

" Status line always visible
set laststatus=2

" make scrolling and painting fast
" ttyfast kept for vim compatibility but not needed for nvim
set ttyfast lazyredraw

" highlight matching parens, braces, brackets, etc
set showmatch

" http://vim.wikia.com/wiki/Searching
set hlsearch incsearch ignorecase smartcase

" Wrap lines
set wrap

" Set working directory to the current files
set autochdir

" open new buffers without saving current modifications (buffer remains open)
set hidden

" http://stackoverflow.com/questions/9511253/how-to-effectively-use-vim-wildmenu
set wildmenu wildmode=list:longest,full

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

" Use system clipboard
" http://vim.wikia.com/wiki/Accessing_the_system_clipboard
if g:os == "Darwin"
  set clipboard+=unnamed
elseif g:os == "Linux"
  set clipboard+=unnamedplus
elseif g:os == "Windows"
endif

" Folding
" https:/vim.fandom.com/wiki/Folding
" https://vim.fandom.com/wiki/All_folds_open_when_opening_a_file
" https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
set foldmethod=indent
set foldnestmax=1
set foldlevelstart=1

" Filetype plugins
filetype plugin on
filetype indent on

" Set 7 lines to the cursor - when moving vertically using j/k
set scrolloff=7


" Open new splits to the right or down instead of moving current window
set splitright
set splitbelow

" Set spell location to English and German
setlocal spell
set spelllang=en,de

" Enable syntax highlighting for languages
syntax enable

" Neovim only
if has("nvim")
  set termguicolors 
endif

" Dark scheme
" colorscheme onedark
colorscheme nord
set background=dark

" Height of the command bar
set cmdheight=2
set showtabline=2

set cursorline

" Show character column
set colorcolumn=80

"Always show current position
set ruler


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                             File Type Specific                             "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Python
autocmd BufNewFile,BufRead *.py set tabstop=4
autocmd BufNewFile,BufRead *.py set softtabstop=4
autocmd BufNewFile,BufRead *.py set shiftwidth=4
autocmd BufNewFile,BufRead *.py set textwidth=79
autocmd BufNewFile,BufRead *.py set expandtab
autocmd BufNewFile,BufRead *.py set autoindent
autocmd BufNewFile,BufRead *.py set fileformat=unix

" Function to activate a virtualenv in the embedded interpeter
function LoadVirtualEnv(path)
  let activate_this = a:path . '/bin/activate_this.py'
  if getftype(a:path) == "dir" && filereadable(activate_this)
    python << EOF
import vim
activate_this = vim.eval('l:activate_this')
execfile(activate_this, dict(__file__=activate_this))
EOF
  endif
endfunction
let defaultvirtualenv = $HOME . "/.virtualenvs/stable"

" Only attempt to load this virtualenv if the defaultvirtualenv actually
" exists and we aren't running with a virtualenv active.
if has("python")
  if empty($VIRTUAL_ENV) && getftype(defaultvirtualenv) == "dir"
    call LoadVirtualEnv(defaultvirtualenv)
  endif
endif

