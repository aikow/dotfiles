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
            dir = vim.fn.expand("%:p:h:h"),
            reveal = true,
            position = "current",
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
        "<leader>ng",
        function()
          require("neo-tree.command").execute({
            source = "git_status",
            reveal = true,
            position = "left",
          })
        end,
        desc = "reveal modified files tracked by git in neo-tree",
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
    },
    init = function()
      -- Load neo-tree if nvim was passed a directory as a single argument.
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(tostring(vim.fn.argv(0)))
        if stat and stat.type == "directory" then require("neo-tree") end
      end
    end,
    opts = {
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = {
          enabled = true,
        },
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = true,
        find_by_full_path_words = true,
      },
      window = {
        mappings = {
          ["<C-v>"] = "open_vsplit",
          ["<C-x>"] = "open_split",
          ["-"] = "navigate_up",
        },
        position = "current",
      },
    },
  },

  {
    "echasnovski/mini.files",
    keys = {
      {
        "-",
        function() require("mini.files").open(require("user.util").buf_path(0)) end,
      },
      {
        "_",
        function() require("mini.files").open() end,
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

      -- Create a new split and open the entry under the cursor in it.
      local map_split = function(buf_id, lhs, direction_mods)
        local rhs = function()
          -- Make new window and set it as target
          local target_window = files.get_target_window()
          if target_window then
            local new_target_window
            vim.api.nvim_win_call(target_window, function()
              vim.cmd.split({ mods = direction_mods })
              new_target_window = vim.api.nvim_get_current_win()
            end)

            MiniFiles.set_target_window(new_target_window)
            MiniFiles.go_in({})
          end
        end

        -- Adding `desc` will result into `show_help` entries
        local desc = "Split " .. table.concat(direction_mods, " ")
        vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
      end

      -- Show/hide dotfiles
      local show_dotfiles = true
      local filter_show = function() return true end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, ".")
      end
      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        MiniFiles.refresh({ content = { filter = new_filter } })
      end
      local files_set_cwd = function()
        -- Works only if cursor is on the valid file system entry
        local cur_entry_path = MiniFiles.get_fs_entry().path
        local cur_directory = vim.fs.dirname(cur_entry_path)
        vim.fn.chdir(cur_directory)
      end

      -- vim.api.nvim_create_autocmd("User", {
      --   pattern = "MiniFilesActionRename",
      --   ---@param params NvimAutocmdCallbackParams
      --   callback = function(params)
      --     local action = params.data.action
      --     if action ~= "rename" then return end
      --
      --     local from_path = params.data.from
      --     local to_path = params.data.to
      --
      --     for _, client in ipairs(vim.lsp.get_clients()) do
      --       -- Make sure that the renaming won't accidently change any libraries
      --       -- or other workspace folders that it shouldn't.
      --       -- Use oil.nvim as a reference
      --       for _, workspace_folder in ipairs(client.workspace_folders) do
      --         -- 1. Check if from_path and to_path are subdirs in a workspace
      --         -- folder.
      --         -- 2. Send a rename request to the language server.
      --       end
      --     end
      --   end,
      -- })

      -- Create extra keymaps.
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        ---@param params NvimAutocmdCallbackParams
        callback = function(params)
          local buf_id = params.data.buf_id

          map_split(
            buf_id,
            "<C-x>",
            { split = "belowright", horizontal = true }
          )
          map_split(buf_id, "<C-v>", { split = "belowright", vertical = true })

          vim.keymap.set("n", "g.", toggle_dotfiles, {
            buffer = buf_id,
            desc = "toggle showing/hiding dotfiles in the file explorer.",
          })
          vim.keymap.set("n", "gc", files_set_cwd, {
            buffer = buf_id,
            desc = "Set the current working directory to the path under the cursor.",
          })
          vim.keymap.set(
            "n",
            "<CR>",
            files.go_in,
            { buffer = buf_id, desc = "Open a file and close the explorer." }
          )
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
