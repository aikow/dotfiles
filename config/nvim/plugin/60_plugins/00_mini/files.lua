local H = {}

-- ------------------------------------------------------------------------
-- | Helper Module
-- ------------------------------------------------------------------------

---Take a buffer as input and return the path, and won't fail for buffers like terminal buffers. If
---the path doesn't exist yet, fall back to the current directory.
---@param buf_id integer
function H.buf_path_or_cwd(buf_id)
  local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf_id })
  if buftype == "" then
    local path = vim.api.nvim_buf_get_name(buf_id)
    if vim.uv.fs_stat(path) then return path end
  end

  return vim.uv.cwd()
end

function H.open_buf() require("mini.files").open(H.buf_path_or_cwd(0)) end
function H.open_root() require("mini.files").open() end
function H.open_last() require("mini.files").open(require("mini.files").get_latest_path()) end

H.show_hidden = true
H.show_ignored = false

function H.toggle_hidden()
  H.show_hidden = not H.show_hidden
  require("mini.files").refresh({ content = { sort = H.filter_ignore } })
  print(H.show_hidden)
end

function H.toggle_ignore()
  H.show_ignored = not H.show_ignored
  require("mini.files").refresh({ content = { sort = H.filter_ignore } })
  print(H.show_ignored)
end

function H.filter_ignore(entries)
  -- technically can filter entries here too, and checking gitignore for _every entry individually_
  -- like I would have to in `content.filter` above is too slow. Here we can give it _all_ the entries
  -- at once, which is much more performant.
  if #entries == 0 then return {} end
  local dir = vim.fs.dirname(entries[1].path)
  local cmd = { "fd", ".", dir, "--max-depth", "1" }
  if H.show_hidden then table.insert(cmd, "--hidden") end
  if H.show_ignored then table.insert(cmd, "-I") end
  table.insert(cmd, "--exec")
  table.insert(cmd, "echo")
  table.insert(cmd, "{/}")

  local proc = vim.system(cmd, { text = true }):wait()
  if proc.code ~= 0 then return end
  local output_lines = vim.split(vim.trim(proc.stdout), "\n")

  return require("mini.files").default_sort(
    vim
      .iter(entries)
      :filter(function(entry) return vim.tbl_contains(output_lines, entry.name) end)
      :totable()
  )
end

-- Create a new split and open the entry under the cursor in it.
function H.map_split(buf_id, lhs, direction_mods, desc)
  local rhs = function()
    -- Make new window and set it as target
    local cur_target = require("mini.files").get_explorer_state().target_window
    local new_target = vim.api.nvim_win_call(cur_target, function()
      vim.cmd.split({ mods = direction_mods })
      return vim.api.nvim_get_current_win()
    end)

    require("mini.files").set_target_window(new_target)
    require("mini.files").go_in({ close_on_file = true })
  end

  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

-- Set the current working directory.
function H.files_set_cwd()
  -- Works only if cursor is on the valid file system entry
  local cur_entry_path = require("mini.files").get_fs_entry().path
  local cur_directory = vim.fs.dirname(cur_entry_path)
  vim.fn.chdir(cur_directory)
end

-- ------------------------------------------------------------------------
-- | MiniFiles
-- ------------------------------------------------------------------------

MiniDeps.now(function()
  local minifiles = require("mini.files")
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

  -- Keymaps to open mini.files
  -- stylua: ignore start
  vim.keymap.set("n", "-", H.open_buf,  { desc = "mini.files open from buf" })
  vim.keymap.set("n", "_", H.open_root, { desc = "mini.files open from root" })
  vim.keymap.set("n", "+", H.open_last, { desc = "mini.files open last state" })
  -- stylua: ignore end

  -- Create extra keymaps.
  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(params)
      local buf_id = params.data.buf_id

      H.map_split(buf_id, "<C-s>", { split = "belowright", horizontal = true }, "Split below")
      H.map_split(buf_id, "<C-v>", { split = "belowright", vertical = true }, "Split right")
      H.map_split(buf_id, "<C-t>", { tab = vim.fn.tabpagenr("$") }, "Split tab")

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
      vim.keymap.set("n", "g.", H.files_set_cwd, {
        buffer = buf_id,
        desc = "Set current working directory",
      })
    end,
  })
end)
