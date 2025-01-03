local M = {}

-- disable some builtin vim plugins
M.disable_default_plugins = {
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

function M.disable_plugins()
  for _, plugin in pairs(M.disable_default_plugins) do
    vim.g["loaded_" .. plugin] = 1
  end
end

-- Disable all builtin providers
M.disable_default_providers = {
  "node",
  "perl",
  "python3",
  "ruby",
}

function M.disable_providers()
  for _, provider in ipairs(M.disable_default_providers) do
    vim.g["loaded_" .. provider .. "_provider"] = 0
  end
end

M.disable_plugins()
M.disable_providers()
