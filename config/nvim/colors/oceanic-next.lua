local colorscheme = require("aiko.theme.colorscheme").Scheme:new({
  name = "oceanic-next",
  background = "dark",
})

colorscheme.theme = {
  base00 = "#1b2b34", -- Confirmed
  base01 = "#343d46", -- Confirmed
  base02 = "#4f5b66", -- Confirmed
  base03 = "#65737e", -- Confirmed
  base04 = "#a7adba", -- Confirmed
  base05 = "#c0c5ce", -- Confirmed
  base06 = "#cdd3de", -- Confirmed
  base07 = "#d8dee9", -- Confirmed
  base08 = "#6cbdbc", -- Confirmed
  base09 = "#fac863", -- Confirmed
  base0A = "#f99157", -- Confirmed
  base0B = "#99c794", -- Confirmed
  base0C = "#5aaeae", -- Confirmed
  base0D = "#6699cc", -- Confirmed
  base0E = "#c594c5", -- Confirmed
  base0F = "#ec5f67", -- Confirmed
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
  black = "#1b2b34", --  nvim bg
  blue = "#6699cc",
  cyan = "#62b3b2",
  dark_black = "#15252e",
  dark_purple = "#ac7bac",
  green = "#99c794",
  grey = "#43535c",
  light_green = "#b9e75b",
  light_grey_1 = "#4d5d66",
  light_grey_2 = "#576770",
  light_grey_3 = "#5f6f78",
  light_pink = "#ff7d85",
  line = "#2a3a43", -- for lines like vertsplit
  nord_blue = "#598cbf",
  orange = "#f99157",
  pink = "#ffafb7",
  purple = "#c594c5",
  red = "#ec5f67",
  sun = "#ffd06b",
  teal = "#50a4a4",
  white = "#d8dee9", -- confirmed
  yellow = "#fac863",
}

colorscheme.polish = {
  ["@parameter"] = { fg = colorscheme.theme.base0A },
  Constant = { fg = colorscheme.theme.base09 },
}

require("aiko.theme").paint(colorscheme)
