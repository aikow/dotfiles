-- credits to original theme https://github.com/voronianski/oceanic-next-color-scheme
-- This is a modified version of the original theme.

local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "oceanic-next",
  background = "dark",
})

colorscheme.colors = {
  white = "#D8DEE9", -- confirmed
  dark_black = "#15252e",
  black = "#1B2B34", --  nvim bg
  bg_1 = "#21313a",
  bg_2 = "#25353e",
  bg_3 = "#2e3e47",
  bg_4 = "#36464f",
  grey = "#43535c",
  light_grey_1 = "#4d5d66",
  light_grey_2 = "#576770",
  light_grey_3 = "#5f6f78",
  red = "#EC5F67",
  light_pink = "#ff7d85",
  pink = "#ffafb7",
  line = "#2a3a43", -- for lines like vertsplit
  green = "#99C794",
  light_green = "#b9e75b",
  nord_blue = "#598cbf",
  blue = "#6699CC",
  yellow = "#FAC863",
  sun = "#ffd06b",
  purple = "#C594C5",
  dark_purple = "#ac7bac",
  teal = "#50a4a4",
  orange = "#F99157",
  cyan = "#62B3B2",
  bg_statusline = "#1f2f38",
  bg_light = "#2c3c45",
  bg_pmenu = "#15bf84",
  bg_folder = "#598cbf",
}

-- Base16 colors taken from:
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

colorscheme.polish = {
  ["@parameter"] = {
    fg = colorscheme.theme.base0A,
  },
  Constant = {
    fg = colorscheme.theme.base09,
  },
}

require("aiko.theme").paint(colorscheme)
