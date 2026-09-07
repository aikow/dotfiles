vim.bo.expandtab = true
vim.bo.autoindent = true
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.textwidth = 80

-- Set the indent after opening parenthesis
vim.g.pyindent_open_paren = vim.bo.shiftwidth

-- Automatically make the current string an f-string when typing `{`.
vim.api.nvim_create_autocmd("InsertCharPre", {
  group = vim.api.nvim_create_augroup("user.ftplugin.python.auto_fstring", {}),
  pattern = { "*.py" },
  desc = "Add f-string prefixes",
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
-- | Commands
-- ------------------------------------------------------------------------

vim.api.nvim_buf_create_user_command(
  0,
  "PyLintRuff",
  "cexpr system('ruff check --output-format=concise')",
  { desc = "Populate quickfix list with ruff check" }
)

vim.api.nvim_buf_create_user_command(
  0,
  "PyLintTy",
  "cexpr system('ty check --output-format=concise')",
  { desc = "Populate quickfix list with ty check" }
)

vim.api.nvim_buf_create_user_command(0, "PyFormatBlack", function()
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
end, { desc = "Format the buffer with black" })

vim.api.nvim_buf_create_user_command(
  0,
  "PyFormatRuffFix",
  function()
    require("conform").format({
      async = true,
      lsp_fallback = true,
      formatters = { "ruff_fix" },
    })
  end,
  { desc = "Fix lints with ruff" }
)

-- ------------------------------------------------------------------------
-- | Keymaps
-- ------------------------------------------------------------------------

vim.keymap.set(
  "n",
  "<localleader>lr",
  "<cmd>PyLintRuff<cr>",
  { buffer = true, desc = "Run ruff check" }
)
vim.keymap.set(
  "n",
  "<localleader>lt",
  "<cmd>PyLintTy<cr>",
  { buffer = true, desc = "Run ty check" }
)
vim.keymap.set(
  "n",
  "<localleader>fb",
  "<cmd>PyFormatBlack<CR>",
  { buffer = true, desc = "Format the buffer with black" }
)
vim.keymap.set(
  { "n", "x" },
  "<localleader>fr",
  "<cmd>PyFormatRuffFix<CR>",
  { buffer = true, desc = "Fix lints with ruff" }
)
