local hexterm = require("aiko.util.hex-xterm")

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

local add_cterm_colors_to_colorscheme = function(colorscheme)
  local add_cterm_colors = function(color)
    if color.ctermfg == nil and color.fg ~= nil then
      color.ctermfg = hexterm.convert_hex_to_xterm(color.fg)
    end

    if color.ctermbg == nil and color.bg ~= nil then
      color.ctermbg = hexterm.convert_hex_to_xterm(color.bg)
    end
  end

  local add_cterm_colors_to_table = function(t)
    for _, color in pairs(t) do
      add_cterm_colors(color)
    end
  end

  add_cterm_colors_to_table(colorscheme.base)
  add_cterm_colors_to_table(colorscheme.colors)
  add_cterm_colors_to_table(colorscheme.polish)
end

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
  if vim.g.ctermcolors then
    add_cterm_colors_to_colorscheme(colorscheme)
  end

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
