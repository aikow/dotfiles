local M = {}

M.setup = function(_, colors)
  local theme = {
    normal = {
      a = { bg = colors.nord_blue, fg = colors.black, gui = "bold" },
      b = { bg = colors.lightbg, fg = colors.grey2 },
      c = { bg = colors.statusline_bg, fg = colors.grey1 },
    },
    insert = {
      a = { bg = colors.dark_purple, fg = colors.black, gui = "bold" },
      b = { bg = colors.lightbg, fg = colors.grey2 },
      c = { bg = colors.statusline_bg, fg = colors.grey1 },
    },
    visual = {
      a = { bg = colors.cyan, fg = colors.black, gui = "bold" },
      b = { bg = colors.lightbg, fg = colors.grey2 },
      c = { bg = colors.statusline_bg, fg = colors.grey1 },
    },
    replace = {
      a = { bg = colors.orange, fg = colors.black, gui = "bold" },
      b = { bg = colors.lightbg, fg = colors.grey2 },
      c = { bg = colors.statusline_bg, fg = colors.grey1 },
    },
    command = {
      a = { bg = colors.green, fg = colors.black, gui = "bold" },
      b = { bg = colors.lightbg, fg = colors.grey2 },
      c = { bg = colors.statusline_bg, fg = colors.grey1 },
    },
    terminal = {
      a = { bg = colors.yellow, fg = colors.black, gui = "bold" },
      b = { bg = colors.lightbg, fg = colors.grey2 },
      c = { bg = colors.statusline_bg, fg = colors.grey1 },
    },
    inactive = {
      a = { bg = colors.lightbg, fg = colors.gray, gui = "bold" },
      b = { bg = colors.lightbg, fg = colors.grey2 },
      c = { bg = colors.statusline_bg, fg = colors.grey1 },
    },
  }

  local ok_lualine, lualine = pcall(require, "lualine")
  if not ok_lualine then
    return
  end
  lualine.setup({
    options = {
      theme = theme,
    },
  })
end

return M
