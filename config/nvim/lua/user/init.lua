local M = {}

function M.plugin_name(name)
  name = string.gsub(name, "%Wnvim$", "")
  name = string.gsub(name, "^nvim%W", "")
  name = string.gsub(name, "%W+", "_")
  return name
end

function M.on_update(name, f)
  local groupname = string.format("user.pack.{}.update", M.plugin_name(name))

  vim.api.nvim_create_autocmd("PackChanged", {
    group = vim.api.nvim_create_augroup(groupname, {}),
    desc = "Handle plugin package updates",
    callback = function(ev)
      local specname = ev.data.spec.name
      local kind = ev.data.kind
      if specname == name and (kind == "install" or kind == "update") then
        vim.notify(string.format("vim.pack updated %s", name), vim.log.levels.INFO)
        f()
      end
    end,
  })
end

return M
