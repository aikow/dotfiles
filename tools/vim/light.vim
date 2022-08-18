source ~/.dotfiles/tools/vim/components/general.vim " Load general settings after plugins

" Load local config options
let g:local_config = expand('$LOCAL_CONFIG/vimrc')
if filereadable(g:local_config)
  source g:local_config
endif
