local M = {}

---Run the given function when an LSP server attaches to a buffer, using the
---builtin LspAttach autocommand.
---@param fn fun(client, bufnr: integer)
local function on_attach(fn)
  vim.api.nvim_create_autocmd("LspAttach", {
    ---@param params NvimAutocmdCallbackParams
    callback = function(params)
      local buffer = params.buf
      local client = vim.lsp.get_client_by_id(params.data.client_id)
      fn(client, buffer)
    end,
  })
end

---Override some options from neovim's builtin LSP handlers.
local function setup_lsp_handlers()
  -- Pretty borders for signature help and hover.
  -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  --   border = "rounded",
  -- })

  -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  --   border = "rounded",
  --   focusable = false,
  --   relative = "cursor",
  -- })

  -- Suppress error messages from lang servers.
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.notify = function(msg, log_level)
    if msg:match("exit code") then return end
    if log_level == vim.log.levels.ERROR then
      vim.api.nvim_err_writeln(msg)
    else
      vim.api.nvim_echo({ { msg } }, true, {})
    end
  end
end

---Setup a single server's configuration using nvim-lspconfig.
---@param server string
local function setup_server(server)
  -- Check if a module to configure the server exists.
  local server_mod_name = "user.plugins.lsp.servers." .. server
  local ok, server_mod = pcall(require, server_mod_name)
  local server_opts = ok and server_mod.opts or {}

  -- server_opts.capabilities =
  --   require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

  -- If the server contains an `override_setup` method which returns true,
  -- don't continue setting up the server afterwards.
  if server_opts.override_setup then
    if server_opts.override_setup() then return end
  end

  -- Setup the LSP server using lspconfig.
  require("lspconfig")[server].setup(server_opts)
end

---Setup servers via mason-lspconfig. This means Mason will automatically try to
---install any missing servers.
---@param mason_servers string[]
local function setup_mason_servers(mason_servers)
  local mason_lspconfig = require("mason-lspconfig")
  mason_lspconfig.setup({ ensure_installed = vim.tbl_values(mason_servers) })

  -- Extend the list of servers with all the installed servers.
  local all_mason_servers = mason_servers
  for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
    if not vim.tbl_contains(all_mason_servers, server) then
      table.insert(all_mason_servers, server)
    end
  end

  local handlers = {}
  for _, server in ipairs(all_mason_servers) do
    handlers[server] = setup_server(server)
  end
  mason_lspconfig.setup_handlers(handlers)
end

---Setup native servers using lspconfig directly. This is useful for servers
---that aren't supposed to be managed by Mason.
---@param native_servers string[]
local function setup_native_servers(native_servers)
  for _, server in ipairs(native_servers) do
    setup_server(server)
  end
end

function M.setup(_, opts)
  -- setup keymaps
  on_attach(
    function(client, buffer) require("user.plugins.lsp.mappings").on_attach(client, buffer) end
  )

  on_attach(function() vim.opt_local.omnifunc = "v:lua.MiniCompletion.completefunc_lsp" end)

  -- diagnostics
  for name, icon in pairs(require("user.ui.icons").diagnostics) do
    name = "DiagnosticSign" .. name
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
  end
  vim.diagnostic.config(opts.diagnostics)

  setup_lsp_handlers()
  setup_mason_servers(opts.servers.mason)
  setup_native_servers(opts.servers.native)
end

return M
