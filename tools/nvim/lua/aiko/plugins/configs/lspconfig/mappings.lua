local M = {}

M.setup = function()
  local map = vim.keymap.set
  local opts = function(desc)
    return {
      silent = true,
      buffer = false,
      desc = desc or "",
    }
  end

  local lsp = vim.lsp.buf
  local d = vim.diagnostic

  -- Hover actions
  map("n", "K", function()
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ "help", "vim" }, filetype) then
      vim.cmd.help(vim.fn.expand("<cword>"))
    elseif vim.tbl_contains({ "man" }, filetype) then
      vim.cmd.Man(vim.fn.expand("<cword>"))
    elseif vim.fn.expand("%:t") == "Cargo.toml" then
      require("crates").show_popup()
    else
      vim.lsp.buf.hover()
    end
  end, opts("show documentation"))
  map("n", "<leader>k", lsp.signature_help, opts("signature help"))

  -- Diagnostics
  map("n", "<leader>e", d.open_float, opts("open diagnostic float"))
  map({ "n", "v", "o" }, "[e", d.goto_prev, opts("go to previous diagnostic"))
  map({ "n", "v", "o" }, "]e", d.goto_next, opts("go to next diagnostic"))
  map("n", "<leader>dl", d.setloclist, opts("diagnostics set location list"))

  -- Code actions
  map("n", "<leader>a", lsp.code_action, opts("LSP code actions"))

  -- Refactoring with <leader>r...
  map("n", "<leader>rr", lsp.rename, opts("LSP rename"))
  map("n", "<leader>rf", lsp.format, opts("LSP format file"))
end

return M
