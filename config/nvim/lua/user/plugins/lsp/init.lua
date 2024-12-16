---Setup a single server's configuration using nvim-lspconfig.
local function setup_server(server_name)
  -- Check if a module to configure the server exists.
  local server_mod_name = "user.plugins.lsp.servers." .. server_name
  local ok, server_mod = pcall(require, server_mod_name)
  local server_opts = ok and server_mod.opts or {}

  server_opts.capabilities = require("blink.cmp").get_lsp_capabilities(server_opts.capabilities)

  -- If the server contains an `override_setup` method which returns true, don't continue setting up
  -- the server afterwards.
  if server_opts.override_setup then
    if server_opts.override_setup() then return end
  end

  -- Setup the LSP server using lspconfig.
  require("lspconfig")[server_name].setup(server_opts)
end

MiniDeps.now(function()
  MiniDeps.add({
    source = "saghen/blink.cmp",
    depends = { "rafamadriz/friendly-snippets" },
    hooks = {
      post_checkout = function(params)
        local proc = vim.system({ "cargo", "build", "--release" }, { cwd = params.path }):wait()
        if proc.code == 0 then
          vim.notify("Building blink.cmp done", vim.log.levels.INFO)
        else
          vim.notify("Building blink.cmp failed", vim.log.levels.ERROR)
        end
      end,
    },
  })

  require("blink.cmp").setup({
    completion = {
      list = {
        selection = "auto_insert",
      },
    },
    snippets = {
      expand = function(snippet) require("luasnip").lsp_expand(snippet) end,
      active = function(filter)
        if filter and filter.direction then return require("luasnip").jumpable(filter.direction) end
        return require("luasnip").in_snippet()
      end,
      jump = function(direction) require("luasnip").jump(direction) end,
    },
    sources = {
      default = { "lsp", "path", "luasnip", "buffer" },
    },
  })
end)

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

  -- Setup keymaps when an LSP server is attach.
  vim.api.nvim_create_autocmd("LspAttach", {
    ---@param params NvimAutocmdCallbackParams
    callback = function(params)
      local buffer = params.buf
      local client = vim.lsp.get_client_by_id(params.data.client_id)
      require("user.plugins.lsp.mappings").on_attach(client, buffer)
    end,
  })
end)
