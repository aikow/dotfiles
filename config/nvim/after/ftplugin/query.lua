vim.bo.omnifunc = "v:lua.vim.treesitter.query.omnifunc"

require("user.ftplugin").undo("setlocal omnifunc<")
