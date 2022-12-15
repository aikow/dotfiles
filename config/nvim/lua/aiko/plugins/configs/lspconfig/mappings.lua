local M = {}

M.setup = function()
  local map = vim.keymap.set

  local bufnr = vim.api.nvim_get_current_buf()
  local opts = function(desc)
    return {
      silent = true,
      buffer = true,
      desc = desc or "",
    }
  end

  local lsp = vim.lsp.buf
  local d = vim.diagnostic
  --
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Code actions and hovers.
  map("n", "K", lsp.hover, opts("LSP hover"))
  map("n", "<leader>k", lsp.signature_help, opts("LSP signature help"))

  map("n", "gr", vim.lsp.buf.references, opts("LSP go to references"))
  map("n", "gD", vim.lsp.buf.declaration, opts("LSP go to declaration"))
  map("n", "gd", vim.lsp.buf.definition, opts("LSP go to definition"))
  map("n", "gi", vim.lsp.buf.implementation, opts("LSP go to implementation"))
  map("n", "gy", vim.lsp.buf.type_definition, opts("LSP go to type definition"))

  -- Symbols outline
  map("n", "gO", "<cmd>SymbolsOutline<CR>", opts("LSP symbols outline"))

  -- Diagnostics
  map("n", "<leader>df", d.open_float, opts("diagnostic open float"))
  map({ "n", "v", "o" }, "[e", d.goto_prev, opts("go to previous diagnostic"))
  map({ "n", "v", "o" }, "]e", d.goto_next, opts("go to next diagnostic"))
  map("n", "<leader>dl", d.setloclist, opts("diagnostic set location list"))

  -- Refactoring with <leader>r...
  map("n", "<leader>rr", lsp.rename, opts("LSP rename"))
  map({ "n", "x" }, "<leader>rf", function()
    vim.lsp.buf.format({ async = true })
  end, opts("LSP format file"))
  map({ "n", "x" }, "<leader>a", lsp.code_action, opts("LSP code actions"))

  -- Workspace folders
  map(
    "n",
    "<leader>lwa",
    vim.lsp.buf.add_workspace_folder,
    opts("LSP workspace add folder")
  )
  map(
    "n",
    "<leader>lwr",
    vim.lsp.buf.remove_workspace_folder,
    opts("LSP workspace remove folder")
  )
  map("n", "<leader>lwl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts("LSP workspace list folders"))
end

return M
