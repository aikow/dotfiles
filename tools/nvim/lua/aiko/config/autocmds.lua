-- ---------------------
-- |   Auto Commands   |
-- ---------------------
local autocmd = require("aiko.util").autocmd

-- Reload files changed outside of Vim not currently modified in Vim
autocmd("general_autoread", {
  event = { "FocusGained", "BufEnter", "WinEnter" },
  callback = function()
    if vim.api.nvim_buf_get_option(0, "buftype") ~= "" then
      return
    end
    vim.api.nvim_command("silent! checktime")
  end,
  desc = "perform a read when entering a new buffer",
})
autocmd("general_autowrite", {
  event = { "FocusLost", "WinLeave" },
  callback = function()
    if vim.api.nvim_buf_get_option(0, "buftype") ~= "" then
      return
    end
    vim.api.nvim_command("silent! noautocmd write")
  end,
  desc = "perform a write when leaving the current buffer",
})

-- Prevent accidental writes to buffers that shouldn't be edited
autocmd("unmodifiable", {
  { event = "FileType", pattern = "help", command = "setlocal readonly" },
  { event = "BufRead", pattern = "*.orig", command = "setlocal readonly" },
  { event = "BufRead", pattern = "*.pacnew", command = "setlocal readonly" },
})

-- Jump to last edit position on opening file
-- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
autocmd("buf_read_post", {
  event = "BufReadPost",
  callback = function()
    local regex = vim.regex([[/\.git/]])
    if
      not regex:match_str(vim.fn.expand("%:p"))
      and vim.fn.line([['"]]) > 1
      and vim.fn.line([['"]]) <= vim.fn.line("$")
    then
      vim.cmd([[exe "normal! g'\""]])
    end
  end,
})

-- Enable spelling after reading a buffer
autocmd("enable_spell", {
  event = "BufReadPost",
  callback = function()
    vim.schedule(function()
      vim.opt.spell = true
      vim.opt.spelllang = "en,de"
    end)
  end,
  once = true,
})

autocmd("terminal_ftplugin", {
  event = "TermOpen",
  callback = function()
    vim.opt_local.spell = false
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false

    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "<localleader>r",
      [[a<C-k><CR><C-\><C-n>G]],
      { noremap = true, silent = true }
    )
  end,
})
