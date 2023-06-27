local job = require("plenary.job")

local M = {}

M.grep = function(needle)
  if vim.fn.executable("rg") == 1 then
    return job
      :new({
        command = "rg",
        args = { "-I", "--", needle },
      })
      :sync()
  else
    return job
      :new({
        command = "grep",
        args = { needle },
      })
      :sync()
  end
end

M.complete_matching_line = function()
  local cur_line = vim.trim(vim.api.nvim_get_current_line())

  if not cur_line then
    return
  end

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

M.complete_matching_line_cwd = function(cur_line)
  cur_line = cur_line or vim.trim(vim.api.nvim_get_current_line())

  if not cur_line then
    return
  end

  local all_lines = M.grep(cur_line)

  local uniq_lines = {}
  for _, v in ipairs(all_lines) do
    uniq_lines[v] = true
  end

  vim.fn.complete(1, uniq_lines)

  return ""
end

return M
