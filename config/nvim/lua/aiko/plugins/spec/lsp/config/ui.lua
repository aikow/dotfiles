local M = {}

-- ------------------------------------------------------------------------
-- | UI Tweaks
-- ------------------------------------------------------------------------
M.setup = function()
  local function lspSymbol(name, icon)
    local hl = "DiagnosticSign" .. name
    vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
  end

  local icons = require("aiko.ui.icons")

  lspSymbol("Error", icons.diagnostics.error)
  lspSymbol("Info", icons.diagnostics.info)
  lspSymbol("Hint", icons.diagnostics.hint)
  lspSymbol("Warn", icons.diagnostics.warn)

  vim.diagnostic.config({
    virtual_text = {
      prefix = "",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
  })

  -- Pretty borders for signature help and hover.
  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
    })

  vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded",
      focusable = false,
      relative = "cursor",
    })

  -- Suppress error messages from lang servers.
  vim.notify = function(msg, log_level)
    if msg:match("exit code") then
      return
    end
    if log_level == vim.log.levels.ERROR then
      vim.api.nvim_err_writeln(msg)
    else
      vim.api.nvim_echo({ { msg } }, true, {})
    end
  end
end

return M
