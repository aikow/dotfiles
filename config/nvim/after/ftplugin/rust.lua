local sql_format = require("user.util.lang.sql-format").sql_format

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

vim.api.nvim_buf_create_user_command(
  0,
  "SqlFormat",
  ---@param params NvimCommandCallbackParams
  function(params)
    if vim.fn.executable("sql-formatter") ~= 1 then
      vim.notify("Missing sql-formatter")
      return
    end

    sql_format(0, { lang = params.args, trim = { 4, 4 } })
  end,
  {
    desc = "Automatically format SQL statements in rust files",
    nargs = "?",
    complete = function()
      return {
        "bigquery",
        "db2",
        "hive",
        "mariadb",
        "mysql",
        "n1ql",
        "plsql",
        "postgresql",
        "redshift",
        "singlestoredb",
        "spark",
        "sql",
        "sqlite",
        "trino",
        "tsql",
      }
    end,
  }
)
