vim.opt.comments = ""

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
local note_hl = vim.api.nvim_get_hl(0, {
  name = "MiniHipatternsNote",
  link = false,
})
local norm_hl = vim.api.nvim_get_hl(0, {
  name = "Normal",
  link = false,
})
vim.api.nvim_set_hl(
  0,
  "MiniHipatternsNeorgToday",
  { fg = norm_hl.bg, bg = note_hl.fg }
)
vim.b.minihipatterns_config = {
  highlighters = {
    today = { pattern = "#today", group = "MiniHipatternsNeorgToday" },
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
