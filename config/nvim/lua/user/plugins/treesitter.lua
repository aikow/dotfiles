return {
  -- Neovim treesitter helper, which enables a lot of cool functionality based
  -- on treesitter.
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-context",
    },
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "comment",
        "cpp",
        "fish",
        "json",
        "lua",
        "markdown",
        "python",
        "query",
        "regex",
        "rust",
        "sql",
        "toml",
        "vim",
        "yaml",
      },

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
      },

      -- Indentation is currently still an experimental feature.
      indent = {
        enable = true,
        disable = { "python" },
      },

      -- Text objects
      textobjects = {
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["]a"] = "@parameter.inner",
          },
          swap_previous = {
            ["[a"] = "@parameter.inner",
          },
        },
      },
      refactor = {
        smart_rename = {
          enable = true,
          keymaps = {
            smart_rename = "<leader>rs",
          },
        },
      },
    },
    config = function(_, opts)
      local configs = require("nvim-treesitter.configs")
      configs.setup(opts)

      require("treesitter-context").setup({
        enable = true,
        max_lines = 16,
        multiline_threshold = 8,
        trim_scope = "inner",
      })
    end,
  },
}
