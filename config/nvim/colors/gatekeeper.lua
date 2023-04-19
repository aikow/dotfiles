local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "gatekeeper",
  background = "dark",
})

colorscheme.colors = {
  white = "#cccdd1",
  dark_black = "#0a0a0a",
  black = "#101010",
  bg_1 = "#181818",
  bg_2 = "#1e1e1e",
  bg_3 = "#252525",
  bg_4 = "#2c2c2c",
  grey = "#363636",
  light_grey_1 = "#3d3d3d",
  light_grey_2 = "#454545",
  light_grey_3 = "#4d4d4d",
  red = "#ff1a67",
  light_pink = "#ff86b7",
  pink = "#ff77a8",
  line = "#2c2c2c",
  green = "#00e756",
  light_green = "#10f766",
  blue = "#29adff",
  nord_blue = "#5c6ab2",
  yellow = "#fff024",
  sun = "#fff82c",
  purple = "#a79ac0",
  dark_purple = "#998cb2",
  teal = "#0b925c",
  orange = "#ffa300",
  cyan = "#29adff",
  bg_statusline = "#181818",
  bg_light = "#272727",
  bg_pmenu = "#5c6ab2",
  bg_folder = "#29adff",
}

colorscheme.theme = {
  base00 = "#101010",
  base01 = "#171717",
  base02 = "#1e1e1e",
  base03 = "#252525",
  base04 = "#2c2c2c",
  base05 = "#d8d9dd",
  base06 = "#d2d3d7",
  base07 = "#cccdd1",
  base08 = "#ffb20f",
  base09 = "#ff004d",
  base0A = "#be620a",
  base0B = "#00e756",
  base0C = "#29adff",
  base0D = "#c54bcf",
  base0E = "#ff4394",
  base0F = "#ffccaa",
}

colorscheme.polish = {
  TSVariable = { fg = colorscheme.colors.orange },
  TSParameter = { fg = colorscheme.colors.white },
}

require("aiko.theme").paint(colorscheme)
