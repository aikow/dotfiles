local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Reload files changed outside of Vim not currently modified in Vim
autocmd({ "FocusGained", "BufEnter", "WinEnter" }, {
  group = augroup("General autoread", {}),
  callback = function()
    if vim.api.nvim_buf_get_option(0, "buftype") ~= "" then
      return
    end
    vim.api.nvim_command("silent! checktime")
  end,
  desc = "perform a read when entering a new buffer",
})

-- Write changes automatically when leaving a window or losing focus.
autocmd({ "FocusLost", "WinLeave" }, {
  group = augroup("general_autowrite", {}),
  callback = function()
    if vim.api.nvim_buf_get_option(0, "buftype") ~= "" then
      return
    end
    vim.api.nvim_command("silent! noautocmd write")
  end,
  desc = "perform a write when leaving the current buffer",
})

-- Prevent accidental writes to buffers that shouldn't be edited
local unmodifiable_group = augroup("Unmodifiable files", {})
autocmd("FileType", {
  group = unmodifiable_group,
  pattern = "help",
  command = "setlocal readonly",
})
autocmd("BufRead", {
  group = unmodifiable_group,
  pattern = { "*.orig", "*.pacnew" },
  command = "setlocal readonly",
})

-- Jump to last edit position on opening file
autocmd("BufWinEnter", {
  group = augroup("Last edit position", {}),
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
autocmd("BufReadPost", {
  group = augroup("Enable spelling", {}),
  callback = function()
    vim.schedule(function()
      vim.opt.spelllang = "en,de"
      vim.opt.spell = true
    end)
  end,
  once = true,
})

-- Set settings for built-in terminal
autocmd("TermOpen", {
  group = augroup("Terminal Settings", {}),
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

-- Automatically read and source `exrc` file in any parent directory.
autocmd("VimEnter", {
  group = augroup("Source exrc", {}),
  callback = function()
    local exrc_patterns = {
      ".exrc",
      ".nvimrc",
    }

    -- Find the list of configs.
    local configs = vim.fs.find(
      exrc_patterns,
      { upward = true, type = "file", limit = math.huge }
    )

    -- Iterate over the files in reverse so that the "most local" one gets
    -- sourced last.
    for _, f in rpairs(configs) do
      local contents = vim.secure.read(f)
      if contents ~= nil then
        vim.api.nvim_exec(contents, false)
      else
        vim.notify(string.format("skipping %s", f), vim.log.levels.DEBUG)
      end
    end
  end,
})
