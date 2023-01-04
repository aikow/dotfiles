return {
  -- Have packer manage itself.
  {
    "folke/lazy.nvim",
  },

  -- Plenary provides helper functions.
  {
    "nvim-lua/plenary.nvim",
  },

  -- -----------------------------
  -- |   Mason Package Manager   |
  -- -----------------------------
  --
  -- Easily install any LSP, DAP, linter, or formatter from inside neovim.
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonLog",
      "MasonUninstall",
      "MasonUninstallAll",
    },
  },

  -- Manage LSP servers with mason.nvim.
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = "mason.nvim",
    config = function()
      require("aiko.plugins.configs.mason").setup()
    end,
  },

  -- ------------------
  -- |   LSP Config   |
  -- ------------------
  --
  -- Provide adapter and helper functions for setting up language servers.
  {
    "neovim/nvim-lspconfig",
    dependencies = "mason-lspconfig.nvim",
    config = function()
      require("aiko.plugins.configs.lspconfig").setup()
    end,
  },

  -- Hook into the builtin LSP features.
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("aiko.plugins.configs.null-ls").setup()
    end,
  },

  -- A tree like view for symbols using LSP.
  {
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
    config = function()
      require("aiko.plugins.configs.symbols-outline").setup()
    end,
  },

  -- Add icons to native LSP based on the completion type.
  {
    "onsails/lspkind.nvim",
  },

  -- -----------------
  -- |   Debugging   |
  -- -----------------
  --
  -- Debug adapter protocol.
  {
    "mfussenegger/nvim-dap",
    enabled = false,
    keys = "<F5>",
    config = function()
      require("aiko.plugins.configs.dap").setup()
    end,
  },

  -- UI elements for nvim-dap.
  {
    "rcarriga/nvim-dap-ui",
    enabled = false,
    dependencies = "nvim-dap",
    config = function()
      require("dapui").setup()
    end,
  },

  -- Insert virtual text during debugging for variable values.
  {
    "theHamsta/nvim-dap-virtual-text",
    enabled = false,
    dependencies = "nvim-dap",
    config = function()
      require("nvim-dap-virtual-text").setup({})
    end,
  },

  -- DAP configuration for python.
  {
    "mfussenegger/nvim-dap-python",
    enabled = false,
    dependencies = "nvim-dap",
    config = function()
      require("dap-python").setup(
        "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      )
    end,
  },

  -- -----------------
  -- |   Telescope   |
  -- -----------------
  --
  -- Find, filter, and search pretty much anything.
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      "benfowler/telescope-luasnip.nvim",
    },
    config = function()
      require("aiko.plugins.configs.telescope").setup()
    end,
  },

  -- Native C FZF implementation for searching.
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },

  -- Search luasnip snippets with telescope.
  {
    "benfowler/telescope-luasnip.nvim",
  },

  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
  },

  -- -------------------
  -- |   Tree-Sitter   |
  -- -------------------
  --
  -- Neovim treesitter helper, which enables a lot of cool functionality based
  -- on treesitter.
  {
    "nvim-treesitter/nvim-treesitter",
    -- event = { "BufRead", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      require("aiko.plugins.configs.treesitter").setup()
    end,
  },

  -- Tree-sitter text objects like classes and functions.
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter",
  },

  -- Tree-sitter buffer-local refactorings.
  {
    "nvim-treesitter/nvim-treesitter-refactor",
    dependencies = "nvim-treesitter",
  },

  {
    "nvim-treesitter/playground",
    dependencies = "nvim-treesitter",
  },

  -- Refactoring support for select languages.
  {
    "ThePrimeagen/refactoring.nvim",
    ft = {
      "typescript",
      "javascript",
      "lua",
      "c",
      "cpp",
      "go",
      "python",
      "java",
      "php",
    },
    config = function()
      require("aiko.plugins.configs.refactoring").setup()
    end,
  },

  -- -------------------------
  -- |   Neovim Tree Views   |
  -- -------------------------
  --
  -- File tree in a sidebar.
  {
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeFocus" },
    config = function()
      require("aiko.plugins.configs.nvim-tree").setup()
    end,
  },

  -- Enhance vim's builtin netrw plugin.
  {
    "tpope/vim-vinegar",
  },

  -- ---------------------
  -- |   Code Snippets   |
  -- ---------------------
  --
  -- VS Code style snippets that can be loaded by luasnip.
  {
    "rafamadriz/friendly-snippets",
  },

  -- Lua snippet engine.
  {
    "L3MON4D3/luasnip",
    dependencies = { "nvim-cmp", "rafamadriz/friendly-snippets" },
    event = "InsertEnter",
    config = function()
      require("aiko.plugins.configs.luasnip").setup()
    end,
  },

  -- ------------------
  -- |   Completion   |
  -- ------------------
  --
  -- These are all loaded dependencies nvim-cmp.
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-omni",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("aiko.plugins.configs.cmp").setup()
    end,
  },

  -- ---------------
  -- |   Comment   |
  -- ---------------
  --
  -- Comment out lines and blocks.
  {
    "numToStr/Comment.nvim",
    lazy = false,
    config = function()
      require("aiko.plugins.configs.comment").setup()
    end,
  },

  -- Prettify to-do comments.
  {
    "folke/todo-comments.nvim",
    config = function()
      require("aiko.plugins.configs.todo-comments").setup()
    end,
  },

  -- -----------------------
  -- |   General Plugins   |
  -- -----------------------
  --
  -- Use '.' to repeat plugin code actions.
  {
    "tpope/vim-repeat",
  },

  -- Work with parenthesis, quotes, and other text surroundings.
  {
    "kylechui/nvim-surround",
    config = function()
      require("aiko.plugins.configs.surround").setup()
    end,
  },

  -- Show indentation.
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("aiko.plugins.configs.indent-blankline").setup()
    end,
  },

  -- Effortlessly switch between vim and tmux windows.
  {
    "christoomey/vim-tmux-navigator",
    config = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.g.tmux_navigator_disable_when_zoomed = 1
    end,
  },

  -- Align tabular data.
  {
    "godlygeek/tabular",
    cmd = "Tabularize",
    config = function()
      -- Add tabular pattern to parse latex table with multicolumns
      vim.cmd.AddTabularPattern(
        [[latex_table /\v(\&)|(\\multicolumn(\{[^}]*\}){3})@=/]]
      )
    end,
  },

  -- Automatically cd to project root.
  {
    "airblade/vim-rooter",
    config = function()
      vim.g.rooter_patterns = {
        ".editorconfig", -- general editor settings
        ".exrc", -- nvim config
        ".git", -- git
        ".hg", -- mercurial
        ".nvimrc", -- nvim config
        ".svn", -- subversion
        "Cargo.toml", -- rust
        "Makefile", -- c/c++
        "package.json", -- javascript
        "pyproject.toml", -- python
        "setup.cfg", -- python
      }
      vim.g.rooter_silent_chdir = 1
    end,
  },

  {
    "folke/neoconf.nvim",
    enabled = false,
  },

  -- Measure startup time.
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
  },

  -- -----------
  -- |   Git   |
  -- -----------
  --
  -- Using git from inside vim.
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "GBrowse",
      "Gcd",
      "Gclog",
      "GDelete",
      "Gdiffsplit",
      "Gdrop",
      "Gedit",
      "Ggrep",
      "Ghdiffsplit",
      "Git",
      "Glcd",
      "Glgrep",
      "Gllog",
      "GMove",
      "Gpedit",
      "Gread",
      "GRemove",
      "GRename",
      "Gsplit",
      "Gtabedit",
      "GUnlink",
      "Gvdiffsplit",
      "Gvsplit",
      "Gwq",
      "Gwrite",
    },
  },

  -- Git status signs in buffer.
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("aiko.plugins.configs.gitsigns").setup()
    end,
  },

  -- ------------------------
  -- |   Language Add-Ons   |
  -- ------------------------
  --
  -- Rust
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    config = function()
      require("aiko.plugins.configs.rust-tools").setup()
    end,
  },

  -- Cargo.toml files and interacting with `crates.io`.
  {
    "saecki/crates.nvim",
    ft = "toml",
    version = "v0.1.0",
    config = function()
      require("aiko.plugins.configs.crates").setup()
    end,
  },

  -- Latex
  {
    "lervag/vimtex",
    config = function()
      require("aiko.plugins.configs.vimtex").setup()
    end,
    ft = "tex",
  },

  -- SQL language server helper.
  {
    "nanotee/sqls.nvim",
    enabled = false,
    ft = "sql",
  },

  -- Justfile support with tree-sitter.
  {
    "IndianBoy42/tree-sitter-just",
    config = function()
      require("tree-sitter-just").setup({})
    end,
  },

  -- Lua
  {
    "rafcamlet/nvim-luapad",
    cmd = { "Luapad", "LuaRun" },
  },

  -- Neovim development with lua.
  {
    "folke/neodev.nvim",
    enabled = false,
  },

  -- Markdown
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = "markdown",
  },

  -- Fish shell syntax support.
  {
    "aikow/vim-fish",
    ft = "fish",
  },

  -- Syntax support for nushell.
  {
    "LhKipp/nvim-nu",
    ft = "nu",
  },

  -- CSV helper plugin.
  {
    "chrisbra/csv.vim",
    ft = { "csv", "tsv" },
  },

  -- Connect to databases inside Neovim
  {
    "tpope/vim-dadbod",
    ft = { "sql", "msql", "mysql", "plsql" },
    cmd = "DB",
  },

  -- ------------------
  -- |   Neorg Mode   |
  -- ------------------
  --
  -- Neorg integrations with `telescope.nvim`.
  {
    "nvim-neorg/neorg-telescope",
    dependencies = "telescope",
    ft = "norg",
  },

  -- Nvim Org mode plugin.
  {
    "nvim-neorg/neorg",
    version = "*",
    ft = "norg",
    cmd = "Neorg",
    dependencies = "neorg-telescope",
    config = function()
      require("aiko.plugins.configs.neorg").setup()
    end,
  },

  -- ------------------------------
  -- |   GUI, Themes, and Icons   |
  -- ------------------------------
  --
  -- Statusline, winbar.
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("aiko.plugins.configs.lualine").setup()
    end,
  },

  -- Override neovim default UI components for user input.
  {
    "stevearc/dressing.nvim",
    config = function()
      require("aiko.plugins.configs.dressing").setup()
    end,
  },

  -- LSP based location for status-line.
  {
    "SmiteshP/nvim-navic",
    config = function()
      vim.g.navic_silence = true
    end,
  },

  -- Dev icons for file types.
  {
    "kyazdani42/nvim-web-devicons",
  },

  -- Focus a single window in zen mode.
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = function()
      require("zen-mode").setup({})
    end,
  },

  -- ---------------------
  -- |   Color Schemes   |
  -- ---------------------
  --
  -- Current default
  { "sainnhe/gruvbox-material" },
  { "B4mbus/oxocarbon-lua.nvim" },
}
