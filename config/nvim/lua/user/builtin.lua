local M = {}

-- disable some builtin vim plugins
M.disable_default_plugins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  -- "netrw",
  -- "netrwPlugin",
  -- "netrwSettings",
  -- "netrwFileHandlers",
  -- "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  -- "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  "tutor",
  "rplugin",
  "syntax",
  "synmenu",
  "optwin",
  "compiler",
  "bugreport",
  "ftplugin",
}

function M.disable_plugins()
  for _, plugin in pairs(M.disable_default_plugins) do
    vim.g["loaded_" .. plugin] = 1
  end
end

-- Disable all builtin providers
M.disable_default_providers = {
  "node",
  "perl",
  "python3",
  "ruby",
}

function M.disable_providers()
  for _, provider in ipairs(M.disable_default_providers) do
    vim.g["loaded_" .. provider .. "_provider"] = 0
  end
end

function M.setup_netrw()
  vim.g.netrw_banner = 0
  vim.g.netrw_browse_split = 0
  vim.g.netrw_liststyle = 0

  -- TODO: Replace this with lua
  vim.cmd([[
    let s:dotfiles = '\(^\|\s\s\)\zs\.\S\+'

    let s:escape = 'substitute(escape(v:val, ".$~"), "*", ".*", "g")'
    let g:netrw_list_hide =
      \ join(map(split(&wildignore, ','), '"^".' . s:escape . '. "/\\=$"'), ',') . ',^\.\.\=/\=$' .
      \ (get(g:, 'netrw_list_hide', '')[-strlen(s:dotfiles)-1:-1] ==# s:dotfiles ? ','.s:dotfiles : '')

    function! s:sort_sequence(suffixes) abort
    return '[\/]$,*' . (empty(a:suffixes) ? '' : ',\%(' .
      \ join(map(split(a:suffixes, ','), 'escape(v:val, ".*$~")'), '\|') . '\)[*@]\=$')
    endfunction
    let g:netrw_sort_sequence = s:sort_sequence(&suffixes)

    function! s:slash() abort
      return !exists("+shellslash") || &shellslash ? '/' : '\'
    endfunction

    function! s:absolutes(first, ...) abort
      let files = getline(a:first, a:0 ? a:1 : a:first)
      call filter(files, 'v:val !~# "^\" "')
      call map(files, "substitute(v:val, '^\\(| \\)*', '', '')")
      call map(files, 'b:netrw_curdir . s:slash() . substitute(v:val, "[/*|@=]\\=\\%(\\t.*\\)\\=$", "", "")')
      return files
    endfunction

    function! s:relatives(first, ...) abort
      let files = s:absolutes(a:first, a:0 ? a:1 : a:first)
      call filter(files, 'v:val !~# "^\" "')
      for i in range(len(files))
        let relative = fnamemodify(files[i], ':.')
        if relative !=# files[i]
          let files[i] = '.' . s:slash() . relative
        endif
      endfor
      return files
    endfunction

    function! s:escaped(first, last) abort
      let files = s:relatives(a:first, a:last)
      return join(map(files, 'fnameescape(v:val)'), ' ')
    endfunction

    function! s:setup_vinegar() abort
      cnoremap <buffer><expr> <cfile> get(<SID>relatives('.'),0,"\022\006")
      cmap <buffer> <C-R><C-F> <cfile>
      nnoremap <buffer> ~ :edit ~/<CR>
      nnoremap <buffer> . :<C-U> <C-R>=<SID>escaped(line('.'), line('.') - 1 + v:count1)<CR><Home>
      xnoremap <buffer> . <Esc>: <C-R>=<SID>escaped(line("'<"), line("'>"))<CR><Home>
      nnoremap <silent><buffer> y. :<C-U>call setreg(v:register, join(<SID>absolutes(line('.'), line('.') - 1 + v:count1), "\n")."\n")<CR>
      nmap <buffer> ! .!
      xmap <buffer> ! .!
      exe 'syn match netrwSuffixes =\%(\S\+ \)*\S\+\%('.join(map(split(&suffixes, ','), s:escape), '\|') . '\)[*@]\=\S\@!='
      hi def link netrwSuffixes SpecialKey
    endfunction

    augroup vinegar
      autocmd!
      autocmd FileType netrw call s:setup_vinegar()
      autocmd OptionSet suffixes
        \ if s:sort_sequence(v:option_old) ==# get(g:, 'netrw_sort_sequence') |
        \   let g:netrw_sort_sequence = s:sort_sequence(v:option_new) |
        \ endif
    augroup END
  ]])
end

M.disable_plugins()
M.disable_providers()

M.setup_netrw()
