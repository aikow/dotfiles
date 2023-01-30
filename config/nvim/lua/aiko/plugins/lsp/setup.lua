local M = {}

---@param on_attach function(client, bufnr)
local on_attach = function(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

local setup_handlers = function()
  -- Pretty borders for signature help and hover.
  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
    })

  vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded",
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
end

M.setup = function(opts)
  -- setup autoformat
  require("aiko.plugins.lsp.format").autoformat = opts.autoformat

  -- setup formatting and keymaps
  on_attach(function(client, buffer)
    require("aiko.plugins.lsp.format").on_attach(client, buffer)
    require("aiko.plugins.lsp.mappings").on_attach(client, buffer)
  end)

  -- diagnostics
  for name, icon in pairs(require("aiko.ui.icons").diagnostics) do
    name = "DiagnosticSign" .. name
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
  end
  vim.diagnostic.config(opts.diagnostics)

  setup_handlers()

  local servers = opts.servers
  local capabilities = require("cmp_nvim_lsp").default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  )

  local mason_lspconfig = require("mason-lspconfig")
  mason_lspconfig.setup({ ensure_installed = vim.tbl_values(servers) })

  -- Extend the list of servers with all the installed servers.
  local all_servers = servers
  for _, server in pairs(mason_lspconfig.get_installed_servers()) do
    local contains = false
    for _, s in pairs(all_servers) do
      if s == server then
        contains = true
      end
    end
    if not contains then
      table.insert(all_servers, server)
    end
  end

  local handlers = {}
  for _, server in pairs(all_servers) do
    handlers[server] = function()
      -- Check if a module to configure the server exists.
      local server_mod_name = "aiko.plugins.lsp.servers." .. server
      local ok, server_mod = pcall(require, server_mod_name)
      local server_opts = ok and server_mod.opts or {}

      server_opts.capabilities = capabilities
      -- If the server contains an `override_setup` method which returns true,
      -- don't continue setting up the server afterwards.
      if server_opts.override_setup then
        if server_opts.override_setup() then
          return
        end
      end

      -- Setup the LSP server using lspconfig.
      require("lspconfig")[server].setup(server_opts)
    end
  end
  mason_lspconfig.setup_handlers(handlers)
end

return M
