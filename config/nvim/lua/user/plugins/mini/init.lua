MiniDeps.now(
  function()
    MiniDeps.add({
      source = "echasnovski/mini.nvim",
      depends = {
        "rafamadriz/friendly-snippets",
        "nvim-treesitter/nvim-treesitter",
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
    })
  end
)

-- Setup mini modules that need to run immediately.
MiniDeps.now(function()
  -- ------------------------------------------------------------------------
  -- | mini.icons
  -- ------------------------------------------------------------------------
  local icons = require("mini.icons")
  icons.setup({})
  icons.mock_nvim_web_devicons()
  icons.tweak_lsp_kind("prepend")

  -- ------------------------------------------------------------------------
  -- | mini.notify
  -- ------------------------------------------------------------------------
  local notify = require("mini.notify")
  notify.setup({})
  vim.notify = notify.make_notify()
  vim.keymap.set("n", "<leader>hn", notify.show_history, { desc = "mini.notify show history" })
  vim.keymap.set("n", "<leader>hN", notify.clear, { desc = "mini.notify show history" })

  -- ------------------------------------------------------------------------
  -- | mini.misc
  -- ------------------------------------------------------------------------
  local minimisc = require("mini.misc")
  minimisc.setup({})
  minimisc.setup_termbg_sync()
  minimisc.setup_restore_cursor()

  -- ------------------------------------------------------------------------
  -- | mini.starter
  -- ------------------------------------------------------------------------
  require("user.plugins.mini.starter")

  -- ------------------------------------------------------------------------
  -- | mini.files
  -- ------------------------------------------------------------------------
  -- Load mini.files immediately to handle opening the case when nvim is passed a path to a directory
  -- instead of a file.
  require("user.plugins.mini.files")

  -- ------------------------------------------------------------------------
  -- | mini.statusline
  -- ------------------------------------------------------------------------
  require("mini.statusline").setup({})
  -- Disable the statusline for certain filetypes.
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "DiffviewFiles" },
    callback = function() vim.b.ministatusline_disable = true end,
  })
end)

-- Load everything else later.
MiniDeps.later(function()
  require("user.plugins.mini.clue")
  require("user.plugins.mini.git")
  require("user.plugins.mini.pick")
  require("user.plugins.mini.visits")

  require("mini.align").setup({})
  require("mini.cursorword").setup({})
  require("mini.splitjoin").setup({})

  -- ------------------------------------------------------------------------
  -- | mini.ai
  -- ------------------------------------------------------------------------
  local spec_treesitter = require("mini.ai").gen_spec.treesitter
  require("mini.ai").setup({
    custom_textobjects = {
      i = spec_treesitter({ a = "@conditional.outer", i = "@conditional.inner" }),
      l = spec_treesitter({ a = "@loop.outer", i = "@loop.inner" }),
      m = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
      o = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
      z = spec_treesitter({ a = "@comment.outer", i = "@comment.inner" }),
    },
  })

  -- ------------------------------------------------------------------------
  -- | mini.basics
  -- ------------------------------------------------------------------------
  require("mini.basics").setup({
    options = { basic = false, extra_ui = true, win_borders = "bold" },
    mappings = { basic = false, option_toggle_prefix = "<leader>t" },
  })

  -- ------------------------------------------------------------------------
  -- | mini.bracketed
  -- ------------------------------------------------------------------------
  require("mini.bracketed").setup({
    diagnostic = { suffix = "" },
    jump = { suffix = "" },
    undo = { suffix = "" },
    window = { suffix = "" },
  })

  -- ------------------------------------------------------------------------
  -- | mini.completion
  -- ------------------------------------------------------------------------
  -- Needs to be loaded _now_, so that 'completefunc' gets set during the LspAttach event
  require("mini.completion").setup({ lsp_completion = { auto_setup = false } })

  -- Disable MiniCompletion for some filetypes
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "minifiles" },
    callback = function() vim.b.minicompletion_disable = true end,
  })

  -- ------------------------------------------------------------------------
  -- | mini.diff
  -- ------------------------------------------------------------------------
  local minidiff = require("mini.diff")
  minidiff.setup({
    view = {
      style = "sign",
      signs = { add = "│", change = "│", delete = "-" },
    },
  })

  vim.keymap.set("n", "<leader>gO", minidiff.toggle_overlay, { desc = "mini.diff toggle overlay" })

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

  -- ------------------------------------------------------------------------
  -- | mini.keymap
  -- ------------------------------------------------------------------------
  local minikeymap = require("mini.keymap")
  minikeymap.map_multistep("i", "<CR>", { "pmenu_accept" })

  -- ------------------------------------------------------------------------
  -- | mini.operators
  -- ------------------------------------------------------------------------
  require("mini.operators").setup({
    evaluate = { prefix = "g=" },
    exchange = { prefix = "gox" },
    multiply = { prefix = "gom" },
    replace = { prefix = "gor" },
    sort = { prefix = "gos" },
  })

  -- ------------------------------------------------------------------------
  -- | mini.snippets
  -- ------------------------------------------------------------------------
  local minisnippets = require("mini.snippets")
  minisnippets.setup({
    snippets = {
      -- Load custom file with global snippets first
      minisnippets.gen_loader.from_runtime("global.{json,lua}"),
      minisnippets.gen_loader.from_lang(),
    },
  })

  local expand_all = function() minisnippets.expand({ match = false }) end
  vim.keymap.set("i", "<C-g><C-j>", expand_all, { desc = "Expand all" })

  -- ------------------------------------------------------------------------
  -- | mini.surround
  -- ------------------------------------------------------------------------
  require("mini.surround").setup({
    mappings = {
      add = "gs",
      delete = "ds",
      find = "",
      find_left = "",
      highlight = "gsh",
      replace = "cs",
      update_n_lines = "gsu",

      suffix_last = "",
      suffix_next = "",
    },
    n_lines = 40,
    respect_selection_type = true,
    search_method = "cover_or_next",
  })
  vim.keymap.set("x", "gs", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })

  -- ------------------------------------------------------------------------
  -- | mini.trailspace
  -- ------------------------------------------------------------------------
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
