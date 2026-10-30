vim.bo.comments = ":#"
vim.bo.commentstring = "# %s"

require("user.ftplugin").undo("setlocal comments< commentstring<")
