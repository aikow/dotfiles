local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({ name = "mountain", background = "dark" })

colorscheme.colors = {
  white = "#F0f0f0",
  dark_black = "#090909",
  black = "#0f0f0f",
  bg_1 = "#181818",
  bg_2 = "#191919",
  bg_3 = "#222222",
  bg_4 = "#2a2a2a",
  grey = "#373737",
  light_grey_1 = "#414141",
  light_grey_2 = "#4b4b4b",
  light_grey_3 = "#535353",
  red = "#ac8a8c",
  light_pink = "#bb999b",
  pink = "#AC8AAC",
  line = "#242424",
  green = "#8aac8b",
  light_green = "#99bb9a",
  blue = "#9691b3",
  nord_blue = "#8F8AAC",
  yellow = "#ACA98A",
  sun = "#b3b091",
  purple = "#C49EC4",
  dark_purple = "#b58fb5",
  teal = "#8fb4b5",
  orange = "#9d9a7b",
  cyan = "#9EC3C4",
  bg_statusline = "#131313",
  bg_light = "#292929",
  bg_pmenu = "#8aac8b",
  bg_folder = "#8F8AAC",
}

colorscheme.theme = {
  base00 = "#0f0f0f",
  base01 = "#151515",
  base02 = "#191919",
  base03 = "#222222",
  base04 = "#535353",
  base05 = "#d8d8d8",
  base06 = "#e6e6e6",
  base07 = "#f0f0f0",
  base08 = "#b18f91",
  base09 = "#d8bb92",
  base0A = "#b1ae8f",
  base0B = "#8aac8b",
  base0C = "#91b2b3",
  base0D = "#a5a0c2",
  base0E = "#ac8aac",
  base0F = "#b39193",
}

colorscheme.polish = {
  TSVariable = { fg = colorscheme.theme.base05 },
}

require("aiko.theme").paint(colorscheme)
