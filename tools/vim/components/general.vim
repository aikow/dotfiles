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

set rtp+=~/.dotfiles/tools/vim/rtp

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

" Set the timeout times
set timeoutlen=500
set ttimeoutlen=5

if !(has('nvim') || has('gvim'))
  set noesckeys
endif

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
    execute "!" . expand('conda env create -f $HOME/.dotfiles/tools/vim/envs/pynvim.yml')
  endif

  if !filereadable(s:pynvim3_path)
    " Bootstrap the python3 conda env with pynvim
    echom "Bootstrapping the conda python3 env..."
    execute "!" . expand('conda env create -f $HOME/.dotfiles/tools/vim/envs/pynvim3.yml')
  endif

  " Set the python provider for neovim
  " let g:python_host_prog = s:pynvim_path
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

if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
  set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable('ag')
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

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
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
noremap j gj
noremap k gk

" Don't deselect visual when indenting in visual mode
vnoremap < <gv
vnoremap > >gv

" Automatically correct spelling with the first option
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Clear the search buffer to remove highlighting from the last search
nnoremap <silent> <c-_> :let @/ = ""<CR>

" Use <gp> to select the text that was last pasted
nnoremap <expr> gp '`[' . strpart(getregtype(), 0,  1) . '`]'

"
vnoremap <leader>us :'<'>!sort<CR>

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
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'gk'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'gj'

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

" Finding searching and navigating
nnoremap <silent> <leader>: :Commands<CR>
nnoremap <silent> <leader>o :Files<CR>
nnoremap <silent> <leader>fb :Buffers<CR>
nnoremap <silent> <leader>fr :Rg<CR>
nnoremap <silent> <leader>fa :Ag<CR>
nnoremap <silent> <leader>fls :Lines<CR>
nnoremap <silent> <leader>flb :BLines<CR>
nnoremap <silent> <leader>fts :Tags<CR>
nnoremap <silent> <leader>ftb :BTags<CR>
nnoremap <silent> <leader>fm :Marks<CR>
nnoremap <silent> <leader>fw :Windows<CR>
nnoremap <silent> <leader>fp :Locate<CR>
nnoremap <silent> <leader>fh :History<CR>
nnoremap <silent> <leader>f: :History:<CR>

" Git shortcuts
nnoremap <silent> <leader>go :GFiles<CR>
nnoremap <silent> <leader>gs :GFiles?<CR>
nnoremap <silent> <leader>gc :Commits<CR>
nnoremap <silent> <leader>gb :BCommits<CR>

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

function s:format_options(pairs, lengths)
  let l:format_str = ""
  for n in a:lengths
    let l:format_str = l:format_str."%-".n."s "
  endfor
  echom l:format_str
  return printf(l:format_str, a:pairs[0], a:pairs[1], a:pairs[2], a:pairs[3])
endfunction

" Get a list of all options that can be set in vim
function! s:opt_list()
  let l:file = globpath(&rtp, 'doc/options.txt')
  let l:lines = readfile(file)
  let l:pairs = []
  let l:max_len = [0, 0, 0, 0]

  for line in l:lines
    " echom line
    let matches = matchlist(line, '\v^''(\w+)''( ''(\w+)'')?\s+(\w+)\s+\(default:?\s+([^)]+)\)?')
    if len(matches) != 0
      let full = matches[1]
      let abbr = matches[3]
      let type = matches[4]
      let default = matches[5]

      let pair = [full, abbr, type, default]
      call add(l:pairs, pair)
      
      for i in range(len(pair))
        if l:max_len[i] > len(pair[i])
          let l:max_len[i] = len(pair[i])
        endif
      endfor
    endif
  endfor

  let l:flines = map(pairs, {_, val -> call <SID>format_options(val, max_len)})

  return l:flines
endfunction

function! s:opt_sink()
endfunction

command! Settings call fzf#run(fzf#wrap({
      \ 'source': s:opt_list(), 
      \ 'sink': function('s:opt_sink')}))

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
