local M = {}

function M.bootstrap_lazy()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.uv.fs_stat(lazypath) then
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

function M.setup_lazy()
  local ok_lazy, lazy = pcall(require, "lazy")
  if not ok_lazy then return end

  local specs = {
    { import = "user.plugins" },
  }

  -- Check that the local plugins module actually exists. We do this by checking
  -- if the directory contains any lua files.
  if
      vim
      .iter(vim.fs.dir(vim.fs.normalize("~/.local/config/nvim/lua/user/local/plugins"), { depth = 8 }))
      :any(function(item) return vim.endswith(item, ".lua") end)
  then
    table.insert(specs, { import = "user.local.plugins" })
  end

  lazy.setup({
    spec = specs,
    ---@diagnostic disable-next-line: assign-type-mismatch
    dev = {
      path = "~/workspace/repos/aikow",
      patterns = { "aikow" },
      fallback = true,
    },
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

function M.setup_user()
  require("user.builtin")
  require("user.globals")
  require("user.filetype")
  require("user.mappings")
  require("user.options")
  require("user.autocmds")
  require("user.commands")

  if vim.fn.exists("neovide") == 1 then require("user.neovide") end
end

function M.setup()
  -- Setup lazy.nvim package manager
  M.bootstrap_lazy()
  M.setup_lazy()

  -- Setup options, key-maps and personal auto commands, and all other user
  -- commands.
  M.setup_user()
end

return M
