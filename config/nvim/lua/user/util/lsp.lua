local M = {}

M.lsp_timeout = 10000

---Register a callback to run when connecting to a new LSP client.
---@param on_attach fun(client: vim.lsp.Client, buffer: integer)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(params)
      local buffer = params.buf
      local client = vim.lsp.get_client_by_id(params.data.client_id)
      if client then on_attach(client, buffer) end
    end,
  })
end

---Get the attribute of obj which is indexed by the items in the path.
---This is a convenience method for dealing with optional nil elements somewhere
---in a deeply nested table.
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

  return vim.regex(regex)
end

---Match a list of LSP file operation filters against a file path.
---Returns true if any filter matches the absolute path of the file, and false
---otherwise.
---@param filters lsp.FileOperationFilter[]
---@param name string
---@return boolean
local function matches_filters(filters, name)
  local path = vim.fs.abspath(name)
  local stat = vim.uv.fs_stat(path)
  local is_dir = stat.type == "directory"

  for _, filter in pairs(filters) do
    local match_type = filter.pattern.matches

    if
      not match_type
      or (match_type == "folder" and is_dir)
      or (match_type == "file" and not is_dir)
    then
      local regex = get_regex(filter.pattern)
      if regex:match_str(path) ~= nil then return true end
    end
  end
  return false
end

---Handle renaming a file for all LSP clients.
---@param from_path string
---@param to_path string
function M.lsp_will_rename(from_path, to_path)
  for _, client in vim.iter(vim.lsp.get_clients({ method = "workspace/willRenameFiles" })) do
    local will_rename =
      get_path(client, { "server_capabilities", "workspace", "fileOperations", "willRename" })

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

---Handle renaming a file for all LSP clients after it has been renamed.
---@param from_path string
---@param to_path string
function M.lsp_did_rename(from_path, to_path)
  for _, client in vim.iter(vim.lsp.get_clients({ method = "workspace/didRenameFiles" })) do
    local did_rename =
      get_path(client, { "server_capabilities", "workspace", "fileOperations", "didRename" })

    local filters = did_rename.filters or {}
    if matches_filters(filters, to_path) then
      client:notify("workspace/didRenameFiles", {
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

---Show the document symbols of the buffer displayed in window with winid in the location list after
---applying a filer.
---@param winid integer Window ID.
---@param kinds string[] List of symbol kinds to display.
function M.document_symbols(winid, kinds)
  return function()
    vim.lsp.buf.document_symbol({
      on_list = function(options)
        options.items = vim
          .iter(options.items)
          :filter(function(o)
            -- Need to remove any LSP-Kind icons from the kind string.
            local kind = string.gsub(o.kind, "%W", "")
            return vim.tbl_contains(kinds, kind)
          end)
          :totable()
        ---@diagnostic disable-next-line: param-type-mismatch
        vim.fn.setloclist(winid, {}, " ", options)
        vim.api.nvim_win_call(winid, vim.cmd.lopen)
      end,
    })
  end
end

---Switch between showing virtual diagnostics after each line and below each line.
function M.toggle_virtual_diagnostics()
  local config = vim.diagnostic.config()
  if config then
    config.virtual_lines = not config.virtual_lines
    config.virtual_text = not config.virtual_text
    vim.diagnostic.config(config)
  end
end

---Toggle showing inlay hints.
function M.toggle_inlay_hints() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end

return M
