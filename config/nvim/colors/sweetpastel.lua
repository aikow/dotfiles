local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "sweetpastel",
  background = "dark",
})

colorscheme.colors = {
  white = "#FFDEDE",
  dark_black = "#161a1e",
  black = "#1B1F23",
  bg_1 = "#22262a",
  bg_2 = "#25292d",
  bg_3 = "#2f3337",
  bg_4 = "#393d41",
  grey = "#43474b",
  light_grey_1 = "#4b4f53",
  light_grey_2 = "#54585c",
  light_grey_3 = "#5d6165",
  red = "#e5a3a1",
  light_pink = "#FFC0EB",
  pink = "#F8B3CC",
  line = "#343A40",
  green = "#B4E3AD",
  light_green = "#9EDABE",
  nord_blue = "#B0CEEF",
  blue = "#A3CBE7",
  yellow = "#ECE3B1",
  sun = "#E7DA84",
  purple = "#CEACE8",
  dark_purple = "#B1A8FB",
  teal = "#94D2CF",
  orange = "#F1C192",
  cyan = "#C9D4FF",
  bg_statusline = "#22262a",
  bg_light = "#2f3337",
  bg_pmenu = "#F8B3CC",
  bg_folder = "#A3CBE7",
}

colorscheme.theme = {
  base00 = "#1B1F23",
  base01 = "#25292d",
  base02 = "#2f3337",
  base03 = "#393d41",
  base04 = "#43474b",
  base05 = "#FDE5E6",
  base06 = "#DEE2E6",
  base07 = "#F8F9FA",
  base08 = "#e5a3a1",
  base09 = "#F1C192",
  base0A = "#ECE3B1",
  base0B = "#B4E3AD",
  base0C = "#F8B3CC",
  base0D = "#A3CBE7",
  base0E = "#CEACE8",
  base0F = "#e5a3a1",
}

require("aiko.theme").paint(colorscheme)
