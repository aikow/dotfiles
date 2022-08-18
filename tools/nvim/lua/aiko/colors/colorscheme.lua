-- A colorscheme object defines some basic properties that are then used to
-- create all the other highlight groups.
local _ = {
  name = "everforest", -- The name of the color scheme.
  background = "dark", -- Whether it is 'dark' or 'light'

  -- Defines the primary colors that make up the theme.
  theme = {
    base00 = "#2b3339", -- Default background color
    base01 = "#323c41", -- Lighter background color (status bars, line numbers, folding marks)
    base02 = "#3a4248", -- Selection background
    base03 = "#424a50", -- Comments, invisibles, line highlighting
    base04 = "#4a5258", -- Dark foreground (status bars)
    base05 = "#d3c6aa", -- Default foreground (caret, delimiters, operators)
    base06 = "#ddd0b4", -- Light foreground (infrequent)
    base07 = "#e7dabe", -- Light background (infrequent)
    base08 = "#7fbbb3", -- Variables, XML tags, markup link text, markup lists, diff deleted
    base09 = "#d699b6", -- Integers, booleans, constants, XML attributes, markup link URLs
    base0A = "#83c092", -- Classes, markup bold, search text background
    base0B = "#dbbc7f", -- Strings, inherited classes, markup code, diff inserted
    base0C = "#e69875", -- Support, regular expressions, escape characters, markup quotes
    base0D = "#a7c080", -- Functions, methods, attribute IDs, headings
    base0E = "#e67e80", -- Keywords, storage, selector, markup italic, diff changed
    base0F = "#e67e80", -- Deprecated, opening and closing embedded language tags
  },

  -- Extends the theme with some additional foregrounds, backgrounds, and other
  -- colors.
  colors = {
    black = "#2b3339", -- Nvim theme background color
    darker_black = "#272f35", -- 6% darker than black
    black2 = "#323a40", -- 6% lighter than black

    -- Background variations for floats and other embedded windows.
    one_bg = "#363e44", -- 10% lighter than black
    one_bg2 = "#363e44", -- 19% lighter than black
    one_bg3 = "#3a4248", -- 27% lighter than black

    -- Grey tones.
    grey = "#4e565c", -- 40% lighter than black, but can vary
    grey_fg = "#545c62", -- 10% lighter than grey
    grey_fg2 = "#626a70", -- 20% lighter than grey
    light_grey = "#656d73", -- 28% lighter than grey

    -- Additional colors for specific parts of neovim.
    statusline_bg = "#2e363c", -- 4% lighter than black.
    lightbg = "#3d454b", -- 13% lighter than statusline_bg

    pmenu_bg = "#83c092", -- Pop-up menu background color
    folder_bg = "#7393b3", -- Any blue color

    -- Line color for vertical or horizontal splits
    line = "#3a4248", -- 15% lighter than black

    red = "#e67e80",
    pink = "#ff75a0",
    baby_pink = "#ce8196", -- 15% lighter than red (or any other baby pink color)
    white = "#D3C6AA",
    green = "#83c092",
    vibrant_green = "#a7c080",
    nord_blue = "#78b4ac", -- 13% darker then blue
    blue = "#7393b3",
    yellow = "#dbbc7f",
    sun = "#d1b171", -- 8% lighter than yellow
    purple = "#ecafcc",
    dark_purple = "#d699b6",
    teal = "#69a59d",
    orange = "#e69875",
    cyan = "#95d1c9",
  },

  -- Allows overriding specific highlight groups. The left-hand side is the
  -- highlight group name and the right-hand side is a color object
  -- (see :help nvim_set_hl)
  polish = {
    ...,
  },
}
