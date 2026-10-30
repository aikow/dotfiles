vim.bo.readonly = true
vim.bo.modifiable = false

require("user.ftplugin").undo("setlocal readonly< modifiable<")
