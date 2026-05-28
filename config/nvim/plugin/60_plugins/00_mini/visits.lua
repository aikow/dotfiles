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
  vim.keymap.set("n", "<leader>vr", visit_paths(false, 1.0), { desc = "select recent (cwd)" })
  vim.keymap.set("n", "<leader>vR", visit_paths(true,  1.0), { desc = "select recent (all)" })
  vim.keymap.set("n", "<leader>vy", visit_paths(false, 0.5), { desc = "select frecent (cwd)" })
  vim.keymap.set("n", "<leader>vY", visit_paths(true,  0.5), { desc = "select frecent (all)" })
  vim.keymap.set("n", "<leader>vf", visit_paths(false, 0.0), { desc = "select frequent (cwd)" })
  vim.keymap.set("n", "<leader>vF", visit_paths(true,  0.0), { desc = "select frequent (all)" })

  vim.keymap.set("n", "<leader>vj", minivisits.add_label,    { desc = "add label" })
  vim.keymap.set("n", "<leader>vJ", minivisits.remove_label, { desc = "remove label" })
  vim.keymap.set("n", "<leader>vl", visit_labels(false),     { desc = "select label (cwd)" })
  vim.keymap.set("n", "<leader>vL", visit_labels(true),      { desc = "select label (all)" })
  -- stylua: ignore end
end)
