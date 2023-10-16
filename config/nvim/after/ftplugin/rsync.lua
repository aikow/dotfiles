vim.opt.comments = ":#"
vim.opt.commentstring = "# %s"

-- Customize the highlight groups for rsync.
local hl_type = vim.api.nvim_get_hl(0, { name = "Type" })
local hl_constant = vim.api.nvim_get_hl(0, { name = "Constant" })

hl_type.bold = true
hl_constant.bold = true

vim.api.nvim_set_hl(0, "RsyncAnchoredFile", hl_type)
vim.api.nvim_set_hl(0, "RsyncAnchoredDir", hl_constant)
