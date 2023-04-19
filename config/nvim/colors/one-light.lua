local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "one-light",
  background = "light",
})

colorscheme.colors = {
  white = "#54555b",
  dark_black = "#efeff0",
  black = "#fafafa",
  bg_1 = "#EAEAEB",
  bg_2 = "#dadadb",
  bg_3 = "#d4d4d5",
  bg_4 = "#cccccd",
  grey = "#b7b7b8",
  light_grey_1 = "#b0b0b1",
  light_grey_2 = "#a9a9aa",
  light_grey_3 = "#a2a2a3",
  red = "#d84a3d",
  light_pink = "#F07178",
  pink = "#ff75a0",
  line = "#e2e2e2",
  green = "#50a14f",
  light_green = "#7eca9c",
  nord_blue = "#428bab",
  blue = "#4078f2",
  yellow = "#c18401",
  sun = "#dea95f",
  purple = "#a28dcd",
  dark_purple = "#8e79b9",
  teal = "#519ABA",
  orange = "#FF6A00",
  cyan = "#0b8ec6",
  bg_statusline = "#ececec",
  bg_light = "#d3d3d3",
  bg_pmenu = "#5e5f65",
  bg_folder = "#6C6C6C",
}

colorscheme.theme = {
  base00 = "#fafafa",
  base01 = "#f4f4f4",
  base02 = "#e5e5e6",
  base03 = "#dfdfe0",
  base04 = "#d7d7d8",
  base05 = "#383a42",
  base06 = "#202227",
  base07 = "#090a0b",
  base08 = "#d84a3d",
  base09 = "#a626a4",
  base0A = "#c18401",
  base0B = "#50a14f",
  base0C = "#0070a8",
  base0D = "#4078f2",
  base0E = "#a626a4",
  base0F = "#986801",
}

colorscheme.polish = {
  TelescopePromptPrefix = { fg = colorscheme.colors.white },
  TelescopeSelection = {
    bg = colorscheme.colors.bg_2,
    fg = colorscheme.colors.white,
  },
  TSPunctBracket = { fg = colorscheme.colors.nord_blue },
  FloatBorder = { fg = colorscheme.theme.base05 },
  DiffAdd = { fg = colorscheme.theme.base05 },
  TbLineThemeToggleBtn = { bg = colorscheme.colors.bg_4 },
  WhichKeyDesc = { fg = colorscheme.colors.white },
  Pmenu = { bg = colorscheme.colors.bg_1 },
}

require("aiko.theme").paint(colorscheme)
