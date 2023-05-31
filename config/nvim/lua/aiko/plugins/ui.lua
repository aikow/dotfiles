return {
  -- Statusline, winbar.
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      local separators = require("aiko.ui.icons").separators
      local lualine = require("lualine")

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

      local lsp_progress = function()
        local lsp = vim.lsp.util.get_progress_messages()[1]
        if lsp then
          local name = lsp.name or ""
          local msg = lsp.message or ""
          local percentage = lsp.percentage or 0
          local title = lsp.title or ""
          return string.format(
            " %%<%s: %s %s (%s%%%%) ",
            name,
            title,
            msg,
            percentage
          )
        end

        local clients = vim.lsp.get_active_clients()
        if clients then
          local names = {}
          for _, client in pairs(clients) do
            table.insert(names, client.name)
          end
          return table.concat(names, ", ")
        end

        return ""
      end

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

      lualine.setup({
        options = {
          icons_enabled = true,
          component_separators = separators.round.outline,
          section_separators = separators.round.fill,
          disabled_filetypes = {
            statusline = {},
            winbar = {
              "DressingInput",
              "NvimTree",
              "TelescopePreview",
              "TelescopePrompt",
              "TelescopeResults",
              "alpha",
              "fzf",
              "help",
              "mason",
              "neo-tree",
              "packer",
              "qf",
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
          lualine_x = { lsp_progress },
          lualine_y = { "diagnostics" },
          lualine_z = { "%l:%c", "%L" },
        },

        tabline = {
          lualine_a = {
            {
              "tabs",
              max_length = vim.o.columns / 3,
              mode = 2,
            },
          },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {
            {
              "windows",
              max_length = function()
                return vim.o.columns / 3
              end,
              filetype_names = {
                NvimTree = "NvimTree",
                alpha = "Alpha",
              },
              disabled_buftypes = { "quickfix", "prompt", "NvimTree" },
            },
          },
        },
        winbar = {
          lualine_a = {},
          lualine_b = { "filename" },
          lualine_c = { loc },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = {},
          lualine_z = {},
        },
        inactive_winbar = {
          lualine_a = {},
          lualine_b = { "filename" },
          lualine_c = { loc },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = {
          "fugitive",
          "man",
          "neo-tree",
          "quickfix",
          "toggleterm",
        },
      })

      -- Hide the tabline by default.
      lualine.hide({
        place = { "tabline" },
        unhide = false,
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
          "NvimTree",
          "Outline",
          "TelescopePrompt",
          "TelescopeResults",
          "alpha",
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
    config = function()
      local dressing = require("dressing")

      dressing.setup({
        input = {
          insert_only = false,
          start_in_insert = true,
          win_options = {
            winhighlight = "NormalFloat:DiagnosticError",
          },
        },
        select = {
          backend = { "telescope" },
        },
      })
    end,
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
