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
  self:map("gD", vim.lsp.buf.declaration, { desc = "LSP go to declaration" })
  self:map("K", vim.lsp.buf.hover, { desc = "LSP hover" })

  -- Signature help
  self:map("<leader>k", vim.lsp.buf.signature_help, { desc = "LSP signature help", has = "signatureHelp" })
  self:map("<c-k>", vim.lsp.buf.signature_help, { mode = "i", desc = "LSP signature help", has = "signatureHelp" })

  self:map("<leader>a", vim.lsp.buf.code_action, { desc = "LSP code actions", mode = { "n", "v" }, has = "codeAction" })

  -- LSP go-to actions
  self:map("gd", "Telescope lsp_definitions", { desc = "list LSP definitions with telescope" })
  self:map("gr", "Telescope lsp_references", { desc = "list LSP references with telescope" })
  self:map("gi", "Telescope lsp_implementations", { desc = "list LSP implementations with telescope" })
  self:map("gy", "Telescope lsp_type_definitions", { desc = "list LSP type definitions with telescope" })

  self:map("<leader>jd", "Trouble lsp_definitions", { desc = "list LSP definitions with trouble" })
  self:map("<leader>jr", "Trouble lsp_references", { desc = "list LSP references with trouble" })
  self:map("<leader>ji", "Trouble lsp_implementations", { desc = "list LSP implementations with trouble" })
  self:map("<leader>jy", "Trouble lsp_type_definitions", { desc = "list LSP type definitions with trouble" })

  -- Telescope - search for symbols
  self:map("<leader>js", "Telscope lsp_workspace_symbols", { desc = "list LSP workspace symbols with telescope" })
  self:map("<leader>jS", "Telscope lsp_dynamic_workspace_symbols", { desc = "list LSP workspace symbols dynamically with telescope" })

  -- Symbols outline
  self:map("gO", "SymbolsOutline", { desc = "LSP open symbols outline" })

  -- Diagnostics
  self:map("<leader>e", vim.diagnostic.open_float, { desc = "open diagnostics float for line" })
  self:map("<leader>dl", vim.diagnostic.setloclist, { desc = "set location list to diagnostics" })
  self:map("<leader>dq", vim.diagnostic.setqflist, { desc = "set quickfix list to diagnostics" })
  self:map("<leader>dt", "Trouble workspace_diagnostics", { desc = "open diagnostics with trouble" })
  self:map("<leader>do", "Telescope diagnostics", { desc = "open diagnostics with telescope" })

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
