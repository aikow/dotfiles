local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "chocolate",
  background = "dark",
})

colorscheme.colors = {
  white = "#cdc0ad",
  dark_black = "#201d1c",
  black = "#252221",
  bg_1 = "#2b2827",
  bg_2 = "#2f2c2b",
  bg_3 = "#393635",
  bg_4 = "#43403f",
  grey = "#4d4a49",
  light_grey_1 = "#575453",
  light_grey_2 = "#615e5d",
  light_grey_3 = "#6b6867",
  red = "#c65f5f",
  light_pink = "#dc7575",
  pink = "#d16a6a",
  line = "#322f2e",
  green = "#8ca589",
  light_green = "#95ae92",
  nord_blue = "#728797",
  blue = "#7d92a2",
  yellow = "#d9b27c",
  sun = "#e1ba84",
  purple = "#998396",
  dark_purple = "#917b8e",
  teal = "#749689",
  orange = "#d08b65",
  cyan = "#829e9b",
  bg_statusline = "#292625",
  bg_light = "#353231",
  bg_pmenu = "#859e82",
  bg_folder = "#768b9b",
}

colorscheme.theme = {
  base00 = "#252221",
  base01 = "#2f2c2b",
  base02 = "#393635",
  base03 = "#43403f",
  base04 = "#4d4a49",
  base05 = "#c8bAA4",
  base06 = "#beae94",
  base07 = "#cdc0ad",
  base08 = "#c65f5f",
  base09 = "#d08b65",
  base0A = "#d9b27c",
  base0B = "#8ca589",
  base0C = "#998396",
  base0D = "#7d92a2",
  base0E = "#c65f5f",
  base0F = "#ab9382",
}

local custom = {
  beige = "#ab9382",
}

colorscheme.polish = {
  TSField = { fg = colorscheme.colors.purple },
  TSVariable = { fg = colorscheme.theme.base06 },
  TSModule = { fg = custom.beige },
  Operator = { fg = colorscheme.colors.blue },
  TSAttribute = { fg = colorscheme.colors.cyan },
  TSPunctBracket = { fg = colorscheme.theme.base06 },
  TSParenthesis = { link = "TSPunctBracket" },
  TSParameter = { fg = colorscheme.colors.green },
  TSFuncBuiltin = { fg = colorscheme.colors.yellow },
}

require("aiko.theme").paint(colorscheme)
