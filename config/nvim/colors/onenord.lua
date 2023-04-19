local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "onenord",
  background = "dark",
})

colorscheme.colors = {
  white = "#D8DEE9",
  dark_black = "#252b37",
  black = "#2a303c",
  bg_1 = "#2f3541",
  bg_2 = "#343a46",
  bg_3 = "#3e4450",
  bg_4 = "#484e5a",
  grey = "#4d535f",
  light_grey_1 = "#545a66",
  light_grey_2 = "#595f6b",
  light_grey_3 = "#606672",
  red = "#d57780",
  light_pink = "#de878f",
  pink = "#da838b",
  line = "#414753",
  green = "#A3BE8C",
  light_green = "#afca98",
  blue = "#7797b7",
  nord_blue = "#81A1C1",
  yellow = "#EBCB8B",
  sun = "#e1c181",
  purple = "#aab1be",
  dark_purple = "#B48EAD",
  teal = "#6484a4",
  orange = "#e39a83",
  cyan = "#9aafe6",
  bg_statusline = "#333945",
  bg_light = "#3f4551",
  bg_pmenu = "#A3BE8C",
  bg_folder = "#7797b7",
}

colorscheme.theme = {
  base00 = "#2a303c",
  base01 = "#3B4252",
  base02 = "#434C5E",
  base03 = "#4C566A",
  base04 = "#566074",
  base05 = "#bfc5d0",
  base06 = "#c7cdd8",
  base07 = "#ced4df",
  base08 = "#d57780",
  base09 = "#e39a83",
  base0A = "#EBCB8B",
  base0B = "#A3BE8C",
  base0C = "#97b7d7",
  base0D = "#81A1C1",
  base0E = "#B48EAD",
  base0F = "#d57780",
}

require("aiko.theme").paint(colorscheme)
