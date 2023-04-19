local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({ name = "rxyhn", background = "dark" })

colorscheme.colors = {
  white = "#D9D7D6",
  dark_black = "#000a0e",
  black = "#061115",
  bg_1 = "#0d181c",
  bg_2 = "#131e22",
  bg_3 = "#1c272b",
  bg_4 = "#242f33",
  grey = "#313c40",
  light_grey_1 = "#3b464a",
  light_grey_2 = "#455054",
  light_grey_3 = "#4f5a5e",
  red = "#DF5B61",
  light_pink = "#EE6A70",
  pink = "#F16269",
  line = "#222d31",
  green = "#78B892",
  light_green = "#8CD7AA",
  nord_blue = "#5A84BC",
  blue = "#6791C9",
  yellow = "#ecd28b",
  sun = "#f6dc95",
  purple = "#C488EC",
  dark_purple = "#BC83E3",
  teal = "#7ACFE4",
  orange = "#E89982",
  cyan = "#67AFC1",
  bg_statusline = "#0A1519",
  bg_light = "#1a2529",
  bg_pmenu = "#78B892",
  bg_folder = "#6791C9",
}

colorscheme.theme = {
  base00 = "#061115",
  base01 = "#0C171B",
  base02 = "#101B1F",
  base03 = "#192428",
  base04 = "#212C30",
  base05 = "#D9D7D6",
  base06 = "#E3E1E0",
  base07 = "#EDEBEA",
  base08 = "#f26e74",
  base09 = "#ecd28b",
  base0A = "#E9967E",
  base0B = "#82c29c",
  base0C = "#6791C9",
  base0D = "#79AAEB",
  base0E = "#C488EC",
  base0F = "#F16269",
}

require("aiko.theme").paint(colorscheme)
