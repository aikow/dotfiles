local command = vim.api.nvim_create_user_command

---Get the row index of the cursor
---@return integer
local function curline()
  ---@diagnostic disable-next-line: return-type-mismatch
  return vim.fn.line(".")
end

---Get the column index of the cursor
---@return integer
local function curcol()
  ---@diagnostic disable-next-line: return-type-mismatch
  return vim.fn.col(".")
end

command("Bclose", function() require("mini.bufremove").delete() end, {
  desc = "Close the current buffer, even if it is unlisted or has no file.",
})

command("Bclean", function()
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

command(
  "Help",
  ---@param params NvimCommandCallbackParams
  function(params)
    local cmd = params.fargs
    local cmd_str = table.concat(cmd, "-")
    local cmd_help = { unpack(cmd) }
    table.insert(cmd_help, "--help")

    -- Prefix the buffer name with hman
    local buf_name = string.format("hman://%s", cmd_str)

    -- Check if a buffer with this name already exists, and reuse it if it does.
    local buf_id = vim
      .iter(vim.api.nvim_list_bufs())
      :find(function(b) return vim.api.nvim_buf_get_name(b) == buf_name end)
    if buf_id == nil then
      -- Create a scratch buffer
      buf_id = vim.api.nvim_create_buf(true, true)
      vim.api.nvim_buf_set_name(buf_id, buf_name)
    else
      -- Make sure the buffer is modifiable before setting the lines.
      vim.bo[buf_id].modifiable = true
      vim.bo[buf_id].readonly = false
    end

    -- Create a new window and buffer respecting all command modifiers
    vim.cmd.split({ mods = params.smods })
    vim.api.nvim_win_set_buf(0, buf_id)

    -- Write the command to the first line
    vim.api.nvim_buf_set_lines(buf_id, 0, 0, false, { cmd_str:upper() })

    -- Execute `cmd --help` and add a callback.
    vim.system(cmd_help, { text = true }, function(obj)
      -- Trim the output, then split by newlines.
      local help_lines = vim.split(vim.trim(obj.stdout), "\n")

      -- Since we're in a callback, we have to wrap our nvim_buf_set_lines call in
      -- vim.schedule.
      vim.schedule(function()
        -- Set the buffer contents to the output.
        vim.api.nvim_buf_set_lines(buf_id, 2, -1, false, help_lines)

        vim.bo[buf_id].swapfile = false
        vim.bo[buf_id].buftype = "nofile"
        vim.bo[buf_id].modified = false
        vim.bo[buf_id].readonly = true
        vim.bo[buf_id].modifiable = false
        vim.bo[buf_id].filetype = "man"
      end)
    end)
  end,
  {
    nargs = "+",
    desc = "Display the help message for a command in a buffer.",
  }
)

command(
  "Start",
  ---@param params NvimCommandCallbackParams
  function(params)
    local mods = vim.tbl_extend("keep", params.smods, { keepalt = true, noswapfile = true })
    vim.cmd.new({ mods = mods })
    require("mini.starter").open()
  end,
  { desc = "Open the starter" }
)

command("SyntaxStack", function()
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

command(
  "Random",
  ---@param params NvimCommandCallbackParams
  function(params)
    local len = params.args ~= "" and params.args or 8
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
  end,
  {
    desc = "Reload and recompile the entire neovim configuration.",
    nargs = "?",
  }
)
