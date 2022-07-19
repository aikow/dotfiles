local M = {}

M.on_attach = function(client, bufnr)
  -- Setup navic component for status line.
  local ok_nvim_navic, nvim_navic = pcall(require, "nvim-navic")
  if ok_nvim_navic then
    nvim_navic.attach(client, bufnr)
  end

  M.mappings()
end

M.mappings = function()
  local map = vim.keymap.set

  map(
    "n",
    "<leader>e",
    vim.diagnostic.open_float,
    { silent = true, desc = "open diagnostic window" }
  )
  map(
    { "n", "v", "o" },
    "[e",
    vim.diagnostic.goto_prev,
    { silent = true, desc = "go to previous diagnostic" }
  )
  map(
    { "n", "v", "o" },
    "]e",
    vim.diagnostic.goto_next,
    { silent = true, desc = "go to next diagnostic" }
  )
  map(
    "n",
    "<leader>dl",
    vim.diagnostic.setloclist,
    { silent = true, desc = "set location list to diagnostics" }
  )

  -- Refactoring with <leader>r...
  map(
    "n",
    "<leader>rr",
    vim.lsp.buf.rename,
    { silent = true, desc = "LSP rename" }
  )
  map(
    "n",
    "<leader>rq",
    vim.lsp.buf.code_action,
    { silent = true, desc = "LSP code actions" }
  )
  map(
    "n",
    "<leader>rf",
    vim.lsp.buf.formatting,
    { silent = true, desc = "LSP format file" }
  )
end

M.ui = function()
  local function lspSymbol(name, icon)
    local hl = "DiagnosticSign" .. name
    vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
  end

  lspSymbol("Error", "")
  lspSymbol("Info", "")
  lspSymbol("Hint", "")
  lspSymbol("Warn", "")

  vim.diagnostic.config({
    virtual_text = {
      prefix = "",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
  })

  -- Pretty borders for signature help and hover.
  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, {
      border = "single",
    })

  vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "single",
      focusable = false,
      relative = "cursor",
    })

  -- Suppress error messages from lang servers.
  vim.notify = function(msg, log_level)
    if msg:match("exit code") then
      return
    end
    if log_level == vim.log.levels.ERROR then
      vim.api.nvim_err_writeln(msg)
    else
      vim.api.nvim_echo({ { msg } }, true, {})
    end
  end

  -- Borders for LspInfo winodw
  local win = require("lspconfig.ui.windows")
  local _default_opts = win.default_opts

  win.default_opts = function(options)
    local opts = _default_opts(options)
    opts.border = "single"
    return opts
  end
end

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
    tagSupport = { valueSet = { 1 } },
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

M.setup = function()
  local ok_lsp_installer, lsp_installer = pcall(require, "nvim-lsp-installer")
  if not ok_lsp_installer then
    return
  end

  lsp_installer.setup({})

  local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
  if not ok_lspconfig then
    return
  end

  M.ui()

  local capabilities = M.capabilities()

  local servers = {
    "pyright",
    "clangd",
    "bashls",
    "yamlls",
    "jsonls",
    "taplo",
    "vimls",
    "gopls",
  }

  -- Basic language servers
  for _, ls in pairs(servers) do
    lspconfig[ls].setup({
      on_attach = M.on_attach,
      capabilities = capabilities,
    })
  end

  M.grammarly(lspconfig)
  M.sumneko_lua(lspconfig)
end

M.grammarly = function(lspconfig)
  lspconfig.grammarly.setup({
    on_attach = M.on_attach,
    capabilities = M.capabilities(),
    filetypes = { "markdown", "tex" },
    settings = {
      suggestions = {
        PassiveVoice = true,
        OxfordComma = true,
      },
    },
  })
end

M.sumneko_lua = function(lspconfig)
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

  lspconfig.sumneko_lua.setup({
    on_attach = M.on_attach,
    on_init = on_init,
    capabilities = M.capabilities(),
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
