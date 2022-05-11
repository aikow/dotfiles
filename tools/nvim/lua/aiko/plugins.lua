vim.cmd([[packadd packer.nvim]])
vim.cmd([[packadd vimball]])

-- Convenience definitions.
local fn = vim.fn

-- For bootstrapping packer local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
  vim.notify("Bootstrapping packer")
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end

-- =========================
-- |=======================|
-- ||                     ||
-- ||   Include Plugins   ||
-- ||                     ||
-- |=======================|
-- =========================

local packer = require("packer")
local plugins = packer.startup(function(use)
  -- Have packer manage itself
  use("wbthomason/packer.nvim")

  -- ---------------------------------------
  -- |   Language Servers and Completion   |
  -- ---------------------------------------
  --
  -- LSP server for neovim
  use("neovim/nvim-lspconfig")

  -- Completion framework
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      -- Completion sources for nvim-cmp
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-omni",
      "quangnguyen30192/cmp-nvim-ultisnips",
      "onsails/lspkind.nvim",
    },
  })

  -- --------------------------------
  -- |   Telescope and Treesitter   |
  -- --------------------------------
  -- Search
  use({
    {
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        "telescope-fzf-native.nvim",
        "fhill2/telescope-ultisnips.nvim",
      },
      config = require("aiko.telescope.config").setup,
    },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      run = "make",
    },
  })

  use({
    "nvim-treesitter/nvim-treesitter",
    requires = {
      "nvim-treesitter/nvim-treesitter-refactor",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Ensure that all maintained languages are always installed.
        ensure_installed = "all",
        sync_install = false,
        -- Allow incremental selection using Treesitter code regions.
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<leader>v",
            scope_incremental = "<C-l>",
            node_incremental = "<C-k>",
            node_decremental = "<C-j>",
          },
        },
        -- Enable Treesitter syntax highlighting.
        highlight = {
          enable = true,
          -- Disable tree-sitter syntax highlighting for tex files, since
          -- vimtex depends on its own syntax highlighting for some features.
          disable = { "latex" },
          additional_vim_regex_highlighting = "latex",
        },
        refactor = {
          highlight_definitions = {
            enable = true,
            clear_on_custor_move = true,
          },
          smart_rename = {
            enable = true,
            keymaps = {
              smart_rename = "<leader>rr",
            },
          },
        },
      })
    end,
    run = ":TSUpdate",
  })

  -- Refactoring support for select languages.
  use({
    "ThePrimeagen/refactoring.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    config = function()
      -- prompt for a refactor to apply when the remap is triggered
      vim.api.nvim_set_keymap(
        "v",
        "<leader>rq",
        "<cmd>lua require('refactoring').select_refactor()<CR>",
        { noremap = true, silent = true, expr = false }
      )
    end,
  })

  -- Enable correct spelling syntax highlighting with Treesitter.
  use({
    "lewis6991/spellsitter.nvim",
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
  --
  use({
    "sirver/ultisnips",
    config = function()
      vim.g.UltiSnipsExpandTrigger = "<tab>"
      vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
      vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"
    end,
  })

  use({
    "L3MON4D3/luasnip",
  })

  use({
    "numToStr/Comment.nvim",
    config = function()
      local comment = require("Comment")
      comment.setup({
        padding = true,
        sticky = true,
        ignore = nil,
        toggler = {
          line = "gcc",
          block = "gbb",
        },
        opleader = {
          line = "gc",
          block = "gb",
        },
        extra = {
          above = "gcO",
          below = "gco",
          eol = "gcA",
        },
        mappings = {
          basic = true,
          extra = true,
          extended = false,
        },
      })
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
    "airblade/vim-rooter",
    {
      "junegunn/fzf.vim",
      config = function()
        vim.g.fzf_history_dir = vim.fn.expand("~/.local/share/fzf-history")
      end,
    },
  })

  -- ------------------------
  -- |   Language Add-Ons   |
  -- ------------------------
  --
  -- Git
  use({
    { "tpope/vim-fugitive" },
    {
      "lewis6991/gitsigns.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("gitsigns").setup({})
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
      requires = "neovim/nvim-lspconfig",
    },
    {
      "saecki/crates.nvim",
      tag = "v0.1.0",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        local map = vim.keymap.set
        local opts = function(desc)
          return {
            silent = true,
            buffer = true,
            desc = desc or "",
          }
        end

        local crates = require("crates")
        crates.setup()

        map("n", "<localleader>t", crates.toggle, opts("crates toggle menu"))
        map("n", "<localleader>r", crates.reload, opts("crates reload source"))

        map("n", "<localleader>v", crates.show_versions_popup, opts("crates show versions popup"))
        map("n", "<localleader>f", crates.show_features_popup, opts("crates show features popup"))

        -- Update crates
        map("n", "<localleader>u", crates.update_crates, opts("crates update"))
        map("n", "<localleader>U", crates.update_all_crates, opts("crates update all"))
        map("n", "<localleader>g", crates.upgrade_crates, opts("crates upgrade"))
        map("n", "<localleader>G", crates.upgrade_all_crates, opts("crates upgrade all"))
      end,
      ft = { "toml" },
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

  -- Colorschemes
  use({
    "joshdick/onedark.vim",
    "arcticicestudio/nord-vim",
    "sainnhe/gruvbox-material",
  })
end)

-- ------------------------
-- |   Bootstrap Packer   |
-- ------------------------
--
-- Automatically set up the configuration after cloning packer.nvim.
if packer_bootstrap then
  packer.compile()
  packer.sync()
end

-- =================================
-- |===============================|
-- ||                             ||
-- ||   Additional Plugin Setup   ||
-- ||                             ||
-- |===============================|
-- =================================

-- -----------------------------
-- |   Setup Language Server   |
-- -----------------------------
--
-- Setup nvim-cmp with lspconfig.
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require("lspconfig")

-- Python language server.
if vim.fn.executable("pyright") == 1 then
  lspconfig.pyright.setup({
    capabilities = capabilities,
  })
end

-- CPP and C server
if vim.fn.executable("clangd") == 1 then
  lspconfig.clangd.setup({
    capabilities = capabilities,
  })
end

-- YAML language server
if vim.fn.executable("yaml-language-server") == 1 then
  lspconfig.yamlls.setup({
    capabilities = capabilities,
  })
end

-- Bash language server
if vim.fn.executable("bash-language-server") == 1 then
  lspconfig.bashls.setup({
    capabilities = capabilities,
  })
end

-- Setup rust LSP separately, since rust-tools overwrites the LSP server.
if vim.fn.executable("rust-analyzer") == 1 then
  require("rust-tools").setup({
    tools = { -- rust-tools options
      autoSetHints = true, -- Automatically set inlay hints
      hover_with_actions = true, -- Show action inside the hover menu
      inlay_hints = {
        show_parameter_hints = true, -- Show parameter hints
        parameter_hints_prefix = "<- ",
        other_hints_prefix = "=> ",
      },
    },
    -- These override the defaults set by rust-tools.nvim.
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
      capabilities = capabilities,
      settings = {
        -- to enable rust-analyzer settings visit:
        -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
        ["rust-analyzer"] = {
          -- enable clippy on save
          checkOnSave = {
            command = "clippy",
          },
          procMacro = {
            enable = true,
          },
        },
      },
    },
  })
end

-- Automaticaclly recompile packer plugins.
vim.api.nvim_create_augroup("packer_user_config", {})
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "plugins.lua",
  command = "source <afile> | PackerCompile",
  group = "packer_user_config",
})

return plugins
