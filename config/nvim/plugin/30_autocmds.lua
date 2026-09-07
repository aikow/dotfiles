local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Prevent accidental writes to buffers that shouldn't be edited
local unmodifiable_group = augroup("user.ft.unmodifiable", {})
local function make_unmodifiable() vim.bo.readonly = true end
autocmd("FileType", {
  group = unmodifiable_group,
  pattern = { "log" },
  desc = "Make log buffers read-only",
  callback = make_unmodifiable,
})
autocmd("BufRead", {
  group = unmodifiable_group,
  pattern = { "*.orig", "*.pacnew" },
  desc = "Make generated files read-only",
  callback = make_unmodifiable,
})

-- Manage big files
-- This must run before the buffer is read: persistent undo hashes the entire
-- buffer during open, whereas the FileType=bigfile handler fires too late.
local bigfile_size = 8 * 1024 * 1024
local function is_bigfile(path)
  local stat = path ~= "" and vim.uv.fs_stat(path)
  return stat and stat.type == "file" and stat.size > bigfile_size
end

-- These are window-local settings. Keep each window's own values so a split
-- that leaves a big buffer immediately behaves normally for its next buffer.
local bigfile_window_options = {}
local function update_bigfile_window_options(win, buf)
  if not vim.api.nvim_win_is_valid(win) then return end

  if vim.bo[buf].filetype == "bigfile" then
    if not bigfile_window_options[win] then
      bigfile_window_options[win] = {
        foldmethod = vim.wo[win].foldmethod,
        smoothscroll = vim.wo[win].smoothscroll,
      }
    end
    vim.wo[win].foldmethod = "manual"
    vim.wo[win].smoothscroll = false
  elseif bigfile_window_options[win] then
    local saved = bigfile_window_options[win]
    vim.wo[win].foldmethod = saved.foldmethod
    vim.wo[win].smoothscroll = saved.smoothscroll
    bigfile_window_options[win] = nil
  end
end

autocmd("BufReadPre", {
  group = augroup("user.undofile.bigfile", {}),
  desc = "Disable undo for large files",
  callback = function(params)
    if is_bigfile(params.file) then vim.bo[params.buf].undofile = false end
  end,
})

autocmd("BufWinEnter", {
  group = augroup("user.window-options.bigfile", {}),
  desc = "Update large-file window options",
  callback = function(params)
    update_bigfile_window_options(vim.api.nvim_get_current_win(), params.buf)
  end,
})

autocmd("WinClosed", {
  group = augroup("user.window-options.bigfile.cleanup", {}),
  desc = "Clear large-file window options",
  callback = function(params) bigfile_window_options[tonumber(params.match)] = nil end,
})

autocmd({ "FileType" }, {
  group = augroup("user.filetype.bigfile", {}),
  pattern = "bigfile",
  desc = "Configure large-file buffers",
  callback = function(params)
    local buf = params.buf
    local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(params.buf), ":p:~:.")
    vim.notify(("Big file detected '%s'"):format(path), vim.log.levels.INFO)

    local ft = vim.filetype.match({ buf = params.buf }) or ""
    vim.api.nvim_buf_call(params.buf, function()
      vim.schedule(function() vim.bo[params.buf].syntax = ft end)
      vim.b[params.buf].minihipatterns_disable = true
    end)
    update_bigfile_window_options(vim.api.nvim_get_current_win(), params.buf)
  end,
})

-- Restore cursor position

-- Set settings for built-in terminal
autocmd("TermOpen", {
  group = augroup("user.terminal.settings", {}),
  desc = "Configure terminal buffers",
  callback = function(params)
    vim.wo.wrap = true -- With wrap disabled, you can scroll sideways, which is disconcerting

    vim.keymap.set("n", "<localleader>r", [[A<Up><CR><C-\><C-n>G]], {
      buffer = params.buf,
      desc = "Rerun the previous command",
    })
  end,
})

-- Automatically trust 'exrc' files that are created and edited using nvim
autocmd("BufWritePost", {
  group = augroup("user.exrc.autotrust", {}),
  pattern = { ".nvim.lua", ".nvimrc", ".exrc" },
  desc = "Trust local configuration files",
  callback = function(params) vim.secure.trust({ action = "allow", bufnr = params.buf }) end,
})

-- Remove default mouse menu options
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  desc = "Remove default mouse menu items",
  callback = function()
    vim.cmd.aunmenu({ "PopUp.How-to\\ disable\\ mouse" })
    vim.cmd.aunmenu({ "PopUp.-2-" })
  end,
})
