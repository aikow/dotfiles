local M = {}

function M.new(client, buffer)
  return setmetatable({ client = client, buffer = buffer }, { __index = M })
end

function M:has(cap)
  return self.client.server_capabilities[cap .. "Provider"]
end

function M:map(lhs, rhs, opts)
  opts = opts or {}
  if opts.has and not self:has(opts.has) then
    return
  end
  vim.keymap.set(
    opts.mode or "n",
    lhs,
    type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs,
    { silent = true, buffer = self.buffer, expr = opts.expr, desc = opts.desc }
  )
end

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

function M.on_attach(client, buffer)
  local self = M.new(client, buffer)

  -- stylua: ignore start
  self:map("gd", "Telescope lsp_definitions", { desc = "goto definition" })
  self:map("gr", "Telescope lsp_references", { desc = "references" })
  self:map("gD", vim.lsp.buf.declaration, { desc = "goto declaration" })
  self:map("gi", "Telescope lsp_implementations", { desc = "goto implementation" })
  self:map("gy", "Telescope lsp_type_definitions", { desc = "goto type definition" })
  self:map("K", vim.lsp.buf.hover, { desc = "hover" })

  -- Telescope
  self:map("<leader>do", "Telescope diagnostics", { desc = "telescope open diagnostics" })
  self:map("<leader>ld", "Telescope lsp_definitions", { desc = "telescope lsp list definitions" })
  self:map("<leader>lr", "Telescope lsp_references", { desc = "telescope lsp list references" })
  self:map("<leader>li", "Telescope lsp_implementations", { desc = "telescope lsp list implementations" })
  self:map("<leader>ly", "Telescope lsp_type_definitions", { desc = "telescope lsp list type definitions" })
  self:map("<leader>lw", "Telescope lsp_workspace_symbols", { desc = "telescope lsp list workspace symbols", })
  self:map("<leader>lW", "Telescope lsp_dynamic_workspace_symbols", { desc = "telescope lsp list dynamic workspace symbols", })
  self:map("<leader>ls", "Telescope lsp_document_symbols", { desc = "telescope lsp list document symbols" })

  -- Symbols outline
  self:map("gO", "<cmd>SymbolsOutline<CR>", { desc = "lsp symbols outline" })

  -- Signature help
  self:map("<leader>k", vim.lsp.buf.signature_help, { desc = "signature help", has = "signatureHelp" })
  self:map("<c-k>", vim.lsp.buf.signature_help, { mode = "i", desc = "signature help", has = "signatureHelp" })

  -- Diagnostics
  self:map("<leader>e", vim.diagnostic.open_float, { desc = "diagnostics for line" })
  self:map("<leader>dl", vim.diagnostic.setloclist, { desc = "diagnostic set location list" })
  self:map("]d", M.diagnostic_goto(true), { desc = "next diagnostic" })
  self:map("[d", M.diagnostic_goto(false), { desc = "prev diagnostic" })
  self:map("]e", M.diagnostic_goto(true, "ERROR"), { desc = "next error" })
  self:map("[e", M.diagnostic_goto(false, "ERROR"), { desc = "prev error" })
  self:map("]w", M.diagnostic_goto(true, "WARNING"), { desc = "next warning" })
  self:map("[w", M.diagnostic_goto(false, "WARNING"), { desc = "prev warning" })

  self:map("<leader>a", vim.lsp.buf.code_action, { desc = "code action", mode = { "n", "v" }, has = "codeAction" })

  local format = require("aiko.plugins.lsp.format").format
  self:map("<leader>rf", format, { desc = "format document", has = "documentFormatting" })
  self:map("<leader>rf", format, { desc = "format range", mode = "v", has = "documentRangeFormatting" })
  self:map("<leader>rr", vim.lsp.buf.rename, { desc = "rename", has = "rename" })
  -- stylua: ignore end
end

return M
