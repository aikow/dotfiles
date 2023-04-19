local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "dracula",
  background = "dark",
})

colorscheme.colors = {
  white = "#F8F8F2",
  dark_black = "#222430",
  black = "#282A36",
  bg_1 = "#2d303e",
  bg_2 = "#373844",
  bg_3 = "#44475a",
  bg_4 = "#565761",
  grey = "#5e5f69",
  light_grey_1 = "#666771",
  light_grey_2 = "#6e6f79",
  light_grey_3 = "#73747e",
  red = "#ff7070",
  light_pink = "#ff86d3",
  pink = "#FF79C6",
  line = "#3c3d49",
  green = "#50fa7b",
  light_green = "#5dff88",
  nord_blue = "#8b9bcd",
  blue = "#a1b1e3",
  yellow = "#F1FA8C",
  sun = "#FFFFA5",
  purple = "#BD93F9",
  dark_purple = "#BD93F9",
  teal = "#92a2d4",
  orange = "#FFB86C",
  cyan = "#8BE9FD",
  bg_statusline = "#2d2f3b",
  bg_light = "#41434f",
  bg_pmenu = "#b389ef",
  bg_folder = "#BD93F9",
}

colorscheme.theme = {
  base00 = "#282936",
  base01 = "#3a3c4e",
  base02 = "#4d4f68",
  base03 = "#626483",
  base04 = "#62d6e8",
  base05 = "#e9e9f4",
  base06 = "#f1f2f8",
  base07 = "#f7f7fb",
  base08 = "#c197fd",
  base09 = "#FFB86C",
  base0A = "#62d6e8",
  base0B = "#F1FA8C",
  base0C = "#8BE9FD",
  base0D = "#50fa7b",
  base0E = "#ff86d3",
  base0F = "#F8F8F2",
}

colorscheme.polish = {
  TSFuncBuiltin = { fg = colorscheme.colors.cyan },
  TSNumber = { fg = colorscheme.colors.purple },
}

require("aiko.theme").paint(colorscheme)
