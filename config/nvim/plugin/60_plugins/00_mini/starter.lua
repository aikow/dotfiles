local H = {}

-- Small helper function to create a new section.
function H.section(section_name, name, action)
  return { section = section_name, name = name, action = action }
end

H.logo = table.concat({
  "                                                  ",
  "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
  "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
  "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
  "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
  "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
  "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
  "                                                  ",
}, "\n")

function H.version()
  local ver = vim.version()
  local s = string.format("v%s.%s.%s", ver.major, ver.minor, ver.patch)
  if ver.prerelease then s = s .. "-" .. ver.prerelease end
  if ver.build and ver.build ~= vim.NIL then s = s .. "+" .. ver.build end
  return s
end

H.edit_config = "cd ~/.dotfiles/config/nvim | edit init.lua"
H.edit_config_local = "cd ~/.local/config/nvim/ | edit after/plugin/local.lua"

function H.diffview()
  vim.ui.input({ prompt = "Diff target" }, function(input)
    if input ~= "" then
      vim.cmd.DiffviewOpen({ args = { input } })
    else
      vim.cmd.DiffviewOpen()
    end
    vim.cmd.tabonly()
  end)
end

safely("now", function()
  local starter = require("mini.starter")

  require("mini.starter").setup({
    evaluate_single = true,
    header = H.logo,
    items = {
      -- Edit actions
      H.section("Workspace", "Edit", "enew | startinsert"),
      H.section("Workspace", "Diff", H.diffview),

      -- Config
      H.section("Config", "Config", H.edit_config),
      H.section("Config", "Local Config", H.edit_config_local),

      -- Builtin actions
      H.section("Builtin", "News", "help news | wincmd o"),
      H.section("Builtin", "Help", "Pick help"),
      H.section("Builtin", "Quit", "quit"),
    },
    footer = H.version(),
    content_hooks = {
      starter.gen_hook.adding_bullet("❭ ", false),
      starter.gen_hook.aligning("center", "center"),
    },
    query_updaters = "abcdefghijklmnopqrstuvwxyz",
  })
end)
