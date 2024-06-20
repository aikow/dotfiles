local M = {}

function M.new(client, buffer)
  return setmetatable({ client = client, buffer = buffer }, { __index = M })
end

function M:has(cap) return self.client.server_capabilities[cap .. "Provider"] end

function M:map(lhs, rhs, opts)
  opts = opts or {}
  if opts.has and not self:has(opts.has) then return end
  vim.keymap.set(
    opts.mode or "n",
    lhs,
    type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs,
    { silent = true, buffer = self.buffer, expr = opts.expr, desc = opts.desc }
  )
end

function M.diagnostic_goto(next, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function() vim.diagnostic.jump({ count = next and 1 or -1, severity = severity }) end
end

function M.on_attach(client, buffer)
  local self = M.new(client, buffer)

  -- stylua: ignore start
  -- Extend default LSP actions.
  self:map("gD", vim.lsp.buf.declaration, { desc = "vim.lsp.buf.declaration()" })
  self:map("gri", vim.lsp.buf.implementation, { desc = "vim.lsp.buf.implementation()" })
  self:map("gy", vim.lsp.buf.type_definition, { desc = "vim.lsp.buf.implementation()" })

  -- Signature help
  self:map("<c-s>", vim.lsp.buf.signature_help, { mode = {"i", "n"}, desc = "LSP signature help", has = "signatureHelp" })

  -- LSP go-to actions
  self:map("gd", "Telescope lsp_definitions", { desc = "telescope lsp definitions" })
  self:map("<leader>lr", "Telescope lsp_references", { desc = "telescope lsp references" })
  self:map("<leader>li", "Telescope lsp_implementations", { desc = "telescope lsp implementations" })
  self:map("<leader>ly", "Telescope lsp_type_definitions", { desc = "telescope lsp type definitions" })

  -- Telescope - search for symbols
  self:map("<leader>ls", "Telescope lsp_workspace_symbols", { desc = "list LSP workspace symbols with telescope" })
  self:map("<leader>lS", "Telescope lsp_dynamic_workspace_symbols", { desc = "list LSP workspace symbols dynamically with telescope" })

  -- Diagnostics
  self:map("<leader>k", vim.diagnostic.open_float, { desc = "open diagnostics float for line" })
  self:map("<leader>dl", vim.diagnostic.setloclist, { desc = "set location list to diagnostics" })
  self:map("<leader>dq", vim.diagnostic.setqflist, { desc = "set quickfix list to diagnostics" })
  self:map("<leader>do", "Telescope diagnostics", { desc = "open diagnostics with telescope" })

  -- Diagnostic movements with [ and ]
  self:map("]d", M.diagnostic_goto(true), { desc = "next diagnostic" })
  self:map("[d", M.diagnostic_goto(false), { desc = "previous diagnostic" })
  self:map("]e", M.diagnostic_goto(true, "ERROR"), { desc = "next error" })
  self:map("[e", M.diagnostic_goto(false, "ERROR"), { desc = "previous error" })
  self:map("]w", M.diagnostic_goto(true, "WARNING"), { desc = "next warning" })
  self:map("[w", M.diagnostic_goto(false, "WARNING"), { desc = "previous warning" })

  self:map("<leader>rr", vim.lsp.buf.rename, { desc = "rename using LSP", has = "rename" })
  -- stylua: ignore end
end

return M
