local M = {}

M.setup = function()
  local comment = require("Comment")
  comment.setup({
    padding = true,
    sticky = true,
    ignore = nil,
    toggler = {
      line = "gcc",
      block = "gbb",
    },
    opleader = {
      line = "gc",
      block = "gb",
    },
    extra = {
      above = "gcO",
      below = "gco",
      eol = "gcA",
    },
    mappings = {
      basic = true,
      extra = true,
      extended = false,
    },
  })
end

return M
