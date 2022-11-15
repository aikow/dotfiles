local sql_format = require("aiko.util.sql-format").sql_format

-- Set rust specific vim settings.
vim.opt_local.colorcolumn = { 100 }
vim.opt_local.textwidth = 100

vim.api.nvim_buf_create_user_command(0, "SqlFormat", function(opts)
  if vim.fn.executable("sql-formatter") ~= 1 then
    vim.notify("Missing sql-formatter")
    return
  end

  sql_format(0, { lang = opts.lang, trim = { 4, 4 } })
end, {
  desc = "Automatically format SQL statements in rust files",
  nargs = "*",
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
})
