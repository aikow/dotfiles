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
  vim.opt.rtp:prepend(lazypath)
end

M.plugins = function()
  local ok_lazy, lazy = pcall(require, "lazy")
  if not ok_lazy then
    return
  end

  lazy.setup("aiko.plugins", {
    change_detection = {
      enabled = true,
      notify = false,
    },
  })
end

M.setup = function()
  -- Setup packer and plugins
  M.bootstrap()
  M.plugins()

  -- Setup options, key-maps and personal auto commands.
  require("aiko.config").setup()
end

return M
