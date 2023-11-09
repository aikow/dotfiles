local M = {}

function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(params)
      local buffer = params.buf
      local client = vim.lsp.get_client_by_id(params.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

return M
