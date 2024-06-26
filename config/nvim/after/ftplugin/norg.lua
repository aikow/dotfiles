vim.opt.comments = ""
vim.opt.wrap = false

-- ---------------------
-- |   Local Keymaps   |
-- ---------------------
--
vim.keymap.set(
  { "v", "n" },
  "<localleader>a",
  "<cmd>Neorg<CR>",
  { buffer = true, desc = "neorg open menu" }
)

-- -------------------------
-- |   Custom Highlights   |
-- -------------------------
vim.b.minihipatterns_config = {
  highlighters = {
    today = { pattern = "#time.due", group = "MiniHipatternsNote" },
  },
}

-- -----------------------------
-- |   File Type Completions   |
-- -----------------------------
--
-- Setup Neorg completion sources to use neorg completion
local ok_cmp, cmp = pcall(require, "cmp")
if ok_cmp then
  ---@diagnostic disable-next-line: missing-fields
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
