source ~/.dotfiles/tools/vim/components/general.vim " Load general settings after plugins

" Load local config options
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
