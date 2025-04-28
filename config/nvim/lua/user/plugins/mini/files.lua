local minifiles = require("mini.files")

local H = {}

H.show_hidden = true
H.show_ignored = false

function H.toggle_hidden()
  H.show_hidden = not H.show_hidden
  minifiles.refresh({ content = { sort = H.filter_ignore } })
  print(H.show_hidden)
end

function H.toggle_ignore()
  H.show_ignored = not H.show_ignored
  minifiles.refresh({ content = { sort = H.filter_ignore } })
  print(H.show_ignored)
end

function H.filter_ignore(entries)
  -- technically can filter entries here too, and checking gitignore for _every entry individually_
  -- like I would have to in `content.filter` above is too slow. Here we can give it _all_ the entries
  -- at once, which is much more performant.
  local dir = vim.fs.dirname(entries[1].path)
  local cmd = { 'fd', '.', dir, '--max-depth', '1' }
  if H.show_hidden then
    table.insert(cmd, '--hidden')
  end
  if H.show_ignored then
    table.insert(cmd, '-I')
  end
  table.insert(cmd, '--exec')
  table.insert(cmd, 'echo')
  table.insert(cmd, '{/}')

  local proc = vim.system(cmd, { text = true }):wait()
  if proc.code ~= 0 then
    return
  end
  local output_lines = vim.split(vim.trim(proc.stdout), '\n')

  return minifiles.default_sort(vim.iter(entries):filter(function(entry)
    return vim.tbl_contains(output_lines, entry.name)
  end):totable())
end

minifiles.setup({
  content = {
    sort = H.filter_ignore,
  },
  mappings = {
    go_in_plus = "<cr>",
  },
  windows = {
    preview = true,
    width_preview = 40,
  },
})

-- Create a new split and open the entry under the cursor in it.
local map_split = function(buf_id, lhs, direction_mods, desc)
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

  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
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

    map_split(buf_id, "<C-s>", { split = "belowright", horizontal = true }, "Split below")
    map_split(buf_id, "<C-v>", { split = "belowright", vertical = true }, "Split right")
    map_split(buf_id, "<C-t>", { tab = vim.fn.tabpagenr("$") }, "Split tab")

    vim.keymap.set("n", "yp", function() vim.fn.setreg("+", minifiles.get_fs_entry().path) end, {
      buffer = buf_id,
      desc = "Yank absolute path",
    })
    vim.keymap.set("n", "gx", function() vim.ui.open(minifiles.get_fs_entry().path) end, {
      buffer = buf_id,
      desc = "Open with vim.ui.open",
    })
    vim.keymap.set("n", "gh", H.toggle_hidden, {
      buffer = buf_id,
      desc = "Toggle hidden",
    })
    vim.keymap.set("n", "gi", H.toggle_ignore, {
      buffer = buf_id,
      desc = "Toggle ignored",
    })
    vim.keymap.set("n", "g.", files_set_cwd, {
      buffer = buf_id,
      desc = "Set current working directory",
    })
  end,
})

-- Keymaps to open mini.files
vim.keymap.set("n", "-", function() minifiles.open(require("user.util").buf_path(0)) end)
vim.keymap.set("n", "_", function() minifiles.open() end)
vim.keymap.set("n", "+", function() minifiles.open(minifiles.get_latest_path()) end)
