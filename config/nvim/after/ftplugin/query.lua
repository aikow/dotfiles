-- -----------------------------------
-- |   Setup File Type Completions   |
-- -----------------------------------
--
-- Setup tree-sitter query completion sources to use onmi completion.
local ok_cmp, cmp = pcall(require, "cmp")
if ok_cmp then
  cmp.setup.buffer({
    sources = cmp.config.sources({
      { name = "luasnip" },
      { name = "omni" },
    }, {
      { name = "buffer", keyword_length = 4 },
    }),
  })
end

-- local omnifunc_module = "nvim_treesitter_playground_query_omnifunc"
-- local ok_omnifunc, mod = pcall(require, omnifunc_module)
-- if ok_omnifunc then
--   local omnifunc = mod.omnifunc
--   vim.cmd([[
--     function! QueryOmnifunc(findstart, base)
--       return v:lua.require'nvim_treesitter_playground_query_omnifunc'.omnifunc(a:findstart, a:base)
--     endfunction
--   ]])
--   vim.bo.omnifunc = "QueryOmnifunc"
-- end
