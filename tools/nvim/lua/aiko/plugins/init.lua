local M = {}

M.plugins = function(use)
  -- Have packer manage itself
  use("wbthomason/packer.nvim")
  use("lewis6991/impatient.nvim")
  use("nvim-lua/plenary.nvim")

  -- ------------------
  -- |   LSP Config   |
  -- ------------------
  use({
    {
      "neovim/nvim-lspconfig",
      config = function()
        require("aiko.plugins.configs.lspconfig").setup()
      end,
    },
    {
      "williamboman/nvim-lsp-installer",
    }
  })

  -- -----------------
  -- |   Telescope   |
  -- -----------------
  use({
    {
      "nvim-telescope/telescope.nvim",
      cmd = "Telescope",
      module = "telescope",
      requires = {
        "nvim-lua/plenary.nvim",
        "telescope-fzf-native.nvim",
        "benfowler/telescope-luasnip.nvim",
      },
      config = function()
        require("aiko.plugins.configs.telescope").setup()
      end,
    },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      run = "make",
    },
    {
      "benfowler/telescope-luasnip.nvim",
      -- module = "telescope._extensions.luasnip",
    },
  })

  -- -------------------
  -- |   Tree-Sitter   |
  -- -------------------
  use({
    {
      "nvim-treesitter/nvim-treesitter",
      event = { "BufRead", "BufNewFile" },
      requires = {
        "nvim-treesitter/nvim-treesitter-refactor",
      },
      config = function()
        require("aiko.plugins.configs.treesitter").setup()
      end,
      run = ":TSUpdate",
    },
    "nvim-treesitter/nvim-treesitter-refactor",
    after = "nvim-treesitter",
  })

  -- Refactoring support for select languages.
  use({
    "ThePrimeagen/refactoring.nvim",
    after = "nvim-treesitter",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    config = function()
      require("aiko.plugins.configs.refactoring").setup()
    end,
  })

  -- Enable correct spelling syntax highlighting with Tree-sitter.
  use({
    "lewis6991/spellsitter.nvim",
    after = "nvim-treesitter",
    config = function()
      require("spellsitter").setup({
        enable = true,
      })
    end,
  })

  -- Fancy UI which replaces vim.ui.select and vim.ui.input.
  use({ "stevearc/dressing.nvim" })

  -- ---------------------
  -- |   Code Snippets   |
  -- ---------------------
  use({
    {
      "rafamadriz/friendly-snippets",
      event = { "InsertEnter", "CmdlineEnter" },
      module = "nvim_cmp_lsp",
    },
    {
      "L3MON4D3/luasnip",
      after = "nvim-cmp",
      requires = {
        "friendly-snippets",
      },
      config = function()
        require("aiko.plugins.configs.luasnip").setup()
      end,
    },
  })

  -- ------------------
  -- |   Completion   |
  -- ------------------
  --
  -- These are all loaded after friendly snippets.
  use({
    {
      "hrsh7th/nvim-cmp",
      after = "friendly-snippets",
      requires = {
        -- Completion sources for nvim-cmp
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-omni",
        "saadparwaiz1/cmp_luasnip",
        "onsails/lspkind.nvim",
      },
      config = function()
        require("aiko.plugins.configs.cmp").setup()
      end,
    },
    {
      "hrsh7th/cmp-nvim-lua",
      after = "nvim-cmp",
    },
    {
      "hrsh7th/cmp-nvim-lsp",
      after = "nvim-cmp",
    },
    {
      "hrsh7th/cmp-buffer",
      after = "nvim-cmp",
    },
    {
      "hrsh7th/cmp-path",
      after = "nvim-cmp",
    },
    {
      "hrsh7th/cmp-cmdline",
      after = "nvim-cmp",
    },
    {
      "hrsh7th/cmp-omni",
      after = "nvim-cmp",
    },
    {
      "saadparwaiz1/cmp_luasnip",
      after = "nvim-cmp",
    },
    {
      "onsails/lspkind.nvim",
      after = "nvim-cmp",
    },
  })

  -- ---------------
  -- |   Comment   |
  -- ---------------
  use({
    "numToStr/Comment.nvim",
    module = "Comment",
    keys = { "gc", "gb" },
    config = function()
      require("aiko.plugins.configs.comment").setup()
    end,
  })

  -- -----------------------
  -- |   General Plugins   |
  -- -----------------------
  --
  -- Nice helper plugins
  use({
    "tpope/vim-repeat",
    "tpope/vim-surround",
    "tpope/vim-vinegar",
    "godlygeek/tabular",
    "christoomey/vim-tmux-navigator",
    {
      "airblade/vim-rooter",
      config = function()
        vim.g.rooter_silent_chdir = 1
      end,
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      event = "BufRead",
      config = function()
        require("aiko.plugins.configs.indent_blankline").setup()
      end,
    },
    {
      "windwp/nvim-autopairs",
      after = "nvim-cmp",
      config = function()
        require("aiko.plugins.configs.autopairs").setup()
      end,
    },
  })

  -- ------------------------
  -- |   Language Add-Ons   |
  -- ------------------------
  --
  -- Git
  use({
    {
      "tpope/vim-fugitive",
      cmd = { "G", "Git" },
    },
    {
      "lewis6991/gitsigns.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("aiko.plugins.configs.gitsigns").setup()
      end,
    },
  })

  -- Python
  use({
    "aikow/python.nvim",
    ft = { "python" },
    config = function()
      local bufname = vim.api.nvim_buf_get_name(0)
      -- Create a buffer local keymap to reformat, using the buffer local
      -- command.
      vim.keymap.set(
        "n",
        "<leader>rf",
        require("python-nvim").format,
        { silent = true, buffer = 0, desc = "reformat python with black and isort" }
      )

      vim.keymap.set("n", "<leader>if", require("python-nvim").flake8, { buffer = 0, desc = "run flake8 linting" })
    end,
  })

  -- Rust
  use({
    {
      "simrat39/rust-tools.nvim",
      ft = { "rust" },
      requires = "neovim/nvim-lspconfig",
      config = function()
        require("aiko.plugins.configs.rusttools").setup()
      end,
    },
    {
      "saecki/crates.nvim",
      ft = { "toml" },
      tag = "v0.1.0",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("aiko.plugins.configs.crates").setup()
      end,
    },
  })

  -- Latex
  use({
    "lervag/vimtex",
    config = function()
      vim.g.tex_flavor = "latex"

      vim.g.vimtex_view_method = "zathura"

      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        build_dir = "build",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        hooks = {},
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }

      vim.api.nvim_create_user_command("LatexSurround", function()
        vim.b["surround" .. vim.fn.char2nr("e")] = [[\\begin{\1environment: \1}\n\t\r\n\\end{\1\1}]]
        vim.b["surround" .. vim.fn.char2nr("c")] = [[\\\1command: \1{\r}]]
      end, { nargs = 0 })
    end,
    ft = { "tex" },
  })
  use({
    "KeitaNakamura/tex-conceal.vim",
    ft = { "tex" },
  })

  -- Markdown
  use({
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = { "markdown" },
    config = function()
      vim.keymap.set("n", "<localleader>r", "<cmd>MarkdownPreview<CR>", { buffer = true, silent = true })
      vim.keymap.set("n", "<localleader>s", "<cmd>MarkdownPreviewStop<CR>", { buffer = true, silent = true })
      vim.keymap.set("n", "<localleader>t", "<cmd>MarkdownPreviewToggle<CR>", { buffer = true, silent = true })
    end,
  })

  -- Fish shell syntax support
  use({
    "dag/vim-fish",
    ft = { "fish" },
  })

  -- Nvim Org mode plugin
  use({
    "nvim-neorg/neorg",
    ft = { "norg" },
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},
          ["core.norg.concealer"] = {},
          ["core.norg.completion"] = {},
        },
      })
    end,
    requires = "nvim-lua/plenary.nvim",
    tag = "*",
  })

  -- --------------------------------
  -- |   Themes and customization   |
  -- --------------------------------
  -- Vim status line
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {},
          always_divide_middle = true,
          globalstatus = false,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "fileformat", "filetype", "encoding" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
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
          lualine_z = {},
        },
        extensions = {},
      })
    end,
  })

  -- ---------------------
  -- |   Color Schemes   |
  -- ---------------------
  use({
    "joshdick/onedark.vim",
    "arcticicestudio/nord-vim",
    "sainnhe/gruvbox-material",
  })
end

return M
