local tbl = require("aiko.util.table")
local generate_capabilities =
  require("aiko.plugins.configs.lspconfig.capabilities").generate_capabilities
local mappings = require("aiko.plugins.configs.lspconfig.mappings")

---@class Server
---@field name string name of the LSP server
---@field on_attach function
---@field on_init function
---@field configure_capabilities function
---@field settings table
---@field filetypes table
local Server = {}

function Server:_on_init(client)
  if self.on_init then
    local result = self.on_init(client)
    if not result then
      vim.notify("LSP on_init failed")
    end
  end

  local wks = require("aiko.workspace")
  local workspace_path = client.workspace_folders[1].name
  local config =
    wks.get_config(workspace_path, string.format("lsp/%s.json", client.name))

  if config.settings then
    local settings = client.config.settings
    client.config.settings = tbl.deep_type_extend(config.settings, settings)

    vim.notify("Loaded workspace settings")
  end

  client.notify(
    "workspace/didChangeConfiguration",
    { settings = client.config.settings }
  )

  return true
end

function Server:_on_attach(client, bufnr)
  -- Setup navic component for status line.
  local ok_nvim_navic, nvim_navic = pcall(require, "nvim-navic")
  if ok_nvim_navic then
    nvim_navic.attach(client, bufnr)
  end

  mappings.setup()

  if self.on_attach then
    self.on_attach(client, bufnr)
  end
end

function Server:setup()
  local opts = {}

  -- Get the capabilities
  opts.capabilities = generate_capabilities()
  if self.configure_capabilities then
    self.configure_capabilities(opts.capabilities)
  end

  -- Copy table values
  opts.settings = self.settings
  opts.filetypes = self.filetypes

  -- Setup callbacks
  opts.on_attach = function(client, bufnr)
    self:_on_attach(client, bufnr)
  end
  opts.on_init = function(client)
    self:_on_init(client)
  end

  -- Setup the LSP server using lspconfig.
  local lspconfig = require("lspconfig")
  lspconfig[self.name].setup(opts)
end

---Constructor for server objects
---@param name string the LSP servers name
---@param options table default server
---@return Server
function Server:new(name, options)
  options = options or {}
  options.name = name
  return setmetatable(options, {
    __index = self,
  })
end

return Server
