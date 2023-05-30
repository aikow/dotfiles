local colorscheme = require("aiko.theme.colorscheme").Scheme:new({
  name = "gruvbox-light",
  background = "light",
})

colorscheme.theme = {
  base00 = "#f2e5bc",
  base01 = "#e3d6ad",
  base02 = "#e5d8af",
  base03 = "#d8cba2",
  base04 = "#cabd94",
  base05 = "#504945",
  base06 = "#3c3836",
  base07 = "#282828",
  base08 = "#9d0006",
  base09 = "#af3a03",
  base0A = "#b57614",
  base0B = "#79740e",
  base0C = "#427b58",
  base0D = "#076678",
  base0E = "#8f3f71",
  base0F = "#d65d0e",
}

colorscheme.colors = {
  bg_1 = "#e3d6ad",
  bg_2 = "#e5d8af",
  bg_3 = "#d8cba2",
  bg_4 = "#cabd94",
  bg_folder = "#746d69",
  bg_light = "#ddd0a7",
  bg_pmenu = "#739588",
  bg_statusline = "#e9dcb3",
  black = "#f2e5bc",
  blue = "#458588",
  cyan = "#82b3a8",
  dark_black = "#e8dbb2",
  dark_purple = "#853567",
  green = "#79740e",
  grey = "#c0b38a",
  light_green = "#7f7a14",
  light_grey_1 = "#b6a980",
  light_grey_2 = "#ac9f76",
  light_grey_3 = "#a2956c",
  light_pink = "#af3a03",
  line = "#ded1a8",
  nord_blue = "#7b9d90",
  orange = "#b57614",
  pink = "#9d0006",
  purple = "#8f3f71",
  red = "#d65d0e",
  sun = "#dd9f27",
  teal = "#749689",
  white = "#504945",
  yellow = "#d79921",
}

colorscheme.polish = {
  TbLineThemeToggleBtn = { fg = "#F2E5BC", bg = colorscheme.colors.white },
}

require("aiko.theme").paint(colorscheme)
