vim.bo.iskeyword = nil
vim.bo.shiftwidth = 4

local runner = require("quarto.runner")
local run_all_langs = function() runner.run_all(true) end

local buffer = vim.api.nvim_get_current_buf()
safely("later", function()
  if not vim.api.nvim_buf_is_valid(buffer) or vim.bo[buffer].filetype ~= "quarto" then return end
  local minisnippets = require("mini.snippets")
  local quarto = vim.list_extend({
    "quarto.{json,lua}",
    "quarto/**/*.{json,lua}",
  }, vim.g.minisnippets_lang_patterns.markdown)

  vim.b[buffer].minisnippets_config = {
    snippets = {
      minisnippets.gen_loader.from_lang({
        lang_patterns = {
          markdown = quarto,
          markdown_inline = quarto,
        },
      }),
    },
  }
end)

-- stylua: ignore start
vim.keymap.set("n", "<localleader>c", runner.run_cell,  { desc = "Run the current cell",                 buffer = true })
vim.keymap.set("n", "<localleader>u", runner.run_above, { desc = "Run cells above",                      buffer = true })
vim.keymap.set("n", "<localleader>a", runner.run_all,   { desc = "Run all cells",                        buffer = true })
vim.keymap.set("n", "<localleader>l", runner.run_line,  { desc = "Run the current line",                 buffer = true })
vim.keymap.set("v", "<localleader>r", runner.run_range, { desc = "Run the selected range",               buffer = true })
vim.keymap.set("n", "<localleader>A", run_all_langs,    { desc = "Run all cells in all languages",       buffer = true })
-- stylua: ignore end

require("user.ftplugin").undo({
  "setlocal iskeyword< shiftwidth<",
  "unlet! b:minisnippets_config",
  "silent! nunmap <buffer> <localleader>c",
  "silent! nunmap <buffer> <localleader>u",
  "silent! nunmap <buffer> <localleader>a",
  "silent! nunmap <buffer> <localleader>l",
  "silent! vunmap <buffer> <localleader>r",
  "silent! nunmap <buffer> <localleader>A",
})
