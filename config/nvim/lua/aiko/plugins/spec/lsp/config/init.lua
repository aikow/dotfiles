local ui = require("aiko.plugins.spec.lsp.config.ui")
local mappings = require("aiko.plugins.spec.lsp.config.mappings")
local Server = require("aiko.plugins.spec.lsp.config.server")

local M = {}

M.mappings = mappings.setup
M.ui = ui.setup
M.Server = Server

M.servers = {
  "bashls",
  "clangd",
  "dockerls",
  "gopls",
  "jsonls",
  "ltex",
  "marksman",
  "pyright",
  -- "sqls",
  "sumneko_lua",
  "taplo",
  "tsserver",
  -- "vimls",
  "yamlls",
}

-- ------------------------------------------------------------------------
-- | Setup LSP Servers
-- ------------------------------------------------------------------------
M.setup = function()
  -- Require lspconfig module.
  ui.setup()

  local base_module_path = "aiko.plugins.spec.lsp.config.servers."
  for _, server_name in pairs(M.servers) do
    local module_path = base_module_path .. server_name

    local options = {}
    local ok, module_options = pcall(require, module_path)
    if ok then
      options = module_options
    end
    local server = Server:new(server_name, options)
    server:setup()
  end
end

return M
