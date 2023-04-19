local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "nord",
  background = "dark",
})

colorscheme.colors = {
  white = "#abb2bf",
  dark_black = "#2a303c",
  black = "#2E3440",
  bg_1 = "#343a46",
  bg_2 = "#373d49",
  bg_3 = "#464c58",
  bg_4 = "#494f5b",
  grey = "#4b515d",
  light_grey_1 = "#565c68",
  light_grey_2 = "#606672",
  light_grey_3 = "#646a76",
  red = "#BF616A",
  light_pink = "#de878f",
  pink = "#d57780",
  line = "#414753",
  green = "#A3BE8C",
  light_green = "#afca98",
  blue = "#7797b7",
  nord_blue = "#81A1C1",
  yellow = "#EBCB8B",
  sun = "#e1c181",
  purple = "#B48EAD",
  dark_purple = "#a983a2",
  teal = "#6484a4",
  orange = "#e39a83",
  cyan = "#9aafe6",
  bg_statusline = "#333945",
  bg_light = "#3f4551",
  bg_pmenu = "#A3BE8C",
  bg_folder = "#7797b7",
}

colorscheme.theme = {
  base00 = "#2E3440",
  base01 = "#3B4252",
  base02 = "#434C5E",
  base03 = "#4C566A",
  base04 = "#D8DEE9",
  base05 = "#E5E9F0",
  base06 = "#ECEFF4",
  base07 = "#8FBCBB",
  base08 = "#88C0D0",
  base09 = "#81A1C1",
  base0A = "#88C0D0",
  base0B = "#A3BE8C",
  base0C = "#81A1C1",
  base0D = "#81A1C1",
  base0E = "#81A1C1",
  base0F = "#B48EAD",
}

colorscheme.polish = {
  TSPunctBracket = { fg = colorscheme.colors.white },
  TSPunctDelimiter = { fg = colorscheme.colors.white },
}

require("aiko.theme").paint(colorscheme)
