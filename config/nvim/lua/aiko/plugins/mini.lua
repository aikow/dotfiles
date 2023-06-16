return {
  {
    "echasnovski/mini.ai",
    opts = {},
  },

  {
    "echasnovski/mini.align",
    opts = {},
  },

  {
    "echasnovski/mini.bracketed",
    opts = {
      buffer = { suffix = "b" },
      comment = { suffix = "x" },
      conflict = { suffix = "c" },
      diagnostic = { suffix = "" },
      file = { suffix = "f" },
      indent = { suffix = "" },
      jump = { suffix = "" },
      location = { suffix = "l" },
      oldfile = { suffix = "o" },
      quickfix = { suffix = "q" },
      treesitter = { suffix = "t" },
      undo = { suffix = "" },
      window = { suffix = "w" },
      yank = { suffix = "" },
    },
  },
  {
    "echasnovski/mini.comment",
    opts = {},
  },
  {
    "echasnovski/mini.pairs",
    opts = {},
  },
  {
    "echasnovski/mini.splitjoin",
    opts = {
      mappings = {
        toggle = "gS",
      },
    },
  },

  {
    "echasnovski/mini.surround",
    opts = {
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
      n_lines = 40,
      respect_selection_type = true,
      search_method = "cover_or_next",
    },
  },

  {
    "echasnovski/mini.starter",
    event = "VimEnter",
    opts = function()
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

      -- Small helper function to create a new section.
      local section = function(name, action, section)
        return { name = name, action = action, section = section }
      end

      local starter = require("mini.starter")
      local config = {
        evaluate_single = true,
        header = logo,
        items = {
          section("Empty file", "enew | startinsert ", "Edit"),
          section("Terminal", "terminal fish", "Edit"),
          section("Directory", "Telescope find_files", "Edit"),
          section(
            "Workspace",
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
      }

      return config
    end,
    config = function(_, opts)
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "MiniStarterOpened",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      local starter = require("mini.starter")
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
    end,
  },
}
