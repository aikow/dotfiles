source ~/.dotfiles/tools/vim/components/plugins.vim " Load plugins and apply custom settings
source ~/.dotfiles/tools/vim/components/general.vim " Load general settings after plugins

" " Output a welcome message
" augroup init_welcome
"   autocmd!
"   " autocmd VimEnter * :<CR>:<CR>
"   autocmd VimEnter * echon ''
" augroup END

" Load local config options
let local_file=glob("~/.vimrc.local")
if filereadable(local_file)
  source local_file
endif
