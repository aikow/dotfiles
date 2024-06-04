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
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
    focusable = false,
    relative = "cursor",
  })
end

---Setup a single server's configuration using nvim-lspconfig.
---@param server string | table
local function setup_server(server)
  if type(server) == "string" then server = { server } end

  if server.setup == false then return end

  local server_name = server[1]

  -- Check if a module to configure the server exists.
  local server_mod_name = "user.plugins.lsp.servers." .. server_name
  local ok, server_mod = pcall(require, server_mod_name)
  local server_opts = ok and server_mod.opts or server.opts or {}

  server_opts.capabilities =
    require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

  -- If the server contains an `override_setup` method which returns true, don't continue setting up
  -- the server afterwards.
  if server_opts.override_setup then
    if server_opts.override_setup() then return end
  end

  -- Setup the LSP server using lspconfig.
  require("lspconfig")[server_name].setup(server_opts)
end

---Setup servers via mason-lspconfig. This means Mason will automatically try to install any missing
---servers.
---@param mason_servers (string | table)[]
local function setup_mason_servers(mason_servers)
  local mason_lspconfig = require("mason-lspconfig")
  mason_lspconfig.setup({
    ensure_installed = vim
      .iter(mason_servers)
      :filter(function(s) return s.install == true end)
      :map(function(s) return s[1] end)
      :totable(),
  })

  -- Extend the list of servers with all the installed servers.
  local all_mason_servers = mason_servers
  for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
    if not vim.tbl_contains(all_mason_servers, function(v) return v[1] == server end) then
      table.insert(all_mason_servers, { server, setup = "mason" })
    end
  end

  local handlers = {}
  for _, server in ipairs(all_mason_servers) do
    if server.setup == "mason" then
      -- Setup the server using the handlers from mason-lspconfig.
      handlers[server[1]] = function() setup_server(server) end
    elseif server.setup == "lspconfig" then
      -- Setup the server directly using lspconfig.
      setup_server(server)
    end
  end
  mason_lspconfig.setup_handlers(handlers)
end

function M.setup(_, opts)
  -- Setup keymaps when an LSP server is attach.
  on_attach(
    function(client, buffer) require("user.plugins.lsp.mappings").on_attach(client, buffer) end
  )

  -- Setup diagnostic icons and highlights.
  for name, icon in pairs(require("user.ui.icons").diagnostics) do
    name = "DiagnosticSign" .. name
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
  end
  vim.diagnostic.config(opts.diagnostics)

  -- Setup LSP related handlers.
  setup_lsp_handlers()

  local lsp_servers = vim
    .iter(opts.servers)
    :map(function(s)
      if type(s) ~= "table" then s = { s } end

      if s.setup == nil then s.setup = "mason" end
      if s.install == nil then s.install = true end

      return s
    end)
    :totable()

  -- Setup the actual LSP servers.
  setup_mason_servers(lsp_servers)
end

return M
