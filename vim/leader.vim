""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Leader                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Set the leader key to the space key
nnoremap <SPACE> <Nop>
let mapleader=" "

nnoremap <leader>o :CtrlP<CR>
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
