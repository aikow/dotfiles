local M = {}

M.package_path = vim.fn.stdpath("data") .. "/site/"
M.mini_path = M.package_path .. "/pack/deps/start/mini.nvim"

function M.bootstrap_mini()
  if not vim.uv.fs_stat(M.mini_path) then
    vim
      .system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/echasnovski/mini.nvim",
        M.mini_path,
      }, {})
      :wait()

    vim.cmd.packadd({ "mini.nvim" })
    vim.cmd.helptags({ "ALL" })
  end
end

function M.setup_plugins()
  local ok_minideps, minideps = pcall(require, "mini.deps")
  if not ok_minideps then return end

  minideps.setup({
    path = {
      package = M.path_package,
    },
  })

  -- Automatically load all lua files in the plugin dir
  local plugin_dir = vim.fs.normalize("~/.dotfiles/config/nvim/lua/user/plugins")
  for name, fs_type in vim.fs.dir(plugin_dir) do
    if fs_type == "directory" then name = name .. "/init.lua" end
    dofile(plugin_dir .. "/" .. name)
  end
end

function M.setup()
  -- Setup lazy.nvim package manager
  M.bootstrap_mini()
  M.setup_plugins()

  -- Setup options, key-maps and personal auto commands, and all other user commands.
  require("user.config").setup()
end

return M
