local colorscheme = require("aiko.theme.colorscheme").Colorscheme.new({
  name = "kanagawa",
  background = "dark",
})

colorscheme.theme = {
  base00 = "#1f1f28",
  base01 = "#2a2a37",
  base02 = "#223249",
  base03 = "#363646",
  base04 = "#4c4c55",
  base05 = "#c8c3a6",
  base06 = "#d2cdb0",
  base07 = "#DCD7BA",
  base08 = "#d8616b",
  base09 = "#ffa066",
  base0A = "#dca561",
  base0B = "#98bb6c",
  base0C = "#7fb4ca",
  base0D = "#7e9cd8",
  base0E = "#9c86bf",
  base0F = "#d8616b",
}

colorscheme.colors = {
  bg_1 = "#25252e",
  bg_2 = "#272730",
  bg_3 = "#2f2f38",
  bg_4 = "#363646",
  bg_folder = "#7E9CD8",
  bg_light = "#33333c",
  bg_pmenu = "#a48ec7",
  bg_statusline = "#24242d",
  black = "#1F1F28",
  blue = "#7FB4CA",
  cyan = "#A3D4D5",
  dark_black = "#191922",
  dark_purple = "#9c86bf",
  green = "#98BB6C",
  grey = "#43434c",
  light_green = "#a3c677",
  light_grey_1 = "#4c4c55",
  light_grey_2 = "#53535c",
  light_grey_3 = "#5c5c65",
  light_pink = "#D27E99",
  line = "#31313a",
  nord_blue = "#7E9CD8",
  orange = "#fa9b61",
  pink = "#c8748f",
  purple = "#a48ec7",
  red = "#d8616b",
  sun = "#FFA066",
  teal = "#7AA89F",
  white = "#DCD7BA",
  yellow = "#FF9E3B",
}

colorscheme.polish = {
  TSInclude = { fg = colorscheme.colors.purple },
  TSURI = { fg = colorscheme.colors.blue },
  TSTagDelimiter = { fg = colorscheme.colors.red },
}

require("aiko.theme").paint(colorscheme)
