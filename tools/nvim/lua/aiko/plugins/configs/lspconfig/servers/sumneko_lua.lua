local S = {}

-- Setup configuration for neovim.
local setup_neovim_libraries = function()
  -- Add all library paths from vim's runtime path.
  local library = {}
  local packer_dir = vim.fn.stdpath("data") .. "/site/pack/packer/*/*/lua"

  for path in string.gmatch(vim.fn.glob(packer_dir), "[^\n]+") do
    if vim.fn.empty(vim.fn.glob(path)) == 0 then
      library[path] = true
    end
  end

  library[vim.fn.expand("$VIMRUNTIME/lua")] = true
  library[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true

  return library
end

--- Adds a custom hook on initialization that only adds the library path's if
--- the current working directory is the nvim directory.
S.on_init = function(client)
  local workspace = client.workspace_folders[1].name
  local config = client.config.settings.Lua

  if string.match(workspace, [[.dotfiles/tools/nvim$]]) then
    -- Setup all the libraries here, since it can be relatively time intensive.
    config.workspace.library = setup_neovim_libraries()
  end

  return true
end

---comment configure the default capabilities.
---@param capabilities Capabilities
S.configure_capabilities = function(capabilities)
  capabilities.documentFormatingProvider = false
end

S.settings({
  Lua = {
    diagnostics = {
      globals = {
        "vim",
      },
    },
    format = {
      enable = true,
      -- All values must be of type string.
      defaultConfig = {
        indent_style = "space",
        indent_size = "2",
      },
    },
    workspace = {
      maxPreload = 100000,
      preloadFileSize = 10000,
    },
  },
})

return S
