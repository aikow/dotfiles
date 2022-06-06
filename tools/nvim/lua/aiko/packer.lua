local M = {}

M.bootstrap = function()
  -- Convenience definitions.
  local fn = vim.fn

  -- For bootstrapping packer local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    vim.notify("Bootstrapping packer")
    fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    })

    vim.cmd("packadd packer.nvim")
    require("aiko.plugins")
    vim.cmd("PackerSync")
  end
end

M.setup = function()
  local packer_present, packer = pcall(require, "packer")

  if not packer_present then
    return
  end

  local plugins_present, plugins = pcall(require, "aiko.plugins")

  if not plugins_present then
    return
  end

  packer.init({
    auto_clean = true,
    compile_on_sync = true,
    git = { clone_timeout = 10 },
    display = {
      open_cmd = "80vnew \\[packer\\]",
    },
  })

  packer.startup(plugins.plugins)
end

return M
