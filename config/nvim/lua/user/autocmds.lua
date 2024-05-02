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
  pattern = { "help", "log" },
  command = "setlocal readonly",
})
autocmd("BufRead", {
  group = unmodifiable_group,
  pattern = { "*.orig", "*.pacnew" },
  command = "setlocal readonly",
})

-- Jump to last edit position on opening file
autocmd("BufReadPost", {
  group = augroup("Last edit position", {}),
  ---@param params NvimAutocmdCallbackParams
  callback = function(params)
    -- Exclude files like commit messages.
    for _, pat in pairs({ "/.git/" }) do
      if string.find(params.file, pat) then return end
    end

    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 1 and mark[1] < vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- Change to project root directory.
autocmd({ "VimEnter", "BufReadPost", "BufEnter" }, {
  nested = true,
  ---@params params NvimAutocmdCallbackPrams
  callback = function(params)
    local path = vim.api.nvim_buf_get_name(0)
    if path ~= "" then
      path = vim.fs.dirname(path)
    else
      path = vim.uv.cwd() or vim.fn.getcwd()
    end
    local root = vim.fs.root(path, {
      ".editorconfig", -- general editor settings
      ".exrc", -- nvim config
      ".git", -- git
      "Cargo.toml", -- rust
      "Makefile", -- c/c++
      "package.json", -- javascript
      "pyproject.toml", -- python
      "setup.py", -- python
    })

    if root then vim.fn.chdir(root) end
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
      [[A<Up><CR><C-\><C-n>G]],
      { noremap = true, silent = true }
    )
  end,
})

-- Automatically set the colorcolumn to the textwidth of the current buffer.
autocmd("BufWinEnter", {
  group = augroup("textwidth colorcolumn", {}),
  callback = function() vim.opt_local.colorcolumn = "" .. vim.bo.textwidth end,
})

-- Highlight text on yank
autocmd("TextYankPost", {
  group = augroup("highlight on yank", {}),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
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
        vim.api.nvim_exec2(contents, {})
      else
        vim.notify(string.format("skipping %s", f), vim.log.levels.DEBUG)
      end
    end
  end,
})
