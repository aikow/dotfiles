local M = {}

M.setup = function()
  local ok_refactoring, refactoring = pcall(require, "refactoring")
  if not ok_refactoring then
    return
  end

  refactoring.setup({})

  -- Prompt for a refactor to apply when the remap is triggered.
  vim.keymap.set(
    "v",
    "<leader>rq",
    refactoring.select_refactor,
    { silent = true, desc = "select refactoring" }
  )

  -- Direct maps for specific refactoring operations.
  vim.keymap.set("v", "<leader>re", function()
    refactoring.refactor("Extract Function")
  end, { silent = true, desc = "refactoring extract function" })

  vim.keymap.set("v", "<leader>rf", function()
    refactoring.refactor("Extract Function To File")
  end, { silent = true, desc = "refactoring extract function to file" })

  vim.keymap.set("v", "<leader>rv", function()
    refactoring.refactor("Extract Variable")
  end, { silent = true, desc = "refactoring extract variable" })

  vim.keymap.set("n", "<leader>rb", function()
    refactoring.refactor("Extract Function")
  end, { silent = true, desc = "refactoring extract block" })

  vim.keymap.set("n", "<leader>rbf", function()
    refactoring.refactor("Extract Block To File")
  end, { silent = true, desc = "refactoring extract block to file" })

  vim.keymap.set({ "n", "v" }, "<leader>ri", function()
    refactoring.refactor("Inline Variable")
  end, { silent = true, desc = "inline variable" })
end

return M
