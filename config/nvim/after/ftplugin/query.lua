vim.opt.omnifunc = "v:lua.vim.treesitter.query.omnifunc"

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
      { name = "luasnip" },
      { name = "omni" },
    }, {
      { name = "buffer", keyword_length = 4 },
    }),
  })
end
