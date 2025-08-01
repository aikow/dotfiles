vim.bo.expandtab = true
vim.bo.autoindent = true
vim.bo.smarttab = true
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.textwidth = 80

-- Set the indent after opening parenthesis
vim.g.pyindent_open_paren = vim.bo.shiftwidth

-- Automatically make the current string an f-string when typing `{`.
vim.api.nvim_create_autocmd("InsertCharPre", {
  pattern = { "*.py" },
  group = vim.api.nvim_create_augroup("py-fstring", { clear = true }),
  callback = function(params)
    if vim.v.char ~= "{" then return end

    local node = vim.treesitter.get_node({})

    if not node then return end

    if node:type() ~= "string" then node = node:parent() end

    if not node or node:type() ~= "string" then return end
    local row, col, _, _ = vim.treesitter.get_node_range(node)
    local first_char = vim.api.nvim_buf_get_text(params.buf, row, col, row, col + 1, {})[1]
    if first_char == "f" or first_char == "r" then return end

    vim.api.nvim_input("<Esc>m'" .. row + 1 .. "gg" .. col + 1 .. "|if<esc>`'la")
  end,
})

-- ------------------------------------------------------------------------
-- | MiniAI
-- ------------------------------------------------------------------------

local spec_treesitter = require("mini.ai").gen_spec.treesitter
vim.b.miniai_config = {
  custom_textobjects = {
    t = spec_treesitter({ a = "@annotation.outer", i = "@annotation.outer" }),
  },
}

-- ------------------------------------------------------------------------
-- | Keymaps
-- ------------------------------------------------------------------------

vim.keymap.set(
  { "n", "x" },
  "<localleader>r",
  [[:!python3 %<CR>]],
  { buffer = true, desc = "Run the file or region through the interpreter" }
)
vim.keymap.set(
  "n",
  "<localleader>l",
  "<cmd>cexpr(system('ruff check --output-format=concise'))<cr>",
  { buffer = true, desc = "populate the quickfix list with the output of 'ruff check'" }
)
vim.keymap.set(
  "n",
  "<localleader>fb",
  function()
    if vim.fn.executable("black") ~= 1 then
      vim.notify("could not find 'black' executable", vim.log.levels.WARN)
      return
    end

    vim
      .system({
        "black",
        "--line-length",
        tostring(vim.o.textwidth),
        "--preview",
        "--enable-unstable-feature=string_processing",
        vim.fs.normalize(vim.api.nvim_buf_get_name(0)),
      })
      :wait()
    vim.cmd.edit()
  end,
  { buffer = true, desc = "format the entire buffer using black with string processing enabled" }
)

vim.keymap.set(
  { "n", "x" },
  "<localleader>fr",
  function()
    require("conform").format({
      async = true,
      lsp_fallback = true,
      formatters = { "ruff_fix" },
    })
  end,
  { buffer = true, desc = "Format the current buffer by fixing all lints using ruff" }
)
