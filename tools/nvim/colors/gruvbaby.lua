local colorscheme = {
  name = "gruvbaby",
  background = "dark",
}

colorscheme.colors = {
  dark0 = "#0d0e0f",
  dark = "#202020",
  foreground = "#ebdbb2",
  background = "#252525",
  background_dark = "#1d2021",
  background_light = "#32302f",
  medium_gray = "#504945",
  comment = "#665c54",
  gray = "#DEDEDE",
  soft_yellow = "#eebd35",
  soft_green = "#98971a",
  bright_yellow = "#fabd2f",
  orange = "#d65d0e",
  red = "#fb4934",
  error_red = "#cc241d",
  magenta = "#b16286",
  pink = "#D4879C",
  light_blue = "#7fa2ac",
  dark_gray = "#83a598",
  blue_gray = "#458588",
  forest_green = "#689d6a",
  clean_green = "#8ec07c",
  milk = "#E7D7AD",
}

require("aiko.ui.colorscheme").paint(colorscheme)
