local M = {}

M.integrations = {
  "alpha",
  "blankline",
  "cmp",
  "colors",
  "defaults",
  "devicons",
  "git",
  "lsp",
  "mason",
  "nvimtree",
  "statusline",
  "syntax",
  "telescope",
  "treesitter",
}

---Load all the highlights from the integration for the colorscheme.
---@param group string
---@param colorscheme Colorscheme
---@return nil|table<string, string>
M.load_hl = function(group, colorscheme)
  local modpath = "aiko.colors.integrations." .. group
  local ok, mod = pcall(require, modpath)
  if not ok then
    vim.notify("Unable to load group " .. group)
    return
  end

  return mod.palette(colorscheme.theme, colorscheme.colors)
end

---Set the neovim color scheme based on the Colorscheme object.
---@param colorscheme Colorscheme
M.paint = function(colorscheme)
  colorscheme.polish = colorscheme.polish or {}
  local all = {}

  -- Clear existing highlight groups
  vim.cmd([[highlight clear]])
  if vim.fn.exists("syntax_on") then
    vim.cmd([[syntax reset]])
  end
  vim.g.colors_name = colorscheme.name
  vim.opt.background = colorscheme.background or "dark"

  -- Load all integrations
  for _, group in ipairs(M.integrations) do
    local palette = M.load_hl(group, colorscheme)
    all = vim.tbl_extend("force", all, palette)
  end

  -- Apply the polish if the color scheme has any
  all = vim.tbl_extend("force", all, colorscheme.polish)

  -- Override with the polish.
  for group, c in pairs(all) do
    vim.api.nvim_set_hl(0, group, c)
  end
end

return M
