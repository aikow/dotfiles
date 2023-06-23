local M = {}

--- Apply a table of keymaps matching the `keys` spec from lazy.nvim
---@param keys table[]
M.lazy_keys = function(keys)
  for _, key in ipairs(keys) do
    local lhs = table.remove(key, 1)
    local rhs = table.remove(key, 1)
    local mode = key.mode or "n"
    key.mode = nil

    vim.keymap.set(mode, lhs, rhs, key)
  end
end

return M
