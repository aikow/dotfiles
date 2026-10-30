-- Edit the displayed list in place, keeping its history, metadata, and window.
vim.keymap.set("n", "dd", function()
  local is_location = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].loclist == 1
  local fields = { items = 0, idx = 0, id = 0 }
  local list = is_location and vim.fn.getloclist(0, fields) or vim.fn.getqflist(fields)
  local row = vim.fn.line(".")
  if row > #list.items then return end

  local count = math.min(vim.v.count1, #list.items - row + 1)
  for _ = 1, count do
    table.remove(list.items, row)
  end
  local index = list.idx > row and math.max(row, list.idx - count) or list.idx
  local update = { id = list.id, items = list.items, idx = math.min(index, #list.items) }
  if is_location then
    vim.fn.setloclist(0, {}, "r", update)
  else
    vim.fn.setqflist({}, "r", update)
  end
  vim.api.nvim_win_set_cursor(0, { math.max(1, math.min(row, #list.items)), 0 })
end, { buffer = true, desc = "Remove entries from the displayed list" })

require("user.ftplugin").undo("silent! nunmap <buffer> dd")
