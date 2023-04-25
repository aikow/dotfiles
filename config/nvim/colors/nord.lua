local colorscheme = require("aiko.theme.colorscheme").Colorscheme.new({
  name = "nord",
  background = "dark",
})

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

colorscheme.colors = {
  bg_1 = "#343a46",
  bg_2 = "#373d49",
  bg_3 = "#464c58",
  bg_4 = "#494f5b",
  bg_folder = "#7797b7",
  bg_light = "#3f4551",
  bg_pmenu = "#A3BE8C",
  bg_statusline = "#333945",
  black = "#2E3440",
  blue = "#7797b7",
  cyan = "#9aafe6",
  dark_black = "#2a303c",
  dark_purple = "#a983a2",
  green = "#A3BE8C",
  grey = "#4b515d",
  light_green = "#afca98",
  light_grey_1 = "#565c68",
  light_grey_2 = "#606672",
  light_grey_3 = "#646a76",
  light_pink = "#de878f",
  line = "#414753",
  nord_blue = "#81A1C1",
  orange = "#e39a83",
  pink = "#d57780",
  purple = "#B48EAD",
  red = "#BF616A",
  sun = "#e1c181",
  teal = "#6484a4",
  white = "#abb2bf",
  yellow = "#EBCB8B",
}

colorscheme.polish = {
  TSPunctBracket = { fg = colorscheme.colors.white },
  TSPunctDelimiter = { fg = colorscheme.colors.white },
}

require("aiko.theme").paint(colorscheme)
