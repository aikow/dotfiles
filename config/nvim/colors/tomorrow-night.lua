local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "tomorrow-night",
  background = "dark",
})

colorscheme.colors = {
  white = "#C5C8C2",
  dark_black = "#191b1d",
  black = "#1d1f21",
  bg_1 = "#232527",
  bg_2 = "#2d2f31",
  bg_3 = "#353b45",
  bg_4 = "#30343c",
  grey = "#434547",
  light_grey_1 = "#545B68",
  light_grey_2 = "#616875",
  light_grey_3 = "#676e7b",
  red = "#cc6666",
  light_pink = "#FF6E79",
  pink = "#ff9ca3",
  line = "#313335",
  green = "#a4b595",
  light_green = "#a3b991",
  nord_blue = "#728da8",
  blue = "#6f8dab",
  yellow = "#d7bd8d",
  sun = "#e4c180",
  purple = "#b4bbc8",
  dark_purple = "#b290ac",
  teal = "#8abdb6",
  orange = "#DE935F",
  cyan = "#70c0b1",
  bg_statusline = "#212326",
  bg_light = "#373B41",
  bg_pmenu = "#a4b595",
  bg_folder = "#6f8dab",
}

colorscheme.theme = {
  base0A = "#f0c674",
  base04 = "#b4b7b4",
  base07 = "#ffffff",
  base05 = "#c5c8c6",
  base0E = "#b294bb",
  base0D = "#81a2be",
  base0C = "#8abeb7",
  base0B = "#b5bd68",
  base02 = "#373b41",
  base0F = "#a3685a",
  base03 = "#969896",
  base08 = "#cc6666",
  base01 = "#282a2e",
  base00 = "#1d1f21",
  base09 = "#de935f",
  base06 = "#e0e0e0",
}

colorscheme.polish = {
  PmenuSel = { fg = colorscheme.colors.bg, bg = colorscheme.colors.red },
}

require("aiko.theme").paint(colorscheme)
