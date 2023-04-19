local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "tokyonight",
  background = "dark",
})

colorscheme.colors = {
  white = "#c0caf5",
  dark_black = "#16161e",
  black = "#1a1b26",
  bg_1 = "#1f2336",
  bg_2 = "#24283b",
  bg_3 = "#414868",
  bg_4 = "#353b45",
  grey = "#40486a",
  light_grey_1 = "#565f89",
  light_grey_2 = "#4f5779",
  light_grey_3 = "#545c7e",
  red = "#f7768e",
  light_pink = "#DE8C92",
  pink = "#ff75a0",
  line = "#32333e",
  green = "#9ece6a",
  light_green = "#73daca",
  nord_blue = "#80a8fd",
  blue = "#7aa2f7",
  yellow = "#e0af68",
  sun = "#EBCB8B",
  purple = "#bb9af7",
  dark_purple = "#9d7cd8",
  teal = "#1abc9c",
  orange = "#ff9e64",
  cyan = "#7dcfff",
  bg_statusline = "#1d1e29",
  bg_light = "#32333e",
  bg_pmenu = "#7aa2f7",
  bg_folder = "#7aa2f7",
}

colorscheme.theme = {
  base00 = "#1A1B26",
  base01 = "#3b4261",
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

colorscheme.polish = {
  TSVariable = { fg = colorscheme.colors.red },
  TSFuncBuiltin = { fg = colorscheme.colors.cyan },
  TSParameter = { fg = colorscheme.colors.white },
}

require("aiko.theme").paint(colorscheme)
