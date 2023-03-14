local M = {}

---@class Theme
---@field base00 string -- Default background color
---@field base01 string -- Lighter background color (status bars, line numbers, folding marks)
---@field base02 string -- Selection background
---@field base03 string -- Comments, invisibles, line highlighting
---@field base04 string -- Dark foreground (status bars)
---@field base05 string -- Default foreground (caret, delimiters, operators)
---@field base06 string -- Light foreground (infrequent)
---@field base07 string -- Light background (infrequent)
---@field base08 string -- Variables, XML tags, markup link text, markup lists, diff deleted
---@field base09 string -- Integers, booleans, constants, XML attributes, markup link URLs
---@field base0A string -- Classes, markup bold, search text background
---@field base0B string -- Strings, inherited classes, markup code, diff inserted
---@field base0C string -- Support, regular expressions, escape characters, markup quotes
---@field base0D string -- Functions, methods, attribute IDs, headings
---@field base0E string -- Keywords, storage, selector, markup italic, diff changed
---@field base0F string -- Deprecated, opening and closing embedded language tags
M.Theme = {}
function M.Theme:new(o)
  o = o or {}
  return setmetatable(o, {
    __index = self,
    __newindex = function()
      error("attempt to update missing fields", 2)
    end,
  })
end

---@class Colors
---@field bg string -- Nvim theme background color
---@field black string -- 6% darker than black
---@field bg_1 string -- 6% lighter than black
---@field bg_2 string -- 10% lighter than black
---@field bg_3 string -- 19% lighter than black
---@field bg_4 string -- 27% lighter than black
---@field grey string -- 40% lighter than black, but can vary
---@field light_grey_1 string -- 10% lighter than grey
---@field light_grey_2 string -- 20% lighter than grey
---@field light_grey_3 string -- 28% lighter than grey
---@field bg_statusline string -- 4% lighter than black.
---@field bg_light string -- 13% lighter than statusline_bg
---@field bg_pmenu string -- Pop-up menu background color
---@field bg_folder string -- Any blue color
---@field line string -- 15% lighter than black
---@field red string
---@field pink string
---@field light_pink string -- 15% lighter than red (or any other baby pink color)
---@field white string
---@field green string
---@field light_green string
---@field nord_blue string -- 13% darker then blue
---@field blue string
---@field yellow string
---@field sun string -- 8% lighter than yellow
---@field purple string
---@field dark_purple string
---@field teal string
---@field orange string
---@field cyan string
M.Colors = {}

-- A colorscheme object defines some basic properties that are then used to
---create all the other highlight groups.
---@class Colorscheme
---@field name string The name of the colorscheme which should match the file name.
---@field background string The background color, either 'light' or 'dark'
---@field theme Theme The base16 theme.
---@field colors Colors The extended colors.
---@field polish table<string, table<string, string | boolean>> Overrides for the default generated highlight groups.
M.Colorscheme = {}

function M.Colorscheme:new(o)
  o = o or {}

  return setmetatable({
    name = o.name or "",
    background = o.background or "",
    theme = o.theme,
    colors = o.colors,
    polish = o.polish or {},
  }, { __index = self })
end

return M
