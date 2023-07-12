return {
  -- Statusline, winbar.
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local separators = require("user.ui.icons").separators

      local cwd = function()
        local filename = vim.fs.basename(vim.fn.getcwd())

        return "  " .. filename
      end

      local loc = function()
        local ok_nvim_navic, nvim_navic = pcall(require, "nvim-navic")
        if not ok_nvim_navic then
          return ""
        end

        if nvim_navic.is_available() then
          return nvim_navic.get_location() or ""
        end

        return ""
      end

      local lsp_clients = function()
        return table.concat(
          vim
            .iter(vim.lsp.get_active_clients())
            :map(function(server)
              local name = server.name or ""
              local progress = server.progress:pop()

              -- HACK: Figure out how to get around having to force-clear the
              -- progress messages.
              server.progress:clear()

              if progress and progress.value then
                return string.format(
                  " %%<%s: %s %s (%s%%%%) ",
                  name,
                  progress.value.title or "-",
                  progress.value.message or "-",
                  progress.value.percentage or "x"
                )
              else
                return string.format(" %%<%s ", name)
              end
            end)
            :totable(),
          "|"
        )
      end

      local filesize = function()
        local size = vim.fn.getfsize(vim.fn.getreg("%"))
        local formats = { "B", "KB", "MB", "GB", "TB" }
        local f_idx = 1
        while size > 1024 and f_idx < #formats do
          size = size / 1024
          f_idx = f_idx + 1
        end
        return string.format("%d%s", size, formats[f_idx])
      end

      return {
        options = {
          icons_enabled = true,
          component_separators = separators.block.outline,
          section_separators = "",
          disabled_filetypes = {
            statusline = {},
            winbar = {
              "DressingInput",
              "TelescopePreview",
              "TelescopePrompt",
              "TelescopeResults",
              "fzf",
              "help",
              "mason",
              "neo-tree",
              "packer",
              "qf",
              "starter",
            },
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { cwd, "branch" },
          lualine_c = { "diff" },
          lualine_x = { lsp_clients },
          lualine_y = { "diagnostics" },
          lualine_z = { "%c", "%l:%L" },
        },
        tabline = {
          lualine_a = { { "tabs", mode = 2 } },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        winbar = {
          lualine_a = {},
          lualine_b = { "filename" },
          lualine_c = { loc },
          lualine_x = { filesize, "encoding", "fileformat" },
          lualine_y = { "filetype" },
          lualine_z = {},
        },
        inactive_winbar = {
          lualine_a = {},
          lualine_b = { "filename" },
          lualine_c = {},
          lualine_x = { filesize, "encoding", "fileformat" },
          lualine_y = { "filetype" },
          lualine_z = {},
        },
        extensions = {
          "fugitive",
          "man",
          "neo-tree",
          "quickfix",
        },
      }
    end,
    config = function(_, opts)
      local lualine = require("lualine")

      -- Hide the tabline if only one tab is opened.
      vim.api.nvim_create_autocmd({ "VimEnter", "TabNew", "TabClosed" }, {
        group = vim.api.nvim_create_augroup("LualineTab", {}),
        callback = function()
          local show = #vim.api.nvim_list_tabpages() > 1
          vim.o.showtabline = show and 1 or 0
          lualine.hide({
            place = { "tabline" },
            unhide = show,
          })
        end,
      })

      -- Set the lualine theme to auto before loading any colorschemes.
      vim.api.nvim_create_autocmd("ColorschemePre", {
        callback = function()
          require("lualine").setup({ options = { theme = "auto" } })
        end,
      })

      lualine.setup(opts)

      -- Hide the tabline by default.
      lualine.hide({
        place = { "tabline" },
        unhide = false,
      })
    end,
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
          section("Help", "Telescope help_tags", "Built-in"),
          section("Quit", "quit", "Built-in"),
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

  -- Show indentation.
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup({
        filetype_exclude = {
          "",
          "Outline",
          "TelescopePrompt",
          "TelescopeResults",
          "help",
          "lazy",
          "lspinfo",
          "man",
          "mason",
          "norg",
          "starter",
          "terminal",
        },
        buftype_exclude = { "terminal" },
        use_treesitter = false,
        show_trailing_blankline_indent = false,
        show_first_indent_level = false,
        show_current_context = true,
        show_current_context_start = false,
      })
    end,
  },

  -- Override neovim default UI components for user input.
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        insert_only = false,
        start_in_insert = true,
        win_options = {
          winblend = 0,
          winhighlight = "NormalFloat:DiagnosticError",
        },
      },
      select = {
        backend = { "telescope" },
      },
    },
  },

  -- LSP based location for status-line.
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    config = function()
      vim.g.navic_silence = true
    end,
  },

  -- Dev icons for file types.
  {
    "nvim-tree/nvim-web-devicons",
  },
}
