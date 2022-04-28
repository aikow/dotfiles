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
        require("crates").setup()
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
    on_attach = function(_client, buf_nr)
      local bufname = vim.api.nvim_buf_get_name(0)
      -- Create a buffer local keymap to reformat, using the buffer local
      -- command.
      vim.keymap.set("n", "<leader>rf", function()
        if vim.fn.executable("black") ~= 1 then
          print("Missing executable 'black'")
          return
        end
        if vim.fn.executable("isort") ~= 1 then
          print("Missing executable 'isort'")
          return
        end
        vim.api.nvim_command("write")
        vim.api.nvim_command("silent !black " .. bufname)
        vim.api.nvim_command("silent !isort " .. bufname)
        vim.api.nvim_command("edit")
      end, { silent = true, buffer = 0, desc = "reformat python with black and isort" })

      vim.keymap.set("n", "<leader>if", function()
        if vim.fn.executable("flake8") ~= 1 then
          print("Missing executable 'flake8'")
          return
        end
        vim.api.nvim_command("write")

        local bufpath = vim.api.nvim_buf_get_name(0)
        local output = vim.fn.system("flake8 " .. bufpath)
        local buf
        for _, _buf in ipairs(vim.api.nvim_list_bufs()) do
          local parts = vim.split(vim.api.nvim_buf_get_name(_buf), "/")
          if parts[#parts] == "__Flake8__" then
            buf = _buf
            break
          end
        end

        if not buf then
          buf = vim.api.nvim_create_buf(false, false)
          vim.api.nvim_buf_set_name(buf, "__Flake8__")
          vim.api.nvim_buf_set_option(buf, "filetype", "flake8")
          vim.api.nvim_buf_set_option(buf, "buftype", "quickfix")
          vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")
          vim.api.nvim_buf_set_option(buf, "swapfile", false)
          vim.api.nvim_buf_set_option(buf, "buflisted", false)
        end

        local win
        local tabpage = vim.api.nvim_get_current_tabpage()
        for _, _window in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
          if vim.api.nvim_win_get_buf(_window) == buf then
            win = _window
          end
        end

        if not win then
          vim.api.nvim_command("vsplit")
          win = vim.api.nvim_get_current_win()
        end

        vim.api.nvim_win_set_buf(win, buf)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn.split(output, "\n"))
      end, { buffer = 0, desc = "run flake8 linting" })
    end,
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
