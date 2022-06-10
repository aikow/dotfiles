local M = {}

M.setup = function()
  local ok_comment, comment = pcall(require, "Comment")
  if not ok_comment then
    return
  end

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
