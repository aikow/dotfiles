local colorscheme = require("aiko.theme.colorscheme").Colorscheme.new({
  name = "oceanic-next",
  background = "dark",
})

colorscheme.theme = {
  base00 = "#1B2B34", -- Confirmed
  base01 = "#343D46", -- Confirmed
  base02 = "#4F5B66", -- Confirmed
  base03 = "#65737e", -- Confirmed
  base04 = "#A7ADBa", -- Confirmed
  base05 = "#C0C5Ce", -- Confirmed
  base06 = "#CDD3De", -- Confirmed
  base07 = "#D8DEE9", -- Confirmed
  base08 = "#6cbdbc", -- Confirmed
  base09 = "#FAC863", -- Confirmed
  base0A = "#F99157", -- Confirmed
  base0B = "#99C794", -- Confirmed
  base0C = "#5aaeae", -- Confirmed
  base0D = "#6699CC", -- Confirmed
  base0E = "#C594C5", -- Confirmed
  base0F = "#EC5F67", -- Confirmed
}

colorscheme.colors = {
  bg_1 = "#21313a",
  bg_2 = "#25353e",
  bg_3 = "#2e3e47",
  bg_4 = "#36464f",
  bg_folder = "#598cbf",
  bg_light = "#2c3c45",
  bg_pmenu = "#15bf84",
  bg_statusline = "#1f2f38",
  black = "#1B2B34", --  nvim bg
  blue = "#6699CC",
  cyan = "#62B3B2",
  dark_black = "#15252e",
  dark_purple = "#ac7bac",
  green = "#99C794",
  grey = "#43535c",
  light_green = "#b9e75b",
  light_grey_1 = "#4d5d66",
  light_grey_2 = "#576770",
  light_grey_3 = "#5f6f78",
  light_pink = "#ff7d85",
  line = "#2a3a43", -- for lines like vertsplit
  nord_blue = "#598cbf",
  orange = "#F99157",
  pink = "#ffafb7",
  purple = "#C594C5",
  red = "#EC5F67",
  sun = "#ffd06b",
  teal = "#50a4a4",
  white = "#D8DEE9", -- confirmed
  yellow = "#FAC863",
}

colorscheme.polish = {
  ["@parameter"] = { fg = colorscheme.theme.base0A },
  Constant = { fg = colorscheme.theme.base09 },
}

require("aiko.theme").paint(colorscheme)
