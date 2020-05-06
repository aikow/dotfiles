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
