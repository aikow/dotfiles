return {
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

            files.set_target_window(new_target_window)
            files.go_in({})
          end
        end

        -- Adding `desc` will result into `show_help` entries
        local desc = "Split " .. table.concat(direction_mods, " ")
        vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
      end

      -- Show/hide dotfiles
      local show_dotfiles = true
      local filter_show = function() return true end
      local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, ".") end
      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        files.refresh({ content = { filter = new_filter } })
      end
      local files_set_cwd = function()
        -- Works only if cursor is on the valid file system entry
        local cur_entry_path = files.get_fs_entry().path
        local cur_directory = vim.fs.dirname(cur_entry_path)
        vim.fn.chdir(cur_directory)
      end

      -- Register renaming and moving files with any attached LSP servers.
      vim.api.nvim_create_autocmd("User", {
        pattern = { "MiniFilesActionRename", "MiniFilesActionMove" },
        callback = function(args) require("user.lsp").lsp_did_rename(args.data.from, args.data.to) end,
      })

      -- Create extra keymaps.
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        ---@param params NvimAutocmdCallbackParams
        callback = function(params)
          local buf_id = params.data.buf_id

          map_split(buf_id, "<C-x>", { split = "belowright", horizontal = true })
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
}
