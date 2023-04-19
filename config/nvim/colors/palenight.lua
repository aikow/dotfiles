local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "palenight",
  background = "dark",
})

colorscheme.colors = {
  white = "#ffffff",
  dark_black = "#232738",
  black = "#292D3E",
  bg_1 = "#2f3344",
  bg_2 = "#333748",
  bg_3 = "#3c4051",
  bg_4 = "#444859",
  grey = "#515566",
  light_grey_1 = "#5b5f70",
  light_grey_2 = "#65697a",
  light_grey_3 = "#6d7182",
  red = "#f07178",
  light_pink = "#606475",
  pink = "#ff5370",
  line = "#3f4354",
  green = "#c3e88d",
  light_green = "#96e88d",
  nord_blue = "#8fb7ff",
  blue = "#82aaff",
  yellow = "#ffcb6b",
  sun = "#ffd373",
  purple = "#c792ea",
  dark_purple = "#b383d2",
  teal = "#89ffe6",
  orange = "#ffa282",
  cyan = "#89ddff",
  bg_statusline = "#2d3142",
  bg_light = "#3c4051",
  bg_pmenu = "#82aaff",
  bg_folder = "#82aaff",
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
