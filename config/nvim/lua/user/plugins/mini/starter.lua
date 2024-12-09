local M = {}

-- Small helper function to create a new section.
local function create_section(section, name, action)
  return { section = section, name = name, action = action }
end

local function pick_help()
  require("mini.pick").builtin.help()
  vim.cmd.wincmd({ "o" })
end

function M.setup()
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
  local version_str = string.format("v%s.%s.%s", ver.major, ver.minor, ver.patch)
  if ver.prerelease then version_str = version_str .. "-" .. ver.prerelease end
  if ver.build and ver.build ~= vim.NIL then version_str = version_str .. "+" .. ver.build end
  local footer = version_str

  local local_config = "~/.local/config/nvim/lua/local/init.lua"

  local starter = require("mini.starter")
  local minipick = require("mini.pick")

  local opts = {
    evaluate_single = true,
    header = logo,
    items = {
      -- Edit actions
      create_section("Workspace", "Edit", "enew | startinsert "),
      create_section("Workspace", "Open", "Pick files"),
      create_section("Workspace", "Recent", "Pick oldfiles"),
      create_section("Workspace", "Files", "lua require'mini.files'.open()"),

      -- Config
      create_section("Config", "Config", "edit $MYVIMRC"),
      create_section("Config", "Config Local", "edit " .. local_config),
      create_section("Config", "Update Plugins", "DepsUpdate"),
      create_section("Config", "Mason", "Mason"),

      -- Dotfiles
      create_section(
        "Dotfiles",
        "Dotfiles",
        function() minipick.builtin.files({}, { source = { cwd = "~/.dotfiles" } }) end
      ),
      create_section(
        "Dotfiles",
        "Dotfiles Local",
        function() minipick.builtin.files({}, { source = { cwd = "~/.local/config" } }) end
      ),

      -- Builtin actions
      create_section("Built-in", "News", "help news | wincmd o"),
      create_section("Built-in", "Help", pick_help),
      create_section("Built-in", "Quit", "quit"),
    },
    footer = footer,
    content_hooks = {
      starter.gen_hook.adding_bullet("❭ ", false),
      starter.gen_hook.aligning("center", "center"),
    },
  }

  require("mini.starter").setup(opts)
end

return M
