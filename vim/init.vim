source ~/.config/dotfiles/vim/plugins.vim 	" Load plugins and apply custom settings
source ~/.config/dotfiles/vim/general.vim   " General settings
source ~/.config/dotfiles/vim/leader.vim	  " Leader key settings
source ~/.config/dotfiles/vim/keys.vim     	" Custom key bindings
source ~/.config/dotfiles/vim/ft.vim        " Filetype specific local settings
source ~/.config/dotfiles/vim/functions.vim " Custom functions

augroup init_welcome
  autocmd!
  autocmd VimEnter * echom 'Hello'
augroup END
