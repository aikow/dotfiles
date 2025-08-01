-- disable some builtin vim plugins
local disable_default_plugins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  -- "gzip",
  "logipat",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  -- "matchit",
  -- "tar",
  -- "tarPlugin",
  "rrhelper",
  -- "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  -- "zip",
  -- "zipPlugin",
  "tutor",
  "rplugin",
  -- "syntax",
  "synmenu",
  "optwin",
  "compiler",
  "bugreport",
  -- "ftplugin",
}

for _, plugin in pairs(disable_default_plugins) do
  vim.g["loaded_" .. plugin] = 1
end

-- Disable all builtin providers
local disable_default_providers = {
  "node",
  "perl",
  "python3",
  "ruby",
}

for _, provider in ipairs(disable_default_providers) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end
