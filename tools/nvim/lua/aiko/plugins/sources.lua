return {
  -- Have packer manage itself.
  ["wbthomason/packer.nvim"] = {},

  -- Plenary provides helper functions.
  ["nvim-lua/plenary.nvim"] = { module = "plenary" },

  -- Improve startup time.
  ["lewis6991/impatient.nvim"] = {},

  -- ------------------
  -- |   LSP Config   |
  -- ------------------
  --
  -- Easily install any language server from inside neovim.
  ["williamboman/mason.nvim"] = {
    -- opt = true,
    -- cmd = require("aiko.plugins.lazy").lsp_cmds,
    -- setup = function()
    --   require("aiko.plugins.lazy").on_file_open("mason.nvim")
    -- end,
  },

  -- Provide adapter and helper functions for setting up language servers.
  ["neovim/nvim-lspconfig"] = {
    -- after = "mason.nvim",
    -- module = "lspconfig",
    config = function()
      require("aiko.plugins.configs.lspconfig").setup()
    end,
  },

  -- Debug adapter protocol.
  ["mfussenegger/nvim-dap"] = {
    module = "dap",
    keys = "<F5>",
    config = function()
      require("aiko.plugins.configs.dap").setup()
    end,
  },

  -- Add icons to native LSP based on the completion type.
  ["onsails/lspkind.nvim"] = {
    module = "lspkind",
  },

  -- -----------------
  -- |   Telescope   |
  -- -----------------
  --
  -- Find, filter, and search pretty much anything.
  ["nvim-telescope/telescope.nvim"] = {
    cmd = "Telescope",
    module = "telescope",
    config = function()
      require("aiko.plugins.configs.telescope").setup()
    end,
  },

  -- Native C FZF implementation for searching.
  ["nvim-telescope/telescope-fzf-native.nvim"] = {
    run = "make",
    module = "telescope._extensions.fzf",
  },

  -- Search luasnip snippets with telescope.
  ["benfowler/telescope-luasnip.nvim"] = {
    module = "telescope._extensions.luasnip",
  },

  -- -------------------
  -- |   Tree-Sitter   |
  -- -------------------
  --
  -- Neovim treesitter helper, which enables a lot of cool functionality based
  -- on treesitter.
  ["nvim-treesitter/nvim-treesitter"] = {
    event = { "BufRead", "BufNewFile" },
    module = "nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("aiko.plugins.configs.treesitter").setup()
    end,
  },

  -- Tree-sitter text objects like classes and functions.
  ["nvim-treesitter/nvim-treesitter-textobjects"] = {
    after = "nvim-treesitter",
  },

  -- Tree-sitter buffer-local refactorings.
  ["nvim-treesitter/nvim-treesitter-refactor"] = {
    after = "nvim-treesitter",
  },

  -- Refactoring support for select languages.
  ["ThePrimeagen/refactoring.nvim"] = {
    ft = require("aiko.plugins.lazy").refactoring_filetyps,
    module = "refactoring",
    config = function()
      require("aiko.plugins.configs.refactoring").setup()
    end,
  },

  -- Enable correct spelling syntax highlighting with Tree-sitter.
  ["lewis6991/spellsitter.nvim"] = {
    after = "nvim-treesitter",
    config = function()
      require("spellsitter").setup({
        enable = true,
      })
    end,
  },

  -- -------------------------
  -- |   Neovim Tree Views   |
  -- -------------------------
  --
  -- File tree in a sidebar.
  ["kyazdani42/nvim-tree.lua"] = {
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    module = "nvim-tree",
    config = function()
      require("aiko.plugins.configs.nvimtree").setup()
    end,
  },

  -- View tree structures like file system, git files, buffers, etc.
  ["nvim-neo-tree/neo-tree.nvim"] = {
    branch = "v2.x",
    cmd = "Neotree",
    config = function()
      require("aiko.plugins.configs.neotree").setup()
    end,
  },

  -- Enhance vim's builtin netrw plugin.
  ["tpope/vim-vinegar"] = {},

  -- ---------------------
  -- |   Code Snippets   |
  -- ---------------------
  --
  -- VS Code style snippets that can be loaded by luasnip.
  ["rafamadriz/friendly-snippets"] = {
    module = "cmp_nvim_lsp",
    event = { "InsertEnter", "CmdlineEnter" },
  },

  -- Lua snippet engine.
  ["L3MON4D3/luasnip"] = {
    wants = "friendly-snippets",
    module = "luasnip",
    after = "nvim-cmp",
    config = function()
      require("aiko.plugins.configs.luasnip").setup()
    end,
  },

  -- ------------------
  -- |   Completion   |
  -- ------------------
  --
  -- These are all loaded after nvim-cmp.
  ["hrsh7th/nvim-cmp"] = {
    after = "friendly-snippets",
    config = function()
      require("aiko.plugins.configs.cmp").setup()
    end,
  },
  ["hrsh7th/cmp-nvim-lua"] = {
    after = "nvim-cmp",
  },
  ["hrsh7th/cmp-nvim-lsp"] = {
    after = "nvim-cmp",
  },
  ["hrsh7th/cmp-buffer"] = {
    after = "nvim-cmp",
  },
  ["hrsh7th/cmp-path"] = {
    after = "nvim-cmp",
  },
  ["hrsh7th/cmp-cmdline"] = {
    after = "nvim-cmp",
  },
  ["hrsh7th/cmp-omni"] = {
    after = "nvim-cmp",
  },
  ["saadparwaiz1/cmp_luasnip"] = {
    after = "nvim-cmp",
  },

  -- ---------------
  -- |   Comment   |
  -- ---------------
  --
  -- Comment out lines and blocks.
  ["numToStr/Comment.nvim"] = {
    module = "Comment",
    keys = { "gc", "gb" },
    config = function()
      require("aiko.plugins.configs.comment").setup()
    end,
  },

  -- Prettify to-do comments.
  ["folke/todo-comments.nvim"] = {
    opt = true,
    setup = function()
      require("aiko.plugins.lazy").on_file_open("todo-comments.nvim")
    end,
    config = function()
      require("aiko.plugins.configs.todo").setup()
    end,
  },

  -- -----------------------
  -- |   General Plugins   |
  -- -----------------------
  --
  -- Use '.' to repeat plugin code actions.
  ["tpope/vim-repeat"] = {},

  -- Work with parenthesis, quotes, and other text surroundings.
  ["kylechui/nvim-surround"] = {
    config = function()
      require("aiko.plugins.configs.surround").setup()
    end,
  },

  -- Show indentation.
  ["lukas-reineke/indent-blankline.nvim"] = {
    opt = true,
    setup = function()
      require("aiko.plugins.lazy").on_file_open("indent-blankline.nvim")
    end,
    config = function()
      require("aiko.plugins.configs.indent_blankline").setup()
    end,
  },

  -- Effortlessly switch between vim and tmux windows.
  ["christoomey/vim-tmux-navigator"] = {
    config = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.g.tmux_navigator_disable_when_zoomed = 1
    end,
  },

  -- Align tabular data.
  ["godlygeek/tabular"] = {
    cmd = { "Tabular", "Tabularize" },
    config = function()
      -- Add tabular pattern to parse latex table with multicolumns
      vim.cmd.AddTabularPattern(
        [[latex_table /\v(\&)|(\\multicolumn(\{[^}]*\}){3})@=/]]
      )
    end,
  },

  -- Automatically cd to project root.
  ["airblade/vim-rooter"] = {
    config = function()
      vim.g.rooter_silent_chdir = 1
    end,
  },

  -- Measure startup time.
  ["dstein64/vim-startuptime"] = {
    cmd = "StartupTime",
  },

  -- -----------
  -- |   Git   |
  -- -----------
  --
  -- Using git from inside vim.
  ["tpope/vim-fugitive"] = {
    cmd = require("aiko.plugins.lazy").fugitive_cmds,
  },

  -- Git status signs in buffer.
  ["lewis6991/gitsigns.nvim"] = {
    config = function()
      require("aiko.plugins.configs.gitsigns").setup()
    end,
  },

  -- ------------------------
  -- |   Language Add-Ons   |
  -- ------------------------
  --
  -- Python
  ["aikow/python.nvim"] = {
    ft = "python",
  },

  -- Rust
  ["simrat39/rust-tools.nvim"] = {
    ft = "rust",
    config = function()
      require("aiko.plugins.configs.rusttools").setup()
    end,
  },
  ["saecki/crates.nvim"] = {
    module = "crates",
    ft = "toml",
    tag = "v0.1.0",
    config = function()
      require("aiko.plugins.configs.crates").setup()
    end,
  },

  -- Latex
  ["lervag/vimtex"] = {
    config = function()
      require("aiko.plugins.configs.vimtex").setup()
    end,
    ft = "tex",
  },

  -- Markdown
  ["iamcco/markdown-preview.nvim"] = {
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = "markdown",
  },

  -- Fish shell syntax support
  ["aikow/vim-fish"] = {
    ft = "fish",
  },

  -- Syntax support for nushell.
  ["LhKipp/nvim-nu"] = {
    ft = "nu",
  },

  -- CSV helper plugin.
  ["chrisbra/csv.vim"] = {
    ft = { "csv", "tsv" },
  },

  -- ------------------
  -- |   Neorg Mode   |
  -- ------------------
  --
  -- Neorg integrations with telescope.nvim
  ["nvim-neorg/neorg-telescope"] = {
    ft = "norg",
  },

  -- Nvim Org mode plugin.
  ["nvim-neorg/neorg"] = {
    tag = "*",
    ft = "norg",
    cmd = "Neorg",
    after = "neorg-telescope",
    config = function()
      require("aiko.plugins.configs.neorg").setup()
    end,
  },

  -- ------------------------------
  -- |   GUI, Themes, and Icons   |
  -- ------------------------------
  --
  -- New UI components.
  ["MunifTanjim/nui.nvim"] = {
    module = "nui",
  },

  -- Override neovim default UI components
  ["stevearc/dressing.nvim"] = {
    config = function()
      require("aiko.plugins.configs.dressing").setup()
    end,
  },

  -- Status-line plugin.
  ["nvim-lualine/lualine.nvim"] = {
    config = function()
      require("aiko.plugins.configs.lualine").setup()
    end,
  },

  -- LSP based location for status-line.
  ["SmiteshP/nvim-navic"] = {
    module = "nvim-navic",
  },

  -- Dev icons for file types.
  ["kyazdani42/nvim-web-devicons"] = {
    module = "nvim-web-devicons",
  },

  -- ---------------------
  -- |   Color Schemes   |
  -- ---------------------
  --
  -- Color and colorscheme helper.
  ["rktjmp/lush.nvim"] = {
    module = "lush",
  },

  -- Current default
  ["sainnhe/gruvbox-material"] = {
    -- event = "ColorSchemePre",
    config = function()
      require("aiko.plugins.configs.colorschemes").gruvbox_material()
    end,
  },

  ["navarasu/onedark.nvim"] = {
    event = "ColorSchemePre",
    config = function()
      require("onedark").setup({
        style = "warm",
      })
    end,
  },

  ["catppuccin/nvim"] = {
    as = "catppuccin",
    run = ":CatppuccinCompile",
    event = "ColorSchemePre",
    config = function()
      require("aiko.plugins.configs.colorschemes").catppuccin()
    end,
  },

  ["marko-cerovac/material.nvim"] = {
    event = "ColorSchemePre",
    config = function()
      require("aiko.plugins.configs.colorschemes").material()
    end,
  },

  ["folke/tokyonight.nvim"] = {
    event = "ColorSchemePre",
  },
}
