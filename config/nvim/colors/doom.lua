local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "doom",
  background = "dark",
})

colorscheme.colors = {
  white = "#bbc2cf",
  dark_black = "#22262e",
  black = "#282c34",
  bg_1 = "#2e323a",
  bg_2 = "#32363e",
  bg_3 = "#3c4048",
  bg_4 = "#41454d",
  grey = "#494d55",
  light_grey_1 = "#53575f",
  light_grey_2 = "#5d6169",
  light_grey_3 = "#676b73",
  red = "#ff6b5a",
  light_pink = "#ff7665",
  pink = "#ff75a0",
  line = "#3b3f47",
  green = "#98be65",
  light_green = "#a9cf76",
  nord_blue = "#47a5e5",
  blue = "#61afef",
  yellow = "#ECBE7B",
  sun = "#f2c481",
  purple = "#dc8ef3",
  dark_purple = "#c678dd",
  teal = "#4db5bd",
  orange = "#ea9558",
  cyan = "#46D9FF",
  bg_statusline = "#2d3139",
  bg_light = "#3a3e46",
  bg_pmenu = "#98be65",
  bg_folder = "#51afef",
}

colorscheme.theme = {
  base00 = "#282c34",
  base01 = "#32363e",
  base02 = "#3c4048",
  base03 = "#4e525a",
  base04 = "#5a5e66",
  base05 = "#a7aebb",
  base06 = "#b3bac7",
  base07 = "#bbc2cf",
  base08 = "#ff6c6b",
  base09 = "#ea9558",
  base0A = "#ECBE7B",
  base0B = "#98be65",
  base0C = "#66c4ff",
  base0D = "#48a6e6",
  base0E = "#9c94d4",
  base0F = "#c85a50",
}

colorscheme.polish = {
  TSFieldKey = { fg = colorscheme.colors.blue },
}

require("aiko.theme").paint(colorscheme)
