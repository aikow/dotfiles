local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "palenight",
  background = "dark",
})

colorscheme.colors = {
  white = "#ffffff",
  darker_black = "#232738",
  black = "#292D3E",
  black2 = "#2f3344",
  one_bg = "#333748",
  one_bg2 = "#3c4051",
  one_bg3 = "#444859",
  grey = "#515566",
  grey_fg = "#5b5f70",
  grey_fg2 = "#65697a",
  light_grey = "#6d7182",
  red = "#f07178",
  baby_pink = "#606475",
  pink = "#ff5370",
  line = "#3f4354",
  green = "#c3e88d",
  vibrant_green = "#96e88d",
  nord_blue = "#8fb7ff",
  blue = "#82aaff",
  yellow = "#ffcb6b",
  sun = "#ffd373",
  purple = "#c792ea",
  dark_purple = "#b383d2",
  teal = "#89ffe6",
  orange = "#ffa282",
  cyan = "#89ddff",
  statusline_bg = "#2d3142",
  lightbg = "#3c4051",
  pmenu_bg = "#82aaff",
  folder_bg = "#82aaff",
}

colorscheme.theme = {
  base00 = "#292d3e",
  base01 = "#444267",
  base02 = "#32374d",
  base03 = "#676e95",
  base04 = "#8796b0",
  base05 = "#d3d3d3",
  base06 = "#efefef",
  base07 = "#ffffff",
  base08 = "#f07178",
  base09 = "#ffa282",
  base0A = "#ffcb6b",
  base0B = "#c3e88d",
  base0C = "#89ddff",
  base0D = "#82aaff",
  base0E = "#c792ea",
  base0F = "#ff5370",
}

colorscheme.polish = {
  TSInclude = { fg = colorscheme.colors.purple },
  TSFieldKey = { fg = colorscheme.colors.orange },
}

require("aiko.theme").paint(colorscheme)
