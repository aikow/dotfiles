return {
  -- View tree-like structures from different providers.
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      {
        "+",
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
        "<leader>no",
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
        "<leader>nb",
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
        "<leader>ne",
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

      -- Load neo-tree if nvim was passed a directory as a single argument.
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(tostring(vim.fn.argv(0)))
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
  },

  {
    "echasnovski/mini.files",
    keys = {
      {
        "-",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0))
        end,
      },
      {
        "_",
        function()
          require("mini.files").open()
        end,
      },
    },
    opts = {
      windows = {
        preview = true,
        width_preview = 40,
      },
    },
    config = function(_, opts)
      local files = require("mini.files")
      files.setup(opts)

      local map_split = function(buf_id, lhs, direction)
        local rhs = function()
          -- Make new window and set it as target
          local target_window = files.get_target_window()
          if target_window then
            local new_target_window
            vim.api.nvim_win_call(target_window, function()
              vim.cmd(direction .. " split")
              new_target_window = vim.api.nvim_get_current_win()
            end)

            MiniFiles.set_target_window(new_target_window)
          end
        end

        -- Adding `desc` will result into `show_help` entries
        local desc = "Split " .. direction
        vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
      end

      local files_set_cwd = function(path)
        -- Works only if cursor is on the valid file system entry
        local cur_entry_path = MiniFiles.get_fs_entry().path
        local cur_directory = vim.fs.dirname(cur_entry_path)
        vim.fn.chdir(cur_directory)
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id

          vim.keymap.set("n", "g.", files_set_cwd, { buffer = buf_id })

          map_split(buf_id, "<C-x>", "belowright horizontal")
          map_split(buf_id, "C-v", "belowright vertical")
        end,
      })
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
