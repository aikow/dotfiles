-- -----------------------------------
-- |   Setup File Type Completions   |
-- -----------------------------------
--
-- Setup tree-sitter query completion sources to use onmi completion.
local ok_cmp, cmp = pcall(require, "cmp")
if ok_cmp then
  ---@diagnostic disable-next-line: missing-fields
  cmp.setup.buffer({
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "crates" },
      { name = "path" },
      { name = "luasnip" },
    }, {
      { name = "buffer", keyword_length = 5, max_item_count = 10 },
    }),
  })
end
