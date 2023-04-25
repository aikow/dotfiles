local colorscheme = require("aiko.theme.colorscheme").Colorscheme.new({
  name = "tokyodark",
  background = "dark",
})

colorscheme.theme = {
  base00 = "#11121d",
  base01 = "#1b1c27",
  base02 = "#21222d",
  base03 = "#282934",
  base04 = "#30313c",
  base05 = "#abb2bf",
  base06 = "#b2b9c6",
  base07 = "#A0A8CD",
  base08 = "#ee6d85",
  base09 = "#7199ee",
  base0A = "#7199ee",
  base0B = "#dfae67",
  base0C = "#a485dd",
  base0D = "#95c561",
  base0E = "#a485dd",
  base0F = "#f3627a",
}

colorscheme.colors = {
  white = "#A0A8CD",
  dark_black = "#0c0d18",
  black = "#11121D",
  bg_1 = "#171823",
  bg_2 = "#1d1e29",
  bg_3 = "#252631",
  bg_4 = "#252631",
  grey = "#40414c",
  light_grey_1 = "#474853",
  light_grey_2 = "#4e4f5a",
  light_grey_3 = "#545560",
  red = "#ee6d85",
  light_pink = "#fd7c94",
  pink = "#fe6D85",
  line = "#191a25",
  green = "#98c379",
  light_green = "#95c561",
  nord_blue = "#648ce1",
  blue = "#7199ee",
  yellow = "#d7a65f",
  sun = "#dfae67",
  purple = "#a485dd",
  dark_purple = "#9071c9",
  teal = "#519aba",
  orange = "#f6955b",
  cyan = "#38a89d",
  bg_statusline = "#161722",
  bg_light = "#2a2b36",
  bg_pmenu = "#ee6d85",
  bg_folder = "#7199ee",
}

require("aiko.theme").paint(colorscheme)
