local colorscheme = require("aiko.theme.colorscheme").Scheme:new({
  name = "vscode-dark",
  background = "dark",
})

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

colorscheme.colors = {
  bg_1 = "#252525",
  bg_2 = "#282828",
  bg_3 = "#313131",
  bg_4 = "#3a3a3a",
  bg_folder = "#7A8A92",
  bg_light = "#303030",
  bg_pmenu = "#60a6e0",
  bg_statusline = "#242424",
  black = "#1E1E1E",
  blue = "#569CD6",
  cyan = "#9CDCFE",
  dark_black = "#1a1a1a",
  dark_purple = "#b77bdf",
  green = "#B5CEA8",
  grey = "#444444",
  light_green = "#bfd8b2",
  light_grey_1 = "#4e4e4e",
  light_grey_2 = "#585858",
  light_grey_3 = "#626262",
  light_pink = "#ea696f",
  line = "#2e2e2e",
  nord_blue = "#60a6e0",
  orange = "#d3967d",
  pink = "#bb7cb6",
  purple = "#c68aee",
  red = "#D16969",
  sun = "#e1c487",
  teal = "#4294D6",
  white = "#dee1e6",
  yellow = "#D7BA7D",
}

local custom = {
  green = "#4EC994",
}

colorscheme.polish = {
  TSParameter = { fg = colorscheme.colors.blue },
  TSKeyword = { fg = colorscheme.colors.blue },
  TSVariable = { fg = colorscheme.colors.cyan },
  luaTSField = { fg = colorscheme.colors.teal },
  TSFieldKey = { fg = custom.green },
  TSKeywordFunction = { fg = colorscheme.colors.teal },
}

require("aiko.theme").paint(colorscheme)
