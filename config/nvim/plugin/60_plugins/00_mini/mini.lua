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
-- | Later
-- ------------------------------------------------------------------------

safely("later", function() require("mini.align").setup({}) end)
safely("later", function() require("mini.cmdline").setup({}) end)
safely("later", function() require("mini.cursorword").setup({}) end)
safely("later", function() require("mini.input").setup({}) end)
safely("later", function() require("mini.splitjoin").setup({}) end)

-- ------------------------------------------------------------------------
-- | mini.ai
-- ------------------------------------------------------------------------
safely("later", function()
  local spec_treesitter = require("mini.ai").gen_spec.treesitter
  require("mini.ai").setup({
    mappings = {
      around_next = "ak",
      inside_next = "ik",
    },
    custom_textobjects = {
      c = spec_treesitter({ a = "@conditional.outer", i = "@conditional.inner" }),
      l = spec_treesitter({ a = "@loop.outer", i = "@loop.inner" }),
      m = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
      o = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
    },
  })
end)

-- ------------------------------------------------------------------------
-- | mini.bracketed
-- ------------------------------------------------------------------------
safely(
  "later",
  function()
    require("mini.bracketed").setup({
      comment = { suffix = "g" },
      diagnostic = { suffix = "" },
      jump = { suffix = "" },
      undo = { suffix = "" },
      window = { suffix = "" },
    })
  end
)

-- ------------------------------------------------------------------------
-- | mini.bufremove
-- ------------------------------------------------------------------------
safely("later", function()
  local minibufremove = require("mini.bufremove")
  minibufremove.setup({})

  vim.keymap.set("n", "<leader>q", minibufremove.delete, { desc = "Delete with mini.bufremove" })
end)

-- ------------------------------------------------------------------------
-- | mini.completion
-- ------------------------------------------------------------------------
safely("later", function()
  require("mini.completion").setup({ lsp_completion = { auto_setup = false } })

  -- Disable MiniCompletion for some filetypes
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user.pack.mini_completion.disable", {}),
    pattern = { "minifiles" },
    desc = "Disable completion for file explorers",
    callback = function() vim.b.minicompletion_disable = true end,
  })
end)

-- ------------------------------------------------------------------------
-- | mini.diff
-- ------------------------------------------------------------------------
safely("later", function()
  local minidiff = require("mini.diff")
  minidiff.setup({
    view = {
      style = "sign",
      signs = { add = "│", change = "│", delete = "-" },
    },
  })

  vim.keymap.set("n", "<leader>gO", minidiff.toggle_overlay, { desc = "Toggle mini.diff overlay" })
end)

-- ------------------------------------------------------------------------
-- | mini.git
-- ------------------------------------------------------------------------
safely("later", function()
  local minigit = require("mini.git")
  minigit.setup({})

  -- Keymaps
  -- stylua: ignore start
  vim.keymap.set({"n", "x"}, "<leader>gk", minigit.show_at_cursor,     { desc = "Show mini.git object at cursor" })
  vim.keymap.set("n",        "<leader>gd", minigit.show_diff_source,   { desc = "Show mini.git diff source at cursor" })
  vim.keymap.set({"n", "x"}, "<leader>gl", minigit.show_range_history, { desc = "Show mini.git selection history" })
  -- stylua: ignore end
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
-- | mini.keymap
-- ------------------------------------------------------------------------
safely("later", function()
  local minikeymap = require("mini.keymap")
  minikeymap.map_multistep("i", "<CR>", { "pmenu_accept" }, { desc = "Accept the completion menu" })
end)

-- ------------------------------------------------------------------------
-- | mini.operators
-- ------------------------------------------------------------------------
safely(
  "later",
  function()
    require("mini.operators").setup({
      evaluate = { prefix = "g=" },
      exchange = { prefix = "gox" },
      multiply = { prefix = "gom" },
      replace = { prefix = "gor" },
      sort = { prefix = "gos" },
    })
  end
)

-- -- ------------------------------------------------------------------------
-- -- | mini.pairs
-- -- ------------------------------------------------------------------------
-- safely("later", function()
--   local minipairs = require("mini.pairs")
--   minipairs.setup({})
--
--   vim.api.nvim_create_autocmd("FileType", {
--     pattern = "rust",
--     desc = "Map single quotes in Rust buffers",
--     callback = function()
--       vim.keymap.set("i", "'", "'", { buf = 0, desc = "Map single quotes in insert mode" })
--     end,
--   })
-- end)

-- ------------------------------------------------------------------------
-- | mini.snippets
-- ------------------------------------------------------------------------
safely("later", function()
  vim.pack.add({
    { src = gh("rafamadriz/friendly-snippets") },
  })

  local minisnippets = require("mini.snippets")

  local langs = {
    latex = { "latex.{json,lua}", "latex/**/*.{json,lua}" },
    -- Add quarto to markdown snippets
    markdown = { "markdown.{json,lua}", "markdown/**/*.{json,lua}" },
  }
  vim.g.minisnippets_lang_patterns = langs

  minisnippets.setup({
    snippets = {
      -- Load custom file with global snippets first
      minisnippets.gen_loader.from_runtime("global.{json,lua}"),
      minisnippets.gen_loader.from_lang({
        lang_patterns = {
          markdown = langs.markdown,
          markdown_inline = langs.markdown,
          plaintext = langs.latex,
          tex = langs.latex,
        },
      }),
    },
  })

  local expand_all = function() minisnippets.expand({ match = false }) end
  vim.keymap.set("i", "<C-g><C-j>", expand_all, { desc = "Expand all snippets" })
end)

-- ------------------------------------------------------------------------
-- | mini.statuscolumn
-- ------------------------------------------------------------------------
safely("later", function()
  local ministatuscolumn = require("mini.statuscolumn")
  ministatuscolumn.setup({
    content = ministatuscolumn.gen_content.main({
      { fold = "%C", lnum = "%l", sign = "%s" }, -- Default sections
      {
        format = "sf=l",
        sep = " " --[[ "│" ]],
      }, -- Line-fold-sign-separator format
      { ltype = "virt", lnum = "•" }, -- Dot in virtual lines
      { ltype = "wrap", lnum = "↳" }, -- Arrow in wrapped lines
    }),
  })
end)

-- ------------------------------------------------------------------------
-- | mini.surround
-- ------------------------------------------------------------------------
safely("later", function()
  local minisurround = require("mini.surround")
  minisurround.setup({
    mappings = {
      add = "gs",
      delete = "ds",
      find = "",
      find_left = "",
      highlight = "gsh",
      replace = "cs",

      suffix_last = "",
      suffix_next = "",
    },
    n_lines = 40,
    respect_selection_type = true,
    search_method = "cover_or_next",
  })
  vim.keymap.set("x", "gs", [[:<C-u>lua MiniSurround.add('visual')<CR>]], {
    silent = true,
    desc = "Add a surround",
  })
  vim.keymap.set(
    "n",
    "gsu",
    minisurround.update_n_lines,
    { desc = "Update mini.surround line count" }
  )
end)

-- ------------------------------------------------------------------------
-- | mini.trailspace
-- ------------------------------------------------------------------------
safely("later", function()
  local minitrailspace = require("mini.trailspace")
  minitrailspace.setup({})
  vim.keymap.set(
    "n",
    "<leader>rt",
    minitrailspace.trim,
    { desc = "Trim whitespace with mini.trailspace" }
  )
  vim.keymap.set(
    "n",
    "<leader>rT",
    minitrailspace.trim_last_lines,
    { desc = "Trim trailing lines with mini.trailspace" }
  )
end)
