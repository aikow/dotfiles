local colorscheme = require("aiko.theme.colorscheme").Scheme:new({
  name = "falcon",
  background = "dark",
})

colorscheme.theme = {
  base00 = "#020222",
  base01 = "#0b0b2b",
  base02 = "#161636",
  base03 = "#202040",
  base04 = "#e4e4eb",
  base05 = "#eeeef5",
  base06 = "#f3f3fa",
  base07 = "#F8F8FF",
  base08 = "#BFDAFF",
  base09 = "#B4B4B9",
  base0A = "#FFC552",
  base0B = "#C8D0E3",
  base0C = "#B4B4B9",
  base0D = "#FFC552",
  base0E = "#8BCCBF",
  base0F = "#DFDFE5",
}

colorscheme.colors = {
  bg_1 = "#0b0b2b",
  bg_2 = "#161636",
  bg_3 = "#202040",
  bg_4 = "#2a2a4a",
  bg_folder = "#598cbf",
  bg_light = "#2a2a4a",
  bg_pmenu = "#FFB07B",
  bg_statusline = "#0b0b2b",
  black = "#020222", --  nvim bg
  blue = "#6699cc",
  cyan = "#BFDAFF",
  dark_black = "#000015",
  dark_purple = "#635196",
  green = "#9BCCBF",
  grey = "#393959",
  light_green = "#b9e75b",
  light_grey_1 = "#434363",
  light_grey_2 = "#4d4d6d",
  light_grey_3 = "#5c5c7c",
  light_pink = "#FF8E78",
  line = "#202040", -- for lines like vertsplit
  nord_blue = "#a1bce1",
  orange = "#f99157",
  pink = "#ffafb7",
  purple = "#99A4BC",
  red = "#FF761A",
  sun = "#FFD392",
  teal = "#34BFA4",
  white = "#F8F8FF",
  yellow = "#FFC552",
}

local custom = {
  white2 = "#DFDFE5",
  tan = "#CFC1B2",
}

colorscheme.polish = {
  Statement = { fg = colorscheme.colors.purple },
  Type = { fg = custom.white2 },
  Include = { fg = custom.tan },
  Keyword = { fg = colorscheme.theme.base0D },
  Operator = { fg = colorscheme.colors.red },
  ["@keyword"] = { fg = colorscheme.theme.base0D },
}

require("aiko.theme").paint(colorscheme)
