local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Reload files changed outside of Vim not currently modified in Vim
autocmd({ "FocusGained", "BufEnter", "WinEnter" }, {
  group = augroup("General autoread", {}),
  callback = function()
    if vim.api.nvim_get_option_value("buftype", {}) ~= "" then return end
    vim.api.nvim_command("silent! checktime")
  end,
  desc = "perform a read when entering a new buffer",
})

-- Prevent accidental writes to buffers that shouldn't be edited
local unmodifiable_group = augroup("Unmodifiable files", {})
autocmd("FileType", {
  group = unmodifiable_group,
  pattern = { "log" },
  command = "setlocal readonly",
})
autocmd("BufRead", {
  group = unmodifiable_group,
  pattern = { "*.orig", "*.pacnew" },
  command = "setlocal readonly",
})

-- Manage big files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("bigfile", { clear = true }),
  pattern = "bigfile",
  callback = function(params)
    local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(params.buf), ":p:~:.")
    vim.notify(
      ("Big file detected `%s`.\nSome Neovim features have been disabled."):format(path),
      vim.log.levels.INFO
    )

    local ft = vim.filetype.match({ buf = params.buf }) or ""
    vim.api.nvim_buf_call(params.buf, function()
      vim.b[params.buf].minihipatterns_disable = true
      vim.schedule(function() vim.bo[params.buf].syntax = ft end)
    end)
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
  callback = function(params)
    vim.opt_local.spell = false
    vim.opt_local.number = false

    vim.api.nvim_buf_set_keymap(
      params.buf,
      "n",
      "<localleader>r",
      [[A<Up><CR><C-\><C-n>G]],
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
    local configs = vim.fs.find(exrc_patterns, { upward = true, type = "file", limit = math.huge })

    -- Iterate over the files in reverse so that the "most local" one gets sourced last.
    for _, f in rpairs(configs) do
      local contents = vim.secure.read(f)
      if contents ~= nil then
        vim.api.nvim_exec2(contents, {})
      else
        vim.notify(string.format("skipping %s", f), vim.log.levels.DEBUG)
      end
    end
  end,
})
