vim.api.nvim_create_user_command("Bclose", function()
  require("mini.bufremove").delete()
end, {
  desc = "Close the current buffer, even if it is unlisted or has no file.",
})

vim.api.nvim_create_user_command("Bhclose", function()
  local shown_buffers = {}
  for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
    for _, window in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
      shown_buffers[vim.api.nvim_win_get_buf(window)] = true
    end
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and not shown_buffers[buf] then
      vim.api.nvim_buf_delete(buf, {})
    end
  end
end, {
  desc = "Close all hidden buffers",
})

vim.api.nvim_create_user_command("SyntaxStack", function()
  local s = vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 1)
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

vim.api.nvim_create_user_command("Random", function(opts)
  local len = opts.args ~= "" and opts.args or 8
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
