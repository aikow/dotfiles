local M = {}

M.setup = function()
  vim.g.neo_tree_remove_legacy_commands = 1
end

M.mappings = function()
  local map = vim.keymap.set

  map(
    "n",
    "<leader>to",
    [[<cmd>Neotree filesystem reveal left<CR>]],
    { silent = true, desc = "Neotree reveal filesystem" }
  )

  map(
    "n",
    "<leader>tg",
    [[<cmd>Neotree git_status reveal left<CR>]],
    { silent = true, desc = "Neotree reveal filesystem" }
  )

  map(
    "n",
    "<leader>tb",
    [[<cmd>Neotree buffers reveal left<CR>]],
    { silent = true, desc = "Neotree reveal filesystem" }
  )
end

return M
