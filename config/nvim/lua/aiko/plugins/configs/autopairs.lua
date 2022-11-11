local M = {}

M.setup = function()
  local ok_autopairs, autopairs = pcall(require, "nvim-autopairs")
  if not ok_autopairs then
    return
  end

  local ok_cmp, cmp = pcall(require, "cmp")
  if not ok_cmp then
    return
  end

  autopairs.setup({
    fast_wrap = {},
    disable_filetype = { "TelescopePrompt", "vim" },
  })

  local cmp_autopairs = require("nvim-autopairs.completion.cmp")

  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return M
