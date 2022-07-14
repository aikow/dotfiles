local M = {}

M.setup = function()
  local ok_dressing, dressing = pcall(require, "dressing")
  if not ok_dressing then
    return
  end

  dressing.setup({
    insert_only = false,
    winhighlight = "NormalFloat:DiagnosticError",
    select = {
      backend = { "telescope" },
    },
  })
end

return M
