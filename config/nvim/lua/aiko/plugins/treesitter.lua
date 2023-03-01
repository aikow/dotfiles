return {
  -- Neovim treesitter helper, which enables a lot of cool functionality based
  -- on treesitter.
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/playground",
    },
    event = { "BufReadPost" },
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
    },
    config = function(_, opts)
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = opts.parsers,

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
        playground = {
          enable = true,
          disable = {},
        },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        },
      })
    end,
  },

  -- Refactoring support for select languages.
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = true,
    -- stylua: ignore
    keys = {
      { "<leader>rq", function() require("refactoring").select_refactor() end, mode = "v", desc = "select refactoring" },
      { "<leader>re", function() require("refactoring").refactor("Extract Function") end, mode = "v", desc = "refactoring extract function" },
      { "<leader>rf", function() require("refactoring").refactor("Extract Function To File") end, mode = "v", desc = "refactoring extract function to file" },
      { "<leader>rv", function() require("refactoring").refactor("Extract Variable") end, mode = "v", desc = "refactoring extract variable" },
      { "<leader>rb", function() require("refactoring").refactor("Extract Function") end, mode = "n", desc = "refactoring extract block" },
      { "<leader>rbf", function() require("refactoring").refactor("Extract Block To File") end, mode = "n", desc = "refactoring extract block to file" },
      { "<leader>ri", function() require("refactoring").refactor("Inline Variable") end, mode = { "n", "v" }, desc = "inline variable" },
    },
  },
}
