local M = {}

M.bootstrap = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data")
    .. "/site/pack/packer/start/packer.nvim"

  -- Set a dark background color, in case the default is bright.
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e222a" })

  if fn.empty(fn.glob(install_path)) > 0 then
    print("Cloning packer ..")
    fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    })

    -- install plugins + compile their configs
    vim.cmd.packadd("packer.nvim")
    require("plugins")
    vim.cmd.PackerSync()
  end
end

M.setup = function()
  local ok_packer, packer = pcall(require, "packer")
  if not ok_packer then
    return
  end

  local ok_sources, sources = pcall(require, "aiko.plugins.sources")
  if not ok_sources then
    return
  end

  local icons = require("aiko.ui.icons").packer

  packer.init({
    auto_clean = true,
    auto_reload_compiled = true,
    compile_on_sync = true,
    git = { clone_timeout = 10 },
    display = {
      working_sym = icons.working,
      error_sym = icons.error,
      done_sym = icons.done,
      removed_sym = icons.removed,
      moved_sym = icons.moved,
      open_fn = function()
        return require("packer.util").float({
          border = "none",
        })
      end,
    },
  })

  packer.startup(function(use)
    for n, p in pairs(sources) do
      p[1] = n
      use(p)
    end
  end)
end

return M
