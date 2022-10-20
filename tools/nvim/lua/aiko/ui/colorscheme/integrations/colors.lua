local M = {}

M.palette = function(_, colors)
  return {
    Black = { fg = colors.white, bg = colors.black },
    DarkerBlack = { fg = colors.white, bg = colors.darkerblack },
    Grey = { fg = colors.white, bg = colors.grey },
    Red = { fg = colors.white, bg = colors.red },
    Pink = { fg = colors.white, bg = colors.pink },
    Baby_pink = { fg = colors.white, bg = colors.baby_pink },
    White = { fg = colors.white, bg = colors.white },
    Green = { fg = colors.white, bg = colors.green },
    Vibrant_green = { fg = colors.white, bg = colors.vibrant_green },
    Nord_blue = { fg = colors.white, bg = colors.nord_blue },
    Blue = { fg = colors.white, bg = colors.blue },
    Yellow = { fg = colors.white, bg = colors.yellow },
    Sun = { fg = colors.white, bg = colors.sun },
    Purple = { fg = colors.white, bg = colors.purple },
    Dark_purple = { fg = colors.white, bg = colors.dark_purple },
    Teal = { fg = colors.white, bg = colors.teal },
    Orange = { fg = colors.white, bg = colors.orange },
    Cyan = { fg = colors.white, bg = colors.cyan },
  }
end

return M
