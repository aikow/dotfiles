local M = {}

M.complete_matching_line = function()
  local cur_line = vim.trim(vim.api.nvim_get_current_line())

  if not cur_line then return end

  local all_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  local matching_lines = {}
  for _, v in ipairs(all_lines) do
    if string.find(v, cur_line, 1, true) then
      table.insert(matching_lines, v)
    end
  end

  vim.fn.complete(1, matching_lines)

  return ""
end

return M
