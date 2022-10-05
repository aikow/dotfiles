vim.opt_local.expandtab = true
vim.opt_local.autoindent = true
vim.opt_local.smarttab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.fileformat = "unix"
vim.opt_local.textwidth = 80

-- Set the indent after opening parenthesis
vim.g.pyindent_open_paren = vim.bo.shiftwidth
-- vim.g.pyindent_nested_paren = vim.bo.shiftwidth
-- vim.g.pyindent_continue = vim.bo.shiftwidth

if vim.fn.executable("python3") == 1 then
  vim.keymap.set({ "n", "v" }, "<localleader>r", [[:!python3 %<CR>]])
end
