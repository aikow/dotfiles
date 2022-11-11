local M = {}

M.setup = function()
  require("symbols-outline").setup({
    keymaps = {
      close = { "<Esc>", "q" },
      code_actions = "a",
      focus_location = "o",
      fold = "h",
      fold_all = "W",
      fold_reset = "R",
      goto_location = "<CR>",
      hover_symbol = { "<C-space>", "K" },
      rename_symbol = "r",
      toggle_preview = "p",
      unfold = "l",
      unfold_all = "E",
    },
  })
end

return M
