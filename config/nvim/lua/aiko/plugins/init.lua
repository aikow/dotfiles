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

M.setup = function()
  local ok_lazy, lazy = pcall(require, "lazy")
  if not ok_lazy then
    return
  end

  lazy.setup("aiko.plugins.spec", {
    change_detection = {
      enabled = true,
      notify = false,
    },
  })
end

return M
