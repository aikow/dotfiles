local minigit = require("mini.git")
minigit.setup({})

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
