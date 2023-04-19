local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "vscode-dark",
  background = "dark",
})

colorscheme.colors = {
  white = "#dee1e6",
  dark_black = "#1a1a1a",
  black = "#1E1E1E",
  bg_1 = "#252525",
  bg_2 = "#282828",
  bg_3 = "#313131",
  bg_4 = "#3a3a3a",
  grey = "#444444",
  light_grey_1 = "#4e4e4e",
  light_grey_2 = "#585858",
  light_grey_3 = "#626262",
  red = "#D16969",
  light_pink = "#ea696f",
  pink = "#bb7cb6",
  line = "#2e2e2e",
  green = "#B5CEA8",
  green1 = "#4EC994",
  light_green = "#bfd8b2",
  blue = "#569CD6",
  nord_blue = "#60a6e0",
  yellow = "#D7BA7D",
  sun = "#e1c487",
  purple = "#c68aee",
  dark_purple = "#b77bdf",
  teal = "#4294D6",
  orange = "#d3967d",
  cyan = "#9CDCFE",
  bg_statusline = "#242424",
  bg_light = "#303030",
  bg_pmenu = "#60a6e0",
  bg_folder = "#7A8A92",
}

colorscheme.theme = {

  base00 = "#1E1E1E",
  base01 = "#262626",
  base02 = "#303030",
  base03 = "#3C3C3C",
  base04 = "#464646",
  base05 = "#D4D4D4",
  base06 = "#E9E9E9",
  base07 = "#FFFFFF",
  base08 = "#D16969",
  base09 = "#B5CEA8",
  base0A = "#D7BA7D",
  base0B = "#BD8D78",
  base0C = "#9CDCFE",
  base0D = "#DCDCAA",
  base0E = "#C586C0",
  base0F = "#E9E9E9",
}

colorscheme.polish = {
  TSParameter = { fg = colorscheme.colors.blue },
  TSKeyword = { fg = colorscheme.colors.blue },
  TSVariable = { fg = colorscheme.colors.cyan },
  luaTSField = { fg = colorscheme.colors.teal },
  TSFieldKey = { fg = colorscheme.colors.green1 },
  TSKeywordFunction = { fg = colorscheme.colors.teal },
}

require("aiko.theme").paint(colorscheme)
