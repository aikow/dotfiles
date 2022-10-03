local M = {}

M.mappings = function()
  local map = vim.keymap.set

  map(
    "n",
    "<localleader>d",
    "<cmd>RustOpenExternalDocs<CR>",
    { silent = true, desc = "rust open external docs" }
  )
  map(
    "n",
    "<localleader>t",
    "<cmd>RustDebuggables<CR>",
    { silent = true, desc = "rust debuggables" }
  )
  map(
    "n",
    "<localleader>r",
    "<cmd>RustRunnables<CR>",
    { silent = true, desc = "rust runnables" }
  )
  map(
    "n",
    "<localleader>c",
    "<cmd>RustOpenCargo<CR>",
    { silent = true, desc = "rust open cargo" }
  )
  map(
    "n",
    "<localleader>m",
    "<cmd>RustExpandMacro<CR>",
    { silent = true, desc = "rust expand macro" }
  )
  map(
    "n",
    "<localleader>a",
    "<cmd>RustHoverActions<CR>",
    { silent = true, desc = "rust hover actions" }
  )
end

M.setup = function()
  local ok_rust_tools, rust_tools = pcall(require, "rust-tools")
  if not ok_rust_tools then
    return
  end

  local ok_cmp_nvim_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  if not ok_cmp_nvim_lsp then
    return
  end

  local capabilities =
    cmp_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

  rust_tools.setup({
    tools = { -- rust-tools options
      autoSetHints = true, -- Automatically set inlay hints
      -- hover_with_actions = true, -- Show action inside the hover menu
      inlay_hints = {
        show_parameter_hints = true, -- Show parameter hints
        parameter_hints_prefix = "<- ",
        other_hints_prefix = "=> ",
      },
    },
    -- These override the defaults set by rust-tools.nvim.
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
      on_attach = function()
        require("aiko.plugins.configs.lspconfig").mappings()
        M.mappings()
      end,
      capabilities = capabilities,
      settings = {
        -- to enable rust-analyzer settings visit:
        -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
        ["rust-analyzer"] = {
          -- enable clippy on save
          checkOnSave = {
            command = "clippy",
          },
        },
      },
    },
  })
end

return M
