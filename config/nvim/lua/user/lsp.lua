local M = {}

M.lsp_timeout = 10000

---Register a callback to run when connecting to a new LSP client.
---@param on_attach fun(client: vim.lsp.Client, buffer: integer)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    ---@param params NvimAutocmdCallbackParams
    callback = function(params)
      local buffer = params.buf
      local client = vim.lsp.get_client_by_id(params.data.client_id)
      if client then on_attach(client, buffer) end
    end,
  })
end

---Get the attribute of obj which is indexed by the items in the path.
---This is a convenience method for dealing with optional nil elements somewhere
---in a
---
---@param obj table
---@param path string[]
---@return any
local function get_path(obj, path)
  local current = obj
  for _, key in ipairs(path) do
    if current[key] == nil then return nil end
    current = current[key]
  end
  return current
end

---Convert a file operation filter pattern to a vim regex.
---@param pattern lsp.FileOperationPattern
---@return vim.regex
local function get_regex(pattern)
  local regex = vim.fn.glob2regpat(pattern.glob)
  if pattern.options and pattern.options.ignoreCase then regex = "\\c" .. regex end

  ---@diagnostic disable-next-line: return-type-mismatch
  return vim.regex(regex)
end

---Match a list of LSP file operation filters against a file path.
---Returns true if any filter matches the absolute path of the file, and false
---otherwise.
---@param filters lsp.FileOperationFilter[]
---@param name string
---@return boolean
local function matches_filters(filters, name)
  local path = require("plenary").Path:new(name)
  local is_dir = path:is_dir()

  for _, filter in pairs(filters) do
    local match_type = filter.pattern.matches

    if
      not match_type
      or (match_type == "folder" and is_dir)
      or (match_type == "file" and not is_dir)
    then
      local regex = get_regex(filter.pattern)
      if regex:match_str(path:absolute()) ~= nil then return true end
    end
  end
  return false
end

---Handle renaming a file for all LSP clients.
---@param from_path string
---@param to_path string
function M.lsp_will_rename(from_path, to_path)
  for _, client in ipairs(vim.lsp.get_clients()) do
    local will_rename =
      get_path(client, { "server_capabilities", "workspace", "fileOperations", "willRename" })
    if will_rename == nil then return end

    local filters = will_rename.filters or {}
    if matches_filters(filters, from_path) then
      local success, resp = pcall(client.request_sync, "workspace/willRenameFiles", {
        files = {
          {
            oldUri = vim.uri_from_fname(from_path),
            newUri = vim.uri_from_fname(to_path),
          },
        },
      }, M.lsp_timeout)

      if success and resp and resp.result ~= nil then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
  end
end

function M.lsp_did_rename(from_path, to_path)
  for _, client in pairs(vim.lsp.get_clients()) do
    local did_rename =
      get_path(client, { "server_capabilities", "workspace", "fileOperations", "didRename" })
    if did_rename == nil then return end

    local filters = did_rename.filters or {}
    if matches_filters(filters, from_path) then
      client.notify("workspace/didRenameFiles", {
        files = {
          {
            oldUri = vim.uri_from_fname(from_path),
            newUri = vim.uri_from_fname(to_path),
          },
        },
      })
    end
  end
end

return M
