local M = {}

function M.setup_plugins()
  vim.pack.add({
    { src = gh("nvim-mini/mini.nvim") },
  })

  -- Init mini.deps so that we can use the later() and now() helpers
  require("mini.deps").setup()

  -- Automatically load all lua files in the plugin dir
  local plugin_dir = vim.fn.stdpath("config") .. "/lua/user/plugins"
  for name, fs_type in vim.fs.dir(plugin_dir) do
    if fs_type == "directory" then name = name .. "/init.lua" end
    dofile(plugin_dir .. "/" .. name)
  end
end

function M.setup()
  require("user.globals")

  M.setup_plugins()
end

return M
