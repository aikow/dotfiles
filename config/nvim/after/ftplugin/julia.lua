vim.keymap.set("n", "<leader>ki", function()
  local bufname = vim.api.nvim_buf_get_name(0)
  local relpath = vim.fs.relpath(vim.uv.cwd(), bufname)
  if not relpath then
    vim.notify(
      "cannot send current buffer, since it is not in the working directory",
      vim.log.levels.WARN
    )
  end

  require("iron.core").send("julia", string.format('includet("%s")', relpath))
end, { desc = "iron include current file" })
