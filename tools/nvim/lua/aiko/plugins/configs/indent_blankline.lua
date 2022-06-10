local M = {}

M.setup = function()
  local ok_blankline, blankline = pcall(require, "indent_blankline")
  if not ok_blankline then
    return
  end

  blankline.setup({
    indentLine_enabled = 1,
    char = "▏",
    filetype_exclude = {
      "help",
      "terminal",
      "alpha",
      "packer",
      "lspinfo",
      "TelescopePrompt",
      "TelescopeResults",
      "nvchad_cheatsheet",
      "lsp-installer",
      "",
    },
    buftype_exclude = { "terminal" },
    show_trailing_blankline_indent = false,
    show_first_indent_level = false,
  })
end

return M
