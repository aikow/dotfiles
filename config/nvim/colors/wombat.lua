local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "wombat",
  background = "dark",
})

colorscheme.colors = {
  white = "#e4e0d7",
  dark_black = "#1b1b1b",
  black = "#222222",
  bg_1 = "#292929",
  bg_2 = "#333333",
  bg_3 = "#3a3a3a",
  bg_4 = "#414141",
  grey = "#4b4b4b",
  light_grey_1 = "#535353",
  light_grey_2 = "#5a5a5a",
  light_grey_3 = "#646464",
  red = "#FF8F7E",
  light_pink = "#f58eff",
  pink = "#e780f8",
  line = "#353535",
  green = "#AEE474",
  light_green = "#95e454",
  nord_blue = "#8dbdfb",
  blue = "#88B8F6",
  yellow = "#efdeab",
  sun = "#feedba",
  purple = "#dc8cff",
  dark_purple = "#c878f0",
  teal = "#7EB6BC",
  orange = "#FFCC66",
  cyan = "#90fdf8",
  bg_statusline = "#262626",
  bg_light = "#3c3c3c",
  bg_pmenu = "#95e454",
  bg_folder = "#7BB0C9",
}

colorscheme.theme = {
  base00 = "#202020",
  base01 = "#303030",
  base02 = "#373737",
  base03 = "#3e3e3e",
  base04 = "#484848",
  base05 = "#d6d2c9",
  base06 = "#ddd9d0",
  base07 = "#e4e0d7",
  base08 = "#FF8F7E",
  base09 = "#FFCC66",
  base0A = "#efdeab",
  base0B = "#AEE474",
  base0C = "#7EB6BC",
  base0D = "#88B8F6",
  base0E = "#dc8cff",
  base0F = "#dc8c64",
}

colorscheme.polish = {
  TSInclude = { fg = colorscheme.colors.red },
  TSConstructor = { fg = colorscheme.colors.orange },
  TSVariable = { link = "TSConstructor" },
  TSConditional = { link = "TSInclude" },
}

require("aiko.theme").paint(colorscheme)
