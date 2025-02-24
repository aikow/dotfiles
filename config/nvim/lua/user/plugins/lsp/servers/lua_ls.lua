local M = {}

M.opts = {
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
      },
      -- FIXME(mini.completion): Remove this once snippets are supported
      -- completion = {
      --   callSnippet = "Replace",
      -- },
    },
  },
}

return M
