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
    event = { "BufReadPost" },
    cmd = {
      "TSConfigInfo",
      "TSContextDisable",
      "TSContextEnable",
      "TSContextToggle",
      "TSDisable",
      "TSEnable",
      "TSInstall",
      "TSInstallFromGrammar",
      "TSInstallInfo",
      "TSInstallSync",
      "TSModuleInfo",
      "TSToggle",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
    },
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cmake",
        "comment",
        "cpp",
        "dockerfile",
        "fish",
        "go",
        "javascript",
        "json",
        "lua",
        "markdown",
        "norg",
        "python",
        "query",
        "regex",
        "rust",
        "sql",
        "toml",
        "typescript",
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
        enable = false,
        disable = { "python" },
      },

      -- Text objects
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["a/"] = "@comment.outer",
            ["am"] = "@function.outer",
            ["im"] = "@function.inner",
            ["ao"] = "@class.outer",
            ["io"] = "@class.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
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
        highlight_definitions = {
          disable = { "nu" },
          clear_on_cursor_move = true,
        },
        smart_rename = {
          enable = true,
          keymaps = {
            smart_rename = "grr",
          },
        },
      },
    },
    config = function(_, opts)
      local configs = require("nvim-treesitter.configs")
      configs.setup(opts)

      require("treesitter-context").setup({
        enable = true,
      })
    end,
  },
}
