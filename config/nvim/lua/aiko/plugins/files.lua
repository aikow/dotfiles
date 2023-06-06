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
    cmd = "Neotree",
    keys = {
      {
        "_",
        function()
          require("neo-tree.command").execute({
            source = "filesystem",
            reveal = true,
            position = "left",
          })
        end,
        desc = "reveal file in neo-tree",
      },
      {
        "+",
        function()
          require("neo-tree.command").execute({
            source = "buffers",
            reveal = true,
            position = "left",
          })
        end,
        desc = "reveal buffers in neo-tree",
      },
      {
        "-",
        function()
          require("neo-tree.command").execute({
            source = "filesystem",
            reveal = true,
            position = "current",
            dir = vim.fn.expand("%:p:h:h"),
          })
        end,
        desc = "reveal file in neo-tree",
      },
    },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = true,
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = true,
      },
      window = {
        mappings = {
          ["<C-v>"] = "open_vsplit",
          ["<C-x>"] = "open_split",
          ["-"] = "navigate_up",
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
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
