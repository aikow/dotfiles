local M = {}

M.setup = function()
  require("rust-tools").setup({
    tools = { -- rust-tools options
      autoSetHints = true, -- Automatically set inlay hints
      hover_with_actions = true, -- Show action inside the hover menu
      inlay_hints = {
        show_parameter_hints = true, -- Show parameter hints
        parameter_hints_prefix = "<- ",
        other_hints_prefix = "=> ",
      },
    },
    -- These override the defaults set by rust-tools.nvim.
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
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
