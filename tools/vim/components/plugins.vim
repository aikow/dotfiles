""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                             Bootstrap VimPlug                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Automatically try to install vim-plug if it not already installed.
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  echom "Installing vim-plug, " . data_dir . '/autoload/plug.vim was empty' 
  silent execute '!curl -fLo ' . data_dir . '/autoload/plug.vim --create-dirs 
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


" Set a different plugin directory depending on whether the config is for neovim
" and gvim or for classic vim
let plug_dir = data_dir . '/plugged'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               Start VimPlug                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
call plug#begin(plug_dir)

if has("nvim")
  Plug 'neovim/nvim-lspconfig'

" lua << EOF
" require'lspconfig'.pyright.setup{}
" EOF
endif

" Syntax checking
" The plugin incorrectly identifies errors in Latex files.
" Plug 'scrooloose/syntastic'

if executable("python3")
  " Snippets and snippets
  Plug 'sirver/ultisnips'
    let g:UltiSnipsExpandTrigger = '<c-j>'
    let g:UltiSnipsJumpForwardTrigger = '<c-j>'
    let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
endif


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

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

  " Enable per-command history
  " - History files will be stored in the specified directory
  " - When set, CTRL-N and CTRL-P will be bound to 'next-history' and
  "   'previous-history' instead of 'down' and 'up'.
  let g:fzf_history_dir = '~/.local/share/fzf-history'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              Language Plugins                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Language pack for 600 file types
Plug 'sheerun/vim-polyglot'

if g:plugin_enabled_tex
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
            \   '-shell-escape',
            \   '-interaction=nonstopmode',
            \ ],
            \}
endif

" Tex - conceals math operators and other items and replaces with compiled
" item.
Plug 'KeitaNakamura/tex-conceal.vim'
  set conceallevel=1
  let g:tex_conceal='abdmg'
  hi Conceal ctermbg=none

if g:plugin_enabled_markdown
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

  augroup LightlineColorscheme
    autocmd!
    autocmd ColorScheme * call s:lightline_update()
  augroup END

  function! s:lightline_update()
    if !exists('g:loaded_lightline')
      return
    endif
    try
      if g:colors_name =~# 'wombat\|solarized\|landscape\|jellybeans\|seoul256\|Tomorrow'
        let g:lightline.colorscheme =
              \ substitute(substitute(g:colors_name, '-', '_', 'g'), '256.*', '', '')
        call lightline#init()
        call lightline#colorscheme()
        call lightline#update()
      endif
      if g:colors_name =~# 'nord\|onedark\|onelight'
        let g:lightline.colorscheme = g:colors_name
        call lightline#init()
        call lightline#colorscheme()
        call lightline#update()
      endif
    catch
    endtry
  endfunction

  function! LightlineWebDevIcons(n)
    let l:bufnr = tabpagebuflist(a:n)[tabpagewinnr(a:n) - 1]
    return WebDevIconsGetFileTypeSymbol(bufname(l:bufnr))
  endfunction

  function! LightlineModified()
    return (&ft =~ 'help' || &ft =~ 'qf') ? '' : &modified ? '+' : &modifiable ? '' : '-'
  endfunction

  function! LightlineReadonly()
    return &ft !~? 'help' && &readonly ? 'RO' : ''
  endfunction

  function! LightlineFilename()
    if (&filetype=="qf")
      return ''
    endif
    let fname = expand('%:t')
    return fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
          \ fname == '__Tagbar__' ? g:lightline.fname :
          \ fname =~ '__Gundo\|NERD_tree' ? '' :
          \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
          \ &ft == 'unite' ? unite#get_status_string() :
          \ &ft == 'vimshell' ? vimshell#get_status_string() :
          \ ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
          \ ('' != fname ? fname : '') .
          \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
  endfunction

  function! LightlineFugitive()
    try
      if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
        let mark = ''  " edit here for cool mark
        let branch = fugitive#head()
        return branch !=# '' ? mark.branch : ''
      endif
    catch
    endtry
    return ''
  endfunction

  function! LightlineFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
  endfunction

  function! LightlineFiletype()
    return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
  endfunction

  function! LightlineFileencoding()
    return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
  endfunction

  function! LightlineMode()
    if (&filetype=="qf")
      return 'Results'
    endif
    let fname = expand('%:t')
    return fname == '__Tagbar__' ? 'Tagbar' :
          \ fname == 'ControlP' ? 'CtrlP' :
          \ fname == '__Gundo__' ? 'Gundo' :
          \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
          \ fname =~ 'NERD_tree' ? 'NERDTree' :
          \ &ft == 'unite' ? 'Unite' :
          \ &ft == 'vimfiler' ? 'VimFiler' :
          \ &ft == 'vimshell' ? 'VimShell' :
          \ winwidth(0) > 10 ? lightline#mode() : ''
  endfunction

  function! LightlineLineinfo()
    return winwidth(0) > 70 ? (line(".") . "," . col(".")) : '' 
  endfunction

if g:plugin_enabled_icons
  " Nerd font icons
  Plug 'ryanoasis/vim-devicons'
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                Color Themes                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins for color themes
Plug 'dylanaraps/wal'
Plug 'fenetikm/falcon'
Plug 'joshdick/onedark.vim'
Plug 'arcticicestudio/nord-vim'

call plug#end()
