-- Create a mock base46 module
package.loaded.base46 = {
  override_theme = function(m, theme)
    m.name = theme
    return m
  end,
}

-- Map of color renames from base46 to my local config.
local color_map = {
  black = "black",
  darker_black = "dark_black",

  black2 = "bg_1",
  one_bg = "bg_2",
  one_bg2 = "bg_3",
  one_bg3 = "bg_4",

  grey = "grey",
  grey_fg = "light_grey_1",
  grey_fg2 = "light_grey_2",
  light_grey = "light_grey_3",

  statusline_bg = "bg_statusline",
  lightbg = "bg_light",
  pmenu_bg = "bg_pmenu",
  folder_bg = "bg_folder",
  line = "line",

  red = "red",
  pink = "pink",
  baby_pink = "light_pink",
  white = "white",
  green = "green",
  vibrant_green = "light_green",
  nord_blue = "nord_blue",
  blue = "blue",
  yellow = "yellow",
  sun = "sun",
  purple = "purple",
  dark_purple = "dark_purple",
  teal = "teal",
  orange = "orange",
  cyan = "cyan",
}

local sorted = function(t, f)
  local a = {}
  for n in pairs(t) do
    table.insert(a, n)
  end
  table.sort(a, f)

  local i = 0 -- iterator variable

  local iter = function() -- iterator function
    i = i + 1
    if a[i] == nil then
      return nil
    else
      return a[i], t[a[i]]
    end
  end
  return iter
end

---comment
---@param module any
---@param color string | boolean
---@return string
local lookup_color = function(module, color)
  if type(color) == "boolean" then
    return color and "true" or "false"
  end

  for key, value in pairs(module.base_16) do
    if value == color then
      return string.format([[colorscheme.theme.%s]], key)
    end
  end

  for key, value in pairs(module.base_30) do
    if value == color then
      return string.format([[colorscheme.colors.%s]], key)
    end
  end

  return string.format([["%s"]], color)
end

local read_module = function(filename)
  local chunk = loadfile(filename, "t", _ENV)
  if chunk == nil then
    error(string.format("Unable to find a file at %s", filename), 2)
  end

  local module = chunk()
  if type(module) ~= "table" then
    error(
      string.format(
        "File did not return a module as was expected. Found %s instead",
        type(module)
      ),
      2
    )
  end

  local result = {}
  result.theme = string.gsub(module.name, "_", "-")
  result.background = module.type
  result.base_16 = {}
  for key, value in pairs(module.base_16) do
    result.base_16[key] = string.lower(value)
  end

  result.base_30 = {}
  for key, value in pairs(module.base_30) do
    local new_key = color_map[key] or key
    result.base_30[new_key] = string.lower(value)
  end

  result.polish = {}
  for hl_group, color in pairs(module.polish_hl or {}) do
    local new_color = {}
    for attr, value in pairs(color) do
      new_color[attr] = lookup_color(module, value)
    end
    result.polish[hl_group] = new_color
  end

  return result
end

local dump_module = function(filename, module)
  local file = io.open(filename, "w")
  if file == nil then
    error(string.format("unable to open file for writing: %s", filename), 2)
  end

  file:write(string.format(
    [[
      local colorscheme = require("aiko.theme.colorscheme").Scheme:new({
        name = "%s",
        background = "%s",
      })
    ]],
    module.theme,
    module.background
  ))
  file:write("\n\n")

  file:write([[colorscheme.theme = {]], "\n")
  for key, value in sorted(module.base_16) do
    file:write(string.format([[  %s = "%s",]], key, value), "\n")
  end
  file:write("}\n\n")

  file:write([[colorscheme.colors = {]], "\n")
  for key, value in sorted(module.base_30) do
    file:write(string.format([[  %s = "%s",]], key, value), "\n")
  end
  file:write("}\n\n")

  file:write([[colorscheme.polish = {]], "\n")
  for hl_group, color in sorted(module.polish) do
    -- TODO: write actual value
    if string.match(hl_group, "^[a-zA-Z][a-zA-Z0-9_]*$") then
      file:write(string.format([[  %s = {]], hl_group))
    else
      file:write(string.format([[  ["%s"] = {]], hl_group))
    end
    for attr, value in pairs(color) do
      file:write(string.format([[ %s = %s, ]], attr, value))
    end
    file:write("},\n")
  end
  file:write("}\n\n")

  file:write([[require("aiko.theme").paint(colorscheme)]], "\n")

  file:flush()
  file:close()

  local format = io.popen(
    string.format("stylua -f ~/.dotfiles/config/nvim/.stylua.toml %s", filename)
  )
  if format == nil then
    error("failed to format file")
  end
  format:close()
end

-- Check that we have at least one argument
if #arg < 1 then
  error("expected at least 1 argument", 2)
end

-- Loop through all files.
for _, file in ipairs(arg) do
  print(file)
  local module = read_module(file)
  dump_module(file, module)
end
