local M = {}

---Search the current directory for the needle.
---
---Try to use ripgrep if it is installed, otherwise fallback to standard GNU
---grep.
---@param needle string
---@return string[]
M.grep = function(needle)
  local command
  if vim.fn.executable("rg") == 1 then
    command = { "rg", "-I", "--", needle }
  else
    command = { "grep", "-i", "--", needle }
  end
  local stdout = vim.system(command, { text = true }):wait().stdout or ""
  return vim.split(stdout, "\n", { trimempty = true, plain = true })
end

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

M.complete_matching_line_cwd = function(cur_line)
  cur_line = cur_line or vim.trim(vim.api.nvim_get_current_line())

  if not cur_line then return end

  local all_lines = M.grep(cur_line)

  local uniq_lines = {}
  local filtered_lines = {}
  for _, v in ipairs(all_lines) do
    if not uniq_lines[v] then
      uniq_lines[v] = true
      table.insert(filtered_lines, v)
    end
  end

  vim.fn.complete(1, filtered_lines)

  return ""
end

return M
