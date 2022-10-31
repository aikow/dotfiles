local iter_query = require("aiko.util.treesitter").iter_query

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

-- Automatically wrap multiline concatenated strings.
vim.api.nvim_buf_create_user_command(0, "StringWrap", function()
  iter_query(
    0,
    [[;;query
      (concatenated_string) @concat
    ]],
    function(text, args)
      -- Check whether its a single line concatenated string.
      if args.range[1] == args.range[2] then
        return text
      end

      -- Trim each line of the multi-line string. Additionally, check if any of
      -- the lines are f-strings. Insert all the whitespace-separated words into a
      -- table.
      local is_fstring = false
      local is_rstring = false
      local words = {}
      for line in vim.gsplit(text, "\n", true) do
        local modifier, trimmed =
          string.match(vim.trim(line), [[^([frFR]*)"(.*)"$]])

        if string.match(modifier, "[fF]") then
          is_fstring = true
        end

        if string.match(modifier, "[rR]") then
          is_rstring = true
        end
        -- Remove spaces and then quotes.
        if trimmed ~= nil then
          for word in string.gmatch(trimmed, "%S+") do
            table.insert(words, word)
          end
        end
      end

      if is_rstring then
        return text
      end

      -- Only modify it if the string is not a raw string, we do not want to mess
      -- with those.
      -- Start row, start col, end row, end col
      local width = vim.api.nvim_buf_get_option(0, "textwidth")
        - args.range[2]
        - 2
        - (is_fstring and 1 or 0)

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
      local prefix = is_fstring and 'f"' or '"'
      for _, line in pairs(raw_lines) do
        if first_word then
          first_word = false
          table.insert(wrapped, prefix .. line .. '"')
        else
          table.insert(wrapped, prefix .. " " .. line .. '"')
        end
      end

      print(vim.inspect(wrapped))

      return wrapped
    end,
    { filetype = "python", line_offset = { 0, 1 } }
  )
end, {
  desc = "automatically wrap and format a multi-line string",
})

vim.api.nvim_buf_create_user_command(0, "SqlFormat", function(opts)
  if vim.fn.executable("sql-formatter") ~= 1 then
    vim.notify("Missing sql-formatter")
    return
  end

  local lang = opts.lang or "sqlite"

  iter_query(
    0,
    [[;; query
      (assignment
        left: (identifier) @_id (#contains? @_id "query")
        right: (string) @sql (#offset! @sql 1 0 -1 0))
    ]],
    function(text)
      -- FIXME: Indentation is at the first of the triple quote ("""). Ideally
      -- it should just be at the continuation indentation level.
      --
      -- Clean the input text.
      text = string.gsub(string.sub(text, 4, -4), "\n", "")

      -- Perform replacements of the identifiers to make the text valid SQL.
      if lang == "sqlite" then
        text = string.gsub(text, "%?", "__id__")
      else
        text = string.gsub(text, "${(%d)}", "__id_%1__")
      end

      text = vim.fn.system("sql-formatter -l " .. lang, text)

      -- Revert the previous substitutions.
      if lang == "sqlite" then
        text = string.gsub(text, "__id__", "%?")
      else
        text = string.gsub(text, "__id_(%d)__", "${%1}")
      end

      -- Split the text on newlines.
      local lines = vim.split(text, "\n")

      -- Remove the last line since its empty.
      table.remove(lines, #lines)

      return lines
    end,
    { filetype = "python", capture = "sql" }
  )
end, {
  desc = "Automatically format SQL statements in python files",
  nargs = "*",
})
