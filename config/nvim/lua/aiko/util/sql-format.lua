local M = {}

-- Default cleaning rules for identifiers.
local clean = setmetatable({
  sqlite = {
    pre = { pat = "%?", rep = "__id__" },
    post = { pat = "__id__", rep = "%?" },
  },
}, {
  -- Set the default cleaning rules.
  __index = {
    pre = { pat = "%${(%d)}", rep = "__id_%1__" },
    post = { pat = "__id_(%d)__", rep = "%${%1}" },
  },
})

local sql_format_helper = function(text, trim, lang)
  text = string.gsub(string.sub(text, trim[1], -trim[2]), "\n", "")

  local subs = clean[lang]

  -- Perform replacements of the identifiers to make the text valid SQL.
  text = string.gsub(text, subs.pre.pat, subs.pre.rep)

  -- Call sql-formatter
  text = vim.fn.system("sql-formatter -l " .. lang, text)

  -- Revert the previous substitutions.
  text = string.gsub(text, subs.post.pat, subs.post.rep)

  -- Split the text on newlines.
  local lines = vim.split(text, "\n")

  -- Remove the last line since its empty.
  table.remove(lines, #lines)

  return lines
end

M.sql_format = function(bufnr, opts)
  bufnr = (bufnr > 0) and bufnr or vim.api.nvim_get_current_buf()

  local lang = opts.lang or vim.b.sql_format_lang or "sqlite"
  local trim = opts.trim or vim.b.sql_format_trim or { 1, 1 }
  local offset = opts.offset or vim.b.sql_format_offset or { 1, 0 }

  local filetype = vim.bo[bufnr].filetype
  local query = vim.treesitter.get_query(filetype, "injections")
  local parser = vim.treesitter.get_parser(bufnr, filetype, {})
  local tree = parser:parse()[1]
  local root = tree:root()

  local changes = {}
  for _, match, _ in query:iter_matches(root, bufnr, 0, -1) do
    for id, node in pairs(match) do
      local name = query.captures[id]
      -- local node_data = metadata[id]

      if name == "sql" then
        local range = { node:range() }
        local indentation = string.rep(" ", range[2])

        -- Clean the input text.
        local text = vim.treesitter.get_node_text(node, bufnr)
        local formatted = sql_format_helper(text, trim, lang)

        -- Add indentation
        for idx, line in ipairs(formatted) do
          formatted[idx] = indentation .. line
        end

        -- Create table of changes in reverse order.
        table.insert(changes, 1, {
          start = range[1] + offset[1],
          final = range[3] + offset[2],
          formatted = formatted,
        })
      end
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
