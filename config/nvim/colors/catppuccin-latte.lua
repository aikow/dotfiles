local colorscheme = require("aiko.theme.colorscheme").Colorscheme.new({
  name = "catppuccin-latte",
  background = "light",
})

colorscheme.theme = {
  base00 = "#EFF1F5",
  base01 = "#e4e6ea",
  base02 = "#d9dbdf",
  base03 = "#ced0d4",
  base04 = "#c3c5c9",
  base05 = "#4C4F69",
  base06 = "#474a64",
  base07 = "#41445e",
  base08 = "#D20F39",
  base09 = "#7c2de3",
  base0A = "#df8e1d",
  base0B = "#40A02B",
  base0C = "#179299",
  base0D = "#1e66f5",
  base0E = "#8839EF",
  base0F = "#62657f",
}

colorscheme.colors = {
  bg_1 = "#e0e2e6",
  bg_2 = "#e4e6ea",
  bg_3 = "#d9dbdf",
  bg_4 = "#ced0d4",
  bg_folder = "#6C6C6C",
  bg_light = "#d9dbdf",
  bg_pmenu = "#7287FD",
  bg_statusline = "#e4e6ea",
  black = "#EFF1F5",
  blue = "#1e66f5",
  cyan = "#04A5E5",
  dark_black = "#e6e8ec",
  dark_purple = "#7c2de3",
  green = "#40A02B",
  grey = "#c3c5c9",
  light_green = "#7eca9c",
  light_grey_1 = "#b9bbbf",
  light_grey_2 = "#b0b2b6",
  light_grey_3 = "#a6a8ac",
  light_pink = "#DD7878",
  line = "#d9dbdf",
  nord_blue = "#7287FD",
  orange = "#FE640B",
  pink = "#ea76cb",
  purple = "#8839EF",
  red = "#D20F39",
  sun = "#dea95f",
  teal = "#179299",
  white = "#4C4F69",
  yellow = "#df8e1d",
}

colorscheme.polish = {
  TelescopePromptPrefix = { fg = colorscheme.colors.white },
  TelescopeSelection = {
    bg = colorscheme.colors.bg_2,
    fg = colorscheme.colors.white,
  },
  FloatBorder = { fg = colorscheme.theme.base05 },
  DiffAdd = { fg = colorscheme.theme.base05 },
  TbLineThemeToggleBtn = { bg = colorscheme.colors.bg_4 },
  WhichKeyDesc = { fg = colorscheme.colors.white },
  Pmenu = { bg = colorscheme.colors.bg_1 },
  St_pos_text = { fg = colorscheme.colors.white },
  TSVariableBuiltin = { fg = colorscheme.colors.red },
  TSProperty = { fg = colorscheme.colors.teal },
}

require("aiko.theme").paint(colorscheme)
