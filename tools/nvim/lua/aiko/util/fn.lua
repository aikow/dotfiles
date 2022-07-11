local M = {}

M.has = function(x) return vim.fn.has(x) == 1 end

M.executable = function(x) return vim.fn.executable(x) == 1 end

return M
