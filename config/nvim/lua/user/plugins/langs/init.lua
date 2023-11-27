return {
  -- unpack(require("user.plugins.langs.rust")),
  -- unpack(require("user.plugins.langs.neorg")),

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

  -- CSV helper plugin.
  {
    "chrisbra/csv.vim",
    ft = { "csv", "tsv" },
    config = function() vim.g.csv_bind_B = 1 end,
  },

  -- Connect to databases inside Neovim.
  {
    "tpope/vim-dadbod",
    ft = { "sql", "msql", "mysql", "plsql" },
    cmd = { "DB" },
  },

  -- Kitty .conf file syntax support.
  {
    "fladson/vim-kitty",
    ft = { "kitty" },
  },
}
