vim.keymap.set("n", "<leader>kI", function()
  local bufname = vim.api.nvim_buf_get_name(0)
  local relpath = vim.fs.relpath(vim.uv.cwd(), bufname)
  if not relpath then
    vim.notify(
      "cannot send current buffer, since it is not in the working directory",
      vim.log.levels.WARN
    )
  end

  vim.fn["slime#send"](string.format('includet("%s")\n', relpath))
end, { desc = "slime include current file" })
