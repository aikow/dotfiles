local M = {}

M.setup = function()
  local ok_mason, mason = pcall(require, "mason")
  if not ok_mason then
    return
  end

  local icons = require("aiko.ui.icons").mason

  mason.setup({
    ui = {
      icons = {
        package_pending = icons.pending,
        package_installed = icons.installed,
        package_uninstalled = icons.uninstalled,
      },
    },
  })

  local ok_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
  if not ok_mason_lspconfig then
    return
  end

  mason_lspconfig.setup({
    ensure_installed = { "sumneko_lua" },
  })
end

return M
