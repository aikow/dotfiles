local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme =
  Colorscheme.new({ name = "jellybeans", background = "dark" })

colorscheme.colors = {
  white = "#e8e8d3",
  dark_black = "#101010",
  black = "#151515",
  bg_1 = "#1c1c1c",
  bg_2 = "#252525",
  bg_3 = "#2e2e2e",
  bg_4 = "#3a3a3a",
  grey = "#424242",
  light_grey_1 = "#474747",
  light_grey_2 = "#4c4c4c",
  light_grey_3 = "#525252",
  red = "#cf6a4c",
  light_pink = "#da7557",
  pink = "#f0a0c0",
  line = "#2d2d2d",
  green = "#99ad6a",
  light_green = "#c2cea6",
  nord_blue = "#768cb4",
  blue = "#8197bf",
  yellow = "#fad07a",
  sun = "#ffb964",
  purple = "#ea94ea",
  dark_purple = "#e58fe5",
  teal = "#668799",
  orange = "#e78a4e",
  cyan = "#8fbfdc",
  bg_statusline = "#191919",
  bg_light = "#2c2c2c",
  bg_pmenu = "#8197bf",
  bg_folder = "#8197bf",
}

colorscheme.theme = {
  base00 = "#151515",
  base01 = "#2e2e2e",
  base02 = "#3a3a3a",
  base03 = "#424242",
  base04 = "#474747",
  base05 = "#d9d9c4",
  base06 = "#dedec9",
  base07 = "#f1f1e5",
  base08 = "#dd785a",
  base09 = "#c99f4a",
  base0A = "#e1b655",
  base0B = "#99ad6a",
  base0C = "#7187af",
  base0D = "#8fa5cd",
  base0E = "#e18be1",
  base0F = "#cf6a4c",
}

require("aiko.theme").paint(colorscheme)
