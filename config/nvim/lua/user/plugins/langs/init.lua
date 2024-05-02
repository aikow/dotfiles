return {
  -- Latex
  {
    "lervag/vimtex",
    dependencies = {
      "micangl/cmp-vimtex",
    },
    ft = { "tex" },
    config = function()
      vim.g.tex_flavor = "latex"

      vim.g.vimtex_view_method = "zathura"

      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        out_dir = "build",
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
        vim.b[0]["surround" .. vim.fn.char2nr("e")] =
          [[\\begin{\1environment: \1}\n\t\r\n\\end{\1\1}]]
        vim.b[0]["surround" .. vim.fn.char2nr("c")] = [[\\\1command: \1{\r}]]
      end, { nargs = 0 })
    end,
  },

  -- Justfile support syntax support.
  {
    "IndianBoy42/tree-sitter-just",
    enabled = true,
    dependencies = { "nvim-treesitter" },
    ft = { "just" },
    opts = {},
  },

  -- Markdown
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  -- Fish shell syntax support.
  {
    "aikow/vim-fish",
    ft = { "fish" },
  },

  -- Rust language support.
  {
    "mrcjkb/rustaceanvim",
    ft = "rust",
    init = function()
      vim.g.rustaceanvim = {
        tools = {
          autoSetHints = true,
          -- hover_with_actions = true, -- Show action inside the hover menu
          inlay_hints = {
            show_parameter_hints = true,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
          },
        },
        server = {
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        },
      }
    end,
  },

  -- Syntax support for nushell.
  {
    "LhKipp/nvim-nu",
    dependencies = {
      "nvim-treesitter",
    },
    ft = { "nu" },
    opts = {
      use_lsp_features = false,
    },
  },

  -- Connect to databases inside Neovim.
  {
    "tpope/vim-dadbod",
    ft = { "sql", "msql", "mysql", "plsql" },
    cmd = { "DB" },
  },

  -- Notes and tasks.
  {
    "nvim-neorg/neorg",
    dependencies = {
      "nvim-treesitter",
      "nvim-neorg/neorg-telescope",
    },
    version = "7.0.0",
    ft = "norg",
    opts = require("user.plugins.langs.neorg").opts,
  },
}
