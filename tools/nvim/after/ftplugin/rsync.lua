-- Customize the highlight groups for rsync.
local hl_type = vim.api.nvim_get_hl_by_name("Type", true)
local hl_constant = vim.api.nvim_get_hl_by_name("Constant", true)

vim.api.nvim_set_hl(0, "RsyncFile", hl_constant)
vim.api.nvim_set_hl(0, "RsyncDir", hl_constant)

hl_type.bold = true
hl_constant.bold = true

vim.api.nvim_set_hl(0, "RsyncAnchoredFile", hl_type)
vim.api.nvim_set_hl(0, "RsyncAnchoredDir", hl_constant)
