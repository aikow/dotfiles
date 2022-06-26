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
  if vim.fn.executable("pyright") == 1 then
    lspconfig.pyright.setup({
      capabilities = capabilities,
    })
  end

  -- CPP and C server
  if vim.fn.executable("clangd") == 1 then
    lspconfig.clangd.setup({
      capabilities = capabilities,
    })
  end

  -- Bash language server
  if vim.fn.executable("bash-language-server") == 1 then
    lspconfig.bashls.setup({
      capabilities = capabilities,
    })
  end

  -- YAML language server
  if vim.fn.executable("yaml-language-server") == 1 then
    lspconfig.yamlls.setup({
      capabilities = capabilities,
    })
  end

  M.jsonls(lspconfig, capabilities)

  M.sumneko_lua(lspconfig, capabilities)
end

M.jsonls = function(lspconfig, capabilities)
  lspconfig.jsonls.setup({
    capabilities = capabilities,
  })
end

M.sumneko_lua = function(lspconfig, capabilities)
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
      client.config.settings.Lua.diagnostics.globals = { "awesome", "client", "screen", "root" }
    end

    client.notify("workspace/didChangeConfiguration")
    return true
  end

  lspconfig.sumneko_lua.setup({
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
  })
end

return M
