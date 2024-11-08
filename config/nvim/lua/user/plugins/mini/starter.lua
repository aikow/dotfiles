local M = {}

-- Create a custom function for telescope vim help tags, so that we can
-- execute wincmd o after selecting a help tag. Telescope does some weird
-- parsing of the cmdline and running multiple commands in a row doesn't
-- work.
local function help_tags()
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
local function create_section(section, name, action)
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
      create_section("Workspace", "Edit", "enew | startinsert "),
      create_section("Workspace", "Open", "Telescope find_files"),
      create_section("Workspace", "Recent", "Telescope oldfiles"),
      create_section("Workspace", "Files", "lua require'mini.files'.open()"),

      -- Config
      create_section("Config", "Config", "edit $MYVIMRC"),
      create_section("Config", "Config Local", "edit " .. local_config),
      create_section("Config", "Lazy", "Lazy show"),
      create_section("Config", "Mason", "Mason"),

      -- Dotfiles
      create_section("Dotfiles", "Dotfiles", "Telescope find_files cwd=~/.dotfiles"),
      create_section("Dotfiles", "Dotfiles Local", "Telescope find_files cwd=~/.local/config"),

      -- Builtin actions
      create_section("Built-in", "News", "help news | wincmd o"),
      create_section("Built-in", "Help", help_tags),
      create_section("Built-in", "Quit", "quit"),
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
