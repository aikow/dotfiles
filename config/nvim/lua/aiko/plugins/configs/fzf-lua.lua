local M = {}

M.mappings = function()
  local map = vim.keymap.set

  map("n", "<leader>z", "<cmd>FzfLua<CR>", {silent=true})
end

return M
