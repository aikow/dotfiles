local colorscheme = require("aiko.theme.colorscheme").Scheme:new({
  name = "tokyonight",
  background = "dark",
})

colorscheme.theme = {
  base00 = "#1a1b26",
  base01 = "#292e42",
  base02 = "#3b4261",
  base03 = "#545c7e",
  base04 = "#565c64",
  base05 = "#a9b1d6",
  base06 = "#bbc5f0",
  base07 = "#c0caf5",
  base08 = "#f7768e",
  base09 = "#ff9e64",
  base0A = "#ffd089",
  base0B = "#9ece6a",
  base0C = "#2ac3de",
  base0D = "#7aa2f7",
  base0E = "#bb9af7",
  base0F = "#c0caf5",
}

colorscheme.colors = {
  bg_1 = "#1f2336",
  bg_2 = "#24283b",
  bg_3 = "#414868",
  bg_4 = "#353b45",
  bg_folder = "#7aa2f7",
  bg_light = "#32333e",
  bg_pmenu = "#7aa2f7",
  bg_statusline = "#1d1e29",
  black = "#1a1b26",
  blue = "#7aa2f7",
  cyan = "#7dcfff",
  dark_black = "#16161e",
  dark_purple = "#9d7cd8",
  green = "#9ece6a",
  grey = "#40486a",
  light_green = "#73daca",
  light_grey_1 = "#565f89",
  light_grey_2 = "#4f5779",
  light_grey_3 = "#545c7e",
  light_pink = "#de8c92",
  line = "#32333e",
  nord_blue = "#80a8fd",
  orange = "#ff9e64",
  pink = "#ff75a0",
  purple = "#bb9af7",
  red = "#f7768e",
  sun = "#ebcb8b",
  teal = "#1abc9c",
  white = "#c0caf5",
  yellow = "#e0af68",
}

colorscheme.polish = {
  TSVariable = { fg = colorscheme.colors.red },
  TSFuncBuiltin = { fg = colorscheme.colors.cyan },
  TSParameter = { fg = colorscheme.colors.white },
}

require("aiko.theme").paint(colorscheme)
