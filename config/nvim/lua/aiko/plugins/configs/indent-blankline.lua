local M = {}

M.setup = function()
  local ok_blankline, blankline = pcall(require, "indent_blankline")
  if not ok_blankline then
    return
  end

  blankline.setup({
    filetype_exclude = {
      "",
      "NvimTree",
      "Outline",
      "TelescopePrompt",
      "TelescopeResults",
      "alpha",
      "help",
      "lazy",
      "lspinfo",
      "man",
      "mason",
      "norg",
      "packer",
      "terminal",
    },
    buftype_exclude = { "terminal" },
    use_treesitter = false,
    show_trailing_blankline_indent = false,
    show_first_indent_level = false,
    show_current_context = true,
    show_current_context_start = false,
  })
end

return M
