local M = {}

M.setup = function()
  -- Setup nvim-cmp with lspconfig.
  require("nvim-lsp-installer").setup({})
  local lspconfig = require("lspconfig")

  -- Borders for LspInfo window
  local win = require("lspconfig.ui.windows")
  local _default_opts = win.default_opts

  win.default_opts = function(options)
    local opts = _default_opts(options)
    opts.border = "single"
    return opts
  end

  local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

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
          globals = { "vim" },
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
