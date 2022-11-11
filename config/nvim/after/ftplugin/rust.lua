local iter_query = require("aiko.util.treesitter").iter_query

-- Set rust specific vim settings.
vim.opt_local.colorcolumn = { 100 }
vim.opt_local.textwidth = 100

vim.api.nvim_buf_create_user_command(0, "SqlFormat", function(opts)
  if vim.fn.executable("sql-formatter") ~= 1 then
    vim.notify("Missing sql-formatter")
    return
  end

  local lang = opts.lang or "sqlite"

  iter_query(
    0,
    [[;; query
      (assignment
        left: (identifier) @_id (#contains? @_id "query")
        right: (string) @sql)
    ]],
    function(text)
      -- FIXME: Indentation is at the first of the triple quote ("""). Ideally
      -- it should just be at the continuation indentation level.
      --
      -- Clean the input text.
      text = string.gsub(string.sub(text, 4, -4), "\n", "")

      -- Default cleaning rules for identifiers.
      local clean = setmetatable({
        sqlite = {
          pre = { pat = "%?", rep = "__id__" },
          post = { pat = "__id__", rep = "%?" },
        },
      }, {
        -- Set the default cleaning rules.
        __index = {
          pre = { pat = "%${(%d)}", rep = "__id_%1__" },
          post = { pat = "__id_(%d)__", rep = "%${%1}" },
        },
      })

      local subs = clean[lang]

      -- Perform replacements of the identifiers to make the text valid SQL.
      text = string.gsub(text, subs.pre.pat, subs.pre.rep)

      text = vim.fn.system("sql-formatter -l " .. lang, text)

      -- Revert the previous substitutions.
      text = string.gsub(text, subs.post.pat, subs.post.rep)

      -- Split the text on newlines.
      local lines = vim.split(text, "\n")

      -- Remove the last line since its empty.
      table.remove(lines, #lines)

      return lines
    end,
    {
      filetype = "rust",
      capture = "sql",
    }
  )
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
