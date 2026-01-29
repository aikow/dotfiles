local H = {}

MiniDeps.now(function()
  -- Automatically update mason registries when updating mason
  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      local name = ev.data.spec.name
      if name == "mason.nvim" then
        vim.notify("[mason] updating registries", vim.log.levels.INFO)
        vim.cmd.MasonUpdate()
      end
    end,
  })

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
  vim.lsp.enable({ "julials", "nushell", "rust_analyzer" })

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
    group = vim.api.nvim_create_augroup("LspSetupKeymaps", {}),
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
  local winid = vim.api.nvim_get_current_win()

  -- stylua: ignore start
  -- Extend default LSP actions.
  map("<leader>s", vim.lsp.buf.signature_help,    { desc = "lsp signature help" })
  map("gD",        vim.lsp.buf.declaration,       { desc = "lsp go to declaration" })
  map("gd",        vim.lsp.buf.definition,        { desc = "lsp go to definition" })
  map("gO",        H.document_symbols(winid),     { desc = "vim.lsp.buf.document_symbol" })
  map("grS",       H.typehierarchy("supertypes"), { desc = "lsp list supertypes" })
  map("grci",      vim.lsp.buf.incoming_calls,    { desc = "lsp list incoming calls" })
  map("grco",      vim.lsp.buf.outgoing_calls,    { desc = "lsp list outgoing calls" })
  map("grs",       H.typehierarchy("subtypes"),   { desc = "lsp list subtypes" })
  map("gry",       vim.lsp.buf.type_definition,   { desc = "lsp type declarations" })

  -- LSP go-to actions
  map("<leader>ld", "Pick lsp scope='definition'",      { desc = "mini.pick lsp definitions" })
  map("<leader>lr", "Pick lsp scope='references'",      { desc = "mini.pick lsp references" })
  map("<leader>li", "Pick lsp scope='implementation'",  { desc = "mini.pick lsp implementations" })
  map("<leader>ly", "Pick lsp scope='type_definition'", { desc = "mini.pick lsp type definitions" })

  -- Search for symbols
  map("<leader>ls", "Pick lsp scope='document_symbol'",  { desc = "mini.pick document symbols" })
  map("<leader>lS", "Pick lsp scope='workspace_symbol'", { desc = "mini.pick workspace symbols" })

  -- Diagnostics
  map("<leader>dl", vim.diagnostic.setloclist, { desc = "diagnostic set location list" })
  map("<leader>dq", vim.diagnostic.setqflist,  { desc = "diagnostic set quickfix list" })
  map("<leader>do", "Pick diagnostic",         { desc = "mini.pick diagnostics" })

  -- Diagnostic movements with [ and ]
  map("]e", H.diagnostic_goto(1, "ERROR"),    { desc = "next error" })
  map("[e", H.diagnostic_goto(-1, "ERROR"),   { desc = "previous error" })
  map("]w", H.diagnostic_goto(1, "WARNING"),  { desc = "next warning" })
  map("[w", H.diagnostic_goto(-1, "WARNING"), { desc = "previous warning" })
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

function H.document_symbols(winid)
  return H.document_symbols_kinds(winid, { "Function", "Method", "Class" })
end

---Show the document symbols of the buffer displayed in window with winid in the location list after
---applying a filer.
---@param winid integer Window ID.
---@param kinds string[] List of symbol kinds to display.
function H.document_symbols_kinds(winid, kinds)
  return function()
    vim.lsp.buf.document_symbol({
      on_list = function(options)
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
    })
  end
end
