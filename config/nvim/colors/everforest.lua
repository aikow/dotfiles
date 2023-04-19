local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "everforest",
  background = "dark",
})

colorscheme.colors = {
  white = "#D3C6AA",
  dark_black = "#272f35",
  black = "#2b3339",
  bg_1 = "#323a40",
  bg_2 = "#363e44",
  bg_3 = "#363e44",
  bg_4 = "#3a4248",
  grey = "#4e565c",
  light_grey_1 = "#545c62",
  light_grey_2 = "#626a70",
  light_grey_3 = "#656d73",
  red = "#e67e80",
  light_pink = "#ce8196",
  pink = "#ff75a0",
  line = "#3a4248",
  green = "#83c092",
  light_green = "#a7c080",
  nord_blue = "#78b4ac",
  blue = "#7393b3",
  yellow = "#dbbc7f",
  sun = "#d1b171",
  purple = "#ecafcc",
  dark_purple = "#d699b6",
  teal = "#69a59d",
  orange = "#e69875",
  cyan = "#95d1c9",
  bg_statusline = "#2e363c",
  bg_light = "#3d454b",
  bg_pmenu = "#83c092",
  bg_folder = "#7393b3",
}

colorscheme.theme = {
  base00 = "#2b3339",
  base01 = "#323c41",
  base02 = "#3a4248",
  base03 = "#424a50",
  base04 = "#4a5258",
  base05 = "#d3c6aa",
  base06 = "#ddd0b4",
  base07 = "#e7dabe",
  base08 = "#7fbbb3",
  base09 = "#d699b6",
  base0A = "#83c092",
  base0B = "#dbbc7f",
  base0C = "#e69875",
  base0D = "#a7c080",
  base0E = "#e67e80",
  base0F = "#e67e80",
}

local custom = {
  turquoise = "#7fbbb3",
}

colorscheme.polish = {
  TSPunctBracket = { fg = colorscheme.colors.red },
  TSTag = { fg = colorscheme.colors.orange },
  TSTagDelimiter = { fg = colorscheme.colors.green },
  TSConstructor = { fg = custom.turquoise },
}

require("aiko.theme").paint(colorscheme)
