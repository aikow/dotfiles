vim.opt_local.expandtab = true
vim.opt_local.autoindent = true
vim.opt_local.smarttab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
-- vim.opt_local.fileformat = "unix"
vim.opt_local.textwidth = 80

-- Set the indent after opening parenthesis
vim.g.pyindent_open_paren = vim.bo.shiftwidth

-- Shortcut to run file through interpreter.
vim.keymap.set({ "n", "v" }, "<localleader>r", [[:!python3 %<CR>]])
vim.keymap.set(
  { "n", "v" },
  "<localleader>b",
  [[:!black --preview --enable-unstable-feature=string_processing %<CR>]]
)

vim.keymap.set(
  { "n", "x" },
  "<leader>rl",
  function()
    require("conform").format({
      async = true,
      lsp_fallback = true,
      formatters = { "ruff_fix" },
    })
  end,
  { desc = "Format the current buffer by fixing all lints" }
)

-- Automatically make the current string an f-string when typing `{`.
vim.api.nvim_create_autocmd("InsertCharPre", {
  pattern = { "*.py" },
  group = vim.api.nvim_create_augroup("py-fstring", { clear = true }),
  ---@param params NvimAutocmdCallbackParams
  callback = function(params)
    if vim.v.char ~= "{" then return end

    local node = vim.treesitter.get_node({})

    if not node then return end

    if node:type() ~= "string" then node = node:parent() end

    if not node or node:type() ~= "string" then return end
    local row, col, _, _ = vim.treesitter.get_node_range(node)
    local first_char =
      vim.api.nvim_buf_get_text(params.buf, row, col, row, col + 1, {})[1]
    if first_char == "f" then return end

    vim.api.nvim_input(
      "<Esc>m'" .. row + 1 .. "gg" .. col + 1 .. "|if<esc>`'la"
    )
  end,
})
