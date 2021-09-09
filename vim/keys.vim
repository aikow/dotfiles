
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
