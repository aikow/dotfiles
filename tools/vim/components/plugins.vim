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
  Plug 'nvim-lua/plenary.nvim'

    " Completion framework
  Plug 'hrsh7th/nvim-cmp'

  " LSP completion source for nvim-cmp
  Plug 'hrsh7th/cmp-nvim-lsp'

  " Snippet completion source for nvim-cmp
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'quangnguyen30192/cmp-nvim-ultisnips'

  " Other usefull completion sources
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-omni'
  Plug 'saecki/crates.nvim', { 'tag': 'v0.1.0' }

  " See hrsh7th's other plugins for more completion sources!

  " To enable more of the features of rust-analyzer, such as inlay hints and more!
  Plug 'simrat39/rust-tools.nvim'

  " Fuzzy finder
  " Optional
  " Plug 'nvim-lua/popup.nvim'
  " Plug 'nvim-lua/plenary.nvim'

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

Plug 'Yggdroot/indentLine'
  let g:indentLine_setConceal = 2
  let g:indentLine_concealcursor = ""

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
   
    " Never opened Automatically
    let g:vimtex_quickfix_mode=0
    let g:vimtex_compiler_progname='nvr'
    let g:vimtex_compiler_method='latexmk'
    let g:vimtex_compiler_latexmk = {
          \ 'build_dir'  : 'build',
          \ 'callback'   : 1,
          \ 'continuous' : 1,
          \ 'executable' : 'latexmk',
          \ 'hooks'      : [],
          \ 'options'    : [
            \   '-verbose',
            \   '-file-line-error',
            \   '-synctex=1',
            \   '-interaction=nonstopmode',
            \ ],
            \}
    let g:vimtex_compiler_latexmk_engines = {
        \ '_'                : '-pdf',
        \ 'pdflatex'         : '-pdf',
        \ 'dvipdfex'         : '-pdfdvi',
        \ 'lualatex'         : '-lualatex',
        \ 'xelatex'          : '-xelatex',
        \ 'context (pdftex)' : '-pdf -pdflatex=texexec',
        \ 'context (luatex)' : '-pdf -pdflatex=context',
        \ 'context (xetex)'  : '-pdf -pdflatex=''texexec --xtx''',
        \}
    let g:vimtex_compiler_latexrun = {
        \ 'build_dir' : '',
        \ 'options' : [
        \   '-verbose-cmds',
        \   '--latex-args="-synctex=1"',
        \ ],
        \}
    let g:vimtex_compiler_latexrun_engines = {
        \ '_'                : 'pdflatex',
        \ 'pdflatex'         : 'pdflatex',
        \ 'lualatex'         : 'lualatex',
        \ 'xelatex'          : 'xelatex',
        \}

    augroup latexSurround
       autocmd!
       autocmd FileType tex call s:latexSurround()
    augroup END

    function! s:latexSurround()
       let b:surround_{char2nr("e")}
         \ = "\\begin{\1environment: \1}\n\t\r\n\\end{\1\1}"
       let b:surround_{char2nr("c")} = "\\\1command: \1{\r}"
    endfunction
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
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'itchyny/lightline.vim'
  let g:lightline = {}
  let g:lightline.colorscheme = 'gruvbox.vim'
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
Plug 'sainnhe/everforest'
Plug 'sainnhe/gruvbox-material'
Plug 'morhetz/gruvbox'

call plug#end()

if has('nvim')

  " Set completeopt to have a better completion experience
  " :help completeopt
  " menuone: popup even when there's only one match
  " noinsert: Do not insert text until a selection is made
  " noselect: Do not select, force user to select one from the menu
  set completeopt=menuone,noinsert,noselect

  " Avoid showing extra messages when using completion
  set shortmess+=c

  " Configure LSP through rust-tools.nvim plugin.
  " rust-tools will configure and enable certain LSP features for us.
  " See https://github.com/simrat39/rust-tools.nvim#configuration
  lua <<EOF
    local nvim_lsp = require'lspconfig'

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
      local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
      local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

      -- Enable completion triggered by <c-x><c-o>
      buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

      -- Mappings.
      local opts = { noremap=true, silent=true }

      -- See `:help vim.lsp.*` for documentation on any of the below functions
      buf_set_keymap('n', '<leader>gc', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
      buf_set_keymap('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
      buf_set_keymap('n', '<leader>gk', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      buf_set_keymap('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
      buf_set_keymap('n', '<leader>h', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
      buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
      buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
      buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
      buf_set_keymap('n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
      buf_set_keymap('n', '<leader>rr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      buf_set_keymap('n', '<leader>rq', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
      buf_set_keymap('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
      buf_set_keymap('n', '<leader>do', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
      buf_set_keymap('n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
      buf_set_keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
      buf_set_keymap('n', '<leader>dl', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
      buf_set_keymap('n', '<leader>rf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

    end

    local opts = {
      tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
          show_parameter_hints = false,
          parameter_hints_prefix = "",
          other_hints_prefix = "",
        },
      },
      -- all the opts to send to nvim-lspconfig
      -- these override the defaults set by rust-tools.nvim
      -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
      server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        on_attach = on_attach,
        settings = {
          -- to enable rust-analyzer settings visit:
          -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
          ["rust-analyzer"] = {
            -- enable clippy on save
            checkOnSave = {
              command = "clippy"
            },
          }
        }
      },
    }

    require('rust-tools').setup(opts)

    nvim_lsp.pyright.setup{
      on_attach = on_attach,
    }
EOF

  " Setup Completion
  " See https://github.com/hrsh7th/nvim-cmp#basic-configuration
  lua <<EOF
    -- Setup nvim-cmp
    local cmp = require'cmp'

    cmp.setup({
      -- Enable LSP snippets
      snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
      },
      mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Add tab support
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        })
      },

      -- Installed sources
      sources = {
        { name = 'nvim_lsp' },
        { name = 'ultisnips' },
        { name = 'path' },
        { name = 'buffer' },
        { name = 'crates' },
      },
    })

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline('/', {
      sources = {
        { name = 'buffer' }
      }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })
EOF
  
  augroup VimTeX
    autocmd!
    autocmd FileType tex
          \ lua require('cmp').setup.buffer { sources = { { name = 'omni' } } }
  augroup END

endif
