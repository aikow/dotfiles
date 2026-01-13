local runner = require("quarto.runner")
local run_all_all = function() runner.run_all(true) end

-- stylua: ignore start
vim.keymap.set("n", "<localleader>rc", runner.run_cell,  { desc = "run cell",                       buffer = true })
vim.keymap.set("n", "<localleader>ru", runner.run_above, { desc = "run up to cell",                 buffer = true })
vim.keymap.set("n", "<localleader>rA", runner.run_all,   { desc = "run all cells",                  buffer = true })
vim.keymap.set("n", "<localleader>rl", runner.run_line,  { desc = "run line",                       buffer = true })
vim.keymap.set("v", "<localleader>r",  runner.run_range, { desc = "run visual range",               buffer = true })
vim.keymap.set("n", "<localleader>rL", run_all_all,      { desc = "run all cells of all languages", buffer = true })
-- stylua: ignore end
