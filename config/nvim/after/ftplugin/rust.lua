-- Set rust specific vim settings.
vim.opt_local.colorcolumn = { 100 }
vim.opt_local.textwidth = 100

local function opts(desc) return { buf = 0, silent = true, desc = desc } end

local map = vim.keymap.set
-- stylua: ignore start
map("n", "<localleader>d", "<cmd>RustOpenExternalDocs<CR>", opts("rust open external docs"))
map("n", "<localleader>t", "<cmd>RustDebuggables<CR>", opts("rust debuggables"))
map("n", "<localleader>r", "<cmd>RustRunnables<CR>", opts("rust runnables"))
map("n", "<localleader>c", "<cmd>RustOpenCargo<CR>", opts("rust open cargo"))
map("n", "<localleader>m", "<cmd>RustExpandMacro<CR>", opts("rust expand macro"))
map("n", "<localleader>a", "<cmd>RustHoverActions<CR>", opts("rust hover actions"))
-- stylua: ignore end
