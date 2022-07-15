local M = {}

M.create_terminal_direction = function(key, direction, opts)
  local Terminal = require("toggleterm.terminal").Terminal

  opts = opts or {}
  local cmd = opts.cmd or "fish"
  local dir = opts.dir or "git_dir"

  local term = Terminal:new({
    cmd = cmd,
    dir = dir,
    direction = direction,
    on_open = function(t)
      vim.api.nvim_buf_set_keymap(
        t.bufnr,
        "n",
        "<M-q>",
        "<cmd>close<CR>",
        { noremap = true }
      )
      vim.api.nvim_buf_set_keymap(
        t.bufnr,
        "t",
        "<M-q>",
        "<cmd>close<CR>",
        { noremap = true }
      )
    end,
  })

  vim.keymap.set(
    "n",
    key,
    function() term:toggle() end,
    { silent = true, desc = "toggle " .. direction .. " terminal" }
  )
end

M.setup = function()
  require("toggleterm").setup({})

  M.create_terminal_direction("<M-v>", "vertical")
  M.create_terminal_direction("<M-x>", "horizontal")
  M.create_terminal_direction("<M-f>", "float")
  M.create_terminal_direction("<M-t>", "tab")
end

return M
