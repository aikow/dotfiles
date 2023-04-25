local colorscheme = require("aiko.theme.colorscheme").Scheme:new({
  name = "wombat",
  background = "dark",
})

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

colorscheme.colors = {
  bg_1 = "#292929",
  bg_2 = "#333333",
  bg_3 = "#3a3a3a",
  bg_4 = "#414141",
  bg_folder = "#7BB0C9",
  bg_light = "#3c3c3c",
  bg_pmenu = "#95e454",
  bg_statusline = "#262626",
  black = "#222222",
  blue = "#88B8F6",
  cyan = "#90fdf8",
  dark_black = "#1b1b1b",
  dark_purple = "#c878f0",
  green = "#AEE474",
  grey = "#4b4b4b",
  light_green = "#95e454",
  light_grey_1 = "#535353",
  light_grey_2 = "#5a5a5a",
  light_grey_3 = "#646464",
  light_pink = "#f58eff",
  line = "#353535",
  nord_blue = "#8dbdfb",
  orange = "#FFCC66",
  pink = "#e780f8",
  purple = "#dc8cff",
  red = "#FF8F7E",
  sun = "#feedba",
  teal = "#7EB6BC",
  white = "#e4e0d7",
  yellow = "#efdeab",
}

colorscheme.polish = {
  TSInclude = { fg = colorscheme.colors.red },
  TSConstructor = { fg = colorscheme.colors.orange },
  TSVariable = { link = "TSConstructor" },
  TSConditional = { link = "TSInclude" },
}

require("aiko.theme").paint(colorscheme)
