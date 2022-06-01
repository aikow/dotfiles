local M = {}

M.setup = function()
  -- prompt for a refactor to apply when the remap is triggered
  vim.api.nvim_set_keymap(
    "v",
    "<leader>rq",
    "<cmd>lua require('refactoring').select_refactor()<CR>",
    { noremap = true, silent = true, expr = false }
  )
end

return M
