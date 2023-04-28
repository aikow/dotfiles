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
  base07 = "#f8f8ff",
  base08 = "#bfdaff",
  base09 = "#b4b4b9",
  base0A = "#ffc552",
  base0B = "#c8d0e3",
  base0C = "#b4b4b9",
  base0D = "#ffc552",
  base0E = "#8bccbf",
  base0F = "#dfdfe5",
}

colorscheme.colors = {
  bg_1 = "#0b0b2b",
  bg_2 = "#161636",
  bg_3 = "#202040",
  bg_4 = "#2a2a4a",
  bg_folder = "#598cbf",
  bg_light = "#2a2a4a",
  bg_pmenu = "#ffb07b",
  bg_statusline = "#0b0b2b",
  black = "#020222", --  nvim bg
  blue = "#6699cc",
  cyan = "#bfdaff",
  dark_black = "#000015",
  dark_purple = "#635196",
  green = "#9bccbf",
  grey = "#393959",
  light_green = "#b9e75b",
  light_grey_1 = "#434363",
  light_grey_2 = "#4d4d6d",
  light_grey_3 = "#5c5c7c",
  light_pink = "#ff8e78",
  line = "#202040", -- for lines like vertsplit
  nord_blue = "#a1bce1",
  orange = "#f99157",
  pink = "#ffafb7",
  purple = "#99a4bc",
  red = "#ff761a",
  sun = "#ffd392",
  teal = "#34bfa4",
  white = "#f8f8ff",
  yellow = "#ffc552",
}

local custom = {
  white2 = "#dfdfe5",
  tan = "#cfc1b2",
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
