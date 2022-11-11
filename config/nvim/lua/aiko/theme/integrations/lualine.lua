local M = {}

M.palette = function(_, colors)
  return {
    normal = {
      a = { bg = colors.green, fg = colors.bg0, gui = "bold" },
      b = { bg = colors.bg3, fg = colors.fg },
      c = { bg = colors.bg1, fg = colors.fg },
    },
    insert = {
      a = { bg = colors.fg, fg = colors.bg0, gui = "bold" },
      b = { bg = colors.bg3, fg = colors.fg },
      c = { bg = colors.bg1, fg = colors.fg },
    },
    visual = {
      a = { bg = colors.red, fg = colors.bg0, gui = "bold" },
      b = { bg = colors.bg3, fg = colors.fg },
      c = { bg = colors.bg1, fg = colors.fg },
    },
    replace = {
      a = { bg = colors.orange, fg = colors.bg0, gui = "bold" },
      b = { bg = colors.bg3, fg = colors.fg },
      c = { bg = colors.bg1, fg = colors.fg },
    },
    command = {
      a = { bg = colors.aqua, fg = colors.bg0, gui = "bold" },
      b = { bg = colors.bg3, fg = colors.fg },
      c = { bg = colors.bg1, fg = colors.fg },
    },
    terminal = {
      a = { bg = colors.purple, fg = colors.bg0, gui = "bold" },
      b = { bg = colors.bg3, fg = colors.fg },
      c = { bg = colors.bg1, fg = colors.fg },
    },
    inactive = {
      a = { bg = colors.bg1, fg = colors.grey1, gui = "bold" },
      b = { bg = colors.bg1, fg = colors.grey1 },
      c = { bg = colors.bg1, fg = colors.grey1 },
    },
  }
end

return M
