local M = {}

M.gruvbox_material = function()
  vim.g.gruvbox_material_background = "medium"
  vim.g.grubbox_material_better_performance = 1
  vim.g.gruvbox_material_enable_bold = 1
  vim.g.gruvbox_material_enable_italic = 1

  local normal = vim.api.nvim_get_hl_by_name("Normal", true)
  local dark1 = "#232323"
  local dark2 = "#1e1e1e"
  local text = normal.foreground

  -- Telescope
  vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { bg = dark1 })
  vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = dark1 })
  vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = dark1, fg = dark1 })
  vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = text })

  vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = dark2 })
  vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = dark2, fg = dark2 })
  vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = dark2 })

  vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = dark1 })
  vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = dark1, fg = dark1 })
  vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = text })

  -- Nvim Tree
  vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = dark1 })
  vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = dark1 })
end

return M
