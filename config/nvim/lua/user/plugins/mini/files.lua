local minifiles = require("mini.files")
minifiles.setup({
  mappings = {
    go_in_plus = "<cr>",
  },
  windows = {
    preview = true,
    width_preview = 40,
  },
})

-- Create a new split and open the entry under the cursor in it.
local map_split = function(buf_id, lhs, direction_mods)
  local rhs = function()
    -- Make new window and set it as target
    local cur_target = minifiles.get_explorer_state().target_window
    local new_target = vim.api.nvim_win_call(cur_target, function()
      vim.cmd.split({ mods = direction_mods })
      return vim.api.nvim_get_current_win()
    end)

    minifiles.set_target_window(new_target)
    minifiles.go_in({ close_on_file = true })
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
  minifiles.refresh({ content = { filter = new_filter } })
end

-- Set the current working directory.
local files_set_cwd = function()
  -- Works only if cursor is on the valid file system entry
  local cur_entry_path = minifiles.get_fs_entry().path
  local cur_directory = vim.fs.dirname(cur_entry_path)
  vim.fn.chdir(cur_directory)
end

-- Register renaming and moving files with any attached LSP servers.
vim.api.nvim_create_autocmd("User", {
  pattern = { "MiniFilesActionRename", "MiniFilesActionMove" },
  callback = function(args) require("user.util.lsp").lsp_did_rename(args.data.from, args.data.to) end,
})

-- Create extra keymaps.
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(params)
    local buf_id = params.data.buf_id

    map_split(buf_id, "<C-s>", { split = "belowright", horizontal = true })
    map_split(buf_id, "<C-v>", { split = "belowright", vertical = true })

    vim.keymap.set("n", "gp", function() vim.fn.setreg("+", minifiles.get_fs_entry().path) end, {
      buffer = buf_id,
      desc = "mini.files yank absolute path",
    })
    vim.keymap.set("n", "gh", toggle_dotfiles, {
      buffer = buf_id,
      desc = "mini.files toggle hidden",
    })
    vim.keymap.set("n", "g.", files_set_cwd, {
      buffer = buf_id,
      desc = "mini.files set current working directory",
    })
  end,
})

-- Keymaps to open mini.files
vim.keymap.set("n", "-", function() minifiles.open(require("user.util").buf_path(0)) end)
vim.keymap.set("n", "_", function() minifiles.open() end)
