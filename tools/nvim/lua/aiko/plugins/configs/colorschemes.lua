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
end

M.gruvbox_material = function()
  vim.g.gruvbox_material_background = "medium"
  vim.g.grubbox_material_better_performance = 1
  vim.g.gruvbox_material_enable_bold = 1
  vim.g.gruvbox_material_enable_italic = 1

  local normal = vim.api.nvim_get_hl_by_name("Normal", true)
  local cp = {
    crust = "#1b1818",
    mantle = "#110f0f",
    text = "#808080",
  }

  vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { bg = cp.crust })
  vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = cp.crust })
  vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = cp.mantle })
  vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = cp.crust })

  vim.api.nvim_set_hl(
    0,
    "TelescopePromptBorder",
    { bg = cp.crust, fg = cp.crust }
  )
  vim.api.nvim_set_hl(
    0,
    "TelescopeResultsBorder",
    { bg = cp.mantle, fg = cp.mantle }
  )
  vim.api.nvim_set_hl(
    0,
    "TelescopePreviewBorder",
    { bg = cp.crust, fg = cp.crust }
  )

  vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = cp.text })
  vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = cp.text })
  vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = cp.text })
end

M.material = function()
  -- Options: oceanic, deep ocean, palenight, lighter, darker
  vim.g.material_style = "darker"
end

return M
