-- TODO: Replace with actual Neorg comment string format
vim.opt_local.commentstring = ""
vim.opt_local.comments = ""

-- -----------------------------------
-- |   Setup File Type Completions   |
-- -----------------------------------
--
-- Setup Neorg completion sources to use neorg completion
local ok_cmp, cmp = pcall(require, "cmp")
if ok_cmp then
  cmp.setup.buffer({
    sources = cmp.config.sources({
      { name = "luasnip" },
      { name = "neorg" },
      { name = "path" },
    }, {
      { name = "buffer", keyword_length = 4, max_item_count = 10 },
    }),
  })
end
