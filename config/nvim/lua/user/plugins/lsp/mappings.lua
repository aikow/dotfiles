local LspUtil = require("user.util.lsp")

local H = {}

function H.diagnostic_goto(next, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function() vim.diagnostic.jump({ count = next and 1 or -1, severity = severity }) end
end

function H.typehierarchy(direction)
  return function() vim.lsp.buf.typehierarchy(direction) end
end

local LspBuf = {}

function LspBuf.new(client, buffer)
  return setmetatable({ client = client, buffer = buffer }, { __index = LspBuf })
end

function LspBuf:map(lhs, rhs, opts)
  opts = opts or {}
  vim.keymap.set(
    opts.mode or "n",
    lhs,
    type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs,
    { silent = true, buffer = self.buffer, desc = opts.desc }
  )
end

function LspBuf.on_attach(client, buffer)
  local self = LspBuf.new(client, buffer)

  -- stylua: ignore start
  -- Extend default LSP actions.
  self:map("<leader>s", vim.lsp.buf.signature_help,                                  { desc = "lsp signature help" })
  self:map("gD",        vim.lsp.buf.declaration,                                     { desc = "lsp go to declaration" })
  self:map("gd",        vim.lsp.buf.definition,                                      { desc = "lsp go to definition" })
  self:map("gO",        LspUtil.document_symbols({ "Function", "Method", "Class" }), { desc = "vim.lsp.buf.document_symbol" })
  self:map("grS",       H.typehierarchy("supertypes"),                               { desc = "lsp list supertypes" })
  self:map("grci",      vim.lsp.buf.incoming_calls,                                  { desc = "lsp list incoming calls" })
  self:map("grco",      vim.lsp.buf.outgoing_calls,                                  { desc = "lsp list outgoing calls" })
  self:map("grs",       H.typehierarchy("subtypes"),                                 { desc = "lsp list subtypes" })
  self:map("gry",       vim.lsp.buf.type_definition,                                 { desc = "lsp type declarations" })

  -- LSP go-to actions
  self:map("<leader>ld", "Pick lsp scope='definition'",      { desc = "mini.pick lsp definitions" })
  self:map("<leader>lr", "Pick lsp scope='references'",      { desc = "mini.pick lsp references" })
  self:map("<leader>li", "Pick lsp scope='implementation'",  { desc = "mini.pick lsp implementations" })
  self:map("<leader>ly", "Pick lsp scope='type_definition'", { desc = "mini.pick lsp type definitions" })

  -- Search for symbols
  self:map("<leader>ls", "Pick lsp scope='document_symbol'",  { desc = "mini.pick document symbols" })
  self:map("<leader>lS", "Pick lsp scope='workspace_symbol'", { desc = "mini.pick workspace symbols" })

  -- Diagnostics
  self:map("<leader>dl", vim.diagnostic.setloclist, { desc = "diagnostic set location list" })
  self:map("<leader>dq", vim.diagnostic.setqflist,  { desc = "diagnostic set quickfix list" })
  self:map("<leader>do", "Pick diagnostic",         { desc = "mini.pick diagnostics" })

  -- Diagnostic movements with [ and ]
  self:map("]e", H.diagnostic_goto(true, "ERROR"),    { desc = "next error" })
  self:map("[e", H.diagnostic_goto(false, "ERROR"),   { desc = "previous error" })
  self:map("]w", H.diagnostic_goto(true, "WARNING"),  { desc = "next warning" })
  self:map("[w", H.diagnostic_goto(false, "WARNING"), { desc = "previous warning" })
  -- stylua: ignore end
end

return LspBuf
