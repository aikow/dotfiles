MiniDeps.now(
  function()
    MiniDeps.add({
      source = "nvim-mini/mini.nvim",
      depends = {
        "rafamadriz/friendly-snippets",
        "nvim-treesitter/nvim-treesitter",
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
    })
  end
)

-- ------------------------------------------------------------------------
-- | mini.icons
-- ------------------------------------------------------------------------
MiniDeps.now(function()
  require("mini.icons").setup({})
  require("mini.icons").mock_nvim_web_devicons()
end)
MiniDeps.later(function() require("mini.icons").tweak_lsp_kind("prepend") end)

-- ------------------------------------------------------------------------
-- | mini.notify
-- ------------------------------------------------------------------------
MiniDeps.now(function()
  local notify = require("mini.notify")
  notify.setup({})
  vim.keymap.set("n", "<leader>hn", notify.show_history, { desc = "mini.notify show history" })
  vim.keymap.set("n", "<leader>hN", notify.clear, { desc = "mini.notify show history" })
end)

-- ------------------------------------------------------------------------
-- | mini.misc
-- ------------------------------------------------------------------------
MiniDeps.now(function()
  local minimisc = require("mini.misc")
  minimisc.setup({})
  minimisc.setup_termbg_sync()
  minimisc.setup_restore_cursor()
end)

-- ------------------------------------------------------------------------
-- | mini.starter
-- ------------------------------------------------------------------------
MiniDeps.now(function() require("user.plugins.mini.starter") end)

-- ------------------------------------------------------------------------
-- | mini.files
-- ------------------------------------------------------------------------
MiniDeps.now(function()
  -- Load mini.files immediately to handle opening the case when nvim is passed a path to a directory
  -- instead of a file.
  require("user.plugins.mini.files")
end)

-- ------------------------------------------------------------------------
-- | mini.statusline
-- ------------------------------------------------------------------------
MiniDeps.now(function()
  require("mini.statusline").setup({})
  -- Disable the statusline for certain filetypes.
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "DiffviewFiles" },
    callback = function() vim.b.ministatusline_disable = true end,
  })
end)

-- ------------------------------------------------------------------------
-- | Later
-- ------------------------------------------------------------------------

MiniDeps.later(function() require("user.plugins.mini.clue") end)
MiniDeps.later(function() require("user.plugins.mini.git") end)
MiniDeps.later(function() require("user.plugins.mini.pick") end)
MiniDeps.later(function() require("user.plugins.mini.visits") end)

MiniDeps.later(function() require("mini.align").setup({}) end)
MiniDeps.later(function() require("mini.cursorword").setup({}) end)
MiniDeps.later(function() require("mini.splitjoin").setup({}) end)

-- ------------------------------------------------------------------------
-- | mini.ai
-- ------------------------------------------------------------------------
MiniDeps.later(function()
  local spec_treesitter = require("mini.ai").gen_spec.treesitter
  require("mini.ai").setup({
    custom_textobjects = {
      c = spec_treesitter({ a = "@conditional.outer", i = "@conditional.inner" }),
      l = spec_treesitter({ a = "@loop.outer", i = "@loop.inner" }),
      m = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
      o = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
    },
  })
end)

-- ------------------------------------------------------------------------
-- | mini.basics
-- ------------------------------------------------------------------------
MiniDeps.later(
  function()
    require("mini.basics").setup({
      options = { basic = false, extra_ui = true, win_borders = "bold" },
      mappings = { basic = false, option_toggle_prefix = "<leader>t" },
    })
  end
)

-- ------------------------------------------------------------------------
-- | mini.bracketed
-- ------------------------------------------------------------------------
MiniDeps.later(
  function()
    require("mini.bracketed").setup({
      diagnostic = { suffix = "" },
      jump = { suffix = "" },
      undo = { suffix = "" },
      window = { suffix = "" },
    })
  end
)

-- ------------------------------------------------------------------------
-- | mini.completion
-- ------------------------------------------------------------------------
MiniDeps.later(function()
  require("mini.completion").setup({ lsp_completion = { auto_setup = false } })

  -- Disable MiniCompletion for some filetypes
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "minifiles" },
    callback = function() vim.b.minicompletion_disable = true end,
  })
end)

-- ------------------------------------------------------------------------
-- | mini.diff
-- ------------------------------------------------------------------------
MiniDeps.later(function()
  local minidiff = require("mini.diff")
  minidiff.setup({
    view = {
      style = "sign",
      signs = { add = "│", change = "│", delete = "-" },
    },
  })

  vim.keymap.set("n", "<leader>gO", minidiff.toggle_overlay, { desc = "mini.diff toggle overlay" })
end)

MiniDeps.later(function()
  -- ------------------------------------------------------------------------
  -- | mini.hipatterns
  -- ------------------------------------------------------------------------
  local hipatterns = require("mini.hipatterns")
  hipatterns.setup({
    highlighters = {
      fixme = { pattern = "FIXME", group = "MiniHipatternsFixme" },
      hack = { pattern = "HACK", group = "MiniHipatternsHack" },
      todo = { pattern = "TODO", group = "MiniHipatternsTodo" },
      note = { pattern = "NOTE", group = "MiniHipatternsNote" },
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

-- ------------------------------------------------------------------------
-- | mini.keymap
-- ------------------------------------------------------------------------
MiniDeps.later(function()
  local minikeymap = require("mini.keymap")
  minikeymap.map_multistep("i", "<CR>", { "pmenu_accept" })
end)

-- ------------------------------------------------------------------------
-- | mini.operators
-- ------------------------------------------------------------------------
MiniDeps.later(
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

-- ------------------------------------------------------------------------
-- | mini.snippets
-- ------------------------------------------------------------------------
MiniDeps.later(function()
  local minisnippets = require("mini.snippets")
  minisnippets.setup({
    snippets = {
      -- Load custom file with global snippets first
      minisnippets.gen_loader.from_runtime("global.{json,lua}"),
      minisnippets.gen_loader.from_lang({
        lang_patterns = {
          tex = { "latex/**/*.json", "latex.json" },
          plaintext = { "latex/**/*.json", "latex.json" },
          markdown_inline = { "markdown/**/*.json", "markdown.json" },
        },
      }),
    },
  })

  local expand_all = function() minisnippets.expand({ match = false }) end
  vim.keymap.set("i", "<C-g><C-j>", expand_all, { desc = "Expand all" })
end)

-- ------------------------------------------------------------------------
-- | mini.surround
-- ------------------------------------------------------------------------
MiniDeps.later(function()
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
  vim.keymap.set("x", "gs", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
  vim.keymap.set("n", "gsu", minisurround.update_n_lines, { desc = "MiniSurround update n_lines" })
end)

-- ------------------------------------------------------------------------
-- | mini.trailspace
-- ------------------------------------------------------------------------
MiniDeps.later(function()
  local minitrailspace = require("mini.trailspace")
  minitrailspace.setup({})
  vim.keymap.set("n", "<leader>rt", minitrailspace.trim, { desc = "mini.trailspace trim" })
  vim.keymap.set(
    "n",
    "<leader>rT",
    minitrailspace.trim_last_lines,
    { desc = "mini.trailspace trim last lines" }
  )
end)
