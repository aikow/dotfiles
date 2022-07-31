-- ---------------------
-- |   Auto Commands   |
-- ---------------------

-- Reload files changed outside of Vim not currently modified in Vim
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "WinEnter" }, {
  group = vim.api.nvim_create_augroup("General autoread", {}),
  callback = function()
    if vim.api.nvim_buf_get_option(0, "buftype") ~= "" then
      return
    end
    vim.api.nvim_command("silent! checktime")
  end,
  desc = "perform a read when entering a new buffer",
})
vim.api.nvim_create_autocmd({ "FocusLost", "WinLeave" }, {
  group = vim.api.nvim_create_augroup("general_autowrite", {}),
  callback = function()
    if vim.api.nvim_buf_get_option(0, "buftype") ~= "" then
      return
    end
    vim.api.nvim_command("silent! noautocmd write")
  end,
  desc = "perform a write when leaving the current buffer",
})

-- Prevent accidental writes to buffers that shouldn't be edited
local unmodifiable_group = vim.api.nvim_create_augroup("Unmodifiable files", {})
vim.api.nvim_create_autocmd("FileType", {
  group = unmodifiable_group,
  pattern = "help",
  command = "setlocal readonly",
})
vim.api.nvim_create_autocmd("BufRead", {
  group = unmodifiable_group,
  pattern = { "*.orig", "*.pacnew" },
  command = "setlocal readonly",
})

-- Jump to last edit position on opening file
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("Last edit position", {}),
  callback = function(args)
    -- Exclude files like commit messages.
    for _, pat in pairs({ "/.git/" }) do
      if string.find(args.file, pat) then
        return
      end
    end

    local line = vim.fn.line
    if line([['"]]) > 0 and line([['"]]) <= line("$") then
      -- Set the cursor position to the position of the last save.
      vim.fn.setpos(".", vim.fn.getpos("'\""))
    end
  end,
})

-- Enable spelling after reading a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("Enable spelling", {}),
  callback = function()
    vim.schedule(function()
      vim.opt.spelllang = "en,de"
      vim.opt.spell = true
    end)
  end,
  once = true,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("Terminal Settings", {}),
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
