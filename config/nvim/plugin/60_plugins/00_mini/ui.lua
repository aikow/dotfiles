safely("later", function() require("mini.cmdline").setup({}) end)
safely("later", function() require("mini.cursorword").setup({}) end)
safely("later", function() require("mini.input").setup({}) end)

-- ------------------------------------------------------------------------
-- | mini.icons
-- ------------------------------------------------------------------------
safely("now", function()
  require("mini.icons").setup({})
  require("mini.icons").mock_nvim_web_devicons()
end)
safely("later", function() require("mini.icons").tweak_lsp_kind("prepend") end)

-- ------------------------------------------------------------------------
-- | mini.notify
-- ------------------------------------------------------------------------
safely("now", function()
  local notify = require("mini.notify")
  notify.setup({})
  vim.keymap.set("n", "<leader>mo", notify.show_history, { desc = "Show mini.notify history" })
  vim.keymap.set("n", "<leader>mc", notify.clear, { desc = "Clear mini.notify history" })
end)

-- ------------------------------------------------------------------------
-- | mini.misc
-- ------------------------------------------------------------------------
safely("now", function()
  local minimisc = require("mini.misc")
  minimisc.setup({})
  -- Theme detection uses OSC10 foreground, leaving OSC11 for border sync.
  minimisc.setup_termbg_sync()
  minimisc.setup_restore_cursor({ ignore_filetype = { "gitcommit", "gitrebase", "bigfile" } })

  vim.keymap.set("n", "<leader>ww", minimisc.zoom, { desc = "Zoom with mini.misc" })
end)

-- ------------------------------------------------------------------------
-- | mini.statusline
-- ------------------------------------------------------------------------
safely("now", function()
  require("mini.statusline").setup({})
  -- Disable the statusline for certain filetypes.
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user.pack.mini_statusline.disable", {}),
    pattern = { "DiffviewFiles" },
    desc = "Disable statusline for diff views",
    callback = function() vim.b.ministatusline_disable = true end,
  })
end)

-- ------------------------------------------------------------------------
-- | mini.hipatterns
-- ------------------------------------------------------------------------
safely("later", function()
  local hipatterns = require("mini.hipatterns")
  hipatterns.setup({
    highlighters = {
      fixme = { pattern = "FIXME", group = "MiniHipatternsFixme" },
      hack = { pattern = "HACK", group = "MiniHipatternsHack" },
      todo = { pattern = "TODO", group = "MiniHipatternsTodo" },
      note = { pattern = "NOTE", group = "MiniHipatternsNote" },
      hex_color = hipatterns.gen_highlighter.hex_color(),
      deprecated = { pattern = "DEPRECATED", group = "MiniHipatternsFixme" },
    },
  })
end)

-- ------------------------------------------------------------------------
-- | mini.statuscolumn
-- ------------------------------------------------------------------------
safely("later", function()
  local ministatuscolumn = require("mini.statuscolumn")
  ministatuscolumn.setup({
    content = ministatuscolumn.gen_content.main({
      { fold = "%C", lnum = "%l", sign = "%s" },
      { format = "fs=l", sep = " " },
      { ltype = "virt", lnum = "•" },
      { ltype = "wrap", lnum = "↳" },
    }),
  })
end)
