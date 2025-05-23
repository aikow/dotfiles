-- Neovim treesitter helper, which enables a lot of cool functionality based
-- on treesitter.
MiniDeps.later(function()
  MiniDeps.add({
    source = "nvim-treesitter/nvim-treesitter",
    depends = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
    },
    hooks = { post_checkout = function() vim.cmd.TSUpdate() end },
  })

  local configs = require("nvim-treesitter.configs")
  configs.setup({
    ensure_installed = {
      "bash",
      "c",
      "comment",
      "cpp",
      "fish",
      "julia",
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
      "vimdoc",
      "yaml",
      "zig",
    },

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
      -- Use vim's regex syntax highlighting for tex files, since vimtex depends on its own syntax
      -- highlighting for some features.
      additional_vim_regex_highlighting = { "latex" },
    },

    -- Indentation is currently still an experimental feature.
    indent = {
      enable = true,
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
          ["]p"] = "@parameter.inner",
        },
        swap_previous = {
          ["[p"] = "@parameter.inner",
        },
      },
    },
  })

  require("treesitter-context").setup({
    enable = true,
    max_lines = 8,
    multiline_threshold = 1,
    trim_scope = "inner",
  })
end)
