safely("later", function()
  local minivisits = require("mini.visits")
  minivisits.setup({})

  local pickers = require("mini.extra").pickers

  local function visit_paths(global, recency_weight)
    return function()
      pickers.visit_paths({
        cwd = global and "" or nil,
        recency_weight = recency_weight,
      })
    end
  end

  local function visit_labels(global)
    return function() pickers.visit_labels({ cwd = global and "" or nil }) end
  end

  -- stylua: ignore start
  vim.keymap.set("n", "<leader>jr", visit_paths(false, 1.0), { desc = "select recent (cwd)" })
  vim.keymap.set("n", "<leader>jR", visit_paths(true,  1.0), { desc = "select recent (all)" })
  vim.keymap.set("n", "<leader>jy", visit_paths(false, 0.5), { desc = "select frecent (cwd)" })
  vim.keymap.set("n", "<leader>jY", visit_paths(true,  0.5), { desc = "select frecent (all)" })
  vim.keymap.set("n", "<leader>jf", visit_paths(false, 0.0), { desc = "select frequent (cwd)" })
  vim.keymap.set("n", "<leader>jF", visit_paths(true,  0.0), { desc = "select frequent (all)" })

  vim.keymap.set("n", "<leader>jj", minivisits.add_label,    { desc = "add label" })
  vim.keymap.set("n", "<leader>jJ", minivisits.remove_label, { desc = "remove label" })
  vim.keymap.set("n", "<leader>jl", visit_labels(false),     { desc = "select label (cwd)" })
  vim.keymap.set("n", "<leader>jL", visit_labels(true),      { desc = "select label (all)" })
  -- stylua: ignore end
end)
