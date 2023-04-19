local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "gruvbox-light",
  background = "light",
})

colorscheme.theme = {
  base00 = "#F2E5BC",
  base01 = "#e5d8af",
  base02 = "#d8cba2",
  base03 = "#cabd94",
  base04 = "#c0b38a",
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
  white = "#504945",
  dark_black = "#e8dbb2",
  black = "#F2E5BC",
  bg_1 = "#e3d6ad",
  bg_2 = "#e5d8af",
  bg_3 = "#d8cba2",
  bg_4 = "#cabd94",
  grey = "#c0b38a",
  light_grey_1 = "#b6a980",
  light_grey_2 = "#ac9f76",
  light_grey_3 = "#a2956c",
  red = "#d65d0e",
  light_pink = "#af3a03",
  pink = "#9d0006",
  line = "#ded1a8",
  green = "#79740e",
  light_green = "#7f7a14",
  nord_blue = "#7b9d90",
  blue = "#458588",
  yellow = "#d79921",
  sun = "#dd9f27",
  purple = "#8f3f71",
  dark_purple = "#853567",
  teal = "#749689",
  orange = "#b57614",
  cyan = "#82b3a8",
  bg_statusline = "#e9dcb3",
  bg_light = "#ddd0a7",
  bg_pmenu = "#739588",
  bg_folder = "#746d69",
}

colorscheme.polish = {
  TbLineThemeToggleBtn = {
    fg = colorscheme.colors.bg,
    bg = colorscheme.colors.white,
  },
}

require("aiko.theme").paint(colorscheme)
