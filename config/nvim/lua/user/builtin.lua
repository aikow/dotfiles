local M = {}

-- disable some builtin vim plugins
M.default_plugins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  -- "netrw",
  -- "netrwPlugin",
  -- "netrwSettings",
  -- "netrwFileHandlers",
  -- "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  -- "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  "tutor",
  "rplugin",
  "syntax",
  "synmenu",
  "optwin",
  "compiler",
  "bugreport",
  "ftplugin",
}

M.disable_plugins = function()
  for _, plugin in pairs(M.default_plugins) do
    vim.g["loaded_" .. plugin] = 1
  end
end

-- Disable all builtin providers
local default_providers = {
  "node",
  "perl",
  "python3",
  "ruby",
}

M.disable_providers = function()
  for _, provider in ipairs(default_providers) do
    vim.g["loaded_" .. provider .. "_provider"] = 0
  end
end

return M
