local M = {}

---Iterate through all the captures of a query and apply the changes generated
---by `callback`.
---@param bufnr integer Buffer number. 0 for the current buffer
---@param query string Treesitter query.
---@param callback function The function that will be called for each capture.
---The function takes a single parameter, which is a table of lines of the
---capture.
---The second parameter is a table which contains the indentation as well
---@param opts table The table has the following options
---filetype string filetype of the treesitter parser.
---capture string name of the capture group.
M.iter_query = function(bufnr, query, callback, opts)
  -- Default to the current buffer.
  bufnr = (bufnr > 0) and bufnr or vim.api.nvim_get_current_buf()

  -- Get options if set, or their default values.
  opts = opts or {}
  local filetype = opts.filetype
      or vim.api.nvim_buf_get_option(bufnr, "filetype")
  local capture = opts.capture
  local line_offset = opts.line_offset or { 1, 0 }

  local ts_query = vim.treesitter.parse_query(filetype, query)

  local parser = vim.treesitter.get_parser(bufnr, filetype, {})
  local tree = parser:parse()[1]
  local root = tree:root()

  local changes = {}
  -- TODO: replace iter_captures with iter_matches to make it more generic.
  for id, node in ts_query:iter_captures(root, bufnr, 0, -1) do
    local name = ts_query.captures[id]
    if capture == nil or name == capture then
      local range = { node:range() }
      local indentation = string.rep(" ", range[2])

      -- Clean the input text.
      local text = vim.treesitter.get_node_text(node, bufnr)
      local formatted =
      callback(text, { range = range, indentation = indentation })

      -- Add indentation
      for idx, line in ipairs(formatted) do
        formatted[idx] = indentation .. line
      end

      -- Create table of changes in reverse order.
      table.insert(changes, 1, {
        start = range[1] + line_offset[1],
        final = range[3] + line_offset[2],
        formatted = formatted,
      })
    end
  end

  -- Apply all the changes in reverse order.
  for _, change in ipairs(changes) do
    vim.api.nvim_buf_set_lines(
      bufnr,
      change.start,
      change.final,
      false,
      change.formatted
    )
  end
end

return M
