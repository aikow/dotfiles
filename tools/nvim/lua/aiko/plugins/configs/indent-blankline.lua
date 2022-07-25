local M = {}

M.setup = function()
  local ok_blankline, blankline = pcall(require, "indent_blankline")
  if not ok_blankline then
    return
  end

  blankline.setup({
    indentLine_enabled = 1,
    filetype_exclude = {
      "help",
      "alpha",
      "terminal",
      "packer",
      "lspinfo",
      "TelescopePrompt",
      "TelescopeResults",
      "mason.nvim",
      "norg",
      "NvimTree",
      "",
    },
    buftype_exclude = { "terminal" },
    show_trailing_blankline_indent = false,
    show_first_indent_level = false,
    show_current_context = true,
    show_current_context_start = false,
  })
end

return M
