local M = {}

M.setup = function()
  local ok_blankline, blankline = pcall(require, "indent_blankline")
  if not ok_blankline then
    return
  end

  blankline.setup({
    indentLine_enabled = 1,
    filetype_exclude = {
      "",
      "alpha",
      "help",
      "lspinfo",
      "man",
      "mason.nvim",
      "norg",
      "NvimTree",
      "packer",
      "TelescopePrompt",
      "TelescopeResults",
      "terminal",
    },
    buftype_exclude = { "terminal" },
    show_trailing_blankline_indent = false,
    show_first_indent_level = false,
    show_current_context = true,
    show_current_context_start = false,
  })
end

return M
