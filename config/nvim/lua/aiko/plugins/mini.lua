return {
  {
    "echasnovski/mini.nvim",
    version = false,
    opts = {
      align = {},
      comment = {},
      pairs = {},
      splitjoin = {
        mappings = {
          toggle = "gS",
        },
      },
      surround = {
        mappings = {
          add = "gs",
          delete = "ds",
          find = "",
          find_left = "",
          highlight = "gsh",
          replace = "cs",
          update_n_lines = "",
          suffix_last = "l",
          suffix_next = "n",
        },
      },
    },
    config = function(_, opts)
      for mod, o in pairs(opts) do
        require("mini." .. mod).setup(o)
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

      local version =
        vim.split(vim.fn.execute("version"), "\n", { trimempty = true })
      local footer = table.concat({
        version[1]:sub(6, -1),
        version[2],
        version[3],
      }, "\n")
      local section = function(name, action, section)
        return { name = name, action = action, section = section }
      end

      local starter = require("mini.starter")
      local config = {
        evaluate_single = true,
        header = logo,
        items = {
          section("Empty file", "enew | startinsert ", "Edit"),
          section(
            "Find file",
            "cd $HOME/workspace | Telescope find_files",
            "Edit"
          ),
          section("Recent", "Telescope oldfiles", "Edit"),
          section("Config", "edit $MYVIMRC | cd %:p:h", "Config"),
          section("Update plugins", "Lazy sync", "Config"),
          section("News", "help news | wincmd o", "Built-in"),
          section("Quit", "qa", "Built-in"),
        },
        footer = footer,
        content_hooks = {
          starter.gen_hook.adding_bullet("░ ", false),
          starter.gen_hook.aligning("center", "center"),
        },
        silent = true,
      }

      require("mini.starter").setup(config)
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          print(vim.inspect(stats))
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
    end,
  },
}
