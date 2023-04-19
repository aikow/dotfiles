-- local Colorscheme = require("aiko.theme.colorscheme").
-- Credits to https://github.com/fenetikm/falcon as its the orignal theme
-- This is a modified version of original theme

local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "falcon",
  background = "dark",
})

colorscheme.colors = {
  white = "#F8F8FF",
  dark_black = "#000015",
  black = "#020222", --  nvim bg
  bg_1 = "#0b0b2b",
  bg_2 = "#161636",
  bg_3 = "#202040",
  bg_4 = "#2a2a4a",
  grey = "#393959",
  light_grey_1 = "#434363",
  light_grey_2 = "#4d4d6d",
  light_grey_3 = "#5c5c7c",
  red = "#FF761A",
  light_pink = "#FF8E78",
  pink = "#ffafb7",
  line = "#202040", -- for lines like vertsplit
  green = "#9BCCBF",
  light_green = "#b9e75b",
  nord_blue = "#a1bce1",
  blue = "#6699cc",
  yellow = "#FFC552",
  sun = "#FFD392",
  purple = "#99A4BC",
  dark_purple = "#635196",
  teal = "#34BFA4",
  orange = "#f99157",
  cyan = "#BFDAFF",
  bg_statusline = "#0b0b2b",
  bg_light = "#2a2a4a",
  bg_pmenu = "#FFB07B",
  bg_folder = "#598cbf",
}

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
