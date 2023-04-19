local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "onedark",
  background = "dark",
})

colorscheme.colors = {
  white = "#abb2bf",
  dark_black = "#1b1f27",
  black = "#1e222a",
  bg_1 = "#252931",
  bg_2 = "#282c34",
  bg_3 = "#353b45",
  bg_4 = "#373b43",
  grey = "#42464e",
  light_grey_1 = "#565c64",
  light_grey_2 = "#6f737b",
  light_grey_3 = "#6f737b",
  red = "#e06c75",
  light_pink = "#DE8C92",
  pink = "#ff75a0",
  line = "#31353d",
  green = "#98c379",
  light_green = "#7eca9c",
  nord_blue = "#81A1C1",
  blue = "#61afef",
  yellow = "#e7c787",
  sun = "#EBCB8B",
  purple = "#de98fd",
  dark_purple = "#c882e7",
  teal = "#519ABA",
  orange = "#fca2aa",
  cyan = "#a3b8ef",
  bg_statusline = "#22262e",
  bg_light = "#2d3139",
  bg_pmenu = "#61afef",
  bg_folder = "#61afef",
}

colorscheme.theme = {
  base00 = "#1e222a",
  base01 = "#353b45",
  base02 = "#3e4451",
  base03 = "#545862",
  base04 = "#565c64",
  base05 = "#abb2bf",
  base06 = "#b6bdca",
  base07 = "#c8ccd4",
  base08 = "#e06c75",
  base09 = "#d19a66",
  base0A = "#e5c07b",
  base0B = "#98c379",
  base0C = "#56b6c2",
  base0D = "#61afef",
  base0E = "#c678dd",
  base0F = "#be5046",
}

require("aiko.theme").paint(colorscheme)
