vim.api.nvim_create_user_command("Bclose", function()
  require("aiko.util.buffer").close_buffer(false)
end, {
  desc = "Close the current buffer, even if it is unlisted or has no file.",
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
