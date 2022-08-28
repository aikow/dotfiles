local M = {}

M.workspaceconfig = ".nvim"

M.get_config = function(workspace, name)
  local config = {}

  local config_path = table.concat({ workspace, M.workspaceconfig, name }, "/")

  -- If the file does exists, we can read it and decode it.
  local file = io.open(config_path, "r")
  if file then
    config = vim.json.decode(file:read("*a"))
  end

  return config
end

return M
