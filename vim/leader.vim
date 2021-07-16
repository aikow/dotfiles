" Set the leader key to the space key
nnoremap <SPACE> <Nop>
let mapleader=" "

" Show syntax highlighting groups for the word under the cursor
" 
nmap <leader>z :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

