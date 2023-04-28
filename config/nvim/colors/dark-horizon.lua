local colorscheme = require("aiko.theme.colorscheme").Scheme:new({
  name = "dark-horizon",
  background = "dark",
})

colorscheme.theme = {
  base00 = "#0e0e0e",
  base01 = "#181818",
  base02 = "#292929",
  base03 = "#363636",
  base04 = "#3f4248",
  base05 = "#c9c7be",
  base06 = "#e6e1cf",
  base07 = "#d9d7ce",
  base08 = "#d9d7ce", -- Confirmed: Variables Confirmed
  base09 = "#eaa273", -- Confirmed: Integers, Booleans
  base0A = "#825aff", -- Classes
  base0B = "#e3a587", -- Confirmed: Strings
  base0C = "#f09483", -- Escape characters, Regular expressions
  base0D = "#ffa500", -- Functions, Methods
  base0E = "#2ca9b4", -- Confirmed: Keywords, Storage, Selector, Markup
  base0F = "#d75271", -- Deprecated, Opening/Closing embedded language tags
}

colorscheme.colors = {
  bg_1 = "#181818",
  bg_2 = "#1c1c1c",
  bg_3 = "#212121",
  bg_4 = "#292929",
  bg_folder = "#07929e",
  bg_light = "#292929",
  bg_pmenu = "#15bf84",
  bg_statusline = "#181818",
  black = "#0e0e0e", --  nvim bg
  blue = "#25b0bc",
  cyan = "#6be4e6",
  dark_black = "#080808",
  dark_purple = "#c65cc2",
  green = "#aad84c",
  grey = "#363636",
  light_green = "#b9e75b",
  light_grey_1 = "#404040",
  light_grey_2 = "#4a4a4a",
  light_grey_3 = "#525252",
  light_pink = "#a72e5b",
  line = "#1d1d1d", -- for lines like vertsplit
  nord_blue = "#18a3af",
  orange = "#ffa500",
  pink = "#ff75a0",
  purple = "#da70d6",
  red = "#dc322f",
  sun = "#ffc038",
  teal = "#749689",
  white = "#ffffff",
  yellow = "#fdb830",
}

colorscheme.polish = {
  Include = { fg = colorscheme.theme.base0E, bold = true },
  luaTSField = { fg = colorscheme.theme.base0E },
  Repeat = { fg = colorscheme.theme.base0E },
  ["@variable"] = { fg = colorscheme.theme.base08 },
  ["@property"] = { fg = colorscheme.theme.base0E },
  ["@tag.delimiter"] = { fg = colorscheme.theme.base05 },
  ["@function"] = { fg = colorscheme.colors.orange },
  ["@parameter"] = { fg = colorscheme.theme.base0F },
  ["@constructor"] = { fg = colorscheme.theme.base0A },
  ["@tag.attribute"] = { fg = colorscheme.colors.orange },
}

require("aiko.theme").paint(colorscheme)
