-- Create a buffer-local user command to pipe the entire buffer contents through
-- the `sql-formatter` binary if it can be found on the path.
--
-- The command takes an optional argument for the SQL dialect (default: sqlite).
vim.api.nvim_buf_create_user_command(
  0,
  "SqlFormat",
  ---@param params NvimCommandCallbackParams
  function(params)
    if vim.fn.executable("sql-formatter") ~= 1 then
      vim.notify("`sql-formatter` is not on PATH", vim.log.levels.WARN)
      return
    end

    local lang = params.args ~= "" and params.args or "sqlite"
    vim.cmd("%!sql-formatter -l " .. lang)
  end,
  {
    force = true,
    desc = "format buffer using sql-formatter",
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
