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

  lspconfig.jsonls.setup({
    capabilities = capabilities,
  })

  -- Lua language server
  lspconfig.sumneko_lua.setup({
    capabilities = capabilities,
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim", "awesome", "client", "root" },
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
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  })
end

return M
