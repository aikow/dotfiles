local M = {}

M.diagnostics = {
  hint = "",
  info = "",
  warn = "",
  error = "",
}

M.packer = {
  working_sym = "ﲊ",
  error_sym = "✗ ",
  done_sym = " ",
  removed_sym = " ",
  moved_sym = "",
}

M.statusline_separators = {
  default = {
    left = "",
    right = " ",
  },

  round = {
    left = "",
    right = "",
  },

  block = {
    left = "█",
    right = "█",
  },

  arrow = {
    left = "",
    right = "",
  },
}

return M
