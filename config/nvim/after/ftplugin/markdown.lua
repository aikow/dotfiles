vim.opt_local.conceallevel = 0

-- ---------------------
-- |   User Commands   |
-- ---------------------
-- local insert = function(keys)
--   vim.api.nvim_feedkeys(
--     vim.api.nvim_replace_termcodes(keys, true, true, true),
--     "n",
--     false
--   )
-- end
--
-- local align = function()
--   local fn = vim.fn
--   local pattern = "^%s*|%s.*%s|%s*$"
--   local line_number = fn.line(".")
--   local cur_column = fn.col(".")
--   local prev_line = fn.getline(line_number - 1)
--   local cur_line = fn.getline(".")
--   local next_line = fn.getline(line_number + 1)
--
--   if
--     cur_line:match("^%s*|")
--     and (prev_line:match(pattern) or next_line:match(pattern))
--   then
--     local column = #cur_line:sub(1, cur_column):gsub("[^|]", "")
--     local position = #fn.matchstr(cur_line:sub(1, cur_column), [[.*|\s*\zs.*]])
--     vim.cmd("Tabularize/|/l1") -- `l` means left aligned and `1` means one space of cell padding
--     vim.cmd("normal! 0")
--     fn.search(
--       ("[^|]*|"):rep(column) .. ("\\s\\{-\\}"):rep(position),
--       "ce",
--       line_number
--     )
--   end
-- end
--
-- vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
--   group = vim.api.nvim_create_augroup("align markdown table", { clear = true }),
--   callback = function()
--     align()
--   end,
--   buffer = 0,
--   desc = "Align markdown table",
-- })
--
-- vim.keymap.set("i", "<Bar>", function()
--   insert("<Bar>")
--   align()
-- end, { silent = true, buffer = true })

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

-- ---------------
-- |   Keymaps   |
-- ---------------
vim.keymap.set(
  "n",
  "<localleader>r",
  "<cmd>MarkdownPreview<CR>",
  { buffer = true, silent = true }
)
vim.keymap.set(
  "n",
  "<localleader>s",
  "<cmd>MarkdownPreviewStop<CR>",
  { buffer = true, silent = true }
)
vim.keymap.set(
  "n",
  "<localleader>t",
  "<cmd>MarkdownPreviewToggle<CR>",
  { buffer = true, silent = true }
)
