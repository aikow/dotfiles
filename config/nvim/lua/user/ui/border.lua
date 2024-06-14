local M = {}

M.win_borders_fillchars = {
  bold = {
    vert = "┃",
    horiz = "━",
    horizdown = "┳",
    horizup = "┻",
    verthoriz = "╋",
    vertleft = "┫",
    vertright = "┣",
  },
  dot = {
    vert = "·",
    horiz = "·",
    horizdown = "·",
    horizup = "·",
    verthoriz = "·",
    vertleft = "·",
    vertright = "·",
  },
  double = {
    vert = "║",
    horiz = "═",
    horizdown = "╦",
    horizup = "╩",
    verthoriz = "╬",
    vertleft = "╣",
    vertright = "╠",
  },
  single = {
    vert = "│",
    horiz = "─",
    horizdown = "┬",
    horizup = "┴",
    verthoriz = "┼",
    vertleft = "┤",
    vertright = "├",
  },
  solid = {
    vert = " ",
    horiz = " ",
    horizdown = " ",
    horizup = " ",
    verthoriz = " ",
    vertleft = " ",
    vertright = " ",
  },
}

return M
