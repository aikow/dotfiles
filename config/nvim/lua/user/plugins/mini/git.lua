local M = {}

function M.setup()
  local minigit = require("mini.git")
  minigit.setup({})

  -- Set the file type for status windows.
  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniGitCommandSplit",
    callback = function(data)
      if data.data.git_subcommand ~= "status" then return end
      vim.bo.filetype = "gitstatus"
    end,
  })

  -- Sync scrolling for buffers for `git blame`.
  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniGitCommandSplit",
    callback = function(data)
      if data.data.git_subcommand ~= "blame" then return end

      -- Align blame output with source.
      local win_source = data.data.win_source
      local win_stdout = data.data.win_stdout

      vim.wo.wrap = false
      vim.fn.winrestview({ topline = vim.fn.line("w0", win_source) })
      vim.api.nvim_win_set_cursor(0, { vim.fn.line(".", win_source), 0 })

      -- Bind both windows so that they scroll together.
      vim.wo.scrollbind = true
      vim.wo[win_source].scrollbind = true

      -- Create an autocmd to turn scrollbind off again when the blame window is closed.
      vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(win_stdout),
        once = true,
        callback = function() vim.wo[win_source].scrollbind = false end,
      })
    end,
  })

  -- Commands
  vim.api.nvim_create_user_command(
    "GBlame",
    "topleft vert Git blame -- %",
    { desc = "Open git blame in a buffer to the left." }
  )

  -- Keymaps
  vim.keymap.set(
    { "n", "x" },
    "<leader>gk",
    minigit.show_at_cursor,
    { desc = "mini.git show object at cursor" }
  )
  vim.keymap.set(
    "n",
    "<leader>gd",
    minigit.show_diff_source,
    { desc = "mini.git show diff source at cursor position" }
  )
  vim.keymap.set(
    { "n", "x" },
    "<leader>gl",
    minigit.show_range_history,
    { desc = "mini.git show history of visual selection" }
  )
end

return M
