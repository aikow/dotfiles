if vim.fn.exists("b:did_ftplugin") == 1 then
  return
end
vim.b.did_ft_plugin = 1

vim.opt_local.commentstring = [[# %s]]

vim.b.undo_ftplugin = nil
