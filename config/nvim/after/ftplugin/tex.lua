local map = vim.keymap.set

map("n", "K", "<cmd>VimtexContextMenu<CR>", { silent = true, buffer = true })

-- -----------------------------------
-- |   Setup File Type Completions   |
-- -----------------------------------
--
-- Setup LaTeX completion sources to use onmi completion.
local ok_cmp, cmp = pcall(require, "cmp")
if ok_cmp then
  cmp.setup.buffer({
    sources = cmp.config.sources({
      { name = "luasnip" },
      { name = "omni" },
      { name = "path" },
    }, {
      { name = "buffer", keyword_length = 4, max_item_count = 10 },
    }),
  })
end
