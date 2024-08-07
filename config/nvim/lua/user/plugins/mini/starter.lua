local M = {}

-- Telescope picker is too slow, so just have a simple input textbox ask
-- for the right man page.
local function man_pages()
  vim.ui.input({ prompt = "Man: " }, function(input)
    vim.cmd.Man({ input })
    vim.cmd.wincmd("o")
  end)
end

-- Create a custom function for telescope vim help tags, so that we can
-- execute wincmd o after selecting a help tag. Telescope does some weird
-- parsing of the cmdline and running multiple commands in a row doesn't
-- work.
local function help_tags()
  -- Load all plugins first
  local lazy = require("lazy")
  local plugins = {}
  for _, p in ipairs(lazy.plugins()) do
    table.insert(plugins, p.name)
  end
  lazy.load({ plugins = plugins })

  require("telescope.builtin").help_tags({
    attach_mappings = function(_, map)
      map({ "i", "n" }, "<CR>", function(prompt_bufnr)
        require("telescope.actions").select_default(prompt_bufnr)
        vim.cmd.wincmd("o")
      end)

      return true
    end,
  })
end

-- Small helper function to create a new section.
local function section(section, name, action)
  return { section = section, name = name, action = action }
end

function M.opts()
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
  if ver.build then version_str = version_str .. "+" .. ver.build end
  local footer = version_str

  local local_config = "~/.local/config/nvim/lua/local/init.lua"

  local starter = require("mini.starter")
  local config = {
    evaluate_single = true,
    header = logo,
    items = {
      -- Edit actions
      section("Workspace", "Edit", "enew | startinsert "),
      section("Workspace", "Open", "Telescope find_files"),
      section("Workspace", "Recent", "Telescope oldfiles"),
      section("Workspace", "Files", "lua require'mini.files'.open()"),

      -- Config and plugin actions
      section("Config", "Config", "edit $MYVIMRC"),
      section("Config", "System Config", "edit " .. local_config),
      section("Config", "Update Plugins", "Lazy sync"),

      -- Dotfiles
      section("Dotfiles", "Dotfiles", "Telescope find_files cwd=~/.dotfiles"),
      section("Dotfiles", "Local", "Telescope find_files cwd=~/.local/config"),

      -- Builtin actions
      section("Built-in", "News", "help news | wincmd o"),
      section("Built-in", "Man", man_pages),
      section("Built-in", "Help", help_tags),
      section("Built-in", "Quit", "quit"),
    },
    footer = footer,
    content_hooks = {
      starter.gen_hook.adding_bullet("❭ ", false),
      starter.gen_hook.aligning("center", "center"),
    },
  }

  return config
end

function M.setup()
  if vim.o.filetype == "lazy" then
    vim.cmd.close()
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniStarterOpened",
      callback = function() require("lazy").show() end,
    })
  end

  local starter = require("mini.starter")
  local opts = M.opts()
  starter.setup(opts)

  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyVimStarted",
    callback = function()
      local stats = require("lazy").stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      starter.config.footer = starter.config.footer
        .. "\n\n"
        .. "Loaded "
        .. stats.loaded
        .. " plugins out of "
        .. stats.count
        .. " in "
        .. ms
        .. "ms"
      pcall(starter.refresh)
    end,
  })
end

return M
