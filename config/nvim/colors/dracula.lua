local colorscheme = require("aiko.theme.colorscheme").Colorscheme.new({
  name = "dracula",
  background = "dark",
})

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

colorscheme.colors = {
  bg_1 = "#2d303e",
  bg_2 = "#373844",
  bg_3 = "#44475a",
  bg_4 = "#565761",
  bg_folder = "#BD93F9",
  bg_light = "#41434f",
  bg_pmenu = "#b389ef",
  bg_statusline = "#2d2f3b",
  black = "#282A36",
  blue = "#a1b1e3",
  cyan = "#8BE9FD",
  dark_black = "#222430",
  dark_purple = "#BD93F9",
  green = "#50fa7b",
  grey = "#5e5f69",
  light_green = "#5dff88",
  light_grey_1 = "#666771",
  light_grey_2 = "#6e6f79",
  light_grey_3 = "#73747e",
  light_pink = "#ff86d3",
  line = "#3c3d49",
  nord_blue = "#8b9bcd",
  orange = "#FFB86C",
  pink = "#FF79C6",
  purple = "#BD93F9",
  red = "#ff7070",
  sun = "#FFFFA5",
  teal = "#92a2d4",
  white = "#F8F8F2",
  yellow = "#F1FA8C",
}

colorscheme.polish = {
  TSFuncBuiltin = { fg = colorscheme.colors.cyan },
  TSNumber = { fg = colorscheme.colors.purple },
}

require("aiko.theme").paint(colorscheme)
