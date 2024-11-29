return {
  "echasnovski/mini.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    local icons = require("mini.icons")
    icons.setup({})
    icons.mock_nvim_web_devicons()

    local notify = require("mini.notify")
    notify.setup({})
    vim.notify = notify.make_notify()

    require("user.plugins.mini.clue").setup()
    require("user.plugins.mini.files").setup()
    require("user.plugins.mini.git").setup()
    require("user.plugins.mini.pick").setup()
    require("user.plugins.mini.starter").setup()

    require("mini.align").setup({})
    require("mini.cursorword").setup({})

    -- ------------------------------------------------------------------------
    -- | mini.statusline
    -- ------------------------------------------------------------------------
    require("mini.statusline").setup({})
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "DiffviewFiles" },
      callback = function() vim.b.ministatusline_disable = true end,
    })

    -- ------------------------------------------------------------------------
    -- | mini.completion
    -- ------------------------------------------------------------------------
    require("mini.completion").setup({
      set_vim_settings = false,
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "minifiles" },
      callback = function() vim.b.minicompletion_disable = true end,
    })

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
    -- | mini.splitjoin
    -- ------------------------------------------------------------------------
    require("mini.splitjoin").setup({
      mappings = {
        toggle = "gz",
      },
    })

    -- ------------------------------------------------------------------------
    -- | mini.bracketed
    -- ------------------------------------------------------------------------
    require("mini.bracketed").setup({
      comment = { suffix = "z" },
      diagnostic = { suffix = "" },
      jump = { suffix = "" },
      undo = { suffix = "" },
      window = { suffix = "" },
      yank = { suffix = "" },
    })

    -- ------------------------------------------------------------------------
    -- | mini.operators
    -- ------------------------------------------------------------------------
    require("mini.operators").setup({
      evaluate = { prefix = "g=" },
      exchange = { prefix = "" },
      multiply = { prefix = "" },
      replace = { prefix = "" },
      sort = { prefix = "gS" },
    })

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
    -- | mini.diff
    -- ------------------------------------------------------------------------
    local minidiff = require("mini.diff")
    minidiff.setup({
      view = {
        style = "sign",
        signs = { add = "│", change = "│", delete = "-" },
      },
    })

    vim.keymap.set(
      "n",
      "<leader>gO",
      minidiff.toggle_overlay,
      { desc = "mini.diff toggle overlay" }
    )
  end,
}
