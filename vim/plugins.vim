" LOAD PLUGINS

call plug#begin('~/.vim/plugged')

Plug 'lervag/vimtex'
  let g:tex_flavor='latex'
  let g:vimtex_view_method='zathura'
  let g:vimtex_quickfix_mode=0
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

Plug 'KeitaNakamura/tex-conceal.vim'
  set conceallevel=1
  let g:tex_conceal='abdmg'
  hi Conceal ctermbg=none

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
  " set to 1, nvim will open the preview window after entering the markdown buffer
  " default: 0
  let g:mkdp_auto_start = 0

  " set to 1, the nvim will auto close current preview window when change
  " from markdown buffer to another buffer
  " default: 1
  let g:mkdp_auto_close = 1

  " set to 1, the vim will refresh markdown when save the buffer or
  " leave from insert mode, default 0 is auto refresh markdown as you edit or
  " move the cursor
  " default: 0
  let g:mkdp_refresh_slow = 0

  " set to 1, the MarkdownPreview command can be use for all files,
  " by default it can be use in markdown file
  " default: 0
  let g:mkdp_command_for_global = 0

  " set to 1, preview server available to others in your network
  " by default, the server listens on localhost (127.0.0.1)
  " default: 0
  let g:mkdp_open_to_the_world = 0

  " use custom IP to open preview page
  " useful when you work in remote vim and preview on local browser
  " more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
  " default empty
  let g:mkdp_open_ip = ''

  " specify browser to open preview page
  " default: ''
  let g:mkdp_browser = ''

  " set to 1, echo preview page url in command line when open preview page
  " default is 0
  let g:mkdp_echo_preview_url = 0

  " a custom vim function name to open preview page
  " this function will receive url as param
  " default is empty
  let g:mkdp_browserfunc = ''

  " options for markdown render
  " mkit: markdown-it options for render
  " katex: katex options for math
  " uml: markdown-it-plantuml options
  " maid: mermaid options
  " disable_sync_scroll: if disable sync scroll, default 0
  " sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
  "   middle: mean the cursor position alway show at the middle of the preview page
  "   top: mean the vim top viewport alway show at the top of the preview page
  "   relative: mean the cursor position alway show at the relative positon of the preview page
  " hide_yaml_meta: if hide yaml metadata, default is 1
  " sequence_diagrams: js-sequence-diagrams options
  " content_editable: if enable content editable for preview page, default: v:false
  " disable_filename: if disable filename header for preview page, default: 0
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

  " use a custom markdown style must be absolute path
  let g:mkdp_markdown_css = ''

  " use a custom highlight style must absolute path
  let g:mkdp_highlight_css = ''

  " use a custom port to start server or random for empty
  let g:mkdp_port = ''

  " preview page title
  let g:mkdp_page_title = '「${name}」'

  " recognized filetypes
  let g:mkdp_filetypes = ['markdown', 'md']

Plug 'godlygeek/tabular'

Plug 'plasticboy/vim-markdown'
  let g:vim_markdown_math = 1
  let g:vim_markdown_strikethrough = 1


Plug 'sirver/ultisnips'
  let g:UltiSnipsExpandTrigger = '<tab>'
  let g:UltiSnipsJumpForwardTrigger = '<tab>'
  let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

Plug 'tpope/vim-commentary'

Plug 'tpope/vim-surround'

Plug 'tpope/vim-vinegar'
  let g:netrw_browse_split = 0

Plug 'tpope/vim-fugitive'

Plug 'itchyny/lightline.vim'
  let g:lightline = {
        \ 'colorscheme': 'onedark',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
        \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], ['filetype' ] ]
        \ },
        \ 'component_function': {
        \   'fugitive': 'LightlineFugitive',
        \   'filename': 'LightlineFilename',
        \   'fileformat': 'LightlineFileformat',
        \   'filetype': 'LightlineFiletype',
        \   'fileencoding': 'LightlineFileencoding',
        \   'mode': 'LightlineMode',
        \   'ctrlpmark': 'CtrlPMark',
        \   'lineinfo': 'LightlineLineinfo'
        \ },
        \ 'component_visible_condition': {
        \    'mode' : '1',
        \    'filename' : '(&filetype!="qf")',
         \   'modified': '&modified||!&modifiable',
         \   'readonly': '&readonly',
         \   'paste': '&paste',
         \   'spell': '&spell'
         \ },
        \ 'component_function_visible_condition': {
        \    'mode' : '1',
        \    'filename' : '(&filetype!="qf")',
         \   'modified': '&modified||!&modifiable',
         \   'readonly': '&readonly',
         \   'paste': '&paste',
         \   'spell': '&spell'
         \ },
        \ 'component_expand': {
        \   'syntastic': 'SyntasticStatuslineFlag',
        \ },
        \ 'component_type': {
        \   'syntastic': 'error',
        \ },
        \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
        \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
        \ 'enable': { 'tabline': 0 },
        \ }

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
          if g:colors_name =~# 'onedark\|onelight'
            let g:lightline.colorscheme = g:colors_name
            call lightline#init()
            call lightline#colorscheme()
            call lightline#update()
          endif
        catch
        endtry
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
    return winwidth(0) > 70 ? (line(".")) : '' 
  endfunction

  function! CtrlPMark()
    if expand('%:t') =~ 'ControlP' && has_key(g:lightline, 'ctrlp_item')
      call lightline#link('iR'[g:lightline.ctrlp_regex])
      return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
            \ , g:lightline.ctrlp_next], 0)
    else
      return ''
    endif
  endfunction

Plug 'dylanaraps/wal'

Plug 'fenetikm/falcon'

Plug 'joshdick/onedark.vim'

call plug#end()

