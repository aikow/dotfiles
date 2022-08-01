local M = {}

M.setup = function()
  local ok_mason, mason = pcall(require, "mason")
  if not ok_mason then
    return
  end

  mason.setup({
    ui = {
      icons = {
        package_pending = " ",
        package_installed = " ",
        package_uninstalled = " ﮊ",
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
