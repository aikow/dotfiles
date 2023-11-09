---Get the row index of the cursor
---@return integer
local curline = function()
  ---@diagnostic disable-next-line: return-type-mismatch
  return vim.fn.curline(".")
end

---Get the column index of the cursor
---@return integer
local curcol = function()
  ---@diagnostic disable-next-line: return-type-mismatch
  return vim.fn.col(".")
end

vim.api.nvim_create_user_command("Bclose", function()
  require("mini.bufremove").delete()
end, {
  desc = "Close the current buffer, even if it is unlisted or has no file.",
})

vim.api.nvim_create_user_command("Bclean", function()
  local shown_buffers = {}
  -- Create a set of buffers that are displayed in at least 1 window in any of
  -- the currently open tab pages.
  for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
    for _, window in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
      shown_buffers[vim.api.nvim_win_get_buf(window)] = true
    end
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    -- Check that the buffer
    -- - is not a terminal buffer
    -- - and is loaded
    -- - and is not shown
    if
      vim.api.nvim_get_option_value("buftype", { buf = buf }) ~= "terminal"
      and vim.api.nvim_buf_is_loaded(buf)
      and not shown_buffers[buf]
    then
      vim.api.nvim_buf_delete(buf, {})
    end
  end
end, {
  desc = "Close all hidden buffers",
})

vim.api.nvim_create_user_command("Help", function(params)
  local command = params.args

  -- Create a new window and buffer respecting all command modifiers and get
  -- the newly created buffer ID.
  vim.cmd.new({ mods = params.smods })
  local buf_id = vim.api.nvim_get_current_buf()

  local header = string.format("%s(%s)", command:upper(), 1)
  vim.api.nvim_buf_set_lines(buf_id, 0, 0, false, { header })

  -- Execute <cmd> --help and add a callback.
  vim.system({ command, "--help" }, { text = true }, function(obj)
    -- Trim the output, then split by newlines.
    local help_lines = vim.split(vim.trim(obj.stdout), "\n")

    -- Since we're in a callback, we have to wrap our nvim_buf_set_lines call in
    -- vim.schedule.
    vim.schedule(function()
      vim.api.nvim_buf_set_lines(buf_id, 2, -1, false, help_lines)
      vim.cmd("Man!")
    end)
  end)
end, {
  nargs = 1,
  desc = "Display the help message for a command in a buffer.",
})

vim.api.nvim_create_user_command("SyntaxStack", function()
  local s = vim.fn.synID(curline(), curcol(), 1)
  vim.notify(
    string.format(
      "%s -> %s",
      vim.fn.synIDattr(s, "name"),
      vim.fn.synIDattr(vim.fn.synIDtrans(s), "name")
    )
  )
end, {
  desc = "Print the syntax group and highlight group of the token under the cursor",
})

vim.api.nvim_create_user_command("Random", function(params)
  local len = params.args ~= "" and params.args or 8
  print(len)
  local chars = "abcdefghijklmnopqrstuvwxyz0123456789"

  -- 65 for uppercase
  -- 97 for lowercase
  local rand = ""
  for _ = 1, len do
    local idx = math.random(1, #chars)
    rand = rand .. string.sub(chars, idx, idx)
  end

  local pos = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local nline = line:sub(0, pos) .. rand .. line:sub(pos + 1)
  vim.api.nvim_set_current_line(nline)
end, {
  desc = "Reload and recompile the entire neovim configuration.",
  nargs = "?",
})
