---comment
---@param keys vector<table>
local lazy_keys = function(keys)
  for _, key in ipairs(keys) do
    local lhs = table.remove(key, 1)
    local rhs = table.remove(key, 1)
    local mode = key.mode or "n"
    key.mode = nil

    vim.keymap.set(mode, lhs, rhs, key)
  end
end

return {
  -- View tree-like structures from different providers.
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = false,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
    end,
    opts = {
      filesystem = {
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = true,
      },
      window = {
        mappings = {
          ["<C-v>"] = "open_vsplit",
          ["<C-x>"] = "open_split",
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)

      -- stylua: ignore
      local keys = {
        { "_", "<cmd>Neotree source=filesystem reveal=true<CR>", desc = "reveal file in neo-tree" },
        { "-", [[<cmd>Neotree source=filesystem reveal=true position=current dir=%:p:h:h<CR>]], desc = "reveal file in neo-tree" },
      }
      lazy_keys(keys)
    end,
  },

  -- Interface for remote network protocols.
  {
    "miversen33/netman.nvim",
    lazy = true,
    config = function()
      require("netman")

      -- Add source to neo-tree.
      table.insert(require("neo-tree").config.sources, "netman.ui.neo-tree")
    end,
  },

  -- Automatically cd to project root.
  {
    "airblade/vim-rooter",
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
}
