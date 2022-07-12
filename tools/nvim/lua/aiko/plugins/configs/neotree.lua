local M = {}

M.setup = function()
  vim.g.neo_tree_remove_legacy_commands = 1

  -- vim.api.nvim_get_hl_by_name("Normal")

  -- vim.api.nvim_set_hl(0, "NeoTreeNormal", { fg = "#ffffff", bg = "#000000" })
  -- vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { fg = "#ffffff", bg = "#000000" })
  -- vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { fg = "#ffffff", bg = "#000000" })
end

return M
