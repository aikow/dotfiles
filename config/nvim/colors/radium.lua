local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({ name = "radium", background = "dark" })

colorscheme.colors = {
  white = "#d4d4d5",
  dark_black = "#0a0d11",
  black = "#101317",
  bg_1 = "#191d22",
  bg_2 = "#212428",
  bg_3 = "#292c30",
  bg_4 = "#33363a",
  grey = "#3e4145",
  light_grey_1 = "#45484c",
  light_grey_2 = "#4a4d51",
  light_grey_3 = "#525559",
  red = "#f87070",
  light_pink = "#ff8e8e",
  pink = "#ffa7a7",
  line = "#30303a",
  green = "#37d99e",
  light_green = "#79dcaa",
  blue = "#7ab0df",
  nord_blue = "#87bdec",
  yellow = "#ffe59e",
  sun = "#ffeda6",
  purple = "#c397d8",
  dark_purple = "#b68acb",
  teal = "#63b3ad",
  orange = "#f0a988",
  cyan = "#50cad2",
  bg_statusline = "#15191e",
  bg_light = "#24282d",
  bg_pmenu = "#3bdda2",
  bg_folder = "#5fb0fc",
}

colorscheme.theme = {
  base00 = "#101317",
  base01 = "#1a1d21",
  base02 = "#23262a",
  base03 = "#2b2e32",
  base04 = "#323539",
  base05 = "#c5c5c6",
  base06 = "#cbcbcc",
  base07 = "#d4d4d5",
  base08 = "#37d99e",
  base09 = "#f0a988",
  base0A = "#e5d487",
  base0B = "#e87979",
  base0C = "#37d99e",
  base0D = "#5fb0fc",
  base0E = "#c397d8",
  base0F = "#e87979",
}

colorscheme.polish = {
  TSPunctBracket = { fg = colorscheme.theme.base07 },
  TSParenthesis = { link = "TSPunctBracket" },
}

require("aiko.theme").paint(colorscheme)
