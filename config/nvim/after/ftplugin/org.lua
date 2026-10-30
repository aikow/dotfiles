vim.bo.formatoptions = string.gsub(vim.bo.formatoptions, "n", "")

require("user.ftplugin").undo("setlocal formatoptions<")
