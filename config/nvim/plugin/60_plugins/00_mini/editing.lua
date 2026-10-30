safely("later", function() require("mini.align").setup({}) end)
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
      around_last = "aj",
      inside_last = "ij",
    },
    custom_textobjects = {
      c = spec_treesitter({ a = "@conditional.outer", i = "@conditional.inner" }),
      L = spec_treesitter({ a = "@loop.outer", i = "@loop.inner" }),
      m = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
      o = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
    },
  })
end)

safely("later", function()
    -- stylua: ignore start
    require("mini.bracketed").setup({
      buffer =      { suffix = "",  options = {} },
      comment =     { suffix = "",  options = {} },
      conflict =    { suffix = "x", options = {} },
      diagnostic =  { suffix = "",  options = {} },
      file =        { suffix = "f", options = {} },
      indent =      { suffix = "",  options = {} },
      jump =        { suffix = "",  options = {} },
      location =    { suffix = "",  options = {} },
      multicursor = { suffix = "",  options = {} },
      oldfile =     { suffix = "",  options = {} },
      quickfix =    { suffix = "",  options = {} },
      treesitter =  { suffix = "",  options = {} },
      undo =        { suffix = "",  options = {} },
      window =      { suffix = "",  options = {} },
      yank =        { suffix = "",  options = {} },
    })
  -- stylua: ignore end
end)

-- ------------------------------------------------------------------------
-- | mini.bufremove
-- ------------------------------------------------------------------------
safely("later", function()
  local minibufremove = require("mini.bufremove")
  minibufremove.setup({})

  vim.keymap.set("n", "<leader>q", minibufremove.delete, { desc = "Delete with mini.bufremove" })
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
    n_lines = 60,
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
