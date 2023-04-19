local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "yoru",
  background = "dark",
})

colorscheme.colors = {
  white = "#edeff0",
  dark_black = "#060809",
  black = "#0c0e0f",
  lighter_black = "#121415",
  bg_2 = "#161819",
  bg_3 = "#1f2122",
  bg_4 = "#27292a",
  grey = "#343637",
  light_grey_1 = "#3e4041",
  light_grey_2 = "#484a4b",
  light_grey_3 = "#505253",
  red = "#DF5B61",
  light_pink = "#EE6A70",
  pink = "#e8646a",
  line = "#1b1d1e",
  green = "#78B892",
  light_green = "#81c19b",
  nord_blue = "#5A84BC",
  blue = "#6791C9",
  yellow = "#ecd28b",
  sun = "#f6dc95",
  purple = "#c58cec",
  dark_purple = "#BC83E3",
  teal = "#70b8ca",
  orange = "#E89982",
  cyan = "#67AFC1",
  bg_statusline = "#101213",
  bg_light = "#1d1f20",
  bg_pmenu = "#78B892",
  bg_folder = "#6791C9",
}

colorscheme.theme = {
  base00 = "#0c0e0f",
  base01 = "#121415",
  base02 = "#161819",
  base03 = "#1f2122",
  base04 = "#27292a",
  base05 = "#edeff0",
  base06 = "#e4e6e7",
  base07 = "#f2f4f5",
  base08 = "#f26e74",
  base09 = "#ecd28b",
  base0A = "#e79881",
  base0B = "#82c29c",
  base0C = "#6791C9",
  base0D = "#709ad2",
  base0E = "#c58cec",
  base0F = "#e8646a",
}

require("aiko.theme").paint(colorscheme)
