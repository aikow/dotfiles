---Setup a single server's configuration using nvim-lspconfig.
local function setup_server(server_name)
  -- Check if a module to configure the server exists.
  local server_mod_name = "user.plugins.lsp.servers." .. server_name
  local ok, server_mod = pcall(require, server_mod_name)
  local server_opts = ok and server_mod.opts or {}

  -- If the server contains an `override_setup` method which returns true, don't continue setting up
  -- the server afterwards.
  if server_opts.override_setup then
    if server_opts.override_setup() then return end
  end

  -- Setup the LSP server using lspconfig.
  require("lspconfig")[server_name].setup(server_opts)
end

MiniDeps.now(function()
  -- Provide adapter and helper functions for setting up language servers.
  MiniDeps.add({
    source = "neovim/nvim-lspconfig",
    depends = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/lazydev.nvim",
      "b0o/SchemaStore.nvim",
    },
    hooks = { post_checkout = function() vim.cmd.MasonUpdate() end },
  })
  require("lazydev").setup()
  require("mason").setup()
  require("mason-lspconfig").setup({
    automatic_installation = false,
    ensure_installed = { "lua_ls" },
  })
  require("mason-lspconfig").setup_handlers({
    function(server_name) setup_server(server_name) end,
  })

  -- Setup LSP servers not installed by mason.
  setup_server("rust_analyzer")
  setup_server("julials")
  setup_server("nushell")

  -- Configure neovim diagnostics
  vim.diagnostic.get_namespaces()
  vim.diagnostic.config({
    virtual_lines = false,
    virtual_text = true,
    float = {
      suffix = function(diagnostic)
        if vim.iter(vim.diagnostic.get_namespaces()):enumerate():last()[1] > 1 then
          return " [" .. diagnostic.source .. "]", "Comment"
          ---@diagnostic disable-next-line: missing-return
        end
      end,
    },
  })

  -- Setup keymaps when an LSP server is attach.
  require("user.util.lsp").on_attach(require("user.plugins.lsp.mappings").on_attach)
  require("user.util.lsp").on_attach(
    function(_, buffer) vim.bo[buffer].completefunc = "v:lua.MiniCompletion.completefunc_lsp" end
  )
end)
