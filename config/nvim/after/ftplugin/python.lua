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
vim.keymap.set({ "n", "v" }, "<localleader>b", function()
  vim
    .system({
      "black",
      "--line-length",
      tostring(vim.o.textwidth),
      "--preview",
      "--enable-unstable-feature=string_processing",
      vim.fs.normalize(vim.api.nvim_buf_get_name(0)),
    })
    :wait()
  vim.cmd.edit()
end)

vim.keymap.set(
  { "n", "x" },
  "<leader>rl",
  function()
    require("conform").format({
      async = true,
      lsp_fallback = true,
      formatters = { "ruff_fix" },
    })
  end,
  { desc = "Format the current buffer by fixing all lints" }
)

-- Automatically make the current string an f-string when typing `{`.
vim.api.nvim_create_autocmd("InsertCharPre", {
  pattern = { "*.py" },
  group = vim.api.nvim_create_augroup("py-fstring", { clear = true }),
  ---@param params NvimAutocmdCallbackParams
  callback = function(params)
    if vim.v.char ~= "{" then return end

    local node = vim.treesitter.get_node({})

    if not node then return end

    if node:type() ~= "string" then node = node:parent() end

    if not node or node:type() ~= "string" then return end
    local row, col, _, _ = vim.treesitter.get_node_range(node)
    local first_char = vim.api.nvim_buf_get_text(params.buf, row, col, row, col + 1, {})[1]
    if first_char == "f" then return end

    vim.api.nvim_input("<Esc>m'" .. row + 1 .. "gg" .. col + 1 .. "|if<esc>`'la")
  end,
})

-- Automatically wrap multiline concatenated strings.
local iter_query = require("user.util.treesitter").iter_query
vim.api.nvim_buf_create_user_command(0, "StringWrap", function()
  iter_query(
    0,
    [[;;query
      (concatenated_string) @concat
    ]],
    function(text, args)
      -- Check whether its a single line concatenated string.
      if args.range[1] == args.range[2] then return text end

      -- Trim each line of the multi-line string. Additionally, check if any of
      -- the lines are f-strings. Insert all the whitespace-separated words into a
      -- table.
      local is_fstring = false
      local is_rstring = false
      local words = {}
      for line in vim.gsplit(text, "\n", { trimempty = true }) do
        local modifier, trimmed = string.match(vim.trim(line), [[^([frFR]*)"(.*)"$]])
        modifier = modifier or ""

        if string.match(modifier, "[fF]") then is_fstring = true end

        if string.match(modifier, "[rR]") then is_rstring = true end
        -- Remove spaces and then quotes.
        if trimmed ~= nil then
          for word in string.gmatch(trimmed, "%S+") do
            table.insert(words, word)
          end
        end
      end

      if is_rstring then return text end

      -- Only modify it if the string is not a raw string, we do not want to mess
      -- with those.
      -- Start row, start col, end row, end col
      local width = vim.bo.textwidth - args.range[2] - 2 - (is_fstring and 1 or 0)

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
      if #cur_line > 0 then table.insert(raw_lines, cur_line) end

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

      return wrapped
    end,
    { filetype = "python", line_offset = { 0, 1 } }
  )
end, {
  desc = "automatically wrap and format a multi-line string",
})
