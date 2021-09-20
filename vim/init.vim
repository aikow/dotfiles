source ~/.dotfiles/vim/components/plugins.nvim " Load plugins and apply custom settings
source ~/.dotfiles/vim/components/general.vim " Load general settings after plugins

" Output a welcome message
augroup init_welcome
  autocmd!
  " autocmd VimEnter * :<CR>:<CR>
  autocmd VimEnter * echon ''
augroup END

" Load local config options
let local_file=glob("~/.vimrc.local")
if filereadable(local_file)
  source local_file
endif
