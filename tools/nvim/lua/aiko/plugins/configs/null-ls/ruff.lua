local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")
local severities = helpers.diagnostics.severities
local utils = require("null-ls.utils")

local custom_end_col = {
  end_col = function(entries, line)
    if not line then
      return
    end

    local start_col = entries["col"]
    local message = entries["message"]
    local code = entries["code"]

    -- highlights only first character on error line, if not specified otherwise
    local default_position = start_col + 1

    local pattern = nil
    local trimmed_line = line:sub(start_col, -1)

    if code == "F841" or code == "F823" then
      pattern = [[local variable %'(.*)%']]
    elseif code == "F821" or code == "F822" then
      pattern = [[undefined name %'(.*)%']]
    elseif code == "F831" then
      pattern = [[duplicate argument %'(.*)%']]
    elseif code == "F401" then
      pattern = [[%'(.*)%' imported]]
    end

    if not pattern then
      return default_position
    end

    local results = message:match(pattern)
    local _, end_col = trimmed_line:find(results, 1, true)

    if not end_col then
      return default_position
    end

    end_col = end_col + start_col
    if end_col > tonumber(start_col) then
      return end_col
    end

    return default_position
  end,
}

local ruff = {
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = { "python" },
  generator = null_ls.generator({
    command = "ruff",
    args = { "$FILENAME" },
    to_stdin = true,
    from_stderr = true,
    format = "line",
    check_exit_code = function(code, stderr)
      local success = code <= 1
      if not success then
        print(stderr)
      end

      return success
    end,
    on_output = helpers.diagnostics.from_pattern(
      [[:(%d+):(%d+): ((%u)%w+) (.*)]],
      { "row", "col", "code", "severity", "message" },
      {
        adapters = {
          custom_end_col,
        },
        severities = {
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
        },
      }
    ),
    cwd = helpers.cache.by_bufnr(function(params)
      return utils.root_pattern(
        -- https://flake8.pycqa.org/en/latest/user/configuration.html
        "ruff.toml",
        "pyproject.toml"
      )(params.bufname)
    end),
  }),
}

null_ls.register(ruff)

return ruff
