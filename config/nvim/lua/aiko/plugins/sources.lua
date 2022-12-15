return {
  -- Have packer manage itself.
  ["wbthomason/packer.nvim"] = {},

  -- Plenary provides helper functions.
  ["nvim-lua/plenary.nvim"] = { module = "plenary" },

  -- Improve startup time.
  ["lewis6991/impatient.nvim"] = {},

  -- -----------------------------
  -- |   Mason Package Manager   |
  -- -----------------------------
  --
  -- Easily install any LSP, DAP, linter, or formatter from inside neovim.
  ["williamboman/mason.nvim"] = {
    opt = true,
    cmd = require("aiko.plugins.lazy").mason_cmds,
    setup = function()
      require("aiko.plugins.lazy").on_file_open("mason.nvim")
    end,
  },

  -- Manage LSP servers with mason.nvim.
  ["williamboman/mason-lspconfig.nvim"] = {
    after = "mason.nvim",
    config = function()
      require("aiko.plugins.configs.mason").setup()
    end,
  },

  -- ------------------
  -- |   LSP Config   |
  -- ------------------
  --
  -- Provide adapter and helper functions for setting up language servers.
  ["neovim/nvim-lspconfig"] = {
    after = "mason-lspconfig.nvim",
    config = function()
      require("aiko.plugins.configs.lspconfig").setup()
    end,
  },

  -- Hook into the builtin LSP features.
  ["jose-elias-alvarez/null-ls.nvim"] = {
    opt = true,
    setup = function()
      require("aiko.plugins.lazy").on_file_open("null-ls.nvim")
    end,
    config = function()
      require("aiko.plugins.configs.null-ls").setup()
    end,
  },

  -- A tree like view for symbols using LSP.
  ["simrat39/symbols-outline.nvim"] = {
    module = "symbols-outline",
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
    config = function()
      require("aiko.plugins.configs.symbols-outline").setup()
    end,
  },

  -- Add icons to native LSP based on the completion type.
  ["onsails/lspkind.nvim"] = {
    module = "lspkind",
  },

  -- -----------------
  -- |   Debugging   |
  -- -----------------
  --
  -- Debug adapter protocol.
  ["mfussenegger/nvim-dap"] = {
    disable = true,
    module = "dap",
    keys = "<F5>",
    config = function()
      require("aiko.plugins.configs.dap").setup()
    end,
  },

  -- UI elements for nvim-dap.
  ["rcarriga/nvim-dap-ui"] = {
    disable = true,
    after = "nvim-dap",
    config = function()
      require("dapui").setup()
    end,
  },

  -- Insert virtual text during debugging for variable values.
  ["theHamsta/nvim-dap-virtual-text"] = {
    disable = true,
    after = "nvim-dap",
    config = function()
      require("nvim-dap-virtual-text").setup({})
    end,
  },

  -- DAP configuration for python.
  ["mfussenegger/nvim-dap-python"] = {
    disable = true,
    after = "nvim-dap",
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

  ["ibhagwan/fzf-lua"] = {
    cmd = "FzfLua",
    module = "fzf-lua",
  },

  -- -------------------
  -- |   Tree-Sitter   |
  -- -------------------
  --
  -- Neovim treesitter helper, which enables a lot of cool functionality based
  -- on treesitter.
  ["nvim-treesitter/nvim-treesitter"] = {
    -- event = { "BufRead", "BufNewFile" },
    -- module = "nvim-treesitter",
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

  ["nvim-treesitter/playground"] = {
    after = "nvim-treesitter",
  },

  -- -- Refactoring support for select languages.
  -- ["ThePrimeagen/refactoring.nvim"] = {
  --   ft = require("aiko.plugins.lazy").refactoring_filetypes,
  --   module = "refactoring",
  --   config = function()
  --     require("aiko.plugins.configs.refactoring").setup()
  --   end,
  -- },

  -- -------------------------
  -- |   Neovim Tree Views   |
  -- -------------------------
  --
  -- File tree in a sidebar.
  ["kyazdani42/nvim-tree.lua"] = {
    cmd = { "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeFocus" },
    config = function()
      require("aiko.plugins.configs.nvim-tree").setup()
    end,
  },

  -- Enhance vim's builtin netrw plugin.
  ["tpope/vim-vinegar"] = {},

  -- ---------------------
  -- |   Code Snippets   |
  -- ---------------------
  --
  -- VS Code style snippets that can be loaded by luasnip.
  ["rafamadriz/friendly-snippets"] = {},

  -- Lua snippet engine.
  ["L3MON4D3/luasnip"] = {
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

  -- Completions for Neovim's lua API.
  ["hrsh7th/cmp-nvim-lua"] = {
    after = "nvim-cmp",
  },

  -- Completions from the builtin LSP.
  ["hrsh7th/cmp-nvim-lsp"] = {
    after = "nvim-cmp",
    module = "cmp_nvim_lsp",
  },

  -- Completions from words in the current buffer.
  ["hrsh7th/cmp-buffer"] = {
    after = "nvim-cmp",
  },

  -- Completions for file-system paths.
  ["hrsh7th/cmp-path"] = {
    after = "nvim-cmp",
  },

  -- Completions for the command line.
  ["hrsh7th/cmp-cmdline"] = {
    after = "nvim-cmp",
  },

  -- Completions from the builtin omni completion.
  ["hrsh7th/cmp-omni"] = {
    after = "nvim-cmp",
  },

  -- Completion source for luasnip snippets.
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
      require("aiko.plugins.configs.todo-comments").setup()
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
    config = function()
      require("aiko.plugins.configs.indent-blankline").setup()
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
    cmd = "Tabularize",
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

  ["folke/neoconf.nvim"] = {
    disable = true,
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
  -- Rust
  ["simrat39/rust-tools.nvim"] = {
    ft = "rust",
    config = function()
      require("aiko.plugins.configs.rust-tools").setup()
    end,
  },

  -- Cargo.toml files and interacting with `crates.io`.
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

  -- SQL language server helper.
  ["nanotee/sqls.nvim"] = {
    disable = true,
    module = "sqls",
    ft = "sql",
  },

  -- Justfile support with tree-sitter.
  ["IndianBoy42/tree-sitter-just"] = {
    -- config = function ()
    --   require("tree-sitter-just").setup({})
    -- end
  },

  -- Lua
  ["rafcamlet/nvim-luapad"] = {
    cmd = { "Luapad", "LuaRun" },
  },

  -- Neovim development with lua.
  ["folke/neodev.nvim"] = {
    disable = true,
  },

  -- Markdown
  ["iamcco/markdown-preview.nvim"] = {
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = "markdown",
  },

  -- Fish shell syntax support.
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

  -- Connect to databases inside Neovim
  ["tpope/vim-dadbod"] = {
    ft = { "sql", "msql", "mysql", "plsql" },
    cmd = "DB",
  },

  -- ------------------
  -- |   Neorg Mode   |
  -- ------------------
  --
  -- Neorg integrations with `telescope.nvim`.
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
  -- Statusline, winbar.
  ["nvim-lualine/lualine.nvim"] = {
    disable = true,
    config = function()
      require("aiko.plugins.configs.lualine").setup()
    end,
  },

  -- Override neovim default UI components for user input.
  ["stevearc/dressing.nvim"] = {
    config = function()
      require("aiko.plugins.configs.dressing").setup()
    end,
  },

  -- LSP based location for status-line.
  ["SmiteshP/nvim-navic"] = {
    module = "nvim-navic",
    config = function()
      vim.g.navic_silence = true
    end,
  },

  -- Dev icons for file types.
  ["kyazdani42/nvim-web-devicons"] = {
    module = "nvim-web-devicons",
  },

  -- Focus a single window in zen mode.
  ["folke/zen-mode.nvim"] = {
    cmd = "ZenMode",
    module = "zen-mode",
    config = function()
      require("zen-mode").setup({})
    end,
  },

  -- Render code into pictures with silicon.
  ["krivahtoo/silicon.nvim"] = {
    run = "./install.sh build",
    cmd = "Silicon",
    module = "silicon",
    config = function()
      require("silicon").setup({
        font = "FiraCode=20",
        theme = "Monokai Extended",
      })
    end,
  },

  -- ---------------------
  -- |   Color Schemes   |
  -- ---------------------
  --
  -- Current default
  ["sainnhe/gruvbox-material"] = {},
  ["B4mbus/oxocarbon-lua.nvim"] = {},
}
