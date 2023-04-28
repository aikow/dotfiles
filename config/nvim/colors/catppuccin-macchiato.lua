local colorscheme = require("aiko.theme.colorscheme").Scheme:new({
  name = "catppuccin-macchiato",
  background = "light",
})

local palette = {
  rosewater = "#f4dbd6", -- Winbar
  flamingo = "#f0c6c6", -- Target word
  pink = "#f5bde6", -- Just pink
  mauve = "#c6a0f6", -- Tag
  red = "#ed8796", -- Error
  maroon = "#ee99a0", -- Lighter red
  peach = "#f5a97f", -- Number
  yellow = "#eed49f", -- Warning
  green = "#a6da95", -- Diff add
  teal = "#8bd5ca", -- Hint
  sky = "#91d7e3", -- Operator
  sapphire = "#7dc4e4", -- Constructor
  blue = "#8aadf4", -- Diff changed
  lavender = "#b7bdf8", -- CursorLine Nr
  text = "#cad3f5", -- Default fg
  subtext1 = "#b8c0e0", -- Indicator
  subtext0 = "#a5adcb", -- Float title
  overlay2 = "#939ab7", -- Popup fg
  overlay1 = "#8087a2", -- Conceal color
  overlay0 = "#6e738d", -- Fold color
  surface2 = "#5b6078", -- Default comment
  surface1 = "#494d64", -- Darker comment
  surface0 = "#363a4f", -- Darkest comment
  base = "#24273a", -- Default bg
  mantle = "#1e2030", -- Darker bg
  crust = "#181926", -- Darkest bg
}

colorscheme.theme = {
  base00 = "#eff1f5",
  base01 = "#e4e6ea",
  base02 = "#d9dbdf",
  base03 = "#ced0d4",
  base04 = "#c3c5c9",
  base05 = "#4c4f69",
  base06 = "#474a64",
  base07 = "#41445e",
  base08 = "#d20f39",
  base09 = "#7c2de3",
  base0A = "#df8e1d",
  base0B = "#40a02b",
  base0C = "#179299",
  base0D = "#1e66f5",
  base0E = "#8839ef",
  base0F = "#62657f",
}

colorscheme.colors = {
  bg_1 = "#e0e2e6",
  bg_2 = "#e4e6ea",
  bg_3 = "#d9dbdf",
  bg_4 = "#ced0d4",
  bg_folder = "#6c6c6c",
  bg_light = "#d9dbdf",
  bg_pmenu = "#7287fd",
  bg_statusline = "#e4e6ea",
  black = "#eff1f5",
  blue = "#1e66f5",
  cyan = "#04a5e5",
  dark_black = "#e6e8ec",
  dark_purple = "#7c2de3",
  green = "#40a02b",
  grey = "#c3c5c9",
  light_green = "#7eca9c",
  light_grey_1 = "#b9bbbf",
  light_grey_2 = "#b0b2b6",
  light_grey_3 = "#a6a8ac",
  light_pink = "#dd7878",
  line = "#d9dbdf",
  nord_blue = "#7287fd",
  orange = "#fe640b",
  pink = "#ea76cb",
  purple = "#8839ef",
  red = "#d20f39",
  sun = "#dea95f",
  teal = "#179299",
  white = "#4c4f69",
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
