local Colorscheme = require("aiko.theme.colorscheme").Colorscheme

local colorscheme = Colorscheme.new({
  name = "gruvmat",
  background = "dark",
})

colorscheme.theme = {
  base00 = "#1e1e1e",
  base01 = "#5a524c",
  base02 = "#35312e",
  base03 = "#928374",
  base04 = "#ddc7a1",
  base05 = "#e78a4e",
  base06 = "#988771",
  base07 = "#35312e",
  base08 = "#d4be98",
  base09 = "#d3869b",
  base0A = "#a9b665",
  base0B = "#a9b665",
  base0C = "#89b482",
  base0D = "#a9b665", -- Aqua
  base0E = "#ea6962", -- Red
  base0F = "#ea6962",
}

colorscheme.colors = {
  black = "#282828",
  dark_black = "#191919",
  bg_1 = "#373737",

  bg_2 = "#424242",
  bg_3 = "#585858",
  bg_4 = "#6f6f6f",

  grey = "#8e8e8e",
  light_grey_1 = "#a8a8a8",
  light_grey_2 = "#c1c1c1",
  light_grey_3 = "#d5d5d5",

  bg_statusline = "#323232",
  bg_light = "#535353",

  bg_pmenu = "#35312e",
  bg_folder = "#7daea3",

  line = "#51524c",

  white = "#d3c6aa",
  red = "#ea6962",
  light_pink = "#e44d26",
  pink = "#701516",
  green = "#a9b665",
  light_green = "#3b4439",
  nord_blue = "",
  blue = "#7daea3",
  yellow = "#d8a657",
  sun = "#d8a657", -- yellow
  purple = "#d3869b",
  dark_purple = "#d3869b", -- same as purple
  teal = "#89b482", -- aqua
  orange = "#e78a4e",
  cyan = "#7daea3", -- blue
}

local _ = {
  grey0 = { "#7c6f64", "243" },
  grey1 = { "#928374", "245" },
  grey2 = { "#a89984", "246" },

  fg0 = { "#d4be98", "223" },
  fg1 = { "#ddc7a1", "223" },
  red = { "#ea6962", "167" },
  orange = { "#e78a4e", "208" },
  yellow = { "#d8a657", "214" },
  green = { "#a9b665", "142" },
  aqua = { "#89b482", "108" },
  blue = { "#7daea3", "109" },
  purple = { "#d3869b", "175" },
  bg_red = { "#ea6962", "167" },
  bg_green = { "#a9b665", "142" },
  bg_yellow = { "#d8a657", "214" },

  bg0 = { "#282828", "235" },
  bg1 = { "#32302f", "236" },
  bg2 = { "#32302f", "236" },
  bg3 = { "#45403d", "237" },
  bg4 = { "#45403d", "237" },
  bg5 = { "#5a524c", "239" },
  bg_statusline1 = { "#32302f", "236" },
  bg_statusline2 = { "#3a3735", "236" },
  bg_statusline3 = { "#504945", "240" },
  bg_diff_green = { "#34381b", "22" },
  bg_visual_green = { "#3b4439", "22" },
  bg_diff_red = { "#402120", "52" },
  bg_visual_red = { "#4c3432", "52" },
  bg_diff_blue = { "#0e363e", "17" },
  bg_visual_blue = { "#374141", "17" },
  bg_visual_yellow = { "#4f422e", "94" },
  bg_current_word = { "#3c3836", "237" },
}

require("aiko.theme").paint(colorscheme)
