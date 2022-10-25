vim.opt_local.expandtab = true
vim.opt_local.autoindent = true
vim.opt_local.smarttab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
-- vim.opt_local.fileformat = "unix"
vim.opt_local.textwidth = 80

-- Set the indent after opening parenthesis
vim.g.pyindent_open_paren = vim.bo.shiftwidth

-- Shortcut to run file through interpreter.
vim.keymap.set({ "n", "v" }, "<localleader>r", [[:!python3 %<CR>]])

-- Auto-wrap python concatenated strings that span multiple lines.
vim.api.nvim_buf_create_user_command(0, "StringWrap", function()
  -- Treesitter query.
  local concatenated_string = vim.treesitter.parse_query(
    "python",
    [[
      (concatenated_string) @concat
    ]]
  )

  local bufnr = vim.api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(bufnr, "python", {})
  local tree = parser:parse()[1]
  local root = tree:root()

  -- Table to keep track of changes so that we can make them in reverse order.
  local changes = {}
  for _, node in concatenated_string:iter_captures(root, bufnr, 0, -1) do
    -- Trim each line of the multi-line string. Additionally, check if any of
    -- the lines are f-strings. Insert all the whitespace-separated words into a
    -- table.
    local is_fstring = false
    local is_rstring = false
    local words = {}
    for line in
      vim.gsplit(vim.treesitter.get_node_text(node, bufnr), "\n", true)
    do
      local modifier, trimmed =
        string.match(vim.trim(line), [[^([frFR]?)"(.*)"$]])
      if modifier == "f" or modifier == "F" then
        is_fstring = true
      elseif modifier == "r" or modifier == "R" then
        is_rstring = true
      end
      -- Remove spaces and then quotes.
      if trimmed ~= nil then
        for word in string.gmatch(trimmed, "%S+") do
          table.insert(words, word)
        end
      end
    end

    -- Only modify it if the string is not a raw string, we do not want to mess
    -- with those.
    if not is_rstring then
      -- Start row, start col, end row, end col
      local range = { node:range() }
      local indentation = string.rep(" ", range[2])
      local width = vim.bo.textwidth - range[2] - 2 - (is_fstring and 1 or 0)

      -- Create table of lines without quotation and without leading space.
      local raw_lines = {}
      local cur_line = ""
      for _, word in pairs(words) do
        if #word >= width then
          if #cur_line > 0 then
            table.insert(raw_lines, cur_line)
            cur_line = ""
          end
          table.insert(raw_lines, word)
        elseif #cur_line + #word + 1 >= width then
          table.insert(raw_lines, cur_line)
          cur_line = word
        elseif #cur_line == 0 then
          cur_line = cur_line .. word
        else
          cur_line = cur_line .. " " .. word
        end
      end
      -- Insert the last line if it is non-empty.
      if #cur_line > 0 then
        table.insert(raw_lines, cur_line)
      end

      -- Create the final table of lines with leading space and quotation marks.
      local wrapped = {}
      local first_word = true
      local prefix
      if is_fstring then
        prefix = indentation .. 'f"'
      else
        prefix = indentation .. '"'
      end
      for _, line in pairs(raw_lines) do
        if first_word then
          first_word = false
          table.insert(wrapped, prefix .. line .. '"')
        else
          table.insert(wrapped, prefix .. " " .. line .. '"')
        end
      end

      -- Keep track of the changes, but insert them in the reverse order.
      table.insert(changes, 1, {
        start = range[1],
        final = range[3] + 1,
        wrapped = wrapped,
      })
    end
  end

  -- Go through all the changes and apply them.
  for _, change in ipairs(changes) do
    vim.api.nvim_buf_set_lines(
      bufnr,
      change.start,
      change.final,
      false,
      change.wrapped
    )
  end
end, {
  desc = "automatically wrap and format a multi-line string",
})

-- Set a keymap shortcut to wrap all concatenated strings
vim.keymap.set(
  "n",
  "<localleader>s",
  [[<cmd>StringWrap<CR>]],
  { buffer = 0, silent = true, desc = "wrap concatenated strings" }
)
