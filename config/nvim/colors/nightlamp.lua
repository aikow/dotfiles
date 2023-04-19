local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({ name = "nightlamp", background = "dark" })

colorscheme.colors = {
  white = "#e0d6bd",
  dark_black = "#13141a",
  black = "#18191f",
  bg_1 = "#202127",
  bg_2 = "#27282e",
  bg_3 = "#2d2e34",
  bg_4 = "#33343a",
  grey = "#3d3e44",
  light_grey_1 = "#48494f",
  light_grey_2 = "#4d4e54",
  light_grey_3 = "#55565c",
  red = "#a67476",
  light_pink = "#d6b3bd",
  pink = "#c99aa7",
  line = "#313238",
  green = "#8aa387",
  light_green = "#94ad91",
  nord_blue = "#8d9bb3",
  blue = "#5a6986",
  yellow = "#ccb89c",
  sun = "#deb88a",
  purple = "#b8aad9",
  dark_purple = "#a99bca",
  teal = "#7aacaa",
  orange = "#cd9672",
  cyan = "#90a0a0",
  bg_statusline = "#1d1e24",
  bg_light = "#2b2c32",
  bg_pmenu = "#b58385",
  bg_folder = "#90a0a0",
}

colorscheme.theme = {
  base00 = "#18191f",
  base01 = "#222329",
  base02 = "#2c2d33",
  base03 = "#3c3d43",
  base04 = "#48494f",
  base05 = "#b8af9e",
  base06 = "#cbc0ab",
  base07 = "#e0d6bd",
  base08 = "#b8aad9",
  base09 = "#cd9672",
  base0A = "#ccb89c",
  base0B = "#8aa387",
  base0C = "#7aacaa",
  base0D = "#b58385",
  base0E = "#8e9cb4",
  base0F = "#90a0a0",
}

require("aiko.theme").paint(colorscheme)
