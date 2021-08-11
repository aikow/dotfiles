""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Python                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

augroup ft_python
  autocmd!
  autocmd BufNewFile,BufRead *.py setlocal tabstop=4
  autocmd BufNewFile,BufRead *.py setlocal softtabstop=4
  autocmd BufNewFile,BufRead *.py setlocal shiftwidth=4
  autocmd BufNewFile,BufRead *.py setlocal textwidth=79
  autocmd BufNewFile,BufRead *.py setlocal expandtab
  autocmd BufNewFile,BufRead *.py setlocal autoindent
  autocmd BufNewFile,BufRead *.py setlocal fileformat=unix
augroup END

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

" Set default virtual environment
let defaultvirtualenv = $HOME . "/.virtualenvs/stable"

" Only attempt to load this virtualenv if the defaultvirtualenv actually
" exists and we aren't running with a virtualenv active.
if has("python")
  if empty($VIRTUAL_ENV) && getftype(defaultvirtualenv) == "dir"
    call LoadVirtualEnv(defaultvirtualenv)
  endif
endif

