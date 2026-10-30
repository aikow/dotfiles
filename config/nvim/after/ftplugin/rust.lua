vim.bo.textwidth = 100
vim.bo.shiftwidth = 4

require("user.ftplugin").undo("setlocal textwidth< shiftwidth<")
