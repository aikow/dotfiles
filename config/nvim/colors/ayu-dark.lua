local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "ayu-dark",
  background = "dark",
})

colorscheme.theme = {
  base00 = "#0B0E14",
  base01 = "#1c1f25",
  base02 = "#24272d",
  base03 = "#2b2e34",
  base04 = "#33363c",
  base05 = "#c9c7be",
  base06 = "#E6E1CF",
  base07 = "#D9D7CE",
  base08 = "#c9c7be",
  base09 = "#FFEE99",
  base0A = "#56c3f9",
  base0B = "#AAD84C",
  base0C = "#FFB454",
  base0D = "#F07174",
  base0E = "#FFB454",
  base0F = "#CBA6F7",
}

colorscheme.colors = {
  white = "#ced4df",
  dark_black = "#05080e",
  black = "#0B0E14",
  bg_1 = "#14171d",
  bg_2 = "#1c1f25",
  bg_3 = "#24272d",
  bg_4 = "#2b2e34",
  grey = "#33363c",
  light_grey_1 = "#3d4046",
  light_grey_2 = "#46494f",
  light_grey_3 = "#54575d",
  red = "#F07178",
  light_pink = "#ff949b",
  pink = "#ff8087",
  line = "#24272d",
  green = "#AAD84C",
  light_green = "#b9e75b",
  blue = "#36A3D9",
  nord_blue = "#43b0e6",
  yellow = "#E7C547",
  sun = "#f0df8a",
  purple = "#c79bf4",
  dark_purple = "#A37ACC",
  teal = "#74c5aa",
  orange = "#ffa455",
  cyan = "#95E6CB",
  bg_statusline = "#12151b",
  bg_light = "#24272d",
  bg_pmenu = "#ff9445",
  bg_folder = "#98a3af",
}

require("aiko.theme").paint(colorscheme)
