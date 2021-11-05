source ~/.dotfiles/tools/vim/components/general.vim
let component_dir = glob("~/.dotfiles/vim/")

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
