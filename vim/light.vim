let g:plugin_enabled_icons = 1
let g:plugin_enabled_markdown = 0
let g:plugin_enabled_tex = 0

source ~/.dotfiles/vim/components/plugins.vim " Load plugins and apply custom settings
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
