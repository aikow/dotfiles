""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Leader                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Set the leader key to the space key
nnoremap <SPACE> <Nop>
let mapleader=" "


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
