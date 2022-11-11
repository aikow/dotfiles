local ui = require("aiko.plugins.configs.lspconfig.ui")
local mappings = require("aiko.plugins.configs.lspconfig.mappings")
local Server = require("aiko.plugins.configs.lspconfig.server")

local M = {}

M.mappings = mappings.setup
M.ui = ui.setup
M.Server = Server

M.servers = {
  "bashls",
  "clangd",
  "gopls",
  "jsonls",
  "ltex",
  "marksman",
  "pyright",
  "sqls",
  "sumneko_lua",
  "taplo",
  "vimls",
  "yamlls",
}

-- ------------------------------------------------------------------------
-- | Setup LSP Servers
-- ------------------------------------------------------------------------
M.setup = function()
  -- Require lspconfig module.
  local ok_lspconfig, _ = pcall(require, "lspconfig")
  if not ok_lspconfig then
    return
  end

  ui.setup()

  local base_module_path = "aiko.plugins.configs.lspconfig.servers."
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
