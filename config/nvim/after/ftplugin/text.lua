vim.bo.comments = ""
vim.bo.commentstring = ""

require("user.ftplugin").undo("setlocal comments< commentstring<")
