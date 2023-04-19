local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({ name = "nightfox", background = "dark" })

colorscheme.colors = {
  white = "#cdcecf",
  dark_black = "#121c29",
  black = "#192330",
  bg_1 = "#202a37",
  bg_2 = "#252f3c",
  bg_3 = "#313b48",
  bg_4 = "#3d4754",
  grey = "#495360",
  light_grey_1 = "#535d6a",
  light_grey_2 = "#5c6673",
  light_grey_3 = "#646e7b",
  red = "#c94f6d",
  light_pink = "#e26886",
  pink = "#d85e7c",
  line = "#2a3441",
  green = "#8ebaa4",
  light_green = "#6ad4d6",
  blue = "#719cd6",
  nord_blue = "#86abdc",
  yellow = "#dbc074",
  sun = "#e0c989",
  purple = "#baa1e2",
  dark_purple = "#9d79d6",
  teal = "#5cc6c8",
  orange = "#fe9373",
  cyan = "#8be5e7",
  bg_statusline = "#202a37",
  bg_light = "#313b48",
  bg_pmenu = "#719cd6",
  bg_folder = "#719cd6",
}

colorscheme.theme = {
  base00 = "#192330",
  base01 = "#252f3c",
  base02 = "#313b48",
  base03 = "#3d4754",
  base04 = "#495360",
  base05 = "#c0c8d5",
  base06 = "#c7cfdc",
  base07 = "#ced6e3",
  base08 = "#e26886",
  base09 = "#fe9373",
  base0A = "#dbc074",
  base0B = "#8ebaa4",
  base0C = "#7ad4d6",
  base0D = "#86abdc",
  base0E = "#9d79d6",
  base0F = "#d85e7c",
}

require("aiko.theme").paint(colorscheme)
