local M = {}

M.use = function(use)
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
      requires = { "williamboman/nvim-lsp-installer" },
      config = function()
        require("aiko.plugins.configs.lsp").setup()
      end,
    },
    {
      "williamboman/nvim-lsp-installer",
    },
    {
      "mfussenegger/nvim-dap",
      module = { "dap" },
      config = function()
        require("aiko.plugins.configs.dap").setup()
      end,
    },
  })

  -- -----------------
  -- |   Telescope   |
  -- -----------------
  use({
    {
      "nvim-telescope/telescope.nvim",
      cmd = "Telescope",
      module = "telescope",
      fn = { "vim.ui.select", "vim.ui.input" },
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
    },
  })

  -- -------------------
  -- |   Tree-Sitter   |
  -- -------------------
  use({
    {
      "nvim-treesitter/nvim-treesitter",
      event = { "BufRead", "BufNewFile" },
      module = { "nvim-treesitter" },
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
    ft = { "typescript", "javascript", "lua", "c", "cpp", "go", "python", "java", "php" },
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
    -- Use '.' to repeat plugin code actions.
    "tpope/vim-repeat",

    -- Work with parenthesis, quotes, and other text surroundings.
    "tpope/vim-surround",

    -- Improve netrw built-in plugin.
    "tpope/vim-vinegar",

    -- Effortlessly switch between vim and tmux windows.
    {
      "christoomey/vim-tmux-navigator",
      config = function()
        vim.g.tmux_navigator_no_mappings = 1
        vim.g.tmux_navigator_disable_when_zoomed = 1
      end,
    },
    {
      "godlygeek/tabular",
      cmd = { "Tabular", "Tabularize" },
      config = function()
        -- Add tabular pattern to parse latex table with multicolumns
        vim.cmd([[
          AddTabularPattern latex_table /\v(\&)|(\\multicolumn(\{[^}]*\}){3})@=/
        ]])
      end,
    },
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
      "dstein64/vim-startuptime",
      cmd = "StartupTime",
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
      cmd = { "G", "Git", "Gdiffsplit", "Gvdiffsplit", "Ghdiffsplit", "G*" },
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

  -- Markdown
  use({
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = { "markdown" },
    config = function()
      vim.keymap.set(
        "n",
        "<localleader>r",
        "<cmd>MarkdownPreview<CR>",
        { buffer = true, silent = true }
      )
      vim.keymap.set(
        "n",
        "<localleader>s",
        "<cmd>MarkdownPreviewStop<CR>",
        { buffer = true, silent = true }
      )
      vim.keymap.set(
        "n",
        "<localleader>t",
        "<cmd>MarkdownPreviewToggle<CR>",
        { buffer = true, silent = true }
      )
    end,
  })

  -- Fish shell syntax support
  use({
    "dag/vim-fish",
    ft = { "fish" },
  })

  -- CSV helper plugin.
  use({
    "chrisbra/csv.vim",
    ft = { "csv", "tsv" },
  })

  -- Nvim Org mode plugin.
  use({
    "nvim-neorg/neorg",
    ft = { "norg" },
    config = function()
      require("aiko.plugins.configs.neorg").setup()
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
      require("aiko.plugins.configs.lualine").setup()
    end,
  })
  use({
    "stevearc/dressing.nvim",
    requires = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("aiko.plugins.configs.dressing").setup()
    end,
  })

  -- ---------------------
  -- |   Color Schemes   |
  -- ---------------------
  use({
    {
      "navarasu/onedark.nvim",
      config = function()
        require("onedark").setup({
          style = "darker",
        })
        vim.cmd([[colorscheme onedark]])
      end,
    },
    "sainnhe/gruvbox-material",
  })
end

return M
