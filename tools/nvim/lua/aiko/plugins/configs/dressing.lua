local M = {}

M.setup = function()
  local ok_dressing, dressing = pcall(require, "dressing")
  if not ok_dressing then
    return
  end

  dressing.setup({
    winhighlight = "NormalFloat:DiagnosticError",
  })
end

return M
