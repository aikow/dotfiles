-- ------------------------------------------------------------------------
-- | mini.diff
-- ------------------------------------------------------------------------
safely("later", function()
  local minidiff = require("mini.diff")
  minidiff.setup({
    view = {
      style = "sign",
      signs = { add = "│", change = "│", delete = "-" },
    },
  })

  vim.keymap.set("n", "<leader>gO", minidiff.toggle_overlay, { desc = "Toggle mini.diff overlay" })
end)

-- ------------------------------------------------------------------------
-- | mini.git
-- ------------------------------------------------------------------------
safely("later", function()
  local minigit = require("mini.git")
  minigit.setup({})

  -- Keymaps
  -- stylua: ignore start
  vim.keymap.set({"n", "x"}, "<leader>gk", minigit.show_at_cursor,     { desc = "Show mini.git object at cursor" })
  vim.keymap.set("n",        "<leader>gd", minigit.show_diff_source,   { desc = "Show mini.git diff source at cursor" })
  vim.keymap.set({"n", "x"}, "<leader>gl", minigit.show_range_history, { desc = "Show mini.git selection history" })
  -- stylua: ignore end
end)
