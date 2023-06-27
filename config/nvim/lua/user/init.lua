local M = {}

M.bootstrap = function()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end

  vim.opt.runtimepath:prepend(lazypath)
end

M.plugins = function()
  local ok_lazy, lazy = pcall(require, "lazy")
  if not ok_lazy then
    return
  end

  local imports = {
    { import = "user.plugins" },
  }

  -- Only add local plugins if the directory exists.
  if vim.fn.globpath(vim.o.runtimepath, "/lua/aiko/local/plugins/*") ~= "" then
    table.insert(imports, { import = "user.local.plugins" })
  end

  lazy.setup(imports, {
    change_detection = {
      enabled = true,
      notify = false,
    },
    performance = {
      rtp = {
        paths = {
          vim.fs.normalize("~/.local/config/nvim"),
        },
      },
    },
  })
end

M.setup = function()
  -- Setup packer and plugins
  M.bootstrap()
  M.plugins()

  -- Setup options, key-maps and personal auto commands.
  require("user.config").setup()
end

return M
