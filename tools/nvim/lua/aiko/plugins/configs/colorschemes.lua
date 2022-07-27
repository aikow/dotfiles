local M = {}

M.catppuccin = function()
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
end

M.material = function()
  -- Options: oceanic, deep ocean, palenight, lighter, darker
  vim.g.material_style = "darker"
end

return M
