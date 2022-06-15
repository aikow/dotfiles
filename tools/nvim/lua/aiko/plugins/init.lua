local M = {}

M.bootstrap = function()
  -- Convenience definitions.
  local fn = vim.fn

  -- For bootstrapping packer local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    vim.notify("Bootstrapping packer")
    local out = fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    })

    vim.notify(out)
    vim.cmd("packadd packer.nvim")

    M.setup()
    vim.cmd("PackerSync")
  end
end

M.setup = function()
  local ok_packer, packer = pcall(require, "packer")
  if not ok_packer then
    return
  end

  local ok_plugins, plugins = pcall(require, "aiko.plugins.plugins")
  if not ok_plugins then
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

  packer.startup(plugins.use)
end

M.lazy_load = function(plugin)
  vim.defer_fn(function()
    require("packer").loader(plugin)
  end, 0)
end

return M
