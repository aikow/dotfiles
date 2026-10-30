local on_update = require("user").on_update
local H = {}

safely("now", function()
  -- Automatically update mason registries when updating mason
  on_update("mason.nvim", function() vim.cmd.MasonUpdate() end)

  -- Provide adapter and helper functions for setting up language servers.
  vim.pack.add({
    { src = gh("neovim/nvim-lspconfig") },
    { src = gh("mason-org/mason.nvim") },
    { src = gh("mason-org/mason-lspconfig.nvim") },
    { src = gh("b0o/SchemaStore.nvim") },
  })
  require("mason").setup()
  require("mason-lspconfig").setup({
    automatic_enable = true,
    automatic_installation = false,
    ensure_installed = { "lua_ls" },
  })

  -- Setup LSP servers not installed by mason.
  vim.lsp.enable({ "jetls", "nushell", "rust_analyzer" })

  -- Configure neovim diagnostics
  vim.diagnostic.config({
    virtual_lines = false,
    virtual_text = true,
    float = {
      suffix = function(diagnostic)
        ---@diagnostic disable-next-line: missing-return
        if diagnostic.source then return " [" .. diagnostic.source .. "]", "Comment" end
      end,
    },
  })

  -- Setup keymaps when an LSP server is attach.
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("user.lsp.keymaps", {}),
    desc = "Set LSP buffer mappings",
    callback = function(params)
      local client = vim.lsp.get_client_by_id(params.data.client_id)
      if client then H.on_attach(client, params.buf) end
    end,
  })
end)

function H.on_attach(client, buffer)
  local map = function(lhs, rhs, opts)
    opts = opts or {}
    vim.keymap.set(
      opts.mode or "n",
      lhs,
      type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs,
      { silent = true, buffer = buffer, desc = opts.desc }
    )
  end

  -- stylua: ignore start
  -- Extend default LSP actions.
  map("<leader>s", vim.lsp.buf.signature_help,    { desc = "Show LSP signature help" })
  map("gD",        vim.lsp.buf.declaration,       { desc = "Go to the declaration" })
  map("gd",        vim.lsp.buf.definition,        { desc = "Go to the definition" })
  map("grS",       H.typehierarchy("supertypes"), { desc = "List supertypes with vim.lsp" })
  map("grci",      vim.lsp.buf.incoming_calls,    { desc = "List incoming calls with vim.lsp" })
  map("grco",      vim.lsp.buf.outgoing_calls,    { desc = "List outgoing calls with vim.lsp" })
  map("grs",       H.typehierarchy("subtypes"),   { desc = "List subtypes with vim.lsp" })

  -- LSP go-to actions
  map("<leader>ld", "Pick lsp scope='definition'",      { desc = "Find LSP definitions with mini.pick" })
  map("<leader>lr", "Pick lsp scope='references'",      { desc = "Find LSP references with mini.pick" })
  map("<leader>li", "Pick lsp scope='implementation'",  { desc = "Find LSP implementations with mini.pick" })
  map("<leader>lt", "Pick lsp scope='type_definition'", { desc = "Find LSP type definitions with mini.pick" })

  -- Search for symbols
  map("<leader>ls", "Pick lsp scope='document_symbol'",  { desc = "Find document symbols with mini.pick" })
  map("<leader>lS", "Pick lsp scope='workspace_symbol'", { desc = "Find workspace symbols with mini.pick" })
  map("<leader>lo", H.document_symbols,                  { desc = "Show document symbols with vim.lsp" })

  -- Diagnostics
  map("<leader>dl", vim.diagnostic.setloclist, { desc = "Set the diagnostic location list" })
  map("<leader>dq", vim.diagnostic.setqflist,  { desc = "Set the diagnostic quickfix list" })
  map("<leader>do", "Pick diagnostic",         { desc = "Find diagnostics with mini.pick" })

  -- Diagnostic movements with [ and ]
  map("]e", H.diagnostic_goto(1, "ERROR"),    { desc = "Go to the next error" })
  map("[e", H.diagnostic_goto(-1, "ERROR"),   { desc = "Go to the previous error" })
  map("]w", H.diagnostic_goto(1, "WARN"),  { desc = "Go to the next warning" })
  map("[w", H.diagnostic_goto(-1, "WARN"), { desc = "Go to the previous warning" })
  -- stylua: ignore end

  vim.bo[buffer].completefunc = "v:lua.MiniCompletion.completefunc_lsp"

  -- Setup LSP folding
  if client:supports_method("textDocument/foldingRange") then
    local win = vim.api.nvim_get_current_win()
    vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
  end
end

function H.diagnostic_goto(count, severity)
  return function() vim.diagnostic.jump({ count = count, severity = severity }) end
end

function H.typehierarchy(direction)
  return function() vim.lsp.buf.typehierarchy(direction) end
end

function H.document_symbols() H.document_symbols_kinds({ "Function", "Method", "Class" }) end

---Show filtered document symbols in the invoking window's location list.
---@param kinds string[] List of symbol kinds to display.
function H.document_symbols_kinds(kinds)
  local winid = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.lsp.buf.document_symbol({
    on_list = function(options)
      if not vim.api.nvim_win_is_valid(winid) or vim.api.nvim_win_get_buf(winid) ~= bufnr then
        return
      end
      options.items = vim
        .iter(options.items)
        :filter(function(o)
          -- Need to remove any LSP-Kind icons from the kind string.
          local kind = string.gsub(o.kind, "%W", "")
          return vim.tbl_contains(kinds, kind)
        end)
        :totable()
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.fn.setloclist(winid, {}, " ", options)
      vim.api.nvim_win_call(winid, vim.cmd.lopen)
    end,
    pos = vim.pos.cursor(0, vim.api.nvim_win_get_cursor(0)),
  })
end
