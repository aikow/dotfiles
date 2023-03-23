vim.opt_local.conceallevel = 0

-- Automatically format markdown tables using tabular
vim.cmd([[
inoremap <silent> <buffer> <Bar> <Bar><Esc>:call MarkdownTable()<CR>a

function! MarkdownTable()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction
]])

-- Markdown previewer
local map = vim.keymap.set
map("n", "<localleader>r", "<cmd>MarkdownPreview<CR>", { buffer = true })
map("n", "<localleader>s", "<cmd>MarkdownPreviewStop<CR>", { buffer = true })
map("n", "<localleader>t", "<cmd>MarkdownPreviewToggle<CR>", { buffer = true })
