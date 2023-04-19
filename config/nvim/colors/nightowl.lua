local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({ name = "nightowl", background = "dark" })

colorscheme.colors = {
  white = "#d6deeb",
  dark_black = "#010f20",
  black = "#011627",
  bg_1 = "#091e2f",
  bg_2 = "#112637",
  bg_3 = "#1b3041",
  bg_4 = "#253a4b",
  grey = "#2c4152",
  light_grey_1 = "#34495a",
  light_grey_2 = "#3c5162",
  light_grey_3 = "#495e6f",
  red = "#f78c6c",
  light_pink = "#ff6cca",
  pink = "#fa58b6",
  line = "#182d3e",
  green = "#29E68E",
  light_green = "#22da6e",
  blue = "#82aaff",
  nord_blue = "#78a0f5",
  yellow = "#ffcb8b",
  sun = "#ffe9a9",
  purple = "#c792ea",
  dark_purple = "#a974cc",
  teal = "#96CEB4",
  orange = "#FFAD60",
  cyan = "#aad2ff",
  bg_statusline = "#051a2b",
  bg_light = "#1a2f40",
  bg_pmenu = "#82aaff",
  bg_folder = "#82aaff",
}

colorscheme.theme = {
  base00 = "#011627",
  base01 = "#0c2132",
  base02 = "#172c3d",
  base03 = "#223748",
  base04 = "#2c4152",
  base05 = "#ced6e3",
  base06 = "#d6deeb",
  base07 = "#feffff",
  base08 = "#ecc48d",
  base09 = "#f78c6c",
  base0A = "#c792ea",
  base0B = "#29E68E",
  base0C = "#aad2ff",
  base0D = "#82aaff",
  base0E = "#c792ea",
  base0F = "#f78c6c",
}

colorscheme.polish = {
  TSParameter = { fg = colorscheme.colors.orange },
  TSConditional = { fg = colorscheme.colors.cyan },
  PmenuSel = { bg = colorscheme.colors.blue },
}

require("aiko.theme").paint(colorscheme)
