local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "monekai",
  background = "dark",
})

colorscheme.colors = {
  white = "#bbc2cf",
  dark_black = "#1f222b",
  black = "#242730",
  bg_1 = "#292c35",
  bg_2 = "#2e313a",
  bg_3 = "#373a43",
  bg_4 = "#3f424b",
  grey = "#494c55",
  light_grey_1 = "#52555e",
  light_grey_2 = "#5b5e67",
  light_grey_3 = "#63666f",
  red = "#e36d76",
  light_pink = "#f98385",
  pink = "#f36d76",
  line = "#363942",
  green = "#96c367",
  light_green = "#99c366",
  nord_blue = "#81A1C1",
  blue = "#51afef",
  yellow = "#e6c181",
  sun = "#fce668",
  purple = "#c885d7",
  dark_purple = "#b26fc1",
  teal = "#34bfd0",
  orange = "#d39467",
  cyan = "#41afef",
  bg_statusline = "#292c35",
  bg_light = "#3d4049",
  bg_pmenu = "#99c366",
  bg_folder = "#61afef",
}

colorscheme.theme = {
  base00 = "#242730",
  base01 = "#2a2e38",
  base02 = "#484854",
  base03 = "#545862",
  base04 = "#5b5e67",
  base05 = "#afb6c3",
  base06 = "#b5bcc9",
  base07 = "#bbc2cf",
  base08 = "#d39467",
  base09 = "#b3a5d4",
  base0A = "#61afef",
  base0B = "#e6c181",
  base0C = "#61afef",
  base0D = "#96c376",
  base0E = "#e36d76",
  base0F = "#e36d76",
}

colorscheme.polish = {
  TSParameter = { fg = colorscheme.colors.blue },
  TSFieldKey = { fg = colorscheme.colors.red },
}

require("aiko.theme").paint(colorscheme)
