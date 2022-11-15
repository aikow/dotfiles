local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")
local severities = helpers.diagnostics.severities
local utils = require("null-ls.utils")

local sev = {
  E = severities["error"],
  W = severities["warning"],
  F = severities["information"],
  D = severities["information"],
  R = severities["warning"],
  S = severities["warning"],
  I = severities["warning"],
  C = severities["warning"],
  B = severities["warning"], -- flake8-bugbear
  N = severities["information"], -- pep8-naming
}

local ruff = {
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = { "python" },
  generator = null_ls.generator({
    command = "ruff",
    args = { "--format", "json", "--stdin-filename", "$FILENAME", "-" },
    to_stdin = true,
    from_stderr = false,
    format = "json",
    check_exit_code = function(code)
      return code <= 1
    end,
    on_output = function(params)
      local diags = {}
      for _, obj in ipairs(params.output) do
        table.insert(diags, {
          row = obj.location.row,
          col = obj.location.column,
          end_col = obj.end_location.column,
          code = obj.code,
          message = obj.message,
          severity = sev[string.sub(obj.code, 1, 1)]
            or severities["information"],
        })
      end
      return diags
    end,
    cwd = helpers.cache.by_bufnr(function(params)
      return utils.root_pattern("pyproject.toml")(params.bufname)
    end),
  }),
}

return ruff
