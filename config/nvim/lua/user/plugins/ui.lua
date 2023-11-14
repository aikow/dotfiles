return {
  {
    "echasnovski/mini.statusline",
    opts = {},
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

      local version_str = vim.fn.execute("version") or ""
      local version = vim.split(version_str, "\n", { trimempty = true })
      local footer = table.concat({
        version[1]:sub(6, -1),
        version[2],
        version[3],
      }, "\n")

      -- Small helper function to create a new section.
      local section = function(name, action, section)
        return { name = name, action = action, section = section }
      end

      local plugins_path = vim.fn.stdpath("data") .. "/lazy/"

      -- Telescope picker is too slow, so just have a simple input textbox ask
      -- for the right man page.
      local man_pages = function()
        vim.ui.input({ prompt = "Man: " }, function(input)
          vim.cmd("Man " .. input)
          vim.cmd.wincmd("o")
        end)
      end

      -- Create a custom function for telescope vim help tags, so that we can
      -- execute wincmd o after selecting a help tag. Telescope does some weird
      -- parsing of the cmdline and running multiple commands in a row doesn't
      -- work.
      local help_tags = function()
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

      local starter = require("mini.starter")
      local config = {
        evaluate_single = true,
        header = logo,
        -- stylua: ignore
        items = {
          -- Edit actions
          section("Empty file", "enew | startinsert ", "Edit"),
          section("Directory", "Telescope find_files", "Edit"),
          section("Workspace", "cd $HOME/workspace | Telescope find_files", "Edit"),
          section("Recent", "Telescope oldfiles", "Edit"),

          -- File actions
          section("Shell", "terminal fish", "Files"),
          section("Files", "lua require'mini.files'.open()", "Files"),
          section("Tree", "Neotree source=filesystem reveal=true position=float", "Files"),

          -- Config and plugin actions
          section("Config", "edit $MYVIMRC | cd %:p:h", "Config"),
          section("Local config", "edit ~/.local/config/nvim/lua/user/local/init.lua | cd %:p:h", "Config"),
          section("Plugins", "Neotree " .. plugins_path, "Config"),
          section("Update plugins", "Lazy sync", "Config"),

          -- Builtin actions
          section("News", "help news | wincmd o", "Built-in"),
          section("Man", man_pages, "Built-in"),
          section("Help", help_tags, "Built-in"),
          section("Quit", "quit", "Built-in"),
        },
        footer = footer,
        content_hooks = {
          starter.gen_hook.adding_bullet("❭ ", false),
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
      require("ibl").setup({
        exclude = {
          filetypes = {
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
          buftypes = {
            "terminal",
          },
        },
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

  -- Dev icons for file types.
  {
    "nvim-tree/nvim-web-devicons",
  },
}
