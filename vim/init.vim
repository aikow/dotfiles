source ~/.dotfiles/vim/plugins.vim 	 " Load plugins and apply custom settings
source ~/.dotfiles/vim/general.vim   " General settings
source ~/.dotfiles/vim/leader.vim	   " Leader key settings
source ~/.dotfiles/vim/keys.vim      " Custom key bindings
source ~/.dotfiles/vim/ft.vim        " Filetype specific local settings
source ~/.dotfiles/vim/functions.vim " Custom functions

" Output a welcome message
augroup init_welcome
  autocmd!
  " autocmd VimEnter * :<CR>:<CR>
  autocmd VimEnter * echon ''
augroup END

" Load local config options
let local_file=glob("~/.local.zshrc")
if filereadable(local_file)
  source local_file
endif
