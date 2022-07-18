local M = {}

M.setup = function()
  local ok_catppuccin, catppuccin = pcall(require, "catppuccin")
  if not ok_catppuccin then
    return
  end

  local cp = require("catppuccin.palettes").get_palette()

  catppuccin.setup({
    dim_inactive = {
      enabled = false,
    },
    transparent_background = false,
    term_colors = true,
    compile = {
      enabled = true,
    },
    styles = {
      comments = { "italic" },
      conditionals = { "italic" },
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
    },
    integrations = {
      treesitter = true,
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
        },
      },
      coc_nvim = false,
      lsp_trouble = false,
      cmp = true,
      lsp_saga = false,
      gitgutter = false,
      gitsigns = true,
      telescope = true,
      nvimtree = {
        enabled = false,
        show_root = true,
        transparent_panel = false,
      },
      neotree = {
        enabled = true,
        show_root = true,
        transparent_panel = false,
      },
      which_key = false,
      indent_blankline = {
        enabled = true,
        colored_indent_levels = false,
      },
      dashboard = false,
      neogit = false,
      vim_sneak = false,
      fern = false,
      barbar = false,
      bufferline = false,
      markdown = true,
      lightspeed = false,
      ts_rainbow = false,
      hop = false,
      notify = false,
      telekasten = false,
      symbols_outline = false,
      mini = false,
    },
    custom_highlights = {
      TelescopePromptPrefix = { bg = cp.crust },
      TelescopePromptNormal = { bg = cp.crust },
      TelescopeResultsNormal = { bg = cp.mantle },
      TelescopePreviewNormal = { bg = cp.crust },
      TelescopePromptBorder = { bg = cp.crust, fg = cp.crust },
      TelescopeResultsBorder = { bg = cp.mantle, fg = cp.mantle },
      TelescopePreviewBorder = { bg = cp.crust, fg = cp.crust },
      TelescopePromptTitle = { fg = cp.text },
      TelescopeResultsTitle = { fg = cp.text },
      TelescopePreviewTitle = { fg = cp.text },
    },
  })

  -- Options: latte, macchiato, frappe, mocha
  vim.g.catppuccin_flavour = "macchiato"

  vim.cmd([[colorscheme catppuccin]])
end

return M
