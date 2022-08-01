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

return M
