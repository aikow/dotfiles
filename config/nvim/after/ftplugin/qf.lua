-- Create a keymap to delete an entry from the quickfix list.
vim.keymap.set("n", "dd", function()
  local qflist = vim.fn.getqflist()
  local entry = vim.fn.line(".")
  table.remove(qflist, entry)
  vim.fn.setqflist(qflist)
  vim.cmd.cfirst({ count = entry })
  vim.cmd.copen()
end, { buffer = true, desc = "Remove an entry from the quickfix list" })
