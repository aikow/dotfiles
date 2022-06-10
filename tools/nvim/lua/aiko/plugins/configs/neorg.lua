local M = {}

M.setup = function()
  local ok_neorg, neorg = pcall(require, "neorg")
  if not ok_neorg then
    return
  end

  neorg.setup({
    load = {
      ["core.defaults"] = {},
      ["core.norg.concealer"] = {},
      ["core.norg.completion"] = {},
    },
  })
end

return M
