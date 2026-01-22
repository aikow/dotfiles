function send_include(how)
  return function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local relpath = vim.fs.relpath(vim.uv.cwd(), bufname)
    if not relpath then
      vim.notify(
        "cannot send current buffer, since it is not in the working directory",
        vim.log.levels.WARN
      )
    end

    vim.fn["slime#send"](string.format('%s("%s")\n', how, relpath))
  end
end

-- stylua: ignore start
vim.keymap.set("n", "<leader>kI", send_include("include"),  { desc = "slime include current file" })
vim.keymap.set("n", "<leader>kR", send_include("includet"), { desc = "slime includet current file" })
-- stylua: ignore end
