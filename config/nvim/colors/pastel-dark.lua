local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme:new({
  name = "pastel-dark",
  background = "dark",
})

colorscheme.colors = {
  white = "#b5bcc9",
  dark_black = "#10171e",
  black = "#131a21",
  bg_1 = "#1a2128",
  bg_2 = "#1e252c",
  bg_3 = "#2a3138",
  bg_4 = "#363d44",
  grey = "#363d44",
  light_grey_1 = "#4e555c",
  light_grey_2 = "#51585f",
  light_grey_3 = "#545b62",
  red = "#ef8891",
  light_pink = "#fca2aa",
  pink = "#fca2af",
  line = "#272e35",
  green = "#9fe8c3",
  light_green = "#9ce5c0",
  blue = "#99aee5",
  nord_blue = "#9aa8cf",
  yellow = "#fbdf90",
  sun = "#fbdf9a",
  purple = "#c2a2e3",
  dark_purple = "#b696d7",
  teal = "#92dbb6",
  orange = "#EDA685",
  cyan = "#b5c3ea",
  bg_statusline = "#181f26",
  bg_light = "#222930",
  bg_pmenu = "#ef8891",
  bg_folder = "#99aee5",
}

colorscheme.theme = {
  base0A = "#f5d595",
  base04 = "#4f565d",
  base07 = "#b5bcc9",
  base05 = "#ced4df",
  base0E = "#c2a2e3",
  base0D = "#a3b8ef",
  base0C = "#abb9e0",
  base0B = "#9ce5c0",
  base02 = "#31383f",
  base0F = "#e88e9b",
  base03 = "#40474e",
  base08 = "#ef8891",
  base01 = "#2c333a",
  base00 = "#131a21",
  base09 = "#EDA685",
  base06 = "#d3d9e4",
}

require("aiko.theme").paint(colorscheme)
