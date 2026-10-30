vim.bo.textwidth = 100

vim.keymap.set("n", "<localleader>s", "<cmd>luafile %<CR>", {
  buffer = true,
  desc = "Run the current Lua file",
})

require("user.ftplugin").undo("setlocal textwidth< | silent! nunmap <buffer> <localleader>s")
