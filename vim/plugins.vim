""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                             Bootstrap VimPlug                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Automatically try to install vim-plug if it not already installed.
let plug_install = 0
if has('nvim')
  let autoload_plug_path = stdpath('config') . '/autoload/plug.vim'
  if !filereadable(autoload_plug_path)
    silent exe '!curl -fL --create-dirs -o ' . autoload_plug_path . 
          \ ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
    execute 'source ' . fnameescape(autoload_plug_path)
    let plug_install = 1
  endif
  unlet autoload_plug_path
else
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
  endif
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               Start VimPlug                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
call plug#begin('~/.config/dotfiles/vim/plugged')

if !empty($VIM_IDE_YCM)
  " Code completion plugin
  Plug 'ycm-core/YouCompleteMe', {'do': './install.py'}
    let g:ycm_key_list_select_completion=['<c-n>', '<Down>']
    let g:ycm_key_list_previous_completion=['<c-p>', '<Up>']
    let g:ycm_autoclose_preview_window_after_completions=1
endif

" Syntax checking
Plug 'scrooloose/syntastic'

" Snippets and snippets
Plug 'sirver/ultisnips'
  let g:UltiSnipsExpandTrigger = '<c-j>'
  let g:UltiSnipsJumpForwardTrigger = '<c-j>'
  let g:UltiSnipsJumpBackwardTrigger = '<c-k>'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                           Functionality Plugins                            "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 
" Repeat commands from plugins
Plug 'tpope/vim-repeat'

" Comment and uncomment according to filetype
Plug 'tpope/vim-commentary'

" Better parenthesis and quoting tools
Plug 'tpope/vim-surround'

" Better netrw file manager
Plug 'tpope/vim-vinegar'
  let g:netrw_browse_split = 0

" Git plugin
Plug 'tpope/vim-fugitive'

" Plugin to align text
Plug 'godlygeek/tabular'

" Fuzzy file finding
Plug 'ctrlpvim/ctrlp.vim'
  let g:ctrlp_map = '<C-p>'
  let g:ctrlp_cmd = 'CtrlP'
  let g:ctrlp_working_path_mode = 'ra'
  if executable('ag')
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    let g:ctrp_use_caching = 0
  endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              Language Plugins                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Language pack for 600 file types
Plug 'sheerun/vim-polyglot'

if !empty($VIM_IDE_LATEX)
  " Tex - Latex compiler, syntax highlighting, preview with zathura
  Plug 'lervag/vimtex'
    let g:tex_flavor='latex'
    let g:vimtex_view_method='zathura'
    let g:vimtex_quickfix_mode=0
    let g:vvimtex_compiler_prognam='nvr'
    let g:vimtex_compiler_latexmk = {
          \ 'build_dir' : 'build',
          \ 'callback' : 1,
          \ 'continuous' : 1,
          \ 'executable' : 'latexmk',
          \ 'hooks' : [],
          \ 'options' : [
            \   '-verbose',
            \   '-file-line-error',
            \   '-synctex=1',
            \   '-interaction=nonstopmode',
            \ ],
            \}

  " Tex - conceals math operators and other items and replaces with compiled
  " item.
  Plug 'KeitaNakamura/tex-conceal.vim'
    set conceallevel=1
    let g:tex_conceal='abdmg'
    hi Conceal ctermbg=none
endif

if !empty($VIM_IDE_MARKDOWN_PREVIEW)
  " Markdown preview in google chrome
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
    let g:mkdp_auto_start = 0
    let g:mkdp_auto_close = 1
    let g:mkdp_refresh_slow = 0
    let g:mkdp_command_for_global = 0
    let g:mkdp_open_to_the_world = 0
    let g:mkdp_open_ip = ''
    let g:mkdp_browser = 'firefox'
    let g:mkdp_echo_preview_url = 0
    let g:mkdp_browserfunc = ''
    let g:mkdp_preview_options = {
          \ 'mkit': {},
          \ 'katex': {},
          \ 'uml': {},
          \ 'maid': {},
          \ 'disable_sync_scroll': 0,
          \ 'sync_scroll_type': 'middle',
          \ 'hide_yaml_meta': 1,
          \ 'sequence_diagrams': {},
          \ 'flowchart_diagrams': {},
          \ 'content_editable': v:false,
          \ 'disable_filename': 0
          \ }
    let g:mkdp_markdown_css = ''
    let g:mkdp_highlight_css = ''
    let g:mkdp_port = ''
    let g:mkdp_page_title = '「${name}」'
    let g:mkdp_filetypes = ['markdown', 'md']
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                           Customization Plugins                            "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 
" Customizes the status bar
Plug 'itchyny/lightline.vim'
  let g:lightline = {}
  let g:lightline.colorscheme = 'nord'
  let g:lightline.active = {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
        \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], ['filetype' ] ]
        \ }
  let g:lightline.tabline = {
        \   'left': [ ['tabs'] ],
        \   'right': [ ['close'] ]
        \ }
  let g:lightline.tab = {
        \   'active': [ 'tabnum', 'filename', 'modified' ],
        \   'inactive': [ 'tabnum', 'filename', 'modified' ]
        \ }
  let g:lightline.tab_component_function = {
        \   'tabnum': 'LightlineWebDevIcons'
        \ }
  let g:lightline.component_function = {
        \   'fugitive': 'LightlineFugitive',
        \   'filename': 'LightlineFilename',
        \   'fileformat': 'LightlineFileformat',
        \   'filetype': 'LightlineFiletype',
        \   'fileencoding': 'LightlineFileencoding',
        \   'mode': 'LightlineMode',
        \   'ctrlpmark': 'CtrlPMark',
        \   'lineinfo': 'LightlineLineinfo'
        \ }
  let g:lightline.component_visible_condition = {
        \   'mode' : '1',
        \   'filename' : '(&filetype!="qf")',
        \   'modified': '&modified||!&modifiable',
        \   'readonly': '&readonly',
        \   'paste': '&paste',
        \   'spell': '&spell'
        \ }
  let g:lightline.component_function_visible_condition = {
        \   'mode' : '1',
        \   'filename' : '(&filetype!="qf")',
        \   'modified': '&modified||!&modifiable',
        \   'readonly': '&readonly',
        \   'paste': '&paste',
        \   'spell': '&spell'
        \ }
  let g:lightline.component_expand = {
        \   'syntastic': 'SyntasticStatuslineFlag',
        \ }
  let g:lightline.component_type = {
        \   'syntastic': 'error',
        \ }
  let g:lightline.separator = { 'left': "\ue0b0", 'right': "\ue0b2" }
  let g:lightline.subseparator = { 'left': "\ue0b1", 'right': "\ue0b3" }


" Nerd font icons
Plug 'ryanoasis/vim-devicons'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                Color Themes                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 
" Plugins for color themes
Plug 'dylanaraps/wal'

Plug 'fenetikm/falcon'

Plug 'joshdick/onedark.vim'

Plug 'arcticicestudio/nord-vim'

call plug#end()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              Install VimPlug                               "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Try to install vim plug if necessary
if plug_install
    PlugInstall --sync
endif
unlet plug_install

