local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "blossom",
  background = "light",
})

colorscheme.colors = {
  white = "#695d57",
  dark_black = "#dfd8d5",
  black = "#e6dfdc",
  bg_1 = "#d9d2cf",
  bg_2 = "#d0c9c6",
  bg_3 = "#c7c0bd",
  bg_4 = "#c0b9b6",
  grey = "#b9b2af",
  light_grey_1 = "#b2aba8",
  light_grey_2 = "#aaa3a0",
  light_grey_3 = "#a09996",
  red = "#b28069",
  light_pink = "#b7856e",
  pink = "#c18f78",
  line = "#d3ccc9",
  green = "#6c805c",
  light_green = "#899d79",
  blue = "#5f7d9b",
  nord_blue = "#5e5f65",
  yellow = "#a9a29f",
  sun = "#d38a73",
  purple = "#a685a6",
  dark_purple = "#9c7b9c",
  teal = "#4b6987",
  orange = "#cc836c",
  cyan = "#75998e",
  bg_statusline = "#dcd5d2",
  bg_light = "#cdc6c3",
  bg_pmenu = "#857e7b",
  bg_folder = "#746d6a",
}

colorscheme.theme = {
  base00 = "#e6dfdc",
  base01 = "#ded7d4",
  base02 = "#d7d0cd",
  base03 = "#d1cac7",
  base04 = "#cac3c0",
  base05 = "#746862",
  base06 = "#5e524c",
  base07 = "#695d57",
  base08 = "#8779a8",
  base09 = "#a87678",
  base0A = "#738199",
  base0B = "#6c805c",
  base0C = "#5e908e",
  base0D = "#b3816a",
  base0E = "#7e8e8e",
  base0F = "#976153",
}

colorscheme.polish = {
  WhichKeyDesc = { fg = colorscheme.colors.white },
  WhichKey = { fg = colorscheme.colors.white },

  TbLineThemeToggleBtn = {
    fg = colorscheme.colors.bg,
    bg = colorscheme.colors.white,
  },

  IndentBlanklineContextStart = { bg = colorscheme.colors.bg_1 },
  St_pos_text = { fg = colorscheme.colors.white },
}

require("aiko.theme").paint(colorscheme)
