local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "catppuccin",
  background = "dark",
})

colorscheme.theme = {
  base00 = "#1E1D2D",
  base01 = "#282737",
  base02 = "#2f2e3e",
  base03 = "#383747",
  base04 = "#414050",
  base05 = "#bfc6d4",
  base06 = "#ccd3e1",
  base07 = "#D9E0EE",
  base08 = "#F38BA8",
  base09 = "#F8BD96",
  base0A = "#FAE3B0",
  base0B = "#ABE9B3",
  base0C = "#89DCEB",
  base0D = "#89B4FA",
  base0E = "#CBA6F7",
  base0F = "#F38BA8",
}

colorscheme.colors = {
  white = "#D9E0EE",
  dark_black = "#191828",
  black = "#1E1D2D",
  bg_1 = "#252434",
  bg_2 = "#2d2c3c",
  bg_3 = "#363545",
  bg_4 = "#3e3d4d",
  grey = "#474656",
  light_grey_1 = "#4e4d5d",
  light_grey_2 = "#555464",
  light_grey_3 = "#605f6f",
  red = "#F38BA8",
  light_pink = "#ffa5c3",
  pink = "#F5C2E7",
  line = "#383747",
  green = "#ABE9B3",
  light_green = "#b6f4be",
  nord_blue = "#8bc2f0",
  blue = "#89B4FA",
  yellow = "#FAE3B0",
  sun = "#ffe9b6",
  purple = "#d0a9e5",
  dark_purple = "#c7a0dc",
  teal = "#B5E8E0",
  orange = "#F8BD96",
  cyan = "#89DCEB",
  bg_statusline = "#232232",
  bg_light = "#2f2e3e",
  bg_pmenu = "#ABE9B3",
  bg_folder = "#89B4FA",
}

local custom = {
  lavender = "#c7d1ff",
}

colorscheme.polish = {
  TSVariable = { fg = custom.lavender },
  TSProperty = { fg = colorscheme.colors.teal },
  TSVariableBuiltin = { fg = colorscheme.colors.red },
}

require("aiko.theme").paint(colorscheme)
