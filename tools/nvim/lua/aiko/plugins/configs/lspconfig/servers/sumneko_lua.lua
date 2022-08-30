local M = {}

M.capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- Setup nvim-cmp with lspconfig.
  local ok_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok_cmp_nvim_lsp then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  end

  capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = {
      valueSet = { 1 },
    },
    resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
      },
    },
  }

  return capabilities
end

-- Setup configuration for neovim.
M.setup_neovim_libraries = function()
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
M.on_init = function(client)
  local workspace = client.workspace_folders[1].name
  local config = client.config.settings.Lua

  if string.match(workspace, [[.dotfiles/tools/nvim$]]) then
    -- Neovim configs
    -- setup libraries
    config.workspace.library = M.setup_neovim_libraries()

    -- Setup global variables
    local diagnostics = config.diagnostics or {}
    diagnostics.globals = { "vim" }
    config.diagnostics = diagnostics
  end

  local wks = require("aiko.workspace")
  local workspace_path = client.workspace_folders[1].name

  local config =
    wks.get_config(workspace_path, string.format("lsp/%s.json", client.name))

  if config.settings then
    local settings = client.config.settings
    client.config.settings = tbl.deep_type_extend(config.settings, settings)

    client.notify(
      "workspace/didChangeConfiguration",
      { settings = client.config.settings }
    )
    vim.notify("Loading workspace settings")
  end

  return true
end

M.setup = function(lspconfig)
  local capabilities = M.capabilities()
  capabilities.documentFormatingProvider = false

  lspconfig.sumneko_lua.setup({
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = capabilities,
    settings = {
      Lua = {
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
    },
  })
end

return M
