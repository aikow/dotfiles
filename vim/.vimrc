" VIM config
"

" Enable Go syntax
set rtp+=$GOROOT/misc/vim

" Filetype plugins
filetype plugin on
filetype indent on

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Enable syntax highlighting
syntax enable

colorscheme desert
set background=dark

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %F%m%r%h\ %w\ \ \ Line:\ %l

" Set default tabstops to 2 spaces instead of 8
set tabstop=2
set softtabstop=2
set shiftwidth=0
set expandtab


" vim-plug section
call plug#begin('~/.vim/plugged')

Plug 'lervag/vimtex'
  let g:tex_flavor='latex'
  let g:vimtex_view_method='zathura'
  let g:vimtex_quickfix_mode=0

Plug 'KeitaNakamura/tex-conceal.vim'
  set conceallevel=1
  let g:tex_conceal='abdmg'
  hi Conceal ctermbg=none

Plug 'sirver/ultisnips'
  let g:UltiSnipsExpandTrigger = '<tab>'
  let g:UltiSnipsJumpForwardTrigger = '<tab>'
  let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

Plug 'dylanaraps/wal'

set background=dark

setlocal spell
set spelllang=en_us,de
inoremap <C-l> <c-g>u<Esc>[s1z=']a<c-g>u

call plug#end()