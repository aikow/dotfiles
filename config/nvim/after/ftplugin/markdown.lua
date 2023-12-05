vim.opt_local.conceallevel = 0

-- Automatically format markdown tables using tabular
if vim.fn.exists(":Tabularize") == 2 then
  vim.cmd([[
    inoremap <silent> <buffer> <Bar> <Bar><Esc>:call MarkdownTable()<CR>a

    function! MarkdownTable()
      let p = '^\s*|\s.*\s|\s*$'
      let line_nr = line('.') 
      if getline(line_nr) =~# '^\s*|' && (getline(line_nr - 1) =~# p || getline(line_nr + 1) =~# p)
        let prefix = getline('.')[0:col('.')]
        let column = strlen(substitute(prefix, '[^|]', '', 'g'))
        let position = strlen(matchstr(prefix, '.*|\s*\zs.*'))
        Tabularize/|/l1
        normal! 0
        call search(repeat('[^|]*|', column).'\s\{-\}'.repeat('.', position), 'ce', line_nr)
      endif
    endfunction
  ]])
end

-- Markdown previewer
vim.keymap.set(
  "n",
  "<localleader>r",
  "<cmd>MarkdownPreview<CR>",
  { buffer = true }
)
vim.keymap.set(
  "n",
  "<localleader>s",
  "<cmd>MarkdownPreviewStop<CR>",
  { buffer = true }
)
vim.keymap.set(
  "n",
  "<localleader>t",
  "<cmd>MarkdownPreviewToggle<CR>",
  { buffer = true }
)
