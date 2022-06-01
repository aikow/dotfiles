local M = {}

M.setup = function()
  require("nvim-treesitter.configs").setup({
    -- Ensure that all maintained languages are always installed.
    ensure_installed = {
      "bash",
      "c",
      "cmake",
      "cpp",
      "fish",
      "go",
      "json",
      "lua",
      "markdown",
      "python",
      "rust",
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
end

return M
