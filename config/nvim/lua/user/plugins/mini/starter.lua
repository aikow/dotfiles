-- Small helper function to create a new section.
local function section(section_name, name, action)
  return { section = section_name, name = name, action = action }
end

local logo = table.concat({
  "                                                  ",
  "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
  "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
  "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
  "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
  "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
  "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
  "                                                  ",
}, "\n")

local ver = vim.version()
local footer = string.format("v%s.%s.%s", ver.major, ver.minor, ver.patch)
if ver.prerelease then footer = footer .. "-" .. ver.prerelease end
if ver.build and ver.build ~= vim.NIL then footer = footer .. "+" .. ver.build end

local starter = require("mini.starter")

require("mini.starter").setup({
  evaluate_single = true,
  header = logo,
  items = {
    -- Edit actions
    section("Workspace", "Edit", "enew | startinsert"),
    section("Workspace", "Open", "Pick files"),
    section("Workspace", "Recent", "Pick oldfiles"),
    section("Workspace", "Files", "lua require'mini.files'.open()"),

    -- Config
    section("Config", "Config", "cd ~/.dotfiles/config/nvim | edit init.lua"),
    section("Config", "Local Config", "cd ~/.local/config/nvim/ | edit plugin/local.lua"),
    section("Config", "Update Plugins", "DepsUpdate"),
    section("Config", "Mason", "Mason"),

    -- Builtin actions
    section("Builtin", "News", "help news | wincmd o"),
    section("Builtin", "Help", "Pick help"),
    section("Builtin", "Quit", "quit"),
  },
  footer = footer,
  content_hooks = {
    starter.gen_hook.adding_bullet("❭ ", false),
    starter.gen_hook.aligning("center", "center"),
  },
})
