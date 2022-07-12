local M = {}

M.setup = function()
  local ok_lsp_installer, lsp_installer = pcall(require, "nvim-lsp-installer")
  if not ok_lsp_installer then
    return
  end

  -- Setup nvim-cmp with lspconfig.
  lsp_installer.setup({})

  local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
  if not ok_lspconfig then
    return
  end

  -- Borders for LspInfo window
  local win = require("lspconfig.ui.windows")
  local _default_opts = win.default_opts

  win.default_opts = function(options)
    local opts = _default_opts(options)
    opts.border = "single"
    return opts
  end

  local capabilities = require("cmp_nvim_lsp").update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  )

  -- Python language server.
  lspconfig.pyright.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
  })

  -- CPP and C server
  lspconfig.clangd.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
  })

  -- Bash language server
  lspconfig.bashls.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
  })

  -- YAML language server
  lspconfig.yamlls.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
  })

  lspconfig.jsonls.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
  })

  M.sumneko_lua(capabilities)
  lspconfig.sumneko_lua.setup(M.sumneko_lua(capabilities))
end

M.on_attach = function(client, bufnr)
  local ok_nvim_navic, nvim_navic = pcall(require, "nvim-navic")
  if ok_nvim_navic then
    nvim_navic.attach(client, bufnr)
  end
end

M.sumneko_lua = function(capabilities)
  -- Setup configuration for neovim.
  local setup_neovim_libraries = function()
    -- Add all library paths from vim's runtime path.
    local library = {}
    local packer_dir = vim.fn.stdpath("data") .. "/site/pack/packer/**/lua"

    for path in string.gmatch(vim.fn.glob(packer_dir), "[^\n]+") do
      if vim.fn.empty(vim.fn.glob(path)) then
        library[path] = true
      end
    end

    library[vim.fn.expand("$VIMRUNTIME/lua")] = true
    library[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true

    return library
  end

  --- Adds a custom hook on initialization that only adds the library path's if
  -- the current working directory is the nvim directory.
  local on_init = function(client)
    local workspace = client.workspace_folders[1].name

    if string.match(workspace, [[.dotfiles/tools/nvim$]]) then
      client.config.settings.Lua.workspace.library = setup_neovim_libraries()
      client.config.settings.Lua.diagnostics.globals = { "vim" }
    elseif string.match(workspace, [[.dotfiles/os/awesome$]]) then
      client.config.settings.Lua.diagnostics.globals =
        { "awesome", "client", "screen", "root" }
    end

    client.notify("workspace/didChangeConfiguration")
    return true
  end

  return {
    on_attach = M.on_attach,
    on_init = on_init,
    capabilities = capabilities,
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim", "awesome", "client", "screen", "root" },
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
    },
  }
end

return M
