local colorscheme = require("aiko.theme.colorscheme").Colorscheme.new({
  name = "everforest-light",
  background = "light",
})

colorscheme.theme = {
  base00 = "#fff9e8",
  base01 = "#f6f0df",
  base02 = "#ede7d6",
  base03 = "#e5dfce",
  base04 = "#ddd7c6",
  base05 = "#495157",
  base06 = "#3b4349",
  base07 = "#272f35",
  base08 = "#5f9b93",
  base09 = "#b67996",
  base0A = "#8da101",
  base0B = "#d59600",
  base0C = "#ef615e",
  base0D = "#87a060",
  base0E = "#c85552",
  base0F = "#c85552",
}

colorscheme.colors = {
  bg_1 = "#ebe5d4",
  bg_2 = "#c6c2aa",
  bg_3 = "#b6b29a",
  bg_4 = "#a6a28a",
  bg_folder = "#747b6e",
  bg_light = "#d3cdbc",
  bg_pmenu = "#5f9b93",
  bg_statusline = "#ede7d6",
  black = "#fff9e8",
  blue = "#3a94c5",
  cyan = "#7521e9",
  dark_black = "#f5efde",
  dark_purple = "#966986",
  green = "#5da111",
  grey = "#a6b0a0",
  light_green = "#87a060",
  light_grey_1 = "#939f91",
  light_grey_2 = "#829181",
  light_grey_3 = "#798878",
  light_pink = "#ce8196",
  line = "#e8e2d1",
  nord_blue = "#656c5f",
  orange = "#F7954F",
  pink = "#ef6590",
  purple = "#b67996",
  red = "#c85552",
  sun = "#d1b171",
  teal = "#69a59d",
  white = "#272f35",
  yellow = "#dfa000",
}

local custom = {
  dimgray = "#4e565c",
}

colorscheme.polish = {
  DiffAdd = { fg = colorscheme.colors.green },
  TSTag = { fg = colorscheme.colors.orange },
  TSField = { fg = colorscheme.theme.base05 },
  TSInclude = { fg = colorscheme.theme.base08 },
  TSConstructor = { fg = colorscheme.colors.blue },
  WhichKeyDesc = { fg = colorscheme.colors.white },
  WhichKey = { fg = colorscheme.colors.white },
  NvimTreeFolderName = { fg = custom.dimgray },
  TbLineThemeToggleBtn = { bg = colorscheme.colors.bg_2 },
  Pmenu = { bg = colorscheme.colors.bg_1 },
  IndentBlanklineContextStart = { bg = colorscheme.colors.bg_1 },
  St_pos_text = { fg = colorscheme.colors.white },
}

require("aiko.theme").paint(colorscheme)
