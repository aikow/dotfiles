vim.bo.shiftwidth = 2

-- Markdown previewer
vim.keymap.set(
  "n",
  "<localleader>v",
  "<cmd>Markview toggle<CR>",
  { desc = "Toggle Markview preview", buffer = true }
)

require("user.ftplugin").undo("setlocal shiftwidth< | silent! nunmap <buffer> <localleader>v")
